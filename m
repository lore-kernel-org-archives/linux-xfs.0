Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9E43fB157529 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 08:04:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9A3C1603103
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 06:05:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MstCC5PzUBsxA3mB for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 06:05:30 -0800 (PST)
Date: Tue, 9 Nov 2010 09:05:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mounting fails on MIPS
Message-ID: <20101109140527.GA13041@infradead.org>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
	<20101104125052.GA22429@infradead.org>
	<AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mips@linux-mips.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ajeet,

On Tue, Nov 09, 2010 at 04:43:04PM +0530, Ajeet Yadav wrote:
> True, its the same system and you were right it was cache VIPT cache problem
> the cache hold the stale value even after xlog_bread() update the buffer.
> I do not know whether its correct ways to resolve the problem, but the
> problem no longer occur.

It seems like you more less re-implemented the vmap coherency hooks
inside XFS, hardcoded to the mips implementation.

The actual helpers would looks something like:

static inline void flush_kernel_vmap_range(void *addr, int size)
{
	dma_cache_inv(addr, size);
}

static inline void invalidate_kernel_vmap_range(void *addr, int size)
{
	dma_cache_inv(addr, size);
}

For some reason the kernel also expects flush_dcache_page to be
implemented by an architecture if we want to implement these two
(it's keyed off ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE).

Can someone of the mips folks helps with this?

The testcase is easy, mounting an xfs filesystem after an unclean
shutdown on a machine with virtually indexed caches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
