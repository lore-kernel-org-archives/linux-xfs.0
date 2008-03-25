Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 16:35:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2PNZjLX015626
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 16:35:47 -0700
Date: Wed, 26 Mar 2008 10:36:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Serious XFS crash
Message-ID: <20080325233611.GW103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325185453.3a1957dd@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 25, 2008 at 06:54:53PM +0100, Emmanuel Florac wrote:
> 
> Here is the setup : Debian sarge running kernel 2.6.18.8 smp (clean
> build), xfsprogs version 2.6.20 (not used). An 8TB xfs filesystem broke
> apart losing roughly 2TB of data in about 350 (big) files :
> 
> Mar 22 12:38:18 system3 kernel:
> 0x0: c0 49 00 35 6a bc c3 80 fd d4 64 f8 16 ec b9 85 
       | forw    | | back    | |mg1| |pad|

#define XFS_DA_NODE_MAGIC       0xfebe  /* magic number: non-leaf blocks */
#define XFS_ATTR_LEAF_MAGIC     0xfbee  /* magic number: attribute leaf blks */
#define XFS_DIR2_LEAF1_MAGIC    0xd2f1  /* magic number: v2 dirlf single blks */
#define XFS_DIR2_LEAFN_MAGIC    0xd2ff  /* magic number: v2 dirlf multi blks */

> 0x0: c0 49 00 35 6a bc c3 80 fd d4 64 f8 16 ec b9 85 
       |hdr.magic|

#define XFS_DIR2_BLOCK_MAGIC    0x58443242      /* XD2B: for one block dirs */
#define XFS_DIR2_DATA_MAGIC     0x58443244      /* XD2D: for multiblock dirs */

So none of the magic numbers for a directory block match.
And FWIW, I can't see any XFs magic number in that block.

> As a precaution, I booted with a live CD with xfsprogs 2.8.11. I first
> ran xfs_repair -n :
> 
> No modify flag set, skipping phase 5
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> bad magic # 0x7c6999f7 for agf 0
> bad version # 270461846 for agf 0
> bad sequence # -506160237 for agf 0
> bad length 1130385756 for agf 0, should be 68590288
> flfirst 260475029 in agf 0 too large (max = 128)
> fllast -1448142937 in agf 0 too large (max = 128)
> bad magic # 0xfffde400 for agi 0
> bad version # -1469688457 for agi 0
> bad sequence # 2021095287 for agi 0
> bad length # 2004318207 for agi 0, should be 68590288
> would reset bad agf for ag 0
> would reset bad agi for ag 0
> bad uncorrected agheader 0, skipping ag...
> root inode chunk not found

Oh, that's toast. Something has overwritten the start of the
filesystem and it does not appear to be other metadata.  Well, not
exactly the start of the filesystem - the superblock is untouched.

What sector size is being used for the XFS filesystem? If it's
not the same as teh filesystem block size, then XFS can't have done
this itself because the offset that this garbage starts at would
not be block aligned.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
