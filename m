Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200635;
	b=x1mcKwU8T+7Sl47lDbeOi/B7B7UEECdDP5wGjuzsSkdSWyTRf+0G1hGanEpRri3j2SsY
	 oS/2DogjLISf+C+BUtjRQjJrbDbnl6vgRBcx9FNudGyw6JERE4ggrNOcjT4nAGm2pttzh
	 UxiOTLQKFaCkrD5Wny/re3cS+0dB9h63XAtQgc1SasS2NH7taLKrWNqC2gvoLfMXJtXOR
	 QZm4LEO1/cFtEhnViQ602d7lV/PIyorvLm+0Of/w9UCFOkJl2rkOof4H+lxtLgtp7+Iwl
	 R6UrfCPhBF+krgIAc1IUFKA008LG0bhhVFUlaRLnroMDgui5FvN8fnyZbWQlK25LDWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200635;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=AslufStoyMNIg6YN8TvdSba9E+RzOx6UwrLWEXYTHj4=;
	b=aM/CTRSvaKH0nO4jyoy4dr3l9Sa2C/+oVeMdIclY7KpowN5Zz4YxQlqAvq9MOrGj37HN
	 LVjnPp/ABU30HZqogIiqST3Og3EvTJuHCq11vwAjjaBnxs8h0DiHdnj4oqZ1MsDhIqtQZ
	 GAdT4eZ07KBnAFvx8x5FkTsVKqt0uub8D6WSNaBuTDD+12o9IAnsZVReZO3k6lhckQiT0
	 JL5WfEBx8Pp7ooI5VLfVPgUzkj5yPr7VxDVA/afRfkTPrRYY05WcCf6UYlMWocscRiMuq
	 vPlLhRt3RAPq9JhLA72shCRRDn2qqCuGTSIkVJoCx86EFVRTowSvKAqu59UgFe+gwtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=u+Adlv+2;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09EC606A31C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E09EC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=u+Adlv+2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AslufStoyMNIg6YN8TvdSba9E+RzOx6UwrLWEXYTHj4=; b=u+Adlv+2NONGqwYbMsQsmOBUOk
	MbwHjr1XLEQN+2jNUeQXs47Bwheal3qXEbKa/7pnGpf44HHTL4JcRkse2eq7uU6WKdRF/EBI2zABY
	xUB6pcQf03F8Q69/uCWtiog2O4wyIvM67u4deMXTq8C9SqlaI/WBPjm01zC9EAItqNPaV/iBfIHLC
	GUmQghJNuX5hFCr1zoFMenxVU0Ru0VgSgrGtwraUjb+XBeWmJIbW47wspJQiUSIhQ1gYvYWGrUIc/
	rYBxHlmiro5CGs3s76mHr2lxB+jMbN0+JQADhXeHAzbjLU7Ag9tRdbHhHilZ0Le8C6EQr1VSKr3Vg
	Iv9kXY/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5Oq-00000007K5b-3IqY;
	Wed, 28 Oct 2026 15:17:12 +0000
Date: Wed, 28 Oct 2026 08:17:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
Message-ID: <auIR-BdWBY8vjXq4@infradead.org>
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
 <20261016050847.GT2705364@frogsfrogsfrogs>
 <a785481f-74a4-468a-b164-0b7a55c04246@redhat.com>
 <auDAzCf_MBLTmkBI@infradead.org>
 <56cba09a-305b-43a7-b0d9-d39820e8cefa@sandeen.net>
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
In-Reply-To: <56cba09a-305b-43a7-b0d9-d39820e8cefa@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 27, 2026 at 11:26:09AM -0500, Eric Sandeen wrote:
> On 10/27/26 10:18 AM, Christoph Hellwig wrote:
> > I wonder if we should have a way to test these compat abis in
> > xfstests.  Have test programs (or xfs_io?) compiled with -m32
> > and compare to native?
> What about 2 things:
> 
> A refactor (to eliminate the need to type out matching structure names twice)
> and a kunit test?

I don't think kunit is all that helpful for copy to/from user tests..

> Something like:
> 
> #define BSTAT_GET(f)            (bstat->f = bstat32->f)
> 
> xfs_bstat_from_compat(
>         struct xfs_bstat                *bstat,
>         const struct compat_xfs_bstat   *bstat32)
> {
> 	BSTAT_GET(bs_ino);
> 	BSTAT_GET(bs_mode);
> 	BSTAT_GET(bs_nlink);
> 	...
> }

That makes the code so much harder to read for no real gain.

