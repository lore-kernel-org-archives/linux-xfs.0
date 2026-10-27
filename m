Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114329;
	b=y4qnehXpe07WtUY/ZWnxWuoh2HHFTFpqnlBboY6fUtWwJNPsQYvUxydKIysVBefoW34G
	 +Q39XwsIucogUalhoQ58EP7vgXxJmo9GvC1bUEWbK7SyFDdHCZyQmDGfrcpk0JM0yPZ0P
	 vQJZw8rmT1pgRFn7vreY14fH0dDvMPsfo/1fGoE/+6nXKs0rxmlBtoNEzh3IibXddQOmI
	 2Ub9jtwJE6SdtP/tnm7xTiX1yPZtrgTXyIBwVariWCyBZuCgHcM/lWNbBHlX9Ak/DA3nL
	 9sEoiJOg9jPWUGU5exkCL8PwNkxs4YpAwd5H7l6is6vK3feCDIUlphI5wXukgC7Pyfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114329;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=T8WTmRbU6Kqgc5KPe4HbrIpfAnkNPKGlFuwjEAMf/uicA1G7IVzVtTKjnn1cRGZmlCCm
	 ee98rOAOWXgNp1xndWU3H0sBoXFCzQsh7tAewGqkAmX6LOhrssX7TRZVvYyGRmHvwBY6G
	 Md+ewLIzCkh9ZX8Y/lMgvsyqzGl1qxbdyaJmlfdh1KsaKSRedTHO5a3wH6RhNPp601LK+
	 YCc6qhL3bK5sE9U+GguOgSSJC4c7cBwC/0LoAnk92lt+FigqGvBSCRdJz5Ub3Ps3IvirE
	 WSH0Lsh6nVYjiXNqXam8vUoMJDEJQT4YT2soqS5YMS0Y6k4ghSXqsX0OT0VeGxnK6JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SRHVN1Tt;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B27B606A31A;
	Tue, 27 Oct 2026 15:18:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B27B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SRHVN1Tt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SRHVN1TtKg40P+pgQ+Dne93SVm
	20Jcu7DNpz8vyl/GYY6kG/sAM0HdUEKlK0t7Kv9MAHapPGutzm5oXG7qaSfsjxTVmsgDi7kuwh7c1
	OR+7XRYOcwbS5+dcnV3G2RThlVErUKSJp73bjVttOxu8+lihwxSDaDTiooQ8Lwyk+BQAPU4ck56DX
	30Hi9FA+tvMdYivvwipJ4GANcC52A1usWcZOVsJd9EXORsSeYFEECkntvMtWMP/XnROWumcPvJCT8
	DDyfC9fy5kUZTJlAecKE+hCVldP2TomIMhTIDcAcDwDmdJDPH6xifop4BAFJMifTtacDRzLHetTwu
	y4wSio8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLiwq-000000059Ah-3xXz;
	Tue, 27 Oct 2026 15:18:48 +0000
Date: Tue, 27 Oct 2026 08:18:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Reid D <skibletz@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
Message-ID: <auDA2DWJqSSJf2kh@infradead.org>
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
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
In-Reply-To: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
