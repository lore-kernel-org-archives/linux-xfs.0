Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E66615B98C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135446; cv=none; b=lU9G9plTinFle2UiyIWMxkqU0JsAV6ysBswEmLNEfAOhTEEO5zt1TmCUxKh+V9Lll0SMz2mzzqtzj7RF6V7309fNPH65sMglXUEM2bexpPRwhY7LS4kMY3eVupSDIk4MoS81Zg+oXkK6W4vctJlZawtuANbvyB1mu1ESP/zGR4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135446; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1zyNpN67Do6JjclxS8qQJsWjG10DIOkX62HjvwVF5IFM8rY81bc4CGezQrfTUOMTqyXc1sQ4zFYXQfO5ABfdVQXzzsFIIPibxwRzs71rE0C8H1FxCnzbSP4pKnbwslgXxJov9SFC2PNFuoGnNDI3UMSGAU+NfbcjVgQMfLPLV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Thz66ii7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Thz66ii7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Thz66ii7PyC9gsLydun3em1zxQ
	V+rzTGBMSknIQ2BXOkGHjKLURGL8xwguoxunZ/bU2eNhrMKcM1s2Q6FlJ/0OcNhVXpua/Gq/lGyxQ
	0Htf/bez118sR0rVwGs4AIJS7lOY4k1tNNSNHaYjISQe59SvOhmIJn30+WOaGgyhrb8IRYaevNjLh
	Sjxd7qu/BHdmWUAD5RsPZgqa2w8tS+pTXeOPXCHuLWNt8eocJ7gQ7aOlWduIVMhCZv0Qe/JRFz86o
	aQfJdnylqD2Q2v5I05zE30Wy4OyL4H5JzYUYPlDvX5+AA7fdpOCPExqMGJsfdpxrkfj4Sh2PEicXL
	7HKeDemw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMCi-00000009ypi-3fu9;
	Wed, 28 Feb 2024 15:50:44 +0000
Date: Wed, 28 Feb 2024 07:50:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/14] xfs: condense extended attributes after a mapping
 exchange operation
Message-ID: <Zd9WVAp-7JF2zsWt@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011774.938268.18374557632879056571.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011774.938268.18374557632879056571.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
