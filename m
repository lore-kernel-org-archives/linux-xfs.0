Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 07:08:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OE8X4p006056
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 07:08:36 -0700
Date: Sat, 25 Aug 2007 00:08:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] optimize XFS_IS_REALTIME_INODE w/o realtime config
Message-ID: <20070824140822.GP72985246@sgi.com>
References: <46C7627A.60503@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C7627A.60503@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Aug 18, 2007 at 04:19:54PM -0500, Eric Sandeen wrote:
> Use XFS_IS_REALTIME_INODE in more places, and #define it to
> 0 if CONFIG_XFS_RT is off.  This should be safe because mount
> checks in xfs_rtmount_init:
> 
> # define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
> 
> so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should
> be encountered after that.
> 
> Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
> presumeably gcc can optimize around the various "if (0)" type
> checks:
> 
> xfs_alloc_file_space	-8
> xfs_bmap_adjacent	-16
> xfs_bmapi		-8
> xfs_bmap_rtalloc	-16
> xfs_bunmapi		-28
> xfs_free_file_space	-64
> xfs_imap		+8  <-- ?  hmm.
> xfs_iomap_write_direct	-12
> xfs_qm_dqusage_adjust	-4
> xfs_qm_vop_chown_reserve -4
> 
> Compile tested only at this point.

This misses a bunch of tests (at least in the current tot)
in xfs_bmap.c, xfs_bmap_btree.c, xfs_iget.c, dmapi/xfs_dm.c and
linux-2.6/xfs_lrw.c. I think they are all in assert statements,
but shoul dbe cleaned up as well.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
