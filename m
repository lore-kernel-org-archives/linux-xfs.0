Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1829 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751169AbdHQGeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 02:34:09 -0400
Date: Thu, 17 Aug 2017 16:34:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170817063405.GP21024@dastard>
References: <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
 <20170816071649.GA4143@debian.home>
 <20170816133502.GN21024@dastard>
 <20170816193100.GA1216@debian.home>
 <20170817000042.GO21024@dastard>
 <20170817053436.GA2382@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170817053436.GA2382@debian.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>

On Thu, Aug 17, 2017 at 02:34:40AM -0300, Ernesto A. Fernández wrote:
> On Thu, Aug 17, 2017 at 10:00:42AM +1000, Dave Chinner wrote:
> > On Wed, Aug 16, 2017 at 04:31:01PM -0300, Ernesto A. Fernández wrote:
> > > xfs_repair, phase 3:
> > > bad magic number febe in block 512 (14452) for directory inode 131
> > 
> > Hmmmm - that's a magic number for a non-crc DA node. Kinda implies
> > that it ENOSPC'd in the middle of a tree split.
> > 
> > Can you test on a CRC enabled filesystem and see if there are any
> > other errors that are detected either at runtime or by repair?
> 
> No other errors, no.
> 
> > If it does fail, can youpost the full output of xfs_repair?
> 
> Of course. I don't think it will be of much help though:
> 
> 
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> bad magic number 3ebe in block 506 (14446) for directory inode 67

Ok, so it's a specific change in tree size that is causing the
problem. It's probably a tree height change opertaion....

> Perhaps this can be of some use:
> 
> In my test I'm setting as many xattrs with 1k values as possible. If I
> change that to 64k values this bug is no longer seen.

Of course. Large xattrs are stored remote to the attribute tree, so
each attribute is only consuming ~30-40 bytes in the attribute tree
rather than 1k.

> The cutoff seems to be when the name+value of the xattr are above 3072+1
> bytes.

Which is exactly 75% of the attribute tree block size. i.e. the size
that attribute data is stored remotely instead of in the tree
itself.

> This does not depend on the amount of free space of the
> filesystem, so this is probably not just about the number of xattrs as I
> first thought.

Given it follows the block size, it smells of a btree level change
going wrong.  Haven't go ttime to look right now, but if you could
look at the inode in xfs_db and print the state of the root attr
fork and the root attr block header before running xfs_repair in the
filesystem that would probably tell us..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
