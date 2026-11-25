Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589887;
	b=GVEHCzJaxbuPyZ0vZ8H/kCGSEYfArQ1ZCHU+7dM7/hPkN/r6LXN/JtsV/2SN1MTeUgYS
	 0GFkyCFgrGwIrAf5wndijLhbL7v1kop6JXQhnezQeZbzi9wg30PAFPLaV1Ed3EbZpONUB
	 FrAZSBMeEg5sBNYrEzvjjkyZ7WqvNkosIvr2PA2Yq+Ua/R4dSTlafef7qPqWZUQDil6lw
	 cAWdxnRKvDbjM03bszawCniifdT+RMZAPlie66Lx9y+YD28wtrttRQTXQ3T/1j3bKVSJ0
	 c27PNG4LOX7m2p1xoddu3m7QB0Z25xxUz/oF2nFXT/px+oaP3H1nvukrK6Ij/SGSmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589887;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=LdHGCmWdibvffrdI1CwTFxzv0LMwpPzdzEhTNac67OI=;
	b=3c6afqBPTJUBFdWUd3Mx5NDDYstKa1Kl9ItKiXVvOT24drF5FT7CxIh8dJbR5Qps5e6r
	 qCfaKKIYE4GOVDzTqqPCeLXZ60pSediR2V8lIaFRRhi6eOAFzgrFpTEuc5pwtzl9ECHxj
	 RhxN91TVBRXx0Wv38awCfvHBltIHcHb4HcWuisNfsyGrQqFhHQK9W5Cly8DCHps2C8IPg
	 WR9MPn2e0YuznxQ+PC+9mrddJ5Oa37/6k53Iprnl0lGJUvA3pQXIWvCdurTzvLm9WIvPo
	 RxXdBtZJWWWlCWXTICVlpwFzlUYGAjpeIp2cv/PeNBeVPHMBy2e54q4egPNJFr61aRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CTz+WNNi;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9682606A31E;
	Wed, 25 Nov 2026 06:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9682606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CTz+WNNi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LdHGCmWdibvffrdI1CwTFxzv0LMwpPzdzEhTNac67OI=; b=CTz+WNNi5dEWBLxwf+KshEg/5M
	UnkEakFbHC1dq+S5enwIYNoJsnEaQ0Z/l6dHbAeJ5Ur/Gf97+O6JBQ1wwyQ7A/NIUsl5Ibot0CW8V
	DAeNO1JwtoB6FnFIw2/1F3F761qQdlN499kxmU75tIgJl/R/3CYb3ddLIuVRsxgixKkPVAOSG16yR
	X8cSV0aPyByO9D3HTAMYADRUBi2iQr1/tCjSnYBkNB9VotT5nvkENWPNTUzvaAL2n65+4EsOZCBz/
	Qs+sNBuoxbX8clZBLsPYozKNDBFeSKmZ9WGGCxhl+WHKbbHb8ilV6h+ccVbgRC2Z1D9LT7j6sS0Ra
	oGRKEOoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6xB-00000008lx1-0VX7;
	Wed, 25 Nov 2026 06:58:05 +0000
Date: Tue, 24 Nov 2026 22:58:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shida Zhang <zhangshida@kylinos.cn>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs: optimize getfsmap by reusing and advancing the
 refcount cursor
Message-ID: <awaG_cs82bPs8QSt@infradead.org>
References: <20261123075048.3658960-1-zhangshida@kylinos.cn>
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
In-Reply-To: <20261123075048.3658960-1-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 23, 2026 at 03:50:48PM +0800, Shida Zhang wrote:
> GETFSMAP sweeps the whole device: online fsck, dedup scanners and
> imaging tools walk thousands of records per call.
> 
> Every record pays two costs.  xfs_getfsmap_is_shared() allocates and
> frees a refcount btree cursor, and xfs_refcount_find_shared() searches
> the refcount btree from the root via xfs_btree_lookup().  A fresh cursor
> re-reads the root block each time; the search re-descends root to leaf
> even when the answer is the next slot.

This reads pretty odd.  Maybe try to reword it a bit using your own
writing instead of an LLM?

> Testing: xfstests with rmapbt=1,reflink=1 passes the fsmap/rmap/clone subset
> (xfs/271-274, 277, 114, 233, 234, 236, 517, 560, 600, generic/127, 129). The
> full fsmap record set is byte-identical before and after.

A full -g auto run would also be useful as we have quite a few tests
that use getfsmap under the hood.

> Not tested: the rtrefcountbt advance path (no RT device on the test box).
> It uses the same logic via the rtrefcountbt cursor, and the rtrmap walk is
> also sorted.

With the zoned allocator, you can use an internal RT device.
Just add "-r zoned" to the test and scratch mkfs options.

> @@ -161,6 +163,10 @@ struct xfs_getfsmap_info {
>  	struct xfs_fsmap_head	*head;
>  	struct fsmap		*fsmap_recs;	/* mapping records */
>  	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
> +	struct xfs_btree_cur	*refcount_cur;	/* cached refcountbt cursor */
> +	struct xfs_refcount_irec	rc_cur;		/* current refcount record */

Overly long line here, and weird indentation for rc_cur.
Please go over the patch and fix all the long lines, not going to
report more of those.

> +/* Drop the cached refcount btree cursor when leaving a group. */
> +static void
> +xfs_getfsmap_put_refcount_cur(
> +	struct xfs_getfsmap_info	*info,
> +	int				error)
> +{
> +	if (info->refcount_cur) {
> +		xfs_btree_del_cursor(info->refcount_cur, error < 0 ?
> +				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		info->refcount_cur = NULL;
> +	}
> +}

All the callers also delete the rmap btree.  So maybe do a prep patch
to add a xfs_getfsmap_del_cursors helper which initially just does
this work for the rmap one, and where you can then add the refcount
cursor deletion as well.

> +	if (!info->refcount_cur) {
> +		if (info->group->xg_type == XG_TYPE_RTG)
> +			cur = xfs_rtrefcountbt_init_cursor(tp,
> +					to_rtg(info->group));
> +		else
> +			cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
> +					to_perag(info->group));
> +		info->refcount_cur = cur;
> +		info->rc_positioned = false;
> +		info->rc_eof = false;
> +	}
> +	cur = info->refcount_cur;
> +	if (info->rc_eof)
> +		return 0;

I don't see why we'd want to allocate a new cursor at EOF.  So this
check should probably move to before the cursor allocation.

> +	if (!info->rc_positioned) {

And this only happens if the cursor was just allocatd.  So the two
branches can be merged, and rc_positioned can be removed.  Bonous
points of splitting the cursor allocation and initial positioning
into a helper.

