Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734613791B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294867; cv=none; b=o9evnNpDpz1WuTntXP+XSEE4mMgpf1OME+7QBHxFBAiKPomT4FFnEIXa0w4gF7DAIvH453oa11puc+WVvpk3GTqZPyCP7ZPbhQrm6rgyWhiTxC6JIsIk0TY2nNVy7f2UTAVwFfZGJ+2Orwna/2ivVGceWcH48tiwGHXKn+g0Hyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294867; c=relaxed/simple;
	bh=8SBnpEKhEBn29sV7AUsJPtfG3wmTAhBQegdyHDk69NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gfn6bx+l7MnKafN8GBKeog1Mbg3duKY/pjdmy5XUStuyb9n4Y9ihlviB1tzjAOEfdCcmMir+1j7V5FVvdIn/hqqyb23LDLagpeZoaNZ6Vh7Z/F5UYZnxk+PJncIan3JrXie0K+iwxGKtxIMWpulAgUQVoad9MUQjvj2TPAHSf9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E0nOvCgc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E0nOvCgc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RrdTNu+szuIlz6GeYNfcC/qFhzMWAKLGFnHlWX8KE0Q=; b=E0nOvCgcKqoNPQWdynquIt/NKX
	579/RaVZiXfuEHPx3wucFi5HVyPpO/piHyL75hNxpz6kDm0auAs5gnrAc73dA2DorwaEVGXbI8INo
	YjpWPwjtSNc2Vqh/7NW2sE/O+gmneESQPsTErdHtkeuSFTTS2IL65Y/P7vAfyfBzU5gMMzE7eCB7j
	wrjtH9onBGWV6Y4aBdQggi3H42+FArTZHL72FKq4pDUsqgpgX/mPQAzTxtBq4rA0zbxgFS+qxRvoh
	dwYQAGoTcSDyD+gVQU8uCIFS4zQOEOD+ZRJf2/G65sNTh2VHdexiW0Qy8u+/k2aB6e6il7+oR0zel
	tY1ycMHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwoG8-0000000DUzb-3rxo;
	Tue, 16 Apr 2024 19:14:24 +0000
Date: Tue, 16 Apr 2024 12:14:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <Zh7OENwAEADcrcvr@infradead.org>
References: <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
 <20240416185209.GZ11948@frogsfrogsfrogs>
 <Zh7LIMHXwuqVeCdG@infradead.org>
 <20240416190733.GC11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416190733.GC11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 12:07:33PM -0700, Darrick J. Wong wrote:
> Ohhhh, does that happens outside of XFS then?  No wonder I couldn't find
> what you were talking about.  Ok I'll go look some more.

Yes. get_name() in fs/exportfs/expfs.c.

