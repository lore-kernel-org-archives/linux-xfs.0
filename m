Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410387;
	b=IGyg+D4Cbdwe5aTUsgFrHHAidOfOmRbZS6rTNAw0ZPMtXCFsP9srPx91O2fR2Pz9QieN
	 E6R+gk2bVDnODLHWYtYVRs+qTdmVqymtIAxDo7e6ya694jCtgaHPPYHej3OdCfS0kVA7h
	 9RK7yie1aqPam4ybUAql0Qvfwf3VhqX30HQ60hOxUz0GahBAKYU9CP+98QMDP4KcWscUR
	 FnpN1bJG9cRDlnnOO3TjHpSicZNIyjBg1Um9ES/k73kGTk+9DrKki4zm66QpPLGM7stv3
	 9lpbd7kuwDAjcZEtYTeIFRZN8cVxnAXVLP9PTUCvoqFPcnvjwIzW1200Wc0SRXDDM0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410387;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=TWhT2mQx/UXPZVOwHoqKwKQnVeRhCgnTAf9T7t5ERDI=;
	b=PZjFVPEIDfQ9TCTKZPEhI9piUFF1Uxrwuvx1eRAru3eMXF5U4uUC8pdaqfxoB39+jZwZ
	 Y2kKrfJ0TzcJEJ7JIt6qtQaJmjrnqO4Lehuh9Od0juRLSfnM8ci8SDTriuv6ml5U6Qlr3
	 ne2kr5q1KOpRIt3GqFJzlpGFi3YY7GoB4UCa1C3crIv4pPUHrVMQGMs7crtOmNIcqz/PO
	 r3lAqfGMMSxytfw6j1dcVh3xrxMB3AXgP3ZaIy+Lf0QnpJBT0Il+L1VGa0c8wlgP/gHRW
	 eYuV43eg4ouO7LUkPrDIPB2bODqrqxizYYN2TxLwIK3pn4IVRKbdGPkQErXCMI+/Kww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=b7cixPqd;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B3606A324;
	Wed, 11 Nov 2026 15:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B62B3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=b7cixPqd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TWhT2mQx/UXPZVOwHoqKwKQnVeRhCgnTAf9T7t5ERDI=; b=b7cixPqdXCACH+Fo8Y+slmh0rd
	YJPmHc3pnFhfO5IBh+neueWmpVoTE9XmUvgtHV5YUomKw2EWgY+1f3lKOgV1iyVSV7mrlqaaRty3u
	UQ84PuxVWNjddRO6bsZXxAe6koJCJzGl/qGh+fwBtw+7CY1ERUzSKsPKw/61jD5W6/YN83VDP5GF4
	9GQj/th5hf5+YRajJV0g8zm//Bel92EtKB16ggSfq8vMCXbbHVWDbbl0xH6xzop6iDjL3Hdkla1J7
	AdA7gKZ4IUI6Nn6t858Qcy/9JemySGtAVNcrsE0AOe1HWZK81kkXzbZ+vxP5ZSuWjEe4u/IVSMK0q
	1IINGN5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRA6z-000000074Lq-33Nw;
	Wed, 11 Nov 2026 15:19:45 +0000
Date: Wed, 11 Nov 2026 07:19:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stian Halseth <stian@itx.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>, Dave Chinner <dgc@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix unaligned access to rmapbt high keys in scrub
Message-ID: <avSHkadYwEjnKF87@infradead.org>
References: <20261111103047.604541-1-stian@itx.no>
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
In-Reply-To: <20261111103047.604541-1-stian@itx.no>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 11, 2026 at 11:30:47AM +0100, Stian Halseth wrote:
> The high keys in a rmapbt node block aren't naturally aligned.
> xchk_rmapbt_check_unwritten_in_keyflags() reads rm_offset through
> union xfs_btree_key and the union is 8-byte aligned.
> 
> The compiler may use an 8-byte load, and on sparc64 each high key
> takes an unaligned access trap:
> 
>   Kernel unaligned access at TPC[105a54d8] xchk_rmapbt_check_unwritten_in_keyflags+0xb8/0x160 [xfs]
> 
> Read the keys through the packed struct xfs_rmap_key instead. This
> tells the compiler they may be unaligned. Decode rm_offset with
> be64_to_cpu() and drop the byte-swapped flag.
> 
> Fixes: 38384569a2a8 ("xfs: detect unwritten bit set in rmapbt node block keys")
> Reported-by: Jan Engelhardt <jengelh@inai.de>
> Closes: https://github.com/sparclinux/issues/issues/115
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Cc: stable@vger.kernel.org # v6.4+
> Signed-off-by: Stian Halseth <stian@itx.no>
> ---
> Tested on sparc64 (T4, 7.3.4) by scrubbing the rmapbt of a loop-mounted
> image: alignment faults per scrub went from about 4000 to 0.
> 
> v3: separate key and rkey variables plus a comment (Dave), shorter
> changelog.
> v2: https://lore.kernel.org/all/20261110223927.558557-1-stian@itx.no/
> v1: https://lore.kernel.org/all/20261109134853.1659991-1-stian@itx.no/
> 
>  fs/xfs/scrub/rmap.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index 68e2847c962bb..7609c03cdc8ab 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -149,8 +149,6 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  	struct xfs_scrub	*sc = bs->sc;
>  	struct xfs_btree_cur	*cur = bs->cur;
>  	struct xfs_btree_block	*keyblock;
> -	union xfs_btree_key	*lkey, *hkey;
> -	__be64			badflag = cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
>  	unsigned int		level;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
> @@ -159,6 +157,14 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  	for (level = 1; level < cur->bc_nlevels; level++) {
>  		struct xfs_buf	*bp;
>  		unsigned int	ptr;
> +		/*
> +		 * The on-disk high keys in an rmap node block are not
> +		 * naturally aligned, so decode them through the packed
> +		 * struct xfs_rmap_key to make the compiler treat them as
> +		 * unaligned.
> +		 */
> +		union xfs_btree_key	*key;
> +		const struct xfs_rmap_key *rkey;
>  
>  		/* Only check the first time we've seen this node block. */
>  		if (cur->bc_levels[level].ptr > 1)
> @@ -166,15 +172,16 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  
>  		keyblock = xfs_btree_get_block(cur, level, &bp);
>  		for (ptr = 1; ptr <= be16_to_cpu(keyblock->bb_numrecs); ptr++) {
> -			lkey = xfs_btree_key_addr(cur, ptr, keyblock);
> -
> -			if (lkey->rmap.rm_offset & badflag) {
> +			key = xfs_btree_key_addr(cur, ptr, keyblock);
> +			rkey = &key->rmap;
> +			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {

Overly long line.

But I wonder if we should simply mark struct xfs_rmap_key as __packed
to force the compliler to deal with unaligned fields instead of jumping
through these hoops at every call site.

