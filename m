Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUG738Y189710 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 10:07:03 -0600
Date: Fri, 30 Nov 2012 11:09:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121130160920.GA9873@infradead.org>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128222622.688093599@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

>  use_alloc_page:
> -	start = BBTOB(bp->b_map.bm_bn) >> PAGE_SHIFT;
> -	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
> +	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
> +	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)

Btw, how is this logic supposed to work for discontiguous buffers?

Each of them might straddle boundaries individually, so doing the
start/end calculation for the number of pages isn't going to be correct.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
