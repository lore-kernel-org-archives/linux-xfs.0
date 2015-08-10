Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DBF57F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 16:12:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BB718F8050
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:12:23 -0700 (PDT)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com
	[209.85.220.171]) by cuda.sgi.com with ESMTP id
	nub6AERnjpATsuh3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 14:12:21 -0700 (PDT)
Received: by qkfj126 with SMTP id j126so11595580qkf.0
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:12:20 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] fs: create and use seq_show_option for escaping
Date: Mon, 10 Aug 2015 17:12:18 -0400
Message-ID: <1643551.Z65F38WpRq@sifl>
In-Reply-To: <20150807234150.GA11735@www.outflux.net>
References: <20150807234150.GA11735@www.outflux.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kees Cook <keescook@chromium.org>
Cc: Firo Yang <firogm@gmail.com>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@lst.de>, "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Ilya Dryomov <idryomov@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serge@hallyn.com>, Mark Fasheh <mfasheh@suse.com>, Jeff Dike <jdike@addtoit.com>, Jan Kara <jack@suse.com>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Bob Peterson <rpeterso@redhat.com>, Joel Becker <jlbec@evilplan.org>, James Morris <james.l.morris@oracle.com>, Eric Paris <eparis@parisplace.org>, Steven Whitehouse <swhiteho@redhat.com>, Fabian Frederick <fabf@skynet.be>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>

On Friday, August 07, 2015 04:41:50 PM Kees Cook wrote:
> Many file systems that implement the show_options hook fail to correctly
> escape their output which could lead to unescaped characters (e.g. new
> lines) leaking into /proc/mounts and /proc/[pid]/mountinfo files. This
> could lead to confusion, spoofed entries (resulting in things like
> systemd issuing false d-bus "mount" notifications), and who knows
> what else. This looks like it would only be the root user stepping on
> themselves, but it's possible weird things could happen in containers
> or in other situations with delegated mount privileges.
> 
> Here's an example using overlay with setuid fusermount trusting the
> contents of /proc/mounts (via the /etc/mtab symlink). Imagine the use of
> "sudo" is something more sneaky:
> 
> $ BASE="ovl"
> $ MNT="$BASE/mnt"
> $ LOW="$BASE/lower"
> $ UP="$BASE/upper"
> $ WORK="$BASE/work/ 0 0
> none /proc fuse.pwn user_id=1000"
> $ mkdir -p "$LOW" "$UP" "$WORK"
> $ sudo mount -t overlay -o "lowerdir=$LOW,upperdir=$UP,workdir=$WORK" none
> /mnt $ cat /proc/mounts
> none /root/ovl/mnt overlay
> rw,relatime,lowerdir=ovl/lower,upperdir=ovl/upper,workdir=ovl/work/ 0 0
> none /proc fuse.pwn user_id=1000 0 0
> $ fusermount -u /proc
> $ cat /proc/mounts
> cat: /proc/mounts: No such file or directory
> 
> This fixes the problem by adding new seq_show_option and seq_show_option_n
> helpers, and updating the vulnerable show_option handlers to use them as
> needed. Some, like SELinux, need to be open coded due to unusual existing
> escape mechanisms.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
>  fs/ceph/super.c          |  2 +-
>  fs/cifs/cifsfs.c         |  6 +++---
>  fs/ext3/super.c          |  4 ++--
>  fs/ext4/super.c          |  4 ++--
>  fs/gfs2/super.c          |  6 +++---
>  fs/hfs/super.c           |  4 ++--
>  fs/hfsplus/options.c     |  4 ++--
>  fs/hostfs/hostfs_kern.c  |  2 +-
>  fs/ocfs2/super.c         |  4 ++--
>  fs/overlayfs/super.c     |  6 +++---
>  fs/reiserfs/super.c      |  8 +++++---
>  fs/xfs/xfs_super.c       |  4 ++--
>  include/linux/seq_file.h | 34 ++++++++++++++++++++++++++++++++++
>  kernel/cgroup.c          |  7 ++++---
>  net/ceph/ceph_common.c   |  7 +++++--
>  security/selinux/hooks.c |  2 +-
>  16 files changed, 72 insertions(+), 32 deletions(-)

The SELinux changes look fine to me.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
