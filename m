Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F2A3D75
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381928; cv=none; b=Va3feGi+MUEZBBQ+0SZAwEKfEQ+DwOCRUj6aWJlRUUJf6NtbbFjmzU/xUoDt6MSbL20EEe+7P3uHO9v0+EpidWiQ496x4OqEmyuB1b66KOXCR/hXjVaww1ld3Z+EXBSvVoNEAp48F+6AX/fIhW9ZmcUDvXFlnonrigrFijZCSBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381928; c=relaxed/simple;
	bh=4LMftuhwyo+RW5ceIwLDAS/t58Bpe2N31cudUylZ5zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5clN1oCIoXRB4X+toSbuu0G0hDMy3V0AiC3gniBHjgocW4fA1pT6C2pvqAlGlc20ZxT5mOmR6hMi0KN96gwRLpNzvMcQSZoHIbqH5/pQLCtftPBKZbv8TQ8W2Kw+OKOM0gs/DW/f02SjY71wJgVag+raVeFL0w4tIhSRwuc0+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GF0RkVWe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GF0RkVWe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4CGbtwLdPmcb21S0ZOMf9FQcdv2VuejnHRh866KQ1f0=; b=GF0RkVWehL7nl+7OazmRNzcNBv
	IkI0vYw5P7zd/jMivhGq1DVyG8i+XoUDAquND16kci9XH9LwA7fvU1nWYXrIecTvYERuKImFakQAu
	8sPUackhofG+mDEXxQsvHweQxDlgbAbxI9wo5ztg+wRg+YFum4NnDXfxNF/UuWaE+Cxicu1gtZxat
	mz92ComLgp3zIeRq0UFfwtN3q0l0A4kWhtb5t35rT0plYyJ5izc4d/EWCrQCIw29hoAmh9IyxGlTl
	zJ91VQvOm9e09OQl0Rplu/1x/Lme1zF6UqYDLvELk9WvQXgmMXpDCyx4uVuGaKV5YeoJonS7iYhHX
	toyAcKLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaTG-0000000CdN3-3yRD;
	Thu, 14 Mar 2024 02:05:26 +0000
Date: Wed, 13 Mar 2024 19:05:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_repair: don't create block maps for data files
Message-ID: <ZfJbZp0MO9cidwEX@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 07:16:29PM -0700, Darrick J. Wong wrote:
> -
> -	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
> +	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
> +	    (type != XR_INO_RTDATA && type != XR_INO_DATA))

Maybe throw a comment in here?  Or even add a little helper with the
comment?

The logic change itself looks fine.
