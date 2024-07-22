Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E316C6B8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721659310; cv=none; b=GbzSBi+0CxnfJx1C0ZtDmC0Bfk8dHmR375QNW76Gy1ZVSutcjCwW2tQK1iAuTFOawl+cw3fSrOgUoLLv2jRRUFghPb0rErGemWgvZotJfvQj9eMFyMNhrQy7pSaxneqym3YpdVxXY08br72IFHib6dg8pq9/30jremivckf7rrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721659310; c=relaxed/simple;
	bh=Xnb8m8Z7OJxVL95kVNKuqtOATF27L1gI0mpkT1YjDVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkA1ZkGSGBQ2dQLU5Zs8TjnlwBwOWfkHsWiHUOtS5+aoaI1fU4jM6GVvjWEsqTJ9s3Xe4FmH9rDPOE/tEZFOMnZMx7oBVmYk1hx7qZSyl1L+D19Xz//3zsK7iK/cg5Nic9sOyTBwtHiyblu+mw7dPC5hKDLel305BySEEpxM7XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nya6n5C6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nya6n5C6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SGG2KagnrDJVq2MPie2x1qLa2bFNW01ZfFCmA/N/GD8=; b=Nya6n5C6gzILe47k1nadogE+AS
	/6YDTmc0O+OCFD9fXXQE4cGeOqgvCVLMJ+jaCQp6y/UpZiVCHSoE4glcmJIITHov5vr2EzNaT9rzs
	ip900UKL8YtSXCBmuZ9Uv3XaXL7QNirE2CdEJAxBcbHLIzzBGDw52a9mgB1KRjOuBOJc9xh7IHFMV
	G+S8Ru2U0RYumqflGB3/fZi9FcJnJpGJ0BAxl+uBQkhnIv519k0xcQyIKjP/T7U6nin4pLsD7/1G1
	FYo6h8c9mI/PrX4Cfdrw2hZczEB1ujDdIry6xp3TB6n2Wbj9Sc1Bv4CqG526Wq9vF9vmLPoAKbXvb
	JpUIv0UQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sVuEV-00000009oeo-1qBR;
	Mon, 22 Jul 2024 14:41:47 +0000
Date: Mon, 22 Jul 2024 07:41:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow SECURE namespace xattrs to use reserved pool
Message-ID: <Zp5vq86RtodlF-d1@infradead.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 19, 2024 at 05:48:53PM -0500, Eric Sandeen wrote:
>  	xfs_attr_sethash(args);
>  
> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
> +	rsvd = args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE);
> +	return xfs_attr_set(args, op, rsvd);

This looks fine, although I'd probably do without the extra local
variable.  More importantly though, please write a comment documenting
why we are dipping into the reserved pool here.  We should have had that
since the beginning, but this is a better time than never.

