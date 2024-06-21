Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11852EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945070; cv=none; b=L9LgPiogXxMyJR/2bF2y+0U82ljba7fi8VXSF6A2wQLTnZwIlitW0zyvyHf2MUUCwV5hKryuZYgzk5RlPdeM+WF1Y2/ZCeU1+3nvKmXLmV2meag8aHj2Q4hqar7b9VyVFWDviSk2hQBPDisG8Ax4oLlTOTb7pBpHWstZk9IfmtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945070; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLgKAE1FQDT/2MLZQUPqteadG9py65Padc7bB28LPtq0G1rWqgB44Vb+8pHFBfxjZ8G29zHv4POPET8+KG2PNJnZIadDP22TE5TvN9ToxeTaIIECjA98TB8N78wEaNP6mlz4aH7jJflA7QgSa2rC6n9Ib4pzHD/Qydyhcc3j4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vdeOXTXi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vdeOXTXi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vdeOXTXi1EN6NIA7GkX0qJlWlt
	wV5cUoaeK3pz8tQAkUn4vgcQJ6MMHIchSJ7AjpztrKekXKf2GQncHv4FZtGqSpYoFxA8Z83wWy/8Y
	q0SOr24Kxy7FMRJ5SPgG2sOG8W+Q6WhbCkIEYxglxE6O4Mdgg38b4W2QPRC4fXtjXMr1DcjHTi2LA
	7WJWyy44yI7QS3k/KSGWGU3JQ8PgzE1GKEPnrANdqOhsbXFp7nJV0er1vjZlSijdd59KjAqL4DFVw
	dBkGBGXJiZ72ScI0EZ0IJXmGr4Mu//WZczdaw1rhvm01l53y3SCSZYZn1vuVovYk9bMEg0b2CBP/a
	Sb6oQT5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW8S-00000007ftC-2Bya;
	Fri, 21 Jun 2024 04:44:28 +0000
Date: Thu, 20 Jun 2024 21:44:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: create libxfs helper to remove an existing
 inode/name from a directory
Message-ID: <ZnUFLEMk2J0MLQAa@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418225.3183075.15347307047089870669.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418225.3183075.15347307047089870669.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

