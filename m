Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCD374171;
	Mon, 16 Mar 2026 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652093; cv=none; b=M5n6AIcmq5zpVFNzy8RdMK3q/cXur7KmeYiz7ZikaWZaeoivEri0mxC1zUavPc56aW0PnsmNBCZCV/H6dhBodBWWpBgZD3Xk5gr8mduZDOUEVZc/gIRoDKbld3GEYj8oHt8FvFRZz63OTX0TI2fRv/PbZ/OYAUSZjxXgc60pZkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652093; c=relaxed/simple;
	bh=kCTzxLtsSDZ71cDeqsGPwFblvUZYyy3vQSczkls8JWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sk5dyoBO4923puFXG3Ej4RfVdNIlEjR1mtDcs5KiLfToGMwfRW/V/gaWBO1WYadAW+5wmtTeKvOkBAZlIaL2STHp14Xa1tdvo0Zu5WBITwRYBzKv+KToT1NrwfIFifsGbQ/3sQiuMzGTKA4mXXSJMMpHmnubbS+TjSd9UZywVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xcsBFmtv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xcsBFmtv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dzvTIKXaThHMq6pGOJyQKSDbTUNoo4RsKqDiZ2q5Xzw=; b=xcsBFmtvMTx8WR+wiEQqz/EtWw
	J3ohrUl5j4XytRWadQ+8KSiC94eUxX/89z5AXX6SqJY4v9vBhGv5nH0QaxsY5HVRVSgHn8XiwMUnd
	ApY8U3VWDRUGLuwi1i1oYqpAGcCVbyGc9BWSITh6Yii2b1QcBjdGOpPOVKn1spfHcVP1KVsF1iqL/
	popVCcFj5SfHBqJpVuekGU7vI/Anuabz0yaaY01276yi5m+UWyWwMUTNm7Ff9ibieG/yvHZw90knb
	i3D4kghYyGqJmlyvSmnMTBrveVCwVwJvmfVoc/QyVuBBxCzeV49LGdFwXRAvfZ+NFFAlbd6OnMfrN
	owyXuyPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w23vn-00000003bXh-1rXB;
	Mon, 16 Mar 2026 09:08:11 +0000
Date: Mon, 16 Mar 2026 02:08:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, jack@suse.cz, fstests@vger.kernel.org,
	amir73il@gmail.com, gabriel@krisman.be,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <abfIexgmKjS1Q7bN@infradead.org>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test the fsnotify filesystem error reporting.

Still would be helpful to explain what is being tested and how and
the source of the test tool.

> +#ifndef FILEID_INO32_GEN
> +#define FILEID_INO32_GEN	1
> +#endif
> +
> +#ifndef FILEID_INVALID
> +#define	FILEID_INVALID		0xff
> +#endif
> +
> +static void print_fh(struct file_handle *fh)
> +{
> +	int i;
> +	uint32_t *h = (uint32_t *) fh->f_handle;
> +
> +	printf("\tfh: ");
> +	for (i = 0; i < fh->handle_bytes; i++)
> +		printf("%hhx", fh->f_handle[i]);
> +	printf("\n");
> +
> +	printf("\tdecoded fh: ");
> +	if (fh->handle_type == FILEID_INO32_GEN)
> +		printf("inode=%u gen=%u\n", h[0], h[1]);
> +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> +		printf("Type %d (Superblock error)\n", fh->handle_type);
> +	else
> +		printf("Type %d (Unknown)\n", fh->handle_type);


Isn't this always going to print unknown for normal xfs mounts without
inode32?
