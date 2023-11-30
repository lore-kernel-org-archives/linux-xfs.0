Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QLQHViyC"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4172ED6C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NuBPuIR3R9qtA5M2JE/q2Q9HRP3dbEA4Ig55tvu3+DY=; b=QLQHViyC0H0cnSKQg2wCOkX9y+
	/i+4wcOQJeqsO0VcCQJXgPEGNHq1RCcpa49nql/ljQRWaH6u9lziwjZn49lUFY0vwZpDWh75hzch+
	ymlvmXsMFFysyJiPggprpY0SZ+kIm98vR0AxjD843+3eUt6ZfREqmHK0sEs48/0ZICHL42Qk3PmZ1
	rOPj0wbzbwofmVLNthwOWjyDD8nmszIupLCb+VXiXGs5WPGDYwUUQKXL3YvEZa9zexfXljkDHsBz1
	3S3yQIlAFuzMFW1GKmlh6DHZTHrQgCsBx2g9g6fn5FWbZWV3ypoVzJTkon/HqvirqyQ9QjguGjqoX
	RbLJXWug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Z39-009wQq-0T;
	Thu, 30 Nov 2023 04:53:19 +0000
Date: Wed, 29 Nov 2023 20:53:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: reintroduce reaping of file metadata blocks to
 xrep_reap_extents
Message-ID: <ZWgVPxNT80LFzvx+@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927926.2771366.6168941084200917015.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927926.2771366.6168941084200917015.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:53:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reintroduce to xrep_reap_extents the ability to reap extents from any
> AG.  We dropped this before because it was buggy, but in the next patch
> we will gain the ability to reap old bmap btrees, which can have blocks
> in any AG.  To do this, we require that sc->sa is uninitialized, so that
> we can use it to hold all the per-AG context for a given extent.

Can you expand a bit on why it was buggy, in what commit is was dropped
and what we're doing better this time around?

> 
>  #endif /* __XFS_SCRUB_REAP_H__ */
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 70a6b18e5ad3c..46bf841524f8f 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -48,6 +48,7 @@ xrep_trans_commit(
>  
>  struct xbitmap;
>  struct xagb_bitmap;
> +struct xfsb_bitmap;

Your might need the forward declaration in reap.h, but definitively
not here :)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
