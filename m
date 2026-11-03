Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698667;
	b=xG1i0PV66B0cO2MO2xYnaH1xuxfXaCmTVwk+5dmd0AwQ1euEFznDADcOlXSkDYxkcLes
	 nWuCVa7mmQbQnWy0AdCUjqBn1sVsNVfmMUY/Gqss6sQ9Ka9Too/aIGWP3pKrYzB+NI8yV
	 fLwl1QO7KJk3ljQf9jzA9pqhMWc21Bb2egA3bdhnALWK47LiSyAl72B2C6h+qMd55eZX3
	 T7z5YrrKk7UatmomGb+jBthUvvMo9xXE/hLvfUqLq0YxUmsFMPNbPbSsxn93Q0jFmYJxP
	 5ob0qqjN2g6ExVYH4znFhw/dI5f2sd9t8sdM8TUYK82W9pv1I5uCHa5vOQxkXgasi6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698667;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=PTfIu5zH5+0vg5rb6e/WBy/N90ekNPWPCmFYZv88RCc=;
	b=d1ukoyX+b8UNSG1CwbPUxBmDIBpPkgbDZbEkkC+tLO1EUHZWD1FJwetfGdX9tHL7Y89Z
	 7jfU3DQj+zgCpuLR0979eYxd1jElgDOlOUkhwJ5Fa7mdsUdphwsKZCibnaeDz69+vAdCX
	 xFTmf+R9/8AE06Zm1XPKM6wZ1wkiVVSI/cUGpgwA3if4JFZMCG6mxIvWZLRpwz5V3gSD3
	 PXq7HoFtakXdELVUXjKTqddd3n2Pl6OHQPZ0VGlmCn7/ShBvBuop+0CtYz8nRBgIBkbmm
	 zC51+pPRXn3RYVKZulNaoLRKM8VcrjkYqNXNG/rF8gcW1iuWO16aykGfKFMduo/7+rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=quZkXKiW;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F9606A32C;
	Tue,  3 Nov 2026 09:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 562F9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=quZkXKiW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PTfIu5zH5+0vg5rb6e/WBy/N90ekNPWPCmFYZv88RCc=; b=quZkXKiWMspYTDMUomMGh+zCME
	BR+mKF39JIPUYqI+2YuEIipCR7bSD8U1X3ZwCb4vUINCWvTpTxf/vh7KEI2VQMdmh9OrD2r9vQGF3
	8jC+tKCX0bFF4ltihycTXes0oGl1cTguvjqjizcQehlV6MT6aAixpQfB7vFYWWmPjOZfGNt7/NyV3
	xKPlnSGs2ImyS9lDe8YnZC8Uca/KxzWSgk5wd9oU8J/vK/fIppiaOrELQTUjCjGXuUhsRggwtkyTz
	wuWW69pCjBUW7qlPh8CqQx4yDby6kmWwtHX0knBWWCdkh9mvxMfseDag8lDcHbL3LXHVN9hq/efb5
	Fv5oC2yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOAxe-00000001lhC-3XfK;
	Tue, 03 Nov 2026 09:37:46 +0000
Date: Tue, 3 Nov 2026 01:37:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 05/15] xfs: handle fsverity I/O in write/read path
Message-ID: <aumrai1iWxj97svo@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-6-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102144147.2393369-6-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 02, 2026 at 03:41:35PM +0100, Andrey Albershteyn wrote:
> @@ -41,6 +41,7 @@
>  #include "xfs_inode_util.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_zone_alloc.h"
> +#include "xfs_verity.h"

I think the Sashiko comment that this breaks the build until
xfs_fsverifty.h is added is spot on.  Easiest is probably to just add
the header in this patch already.

>  	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
> @@ -265,7 +270,8 @@ xfs_map_blocks(
>  	    isnullstartblock(imap.br_startblock))
>  		goto allocate_blocks;
>  
> -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
> +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
> +			  XFS_WPC(wpc)->data_seq);

Is there a reason to not just move the IOMAP_F_FSVERITY handling
into xfs_bmbt_to_iomap?  It would break if single extent is shared
between data and verity data, but we already leave a large enough hole
that this could never happen, right?

If we need to protect agaist that explicitly passing the offset might
still be better, although it would be a bit ugly.

>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
> -			XFS_FSB_TO_B(mp, count_fsb));
> +			XFS_FSB_TO_B(mp, count_fsb), iomap_flags);

Same for xfs_iomap_set_anon_write, although we already do have the
offset here in either case.

> +static int
> +xfs_iomap_writepages(
> +	struct xfs_inode		*ip,
> +	struct iomap_writepage_ctx	*ctx)
> +{
> +	/*
> +	 * Writeback does not work for folios past EOF, let it know that
> +	 * I/O happens for fsverity metadata and this restriction need
> +	 * to be skipped
> +	 */
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		ctx->iomap.flags |= IOMAP_F_FSVERITY;

Sashiko complained about this, but I also really don't understand
how setting ctx->iomap.flags before we even get a mapping to start
with make much sense.  This should be set together with filling the
iomap either way.

> +#include "xfs_verity.h"
> +#include <linux/fsverity.h>
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -883,6 +885,9 @@ xfs_direct_write_iomap_begin(
>  	if (flags & IOMAP_ATOMIC)
>  		iomap_flags |= IOMAP_F_ATOMIC_BIO;
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	/*
>  	 * COW writes may allocate delalloc space or convert unwritten COW
>  	 * extents, so we need to make sure to take the lock exclusively here.
> @@ -1023,7 +1028,8 @@ xfs_direct_write_iomap_begin(
>  	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
>  	if (imap.br_startblock != HOLESTARTBLOCK) {
>  		seq = xfs_iomap_inode_sequence(ip, 0);
> -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
> +		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
> +				iomap_flags & IOMAP_F_FSVERITY, seq);

Does passing on the other iomap_flags hurt here?  Filtering out a
specific one looks pretty odd.

