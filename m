Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.187
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794398264;
	b=p13ALuz+1/i/6pt2XsQtTaW/qoeTjkcLvwz4PTX044rr6k6XeKkBOJL0O9i57XCVmSgQ
	 kBFnMUwtbdjWzZRr3bjHG1qxwW6fneN8V3GBd1OKMl58GWanuSyK9215MhlT04qXJsZpk
	 X43uWGQUGzTTCNCxKEcdwdzFHKJ/iMKmLMbx2pAGp3FTePv0nYoh27Pn/Y9ZyO+OvS1WO
	 7EJ5iQtVuXryFWIL5MhqzmOLXWBpyYckpMUlRfZpcF0C2banlr/Bfwxa0M3LB+gI1euWo
	 5o8v0uxchO+y7IXUXeC6rLI05Zgj3nfYV7Pz0d1qAFtUtvVyr1l5Xc0AAh8EIw80dHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794398264;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZEZTnB5aU7ocxmhzsxXcDqks+nTDqab9UMIUEXxgSak=;
	b=dO/NzMDzAoNNC+TskViFkfPyi6CP6cUKWqQWTEZ5IR2tIRhIgxQU+GrtANg3BX99gzic
	 F5uP1HPO3kAbiKLzd0w5xImHB0jGPBFMsWdXX9QjXiyTMbqBOcAqlddQLGFFU3FaxwW0V
	 j201VA1WsWrFgysXNuwgNK4YFcIrtOl0L3+G8xTpcxVyPp1YC7LIEwQPTkBHzIwVd4Ako
	 2Oum/lHwrwcZgEhWzHmymBngSGZzwkYXII2NjWnk54QeaWOcFB6yoHd7Dgnf1AB/dQqC4
	 820KiAMLQyHoyIiGgDoUArzsuLBiDJ9orn9HTdv1fExV07EidtuHYRrixLiDBQI05Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="DB6y/JiS";
	arc=none smtp.remote-ip=95.215.58.187
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEB8606A88C
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 11:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DEB8606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DB6y/JiS
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zWrK+nJrSEviByYnsG+J5TTI7tO3O0qSx+hBnbwOCL0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794398261; v=1; x=1795003061;
 b=DB6y/JiSARIvct9gJrFTkf/rGcvMgPM8AEVxoH3QylOT2tGNON6l6WAwYKoGYFRLkDoBtngk
 GqWi7ORzmTE2EYJJ1RCq4zUaS1ErM5kbTFHaStHuJaKbUPN2yUYUGeWMhSAiXKNueqk/dJw5m+g
 FEjzzHLIIRciszu/rK0uw4MM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e6515124bae25b44;
	Wed, 11 Nov 2026 11:57:41 +0000
X-Mizu-Trace-ID: e6515124bae25b44
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 12:57:39 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/25] xfs: verify data checksums during media
 verification
Message-ID: <avRUQnZqmuiQVC1h@quentin>
References: <20261104085929.317544-1-hch@lst.de>
 <20261104085929.317544-21-hch@lst.de>
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
In-Reply-To: <20261104085929.317544-21-hch@lst.de>

On Wed, Nov 04, 2026 at 09:57:24AM +0100, Christoph Hellwig wrote:
> Wire up reading and verifying data checksums during media verification.
> This is very similar to the file read path in that it kicks of an async
> read for the checksum buffer before reading the data, and then validating
> once both are read in.
> 
> To support this, split the per-read logic in xfs_verify_media into a
> separate helpers for the data checksums vs no checksum cases.
> 
> +
> +/*
> + * Data checksums are per-FSB, so we can only validate FSB-aligned regions.
> + *
> + * When the alignment leads to an empty range, give up.
> + */

A comment here would be helpful about the return values.
0 for success,
1 for media errors
errno for other errors.

> +static int
> +xfs_submit_verify_bio_csum(
> +	struct xfs_mount	*mp,
> +	struct xfs_verify_media	*me,
> +	struct xfs_buftarg	*btp,
> +	struct folio		*folio,
> +	xfs_daddr_t		*daddr)
> +{
> +	xfs_fsblock_t		bno = xfs_daddr_to_rtb(mp, *daddr);
> +	xfs_fsblock_t		end = xfs_daddr_to_rtb(mp, me->me_end_daddr);
> +	struct xfs_buf		*csum_bp = NULL;
> +	struct bvec_iter	saved_iter;
> +	unsigned int		bbcount;
> +	xfs_filblks_t		len;
> +	struct bio		bio;
> +	struct bio_vec		bv;
> +	int			error;
> +
> +	len = min3(end - bno, xfs_rtcsum_max_len(mp, bno),
> +			XFS_B_TO_FSBT(mp, folio_size(folio)));

For large block size systems, if we allocate a single page in the folio
due to fragmentation, len will always be zero (4096 >> (blocklog > 12)).

> +	if (!len) {
> +		*daddr = me->me_end_daddr;
> +		return 0;
> +	}

And we skip those ranges without verifying anything with a success.

I think we should raise the iosize to a single FSB in
xfs_verify_alloc_folio and should return ENOMEM if we cannot allocate
one?

> +
> +	error = xfs_rtcsum_read_async(mp, bno, &csum_bp);
> +	if (error)
> +		return error;
> +
> +	*daddr = xfs_rtb_to_daddr(mp, bno);
> +	bbcount = XFS_FSB_TO_BB(mp, len);
> +
> +	bio_init(&bio, btp->bt_bdev, &bv, 1, REQ_OP_READ);
> +	bio.bi_iter.bi_sector = *daddr;
> +	bio_add_folio_nofail(&bio, folio, bbcount << SECTOR_SHIFT, 0);
> +
> +	saved_iter = bio.bi_iter;
> +	error = submit_bio_wait(&bio);
> +	if (error) {
> +		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
> +		error = 1;
> +		goto out_buf_rele;
> +	}
> +
> +	error = xfs_buf_read_async_wait(csum_bp);
> +	if (error)
> +		goto out_buf_rele;
> +
> +	error = xfs_csum_verify(mp, &bio, &saved_iter,
> +			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
> +			false);
> +	if (error) {
> +		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
> +		error = 1;
> +		goto out_buf_rele;
> +	}
> +
> +	*daddr = xfs_rtb_to_daddr(mp, bno + len);
> +out_buf_rele:
> +	xfs_buf_rele(csum_bp);
> +	bio_uninit(&bio);
> +	return error;
> +}
> +

-- 
Pankaj
