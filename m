Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9038389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388919; cv=none; b=MhgzKxgBuS74+E29k6N+RvOBk4muIto3qSvdI24Tii6lpqGPYCjjExXvb7Vqd1R5BZ619PxUzm1Wi+/bgnFYgBwxNLRDKa4zi9KTR/E0o6v5KLiplLC9l3RTPXGV1rBLyaqqcbDMJh7nAdRNtH/rpGOWlApHDgaxwbinWdoe2VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388919; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHml0mnqwtzjFaU1Q5e5viJBQG7ba7qnYq3x3MZmo2QFjtlaJd4NZblQfUuxjVf06xpW1cN24EJiGm5FVro2e+5WbcoY5vG/mfzDzDnPVL27IcatEKTj9elOIkknq1ybSmxX0xaxXiwnVT9Y68hrJ36OCWkMH1VzaIuNzmPDMeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hi7iqyyf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hi7iqyyf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hi7iqyyfo+uoXGStgsATnK/ze+
	W+Ng1Y5GnG0SqSHuGZ1pbpEzmd9FtPzhqBJU0btI6wvfNHkPlh0mL55m8omGF/iyfipnV4wcK3Dca
	0cIogzQoSwdixLxuZ8yQ1lbx5N/HCVFvHhXHgiGpCNvU0utAmBcRD5zv0xIAS97Blz5Bkm1fLELr1
	GzQs+JzkG7yQm8F8xhlOhUebx5MW2diQZJFybsTboDq/KGqYpLtA/Nyoz25QwsD9LmFCM8V2oDMQ6
	T0Fvf41JhDHrDsH8EMcHtn/A7vku1b+j47NqQrUX2HAT/UE5CLd7fUP0rjj6gO8rgFSMfCO0qxTE1
	WYK8grTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMKU-0000000FEng-23dB;
	Fri, 23 Aug 2024 04:55:18 +0000
Date: Thu, 22 Aug 2024 21:55:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] xfs: check metadata directory file path
 connectivity
Message-ID: <ZsgWNj_3D4ddqfGW@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085587.57482.11593695943649872387.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085587.57482.11593695943649872387.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

