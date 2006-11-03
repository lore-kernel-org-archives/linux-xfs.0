Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 16:42:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA30gjaG007494
	for <xfs@oss.sgi.com>; Thu, 2 Nov 2006 16:42:49 -0800
Date: Fri, 3 Nov 2006 11:41:42 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061103004142.GI8394166@melbourne.sgi.com>
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Cc: xfs@oss.sgi.com

On Thu, Nov 02, 2006 at 06:26:08PM +0100, Christian Guggenberger wrote:
> Hi,
> 
> a colleague recently tried to grow a 16 TB filesystem (x86, 32bit) on
> top of lvm2 to 17TB. (I am not even sure if that's supposed work with
> linux-2.6, 32bit)

Not supported - any metadata access past 16TB will wrap the 32 bit page cache
index for the metadata address space and you'll corrupt the filesystem.

> used kernel seems to be debian sarge's 2.6.8
> 
> xfs_growfs seemed to succeed (AFAIK..)
> 
> however, the fs shut down:
> 
> XFS internal error
> XFS_WANT_CORRUPTED_GOTO at line 1583 of file fs/xfs/xfs_alloc.c.  Caller
> 0xf89978a8
> [__crc_pm_idle+550816/2056674] xfs_free_ag_extent+0x454/0x78a [xfs]
> [__crc_pm_idle+555561/2056674] xfs_free_extent+0xea/0x10f [xfs]
> [__crc_pm_idle+555561/2056674] xfs_free_extent+0xea/0x10f [xfs]
> [__crc_pm_idle+553757/2056674] xfs_alloc_read_agf+0xbe/0x1e4 [xfs]
> [__crc_pm_idle+764480/2056674] xfs_growfs_data_private+0xd80/0xec0 [xfs]

No, growfs failed trying to extend the data partition and shut
down the filesystem.

> mounting fails with:
> 
> XFS: SB sanity check 2 failed
.....
> and finally, xfs_repair stops at
> 
> bad primary superblock: inconsistent file geometrie information

Probably because growfs failed part way through and left inconsistent
state behind.

> found candidate secondary superblock...
> superblock read failed, offset 10093861404672, size 2048, ag 0, rval 29

Does LVM2 even support volumes larger than 16TB on 32 bit machines?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
