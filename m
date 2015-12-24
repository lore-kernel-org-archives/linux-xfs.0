Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 630FD29DF5
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:00:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3C7DAC001
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:00:26 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4BC8OtAKu0xYdIFG for <xfs@oss.sgi.com>;
	Wed, 23 Dec 2015 16:00:24 -0800 (PST)
Date: Thu, 24 Dec 2015 11:00:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A blocksize problem about dax and ext4
Message-ID: <20151224000021.GU19802@dastard>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Wed, Dec 23, 2015 at 09:18:05PM +0000, Elliott, Robert (Persistent Memory) wrote:
> 
> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> > Dan Williams
> > Sent: Wednesday, December 23, 2015 11:16 AM
> > To: Cholerae Hu <choleraehyq@gmail.com>
> > Cc: linux-nvdimm@lists.01.org
> > Subject: Re: A blocksize problem about dax and ext4
> > 
> > On Wed, Dec 23, 2015 at 4:03 AM, Cholerae Hu <choleraehyq@gmail.com>
> > wrote:
> ...
> > > [root@localhost cholerae]# mount -o dax /dev/pmem0 /mnt/mem
> > > mount: wrong fs type, bad option, bad superblock on /dev/pmem0,
> > >        missing codepage or helper program, or other error
> > >
> > >        In some cases useful info is found in syslog - try
> > >        dmesg | tail or so.
> > > [root@localhost cholerae]# dmesg | tail
> ...
> > > [   81.779582] EXT4-fs (pmem0): error: unsupported blocksize for dax
> ...
> 
> > What's the fs block size?  For example:
> > # dumpe2fs -h /dev/pmem0  | grep "Block size"
> > dumpe2fs 1.42.9 (28-Dec-2013)
> > Block size:               4096
> > Depending on the size of /dev/pmem0 it may have automatically set it
> > to a block size less than 4 KiB which is incompatible with "-o dax".
> 
> I noticed a few things while trying that out on both ext4 and xfs.
> 
> $ sudo mkfs.ext4 -F -b 1024 /dev/pmem0
> $ sudo mount -o dax /dev/pmem0 /mnt/ext4-pmem0
> $ sudo mkfs.xfs -f -b size=1024 /dev/pmem0
> $ sudo mount -o dax /dev/pmem0 /mnt/xfs-pmem0
> 
> [  199.679195] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  199.724931] EXT4-fs (pmem0): error: unsupported block size 1024 for dax 
> [  859.077766] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  859.118106] XFS (pmem0): Filesystem block size invalid for DAX Turning DAX off.
> [  859.156950] XFS (pmem0): Mounting V4 Filesystem
> [  859.183626] XFS (pmem0): Ending clean mount
> 
> 1. ext4 fails to mount the filesystem, while xfs just disables DAX.
> It seems like they should they be the same.

I don't really care what is done to ext4 here, but I'm not changing
XFS behaviour. I'm expecting mixed dax/non-dax fileystems to be a
thing, with DAX turned on by an inode flag on disk. Indeed, I see
the mount option going away permanently for XFS, and DAX being
controlled completely from on-disk flags. E.g. ext4 encrypted files
need to turn off DAX, while clear text files can be accessed using
DAX. This should happen completely transparently to the user....

In the situation of block size < page size, there's things we can do
to ensure that XFS will allocate page size aligned/sized extents
(extent size hints FTW). This is the same mechanism that we'll use
to ensure that extents are aligned/sized for reliable huge page
mappings. Hence while DAX /as a global option/ needs to be turned
off for sub-page block size filesystems, there's no reason why we
can't turn DAX on for files that will always allocate blocks
according to DAX constraints.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
