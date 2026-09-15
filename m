Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A043B47F5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475147; cv=none; b=h9zcfLdjxvPVUi5eZm/Nz0rkDsD7K1Lb6BqZ7cTYbpKuzUepOV+Z1ACRapbiOrFd0vdNx4dVNH4QVSUPe2O8RG3tDYPxqE1el1TC1NRyAHAP182pBBI8XdFNNuhxURjcMbZ2GnmtKhwqyjWpaeJ7YVK17n1ipKIQzBqlWeHVwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475147; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmEyV7xlmdYSUu+gdcwEjq8JfE3h4NlpLjUFnnwhvf5zh/dUAWDJ2+gnFSdvNtTsWHtbGbYRZGc2bUEhXhCuyby4IPrCs4MY4r5fDMnrFmPfrq+cSloprV0wnbnaF6WdAg+/z6hcF286o93mPXLI+ElPk+jTf7+AWD9Px2tpMwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=URMCEzCL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="URMCEzCL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=URMCEzCLy8UOhsOu6WMMN7zSsj
	10Lq7xrketrMSxH7jAMs1/jHLnL0wJmEDgJmEZzQZu9qoRWZoO0ygGGo6yqGeGxnSw973gW8W0rSg
	HaJkNHKQhcjCTOzJ5SXpO6n4RFoE+hXzH/Moc0QWpzSEPrq85vJofRai7CbSXOoxqM12rUgR7UNAt
	Q6szq1+2gkI/NeXWvaLUnv3kTFyfWkYw3TTFc8dAh3QPZiVQky47B2ywLyV07pSqMn2KOWDlb+heg
	GL8cTogNFNnnDtX4TaMap/GLWuibK8aoZ5V04NcHUPcBsf5FT211PCRPPYap3/lose1+vY2bRt/qZ
	1xMHsgSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SEJ-00000006UEX-1Nm4;
	Tue, 15 Sep 2026 12:25:43 +0000
Date: Tue, 15 Sep 2026 05:25:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] libfrog: enhance struct fs_path to store optional
 mount fd
Message-ID: <aqk5Rzcv9XMMhraH@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484862.2108717.5940087474719549167.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484862.2108717.5940087474719549167.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

