Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDA5823C
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367386; cv=none; b=DymV0Tl+5mUorKZsRN3zdRwuu+JiDadkoU6IkxirLaNtg0MhGDKCtrKcY4Qh0Tlx3vLavuyZLaGyFP4ucIXe9nB67BLVKyhMR63rbP6EEzz/ksUlmP5ZruirzT3rtaC4A/c1qwar8AHtOrGxkkuUIxQLUCKm1CIOONnVbnOYWhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367386; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5yb8/XBdPY/J0S+fYyyLTuzK3XFW5V10O6sxE6Hhc4kNGsfPlcIZHHaaje6eNcS4BYE3cWBrhlR31C+C6jsQN9leqRMzFBHijzDDxFrqzW9PhgCMtO1X1A4e7PqDiJnvuYGMHiQWHTFw3Up0q+9+705b9fzdq6niigTrP5LfEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lFPb0OxB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lFPb0OxB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lFPb0OxBWxDIFUJrSUuGmcQ1Oo
	XyR8e47PziPQrHVC9UeVV52KAo8YXavF6bJWldp7TB10wb0Gul9loqkv8yifvxoKtUHVj0PjLwKU4
	go+bFgOmeSiYIfwahLQ8SBVcyzz2gGEA/676ALFFPV1uTCZBnAhqgSkuCtRON2mSnJJ+jfUa7WMHX
	bA+KvVR0Skg/1Xm9DuY6uY/ThWi4YX7MUmtUp6eV2A9i+D9WFhXZj4GOQPItmPBNnihQNKu0eRFQM
	8t99MBwomzlQHe1OEwLnEDaaTi8Xs9+F+CP5lFvEdgB+vIAY3mS8AeOkUZBppvdeEkgHS8fRp9n23
	74RCgvGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWgi-0000000C44f-2Wbm;
	Wed, 13 Mar 2024 22:03:04 +0000
Date: Wed, 13 Mar 2024 15:03:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs_{db,repair}: use m_blockwsize instead of
 sb_blocksize for rt blocks
Message-ID: <ZfIimIzFQ4szQx-D@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430743.2061422.9896530952028500488.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430743.2061422.9896530952028500488.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
