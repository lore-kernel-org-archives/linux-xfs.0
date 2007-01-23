Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 19:08:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N38iqw010790
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 19:08:46 -0800
Message-Id: <200701230307.OAA28050@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: EXTENT BOUNDARIES
Date: Tue, 23 Jan 2007 14:08:29 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <45B19BDD.2050808@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Les Oxley' <les@ampex.com>
Cc: xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Eric Sandeen
> Sent: Saturday, 20 January 2007 3:35 PM
> To: Les Oxley
> Cc: xfs@oss.sgi.com
> Subject: Re: EXTENT BOUNDARIES
> 
> Les Oxley wrote:
> > 
> > Hello,
> > 
> > We are looking into running XFS on a 3TB FLASH MEMORY 
> MODULE.  We have a 
> > question  regarding the extent boundaries.
> > See the attached PowerPoint drawing, xfs.ppt We are running Linux.
> > Our  media is 3 million contiguous 4KB blocks. We would 
> like to define 
> > an extent size of 1MB and this tracks the erasure block size
> > of the flash memory, and that greatly improves perfomance. 
> We are trying 
> > to understand where XFS places the extent boundaries with 
> reference to 
> > the contiguous block sequence.
> > Is this deterministic as indicated in the drawing ? That 
> is, are the 
> > extent boundaries on 256 block boundaries.
> > 
> > Any help would be greatly appreciated.
> > 
> > Les Oxley
> > Ampex Corporation
> > Redwood City
> > California.
> 
> extents by definition land on filesystem block boundaries, and can in 
> general be any number of filesystem blocks, starting & ending most 
> anywhere on the block device.
> 
> If you wish to always allocate in 1m chunks, you might consider using 
> the xfs realtime subvolume, see the extsize description in 
> the mkfs.xfs 
> man page.  I'm not sure how much buffered IO to the realtime 
> subvol has 
> been tested; pretty sure it works at this point, though the sgi guys 
> will correct me if I'm wrong... it's not exactly the normal mode of 
> operation.
> 
> Using the realtime subvol, however, all your file -metadata- 
> will still 
> be allocated on the main data volume, in much smaller pieces.
> 
> -Eric

If you don't need to use 100% of the space for your data, you can give
XFS a hint to align on a stripe unit if it's applicable.

If you allocate 1MB chunks at a time (either via a write or prealloc)
with an filesystem with sunit=1MB (2048 sectors if using 512 bytes
sectors for mkfs.xfs command), it will align to the stripe unit where
there is space available.

Once the aligned space is full, it will allocate in the remaining space.
Metadata such as inodes, directories, etc will not be nicely aligned.

If your total write or prealloc is smaller than 512KB it will not nicely
align, but find suitable space.

I would recommending some experimentation to see if either of the above
ideas are suitable for your purpose.

For the sunit idea and 512 byte sector size, the following mkfs command
should work:

# mkfs.xfs -b 4096 -d sunit=2048,swidth=4096 <device>

To see it in action using dd:

# dd if=/dev/zero of=<file> bs=1048576
# xfs_bmap -v <file>

You should see the block range aligned to 2048 sectors.
