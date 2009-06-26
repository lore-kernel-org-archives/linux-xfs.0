Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QHZUMi217249 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 12:35:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9F8C326FA5
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 10:35:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DG7IQDgFAQCZtq1t for
	<xfs@oss.sgi.com>; Fri, 26 Jun 2009 10:35:59 -0700 (PDT)
Date: Fri, 26 Jun 2009 13:35:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inconsistent lock state on 2.6.30?
Message-ID: <20090626173558.GA402@infradead.org>
References: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
	<20090623170844.GA23971@infradead.org>
	<Pine.LNX.4.64.0906241438100.24641@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906241438100.24641@cobra.newdream.net>
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
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 24, 2009 at 02:40:42PM -0700, Sage Weil wrote:
> [ 7822.230090] =================================
> [ 7822.230208] [ INFO: inconsistent lock state ]
> [ 7822.230208] 2.6.30 #22
> [ 7822.230208] ---------------------------------
> [ 7822.230208] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> [ 7822.230208] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 7822.230208]  (&(&ip->i_iolock)->mr_lock){++++?+}, at: [<ffffffff803af53a>] xfs_ilock+0x27/0x79
> [ 7822.230208] {RECLAIM_FS-ON-W} state was registered at:
> [ 7822.230208]   [<ffffffff8025c297>] mark_held_locks+0x4d/0x6b
> [ 7822.230208]   [<ffffffff8025c35d>] lockdep_trace_alloc+0xa8/0xc3
> [ 7822.230208]   [<ffffffff80287c4e>] __alloc_pages_internal+0x6d/0x457
> [ 7822.230208]   [<ffffffff802a7eb6>] alloc_pages_current+0xbe/0xc6
> [ 7822.230208]   [<ffffffff80281c19>] grab_cache_page_write_begin+0x5e/0xa2
> [ 7822.230208]   [<ffffffff802d2aa5>] block_write_begin+0x3d/0xcf
> [ 7822.230208]   [<ffffffff803cb634>] xfs_vm_write_begin+0x25/0x27
> [ 7822.230208]   [<ffffffff802825ba>] generic_file_buffered_write+0x139/0x2ff
> [ 7822.230208]   [<ffffffff803d172a>] xfs_write+0x4de/0x717

That's actually a different but slightly related one.


But thinking about I came to the conclusion that both the previous and
this one actually are false positives

Both of them actually fit into the earlier reports of i_lock dependencies
inside the inode relcaim path causing problems for normal runtime use
of the fs.  But unlike the previous mmap path where we really have
exclusive lock chains I'm not so sure about this one.  Give me some time
to sort out the reclaim path which I'll need to do anyway for the
various nfs-related issues hitting the list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
