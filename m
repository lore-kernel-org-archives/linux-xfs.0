Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202631;
	b=ciGmN1jzEfZHWZO1gl9y5CNtoyGSUerLuiMC2K8LeqGkuH8qUKoKgvxfsbJKlXOF2+iK
	 c1MSyylhebm8iSSgJW2qu9gZCO1fX0/ySreuhVKihBckOK4GA5kxOyrDr9lN7k2KwV3c6
	 qcQX2XHYR1aOLhQRGpx7TOPR0yHnHExcGeWYkK8RT4NgDgZeStQoKllJb1EgVEVkDtjE4
	 HNw8Y9aIoUqJnDsiSqaWQYIYfMVAlHY0Iiswq4IANUFBbXuj+d6YNwLzSM7loWSIHITvj
	 4SBld75pCYyK9e35HYiT9j26mcWYDlWay/gGJknVO3Fu/r/XGy1ydvNfJRM2NQcREqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202631;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=9KS9LxPBhEtCGkloc3oI3wlw8Z4Yw11cjEZzittDNrU=;
	b=NoMas4CNZn+bqZM1sz+7lI3lGrPRgP0cEpwHwwm6mEZwjbayEpbBU1W7pwZodhWm1fAQ
	 BIVmw0mnwtQuukkAjpmEblEL32zt1IDgchjQi54AeZxLUOghOis6U8p2rggOkPpuOUnte
	 bC2mq6pEcPDJO+2MQEJ6a68GtS+VPwX6+cyRjUl+DB5XOFSF1KDRUBwlceurPE0F3SCH+
	 IQJVWGqNYTqcwwLkFFXnSAeJuTTf1PQiCARVtuKtmVm0diHPc4vYqrskgYqyYnvXMoLWg
	 D7+l6YdqPT1OcZaWo2OonKyp73QOCZP4Sht6mpcbAFqe6OURX4rPWwyA/0ODP6thSoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="18G9PyK/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99067606A323
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99067606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=18G9PyK/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9KS9LxPBhEtCGkloc3oI3wlw8Z4Yw11cjEZzittDNrU=; b=18G9PyK/9Gt/DGVLKihWRZHDix
	NFWSCeiMVyW568ubwPnqlTsOtGQ5EVeN/l4xNQo/ubradKdz/qTvj+Ga75ViQ0Ll39YdfuJiwGsSh
	sX06kSJJOeKsPxgX/p/fIVeA0aqRoy8970Q/meO5RmNgzRjoU1eEbw42TlfIBFF3nOh5I4NuWuDzi
	FHpsd5mHG+5r/aCob8xqLCGVNnE06o/vAJY2wnAW2JeAhI/4VLyftX1Eal/Qc4Cdh3MdrdLxQYYYb
	4vsGJL+MwUm/xRo5FlcRa31srh6gkgm++lUbXpMd3bnSoVhbTcPyaR8/Mgy30TxL40YeMbOT6Fxxr
	TeJYMeYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5v5-00000007Sw2-0tks;
	Wed, 28 Oct 2026 15:50:31 +0000
Date: Wed, 28 Oct 2026 08:50:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 5/8] xfs: remove status parameter from several btree
 insert functions
Message-ID: <auIZx_UH5UYvYzqU@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-6-sandeen@redhat.com>
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
In-Reply-To: <20261016193422.1630907-6-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 16, 2026 at 02:29:05PM -0500, Eric Sandeen wrote:
> xfs_btree_insert and its callers now have no need for the status
> parameter; either they return error = 0 / status = 1, or nonzero error
> and status 0. No caller evaluates the status variable, so remove that
> parameter from these functions.
> 
> As requested, convert all of the compound tests/assignments to discrete
> lines.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I agree with Darrick that spelling out the parameters would
be helpful.
