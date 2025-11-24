Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DFD1400C;
	Mon, 24 Nov 2025 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976878; cv=none; b=jLPOolt7gF7CAIbkJhGTwIYx6MISQFPYZMeZD3PUw//HA0o1IzvaSqv5O9pBnEBuG4Skf4uxbSGINSJhcnjX8kN/Ez8OZAUTt+RR/r0f8PhnJESSbrOtSwiJDLlb52Yhs3UEu6gpng7YL//7l/qxniUFVzIvYFl/znboFYXjRFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976878; c=relaxed/simple;
	bh=7MXbx2jvsAMh0dzNBITEYgszgmSIHzXP4tuZty4z4rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkuBfeoo43N66dzwCmP+y892zWKJaDoYJGNno60VWb2Z7fM8xSotyjvP5JBPoLmrRGVFcv/fpXX4xpXaqtY9e1oqVHNc4X/gyQcEw+WXHheSbWERTeFt67q3+9et/o47VlpREeuCLjt+cRayTW8b+zE46jgZE9hiUcWu1ijJfTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iPDXvQAF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iPDXvQAF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xTFWBdTKMBwHwNOCAPco4lCRTKC6/jqQtcSWDbiwMLQ=; b=iPDXvQAFx6Llln38Z2aLKozWJ5
	QpVpbLDQlKHFr7HLkPJu3Gc419HATA5t7SM70zt4vH4MdujAc4HughcveZEM+pYdLkVCjNt4HyoIo
	+hRzj7FtLr40w44SyC8Zh/zG74jgHsRtu6ThctC6KycPLZ+D4p/f54yQcxxEpArqvkcmLYtOn95SS
	g8T4rPi2nh4uHimq+KfTkylbw0I446HQMW8lMCLKfvKFtcGxUsBOuMZUly7PS3YIAnVoO/WnT2/ja
	aHBUIjjxu/rL1x67jYYWg8pQD5S4JL77GmtER5L5Vg6Ba76sGMEn6AbWnWQzpfJkN+Gg0hacQOZPs
	aPX2valw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNSxm-0000000BMJN-37gi;
	Mon, 24 Nov 2025 09:34:26 +0000
Date: Mon, 24 Nov 2025 01:34:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: fix confused tracepoints in
 xfs_reflink_end_atomic_cow()
Message-ID: <aSQmomhODBHTip8j@infradead.org>
References: <20251121115656.8796-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121115656.8796-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 21, 2025 at 07:56:56PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> The commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
> introduced xfs_reflink_end_atomic_cow() for atomic CoW-based writes, but
> it used the same tracepoint as xfs_reflink_end_cow(), making trace logs
> ambiguous.
> 
> This patch adds two new tracepoints trace_xfs_reflink_end_atomic_cow() and
> trace_xfs_reflink_end_atomic_cow_error() to distinguish them.

Confused sounds a bit strong, but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Semi-related:  back when this code was added I asked why we're not
using the transaction / defer ops chaining even for normale reflink
completions, as it should be just as efficient and that way we have
less code to maintain and less diverging code paths.  Or am I missing
something?

> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/xfs/xfs_reflink.c | 4 ++--
>  fs/xfs/xfs_trace.h   | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 3f177b4ec131..47f532fd46e0 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1003,7 +1003,7 @@ xfs_reflink_end_atomic_cow(
>  	struct xfs_trans		*tp;
>  	unsigned int			resblks;
>  
> -	trace_xfs_reflink_end_cow(ip, offset, count);
> +	trace_xfs_reflink_end_atomic_cow(ip, offset, count);
>  
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	end_fsb = XFS_B_TO_FSB(mp, offset + count);
> @@ -1028,7 +1028,7 @@ xfs_reflink_end_atomic_cow(
>  				end_fsb);
>  	}
>  	if (error) {
> -		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
> +		trace_xfs_reflink_end_atomic_cow_error(ip, error, _RET_IP_);
>  		goto out_cancel;
>  	}
>  	error = xfs_trans_commit(tp);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 79b8641880ab..29eefacb8226 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4186,12 +4186,14 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
>  
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
> +DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_atomic_cow);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_from);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_to);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_skip);
>  
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
> +DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_atomic_cow_error);
>  
>  
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
> -- 
> 2.49.0
> 
> 
---end quoted text---
