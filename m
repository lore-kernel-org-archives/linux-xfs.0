Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018713B5AF
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712811026; cv=none; b=VyKZyb4BTCZBJdCuNMYfevuX2QAdfxE+EQsGusAE/Boz0VT2oNCPMX5Rcw3p+ezp0cta30oWtM/5XIT5QpiuVnX1LhzBU7foFkNegEqW1dy/OMLDkqXXlF5gv3KZXnLMZA0+RHlW1/nVTKl5E0xSlZj1OYWMUDbkP7vPaFRKX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712811026; c=relaxed/simple;
	bh=Hs6a2eWB3mZrsyG8bQ4ygkAgr1TYJGPsYZUnNcnCGFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mu5ySxxyX8WjJ+qjnDXYUcdGbsaSnCwi/+Sxo4df3WXdQ1w6XMVBSYAFSfMwLEUtw6IuejbF/3aNpG0zrN5kQSnA9cTIUQw02NJcnorjiOJXq6UgYKqKXT2z0BPfk5s2oMVX79+mWATNnh1y7xuIrVHvzb7eZFCpTq735PszfuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0IV2eztb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0IV2eztb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=45rgfrz20Tx5xYlOnLOhkojQhlaU67RW20ih5J2aDQ4=; b=0IV2eztbj2ssjgonQrICrGpG4e
	DxiTRSi6hL2KIwIl5aYtFVsHQ/Jqiq4CXaTMeWstjMVLDFHehVXDCpIoYqxPE6f0oIsKKiLsQlfRR
	qJpCnxDilLLQt/vYEbXAmGsoRoNx4yk/ZRZB7v7BTzFulcBcJHg+FjWNsuZZ9HPOZ3thm9A7v7u4D
	4wxzAyuGZMaNLrt/ga6je18UeC8F1EcwUI/CZG10awe/G/Jp5qW6o96Hd+TC3+vD2uuAz4A8tP5DX
	s6LRccTNiBumb05xc8KoLUkUfhc+U9fiYfKrph0i5XQmMgh6qLmXBOhLm1Psxno3YJ6tUJXsfBwYG
	bAJ1el1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rumOE-0000000ALCh-1Pw1;
	Thu, 11 Apr 2024 04:50:22 +0000
Date: Wed, 10 Apr 2024 21:50:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, catherine.hoang@oracle.com,
	hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: add xattr setname and removename functions
 for internal users
Message-ID: <ZhdsDu_-vLo-f_9I@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
 <ZhYvG1_eNLVKu3Ag@infradead.org>
 <20240410221844.GL6390@frogsfrogsfrogs>
 <ZhdZ3IjRjdvqtppH@infradead.org>
 <20240411043048.GU6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411043048.GU6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 09:30:48PM -0700, Darrick J. Wong wrote:
> Heh, I almost did that:
> 
> enum xfs_attr_change {
> 	XAC_CREATE	= XATTR_CREATE,
> 	XAC_REPLACE	= XATTR_REPLACE,
> 	XAC_UPSERT,
> 	XAC_REMOVE,
> };
> 
> (500 patches from now when I get around to removing xattr_flags & making
> it a parameter.)

Heh. Reusing the XATTR_* values is ok, but I doubt it's really worth
the effort given that just one caller actually uses them.

