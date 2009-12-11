Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBB6UH94158778 for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 00:30:17 -0600
Date: Thu, 10 Dec 2009 22:30:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
In-Reply-To: <200912102219.nBAMJRr6028987@stout.americas.sgi.com>
Message-ID: <alpine.LFD.2.00.0912102228180.3560@localhost.localdomain>
References: <200912102219.nBAMJRr6028987@stout.americas.sgi.com>
MIME-Version: 1.0
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
To: Alex Elder <aelder@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Thu, 10 Dec 2009, Alex Elder wrote:
> 
>   git://oss.sgi.com/xfs/xfs for-linus

Hmm. There seems to be a lot of duplicate commits there due to something 
odd going on: rebasing _and_ then merging the rebased end result. IOW, 
these are all duplicates:

      xfs: cleanup data end I/O handlers
      xfs: cleanup data end I/O handlers
      xfs: cleanup dmapi macros in the umount path
      xfs: cleanup dmapi macros in the umount path
      xfs: Fix error return for fallocate() on XFS
      xfs: Fix error return for fallocate() on XFS
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: I/O completion handlers must use NOFS allocations
      xfs: I/O completion handlers must use NOFS allocations
      xfs: kill the STATIC_INLINE macro
      xfs: kill the STATIC_INLINE macro
      xfs: remove incorrect sparse annotation for xfs_iget_cache_miss
      xfs: remove incorrect sparse annotation for xfs_iget_cache_miss
      xfs: remove IO_ISAIO
      xfs: remove IO_ISAIO
      xfs: rename xfs_attr_fetch to xfs_attr_get_int
      xfs: rename xfs_attr_fetch to xfs_attr_get_int
      xfs: reset the i_iolock lock class in the reclaim path
      xfs: reset the i_iolock lock class in the reclaim path
      xfs: simplify inode teardown
      xfs: simplify inode teardown
      xfs: simplify xfs_buf_get / xfs_buf_read interfaces
      xfs: simplify xfs_buf_get / xfs_buf_read interfaces
      xfs: uninline xfs_get_extsz_hint
      xfs: uninline xfs_get_extsz_hint
      xfs: use WRITE_SYNC_PLUG for synchronous writeout
      xfs: use WRITE_SYNC_PLUG for synchronous writeout
      xfs: Wrapped journal record corruption on read at recovery
      xfs: Wrapped journal record corruption on read at recovery

What's up, doc?

			Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
