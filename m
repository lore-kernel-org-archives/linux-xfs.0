Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGFYgoq077331 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 09:34:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64A911CD2E57
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 07:36:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rWYTO5RYBaTEMrnF for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 07:36:37 -0800 (PST)
Date: Thu, 16 Dec 2010 10:36:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Message-ID: <20101216153634.GA24185@infradead.org>
References: <1292203313-15570-1-git-send-email-david@fromorbit.com>
	<1292203313-15570-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292203313-15570-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 13, 2010 at 12:21:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has a per-cpu counter implementation for in-core superblock
> counters that pre-dated the generic implementation. It is complex
> and baroque as it is tailored directly to the needs of ENOSPC
> detection.
> 
> Now that the generic percpu counter infrastructure has the
> percpu_counter_add_unless_lt() function that implements the
> necessary threshold checks for us, switch the XFS per-cpu
> superblock counters to use the generic percpu counter
> infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

A little nipick:

> -#ifdef HAVE_PERCPU_SB
>  	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
> -#endif

No need to keep this assert - xfs_mod_incore_sb_unlocked already
has one for unknown fields.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
