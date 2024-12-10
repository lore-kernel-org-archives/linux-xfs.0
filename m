Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0A9BA3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806896; cv=none; b=sAYR/MJf3LcFXlR5MOoZI2H4Q2kuh9k7Y5uskAppnH83G1ZKczBRE8V+ROgtTAE14IKK73D/xpaPHz+QAw1CIsMxi3MDXpW3ey6+K0MfIWZrTKUKhsMUzEpKD3yiErcnbN6P++OjMzDHjzGm/Rr7pbMm+7aFH3TB77/izVbPJeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806896; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtfMYjejRvocxOP9iwb9+9WKCywvfoatg123/tJuU5yNvh7FU5hha3jSVul+Uv/ennJdcezoSNE3FeBRl2swZLQkaceMMckQDrgJBrW/GnArQI5kMIR//u5QMVLeohlbX59dU1fPOY0GIQLoHxk61ovWki+MKym+WZUuJIgNhGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cbIsOiOH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cbIsOiOH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cbIsOiOHWZg5QMVxbW9pUYFSjR
	TXYx73K+M8myhE+79kVT4Ju545YQacVSM00jGAS24WXTk2JxovVn4KRL5iaTDziVRBCl3BuCgWeiY
	wWQVJd04pfBFvqv6v04ob8CloXmxMlehkRmI3PutWOkCdhgdvCJE8YWEepSzL9hCbzQsuR+Pl6XB6
	wsoUF7b7SZ11UXJzeQ0vmVn4SUJlOjz156GUDmaAeFEdaROaJ4JE6nvUb2iWyEkInn9sTYK1TWVr8
	LZkR89c1ug9ikhfVMvgikdCVpHuNn6yQAtT6OmvHlYi3PJpPe44ChTOZzXr+UcBEZ4NykeQbtgkYV
	wS5uzoYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsNL-0000000AEyc-0nmV;
	Tue, 10 Dec 2024 05:01:35 +0000
Date: Mon, 9 Dec 2024 21:01:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/41] xfs_io: support scrubbing metadata directory paths
Message-ID: <Z1fLL2KunClCxfIb@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748483.122992.13810127442680845944.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748483.122992.13810127442680845944.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

