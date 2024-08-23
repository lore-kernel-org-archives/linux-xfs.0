Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E63F376E9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388197; cv=none; b=R1djI8TbWydjZ8Dm2ZA2CQhS6DM5zkfuTyD5pFVCeON+Q+n3BJaTdSIqkfPrq4GADVtFzkvZ7+rtxZo1tipaxqiu2bNiB53HIE8uAGaAjhbSGWP9NHmpZSDNggx1wIbBju2h4WvLb8hehbMai33WLK2JyDODpUq5xCf3zB9oJQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388197; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaghSOpycpExhurgrPlwnbOSd2ANodU4sKir+WJGKBO7/h0rfbEVwP1xg6ipIHfrSLhLKno0OPnqvxDxgUEEDRj9HIlFw9NORMSaqRibyePFq9va47zU4VLAJlzdjTpeiYMDegJv4ikiTi6yTV70k+UudyL9hRYmmuqI4C+NDuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TXgpJ7cK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TXgpJ7cK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TXgpJ7cKp9giNWf9nap4HI+yTt
	Ktfkn6MKF2i4umETJe2LSmpoZHGupfKUrszsry3Gq1gqcMir2WZSmPNrXKWNxgCMt13Vdgam4lSgn
	DWVoXVdzfuF9VFgftkMQSL9HvYCoIIP/3/Ij86wtDnupH2stQqKIZerzlW0sM+baaiv5PEVEhoBfb
	wDxtwK+eH+5Sgq+PHJyZfsIN4ohnU62n0IfDKFMMyZ3VTk0xGqKVVRSiSW9YdPXRqgYxnVK03GRfg
	tOZQhNjbEQzB6tcQxz1rHBI/8QuUUosrGe0bQl8sNNpJb4VVBXdkQ1lSsDeMW50dV+FpLLaViefoW
	ejYNxuDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM8p-0000000FDh1-2bC1;
	Fri, 23 Aug 2024 04:43:15 +0000
Date: Thu, 22 Aug 2024 21:43:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/26] xfs: record health problems with the metadata
 directory
Message-ID: <ZsgTY1ejHv-UiEoH@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085417.57482.10297933158673089064.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085417.57482.10297933158673089064.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

