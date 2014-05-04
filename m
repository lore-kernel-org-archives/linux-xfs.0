Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 157C77F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 19:17:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA8D8AC003
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 17:17:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gqqg7VUwp6k84jqF for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 17:17:48 -0700 (PDT)
Date: Sun, 4 May 2014 10:17:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iflush_int: Bad inode, xfs_do_force_shutdown from
	xfs_inode.c during file copy
Message-ID: <20140504001746.GL26353@dastard>
References: <20140503124933.7ed0ff3e@innuk.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140503124933.7ed0ff3e@innuk.localdomain>
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
To: Marcel Giannelia <info@skeena.net>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 12:49:33PM -0700, Marcel Giannelia wrote:
> Hi,
> 
> I just had the following happen on a server that's never had any
> previous issues with XFS:
> 
> I was copying an 8 GB file onto an XFS filesystem, when the copy
> aborted with an I/O error message and I was forced to unmount and
> xfs_repair the filesystem before it would mount again. Relevant dmesg
> messages below.
> 
> Some other information that might be relevant:
> 
> - Distribution & kernel version: Debian 7, uname -a returns:
> 
> Linux hostname 3.2.0-4-686-pae #1 SMP Debian 3.2.41-2+deb7u2 i686 GNU/Linux

So, old hardware...

> dmesg entries:
> 
> > Immediately after the cp command exited with "i/o error":
> 
> XFS (md126): xfs_iflush_int: Bad inode 939480132, ptr 0xd12fa080, magic number 0x494d

The magic number has a single bit error in it.

#define XFS_DINODE_MAGIC                0x494e  /* 'IN' */

That's the in-memory inode, not the on-disk inode. It caught the
problem before writing the bad magic number to disk - the in-memory
disk buffer was checked immediately before the in-memory copy, and
it checked out OK...

> After this, I ran xfs_repair with -L. xfs_repair noted the same bad inode
> number and deleted the file I had tried to copy, but otherwise made no changes
> that I could see. After this, the filesystem mounted normally and there were no
> further issues.

What was the error that xfs_repair returned? There may have been
other things wrong with the inode that weren't caught when it was
loaded into memory.

However, I'd almost certainly be checking you hardware at this
point, as software doesn't usually cause random single bit flips...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
