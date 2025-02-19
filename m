Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08C117BB21;
	Wed, 19 Feb 2025 06:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945049; cv=none; b=mBfNJn+7Z3apQznaECs6a02wkhoKTcXm0O4jJbp1otHJ2QEmSMeCgeaKCnc3RL6jvN3ZUmuMzm6x0KEv0HTbk56nf45oMFH1ThpoWjchZ7SzWpeHSs0ibKk9YIzqBdRF3MkBfegippnwIaVFKX+61BKuAcPqTJmITXqSrDRPmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945049; c=relaxed/simple;
	bh=ZGd/6EcmqKa6xcriGkk1e3oAd9wjXWvW74j/gtyWFrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMWg1sZTi2gr0ESEqRvzQvhnv0fUj1D1TT9nD5HFyRasAJp6/0G5eR/PiNvQl4gWPJsKVRn+/OC424oX1gao2sKIlSnc6Pjgwa1//XQrIUjjRVm7b7eezyuzi5tEID2VesDDOj7HUrMkNfS9ic5s9PT39+quz1by5qt0SPsLiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gtiql+z/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gtiql+z/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CGyqZoCGU0FBhE623ZjTdZx36MOTEYM/NSe18V6jQ/Q=; b=gtiql+z/SE03PMvLsr22FQCiIu
	TloInQyWZ4XFVbWBUbbRvwQ8BirkTyhrCdV7nfurf4I2gGVDCa2tph+fZftZvGhSc8lMePBcnl+xb
	pxhk6CEIgiuTskPqT9WtyFF/1Pw543zl/CrT0XSslihrjMKYmD0jptSY2hOyVBurkR+nzY7i5XEds
	1NjATAiS2JJpVclsOS8KkaTwPiUaUlUqPMoNiKJuNjAIv0672WH+czOR3hTGrjXuiBV7nldmgMq1A
	mACaIj4crjUj+t1owqeFrqTHUdhl/KezgUjR4ZyP86r1Txsgjx2/TLnou339McpiaqgNVX2IGI6sT
	GO2Bn+gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdBn-0000000AzKt-33rr;
	Wed, 19 Feb 2025 06:04:07 +0000
Date: Tue, 18 Feb 2025 22:04:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs/206: update for metadata directory support
Message-ID: <Z7V0V1nEKUE7LOzv@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588135.4078751.12082973016977797784.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588135.4078751.12082973016977797784.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:54:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filter 'metadir=' out of the golden output so that metadata directories
> don't cause this test to regress.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

