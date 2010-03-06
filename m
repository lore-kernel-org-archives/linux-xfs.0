Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26BcZv1083149 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 05:38:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1419821FD97
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 03:40:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ADo6v7oMRExrkMjE for <xfs@oss.sgi.com>;
	Sat, 06 Mar 2010 03:40:03 -0800 (PST)
Date: Sat, 6 Mar 2010 22:40:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs_fsr: Improve handling of attribute forks
Message-ID: <20100306114000.GB28189@discord.disaster>
References: <1267764049-30650-1-git-send-email-david@fromorbit.com>
	<20100306104357.GA22520@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100306104357.GA22520@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 05:43:57AM -0500, Christoph Hellwig wrote:
> On Fri, Mar 05, 2010 at 03:40:49PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If the file being defragmented has attributes, then fsr puts a dummy
> > attribute on the temporary file to try to ensure that the inode
> > attribute fork offset is set correctly. This works perfectly well
> > for the old style of attributes that use a fixed fork offset - the
> > presence of any attribute of any size or shape will result in fsr
> > doing the correct thing.
> > 
> > However, for attr2 filesystems, the attribute fork offset is
> > dependent on the size and shape of both the data and attribute
> > forks. Hence setting a small attribute on the file does not
> > guarantee that the two inodes have the same fork offset and
> > therefore compatible for a data fork swap.
> > 
> > This patch improves the attribute fork handling of fsr. It checks
> > the filesystem version to see if the old style attributes are in
> > use, and if so uses the current method.
> > 
> > If attr2 is in use, fsr uses bulkstat output to determine what the
> > fork offset is. If the attribute fork offsets differ then fsr will
> > try to create attributes that will result in the correct offset. If
> > that fails, or the attribute fork is too large, it will give up and just
> > attempt the swap.
> > 
> > This fork offset value in bulkstat new functionality in the kernel,
> > so if there are attributes and a zero fork offset, then the kernel
> > does not support this feature and we simply fall back to the existing,
> > less effective code.
> 
> Looks reasonable.  It would be good to have a testcase for this in
> xfsqa to verify this works.

Yeah, so far I've tested by running './check -g auto' and finding
the inodes that failed with the standard fsr, then running the fixed
fsr on them. It's not particularly efficient....

FWIW, there's enough information from fsr and xfs_db to be able to
recreate the failure scenario. e.g. from 'xfs_fsr -d -v ...' on a
failed inode:

ino=149
ino=149 extents=21 can_save=2 tmp=/mnt/test/.fsr/ag0/tmp18175
set temp attr
DEBUG: fsize=2873344 blsz_dio=2873344 d_min=512 d_max=2147483136
pgsz=4096
Temporary file has 18 extents (21 in original)
XFS_IOC_SWAPEXT failed: ino=149: Invalid argument

That inode:

$ sudo xfs_db -r -c "inode 149" -c "p" /dev/sdb1
core.magic = 0x494e                                                                      
core.mode = 0100666                                                                      
core.version = 2
core.format = 3 (btree)
....
core.size = 2873344
core.nblocks = 194
core.extsize = 0
core.nextents = 12
core.naextents = 3
core.forkoff = 15
core.aformat = 3 (btree)
....

has 12 data extents and 3 attribute extents. I should be able to
create this with xfs_io without too much trouble.

Actaully the patch I posted fails on this inode - the previous ones
that were created were btree data fork and extent attribute fork,
so there's more work on this to be done.

More importantly, I discovered a neat option to xfs_fsr yesterday:

$ export FSRXFSTEST=true
$ xfs_fsr -C 18 ....

which allows you to control the number of extents in the temporary
file, so I should be able to recreate the exact conditions that
triggered a failure as well....

I'll see what I can come up with and do some more rigorous testing
of the patch before moving forward with it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
