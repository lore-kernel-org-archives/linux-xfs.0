Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 964E27F50
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 18:15:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73003304032
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 16:15:53 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id CBbee90A2x0i1GMq (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 16:15:51 -0700 (PDT)
Date: Thu, 13 Mar 2014 19:15:06 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Cluster-devel] [PATCH] fs: push sync_filesystem() down to the
	file system's remount_fs()
Message-ID: <20140313231506.GB16785@thunk.org>
References: <20140313073936.GA14663@infradead.org>
	<1394720456-16629-1-git-send-email-tytso@mit.edu>
	<20140313162319.GA504@quack.suse.cz>
	<1394728103.2767.32.camel@menhir>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1394728103.2767.32.camel@menhir>
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
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, linux-mtd@lists.infradead.org, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Petr Vandrovec <petr@vandrovec.name>, codalist@TELEMANN.coda.cs.cmu.edu, linux-cifs@vger.kernel.org, linux-fsdevel@thunk.org, cluster-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>, Evgeniy Dushistov <dushistov@mail.ru>, Kees Cook <keescook@chromium.org>, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, linux-nilfs@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nfs@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, Adrian Hunter <adrian.hunter@intel.com>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>, ocfs2-devel@oss.oracle.com

On Thu, Mar 13, 2014 at 04:28:23PM +0000, Steven Whitehouse wrote:
> 
> I guess the same is true for other file systems which are mounted ro
> too. So maybe a check for MS_RDONLY before doing the sync in those
> cases?

My original patch moved the sync_filesystem into the check for
MS_RDONLY in the core VFS code.  The objection was raised that there
might be some file system out there that might depend on this
behaviour.  I can't imagine why, but I suppose it's at least
theoretically possible.

So the idea is that this particular patch is *guaranteed* not to make
any difference.  That way there can be no question about the patch'es
correctness.

I'm going to follow up with a patch for ext4 that does exactly that,
but the idea is to allow each file system maintainer to do that for
their own file system.

I could do that as well for file systems that are "obviously"
read-only, but then I'll find out that there's some wierd case where
the file system can be used in a read-write fashion.  (Example: UDF is
normally used for DVD's, but at least in theory it can be used
read/write --- I'm told that Windows supports read-write UDF file
systems on USB sticks, and at least in theory it could be used as a
inter-OS exchange format in situations where VFAT and exFAT might not
be appropriate for various reasons.)

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
