Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC8A47F3F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 12:10:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41D09AC004
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 10:10:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NxybemX9GaimHKyQ for
	<xfs@oss.sgi.com>; Thu, 13 Mar 2014 10:10:32 -0700 (PDT)
Subject: Re: [Cluster-devel] [PATCH] fs: push sync_filesystem() down to the
	file system's remount_fs()
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20140313162319.GA504@quack.suse.cz>
References: <20140313073936.GA14663@infradead.org>
	<1394720456-16629-1-git-send-email-tytso@mit.edu>
	<20140313162319.GA504@quack.suse.cz>
Date: Thu, 13 Mar 2014 16:28:23 +0000
Message-ID: <1394728103.2767.32.camel@menhir>
Mime-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: jfs-discussion@lists.sourceforge.net, Anders Larsen <al@alarsen.net>, linux-mtd@lists.infradead.org, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Petr Vandrovec <petr@vandrovec.name>, codalist@TELEMANN.coda.cs.cmu.edu, linux-cifs@vger.kernel.org, linux-fsdevel@thunk.org, cluster-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>, Evgeniy Dushistov <dushistov@mail.ru>, Kees Cook <keescook@chromium.org>, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, linux-nilfs@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, Adrian Hunter <adrian.hunter@intel.com>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>, ocfs2-devel@oss.oracle.com

Hi,

On Thu, 2014-03-13 at 17:23 +0100, Jan Kara wrote:
> On Thu 13-03-14 10:20:56, Ted Tso wrote:
> > Previously, the no-op "mount -o mount /dev/xxx" operation when the
>                                   ^^remount
> 
> > file system is already mounted read-write causes an implied,
> > unconditional syncfs().  This seems pretty stupid, and it's certainly
> > documented or guaraunteed to do this, nor is it particularly useful,
> > except in the case where the file system was mounted rw and is getting
> > remounted read-only.
> > 
> > However, it's possible that there might be some file systems that are
> > actually depending on this behavior.  In most file systems, it's
> > probably fine to only call sync_filesystem() when transitioning from
> > read-write to read-only, and there are some file systems where this is
> > not needed at all (for example, for a pseudo-filesystem or something
> > like romfs).
>   Hum, I'd avoid this excercise at least for filesystem where
> sync_filesystem() is obviously useless - proc, debugfs, pstore, devpts,
> also always read-only filesystems such as isofs, qnx4, qnx6, befs, cramfs,
> efs, freevxfs, romfs, squashfs. I think you can find a couple more which
> clearly don't care about sync_filesystem() if you look a bit closer.
> 
>
> 								Honza

I guess the same is true for other file systems which are mounted ro
too. So maybe a check for MS_RDONLY before doing the sync in those
cases?

Steve.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
