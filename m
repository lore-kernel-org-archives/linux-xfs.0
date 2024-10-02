Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC2EAFA;
	Wed,  2 Oct 2024 05:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727847952; cv=none; b=YcLGL72YWLwjIY+tmNBtnKH1tiMbCYioTC8F5HiCuN0mjrcNgaG5zCz8ydcEe13SJHuWVMpysiL5P+okuOy4BPtXygXjalo4W0DYAmm2akBvTdkNbCOK/XlukG3xhYNrGx7/LgPBvSr0IPv2hG2QCgp+WiE547T5RiTE+7OpUsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727847952; c=relaxed/simple;
	bh=+i14UzwmtqKWpVa7wEFXSu9d2K//IgAAFhjNuPVNCK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eaqp62bdfUWFXOKZqH2gPrx0+OlO3zaNRMx1lkJr9kNRelAcI2g1ohg/VUMRs1aulucWr0Nv6yarJqthD8GtT7lR/kRObFUDZNCb/zjg9o9qa47HJpDAtWiahecEcrtwg21wRc0o7sw4xu6JktA3eluf+3UpLZHdCLsLXjMQJ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wv4wHRND; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wv4wHRND"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=47rxNjWHozFcl63eOw0wXN7QtlT++8WVCcG3Xnz1V9w=; b=Wv4wHRNDVmeid4vVA3zZTc3SBL
	JrQD7NNy3tt0++bKteNZqkzKi2Q1RDZ3Uan/vXcDmC2f9rwqhw7mzh/RSEaVYcpoDTOQIQfcDA+qq
	FEB0mElFsdCc10me5Ya0/UnxwGAcr22HD9SUtaAs07t3u7jfLRvCL0UFaR1Ca8YbCpj0LSkYiDot7
	ovoJaTnl0wAE5d1JkMFlYLQyGn/+KQJCKLcuuz7FMtLyPbzIft0Jjzg8H7mCDMRBaFH3L0eX/qYql
	UvRQkUJBXrmWLiDbWiwBVN/JScn94kFSoEtJ1pfzLsNMggDiXs05A9O9nPmivSX7oN6/g7RSkvd2P
	OuA7g8Gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsBK-00000004rZr-49iI;
	Wed, 02 Oct 2024 05:45:50 +0000
Date: Tue, 1 Oct 2024 22:45:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <ZvzeDhbIUPEHCP2D@infradead.org>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 01, 2024 at 09:49:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.

Meh.  Can we please not add more to xfs/122, as that's alway just
a pain?  We can just static_assert the size in xfsprogs (or the
xfstests code using it) instead of this mess.

