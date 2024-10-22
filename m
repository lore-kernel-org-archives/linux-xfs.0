Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555D71E529
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576193; cv=none; b=htFN7LgIUcyyatRs52phY+bDO/Kxw4+XJ2stBg8w5PeM00+gr5BZLMAXqoJccxuRMFtG4UlCkVABpSyU1lBBgmZEr7xuiTXNp0jmcWGjA01Sz8YBL+Ejj9Qsl1loHEXcWt06yEZBNFPtOMzcbPkHys6gkZA7cbygaUg+hR/H/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576193; c=relaxed/simple;
	bh=N+tI36g4PfA8HBN8LzE/miOmf0ZunErrMtnifXjubpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooaS8/mDUUrDD9gM+fHB541JnDIs4RYimlNTyYhVhhpSQAoBmCadq1eQPVKkwsh9VweSsLnZGK1hg9LEO+PXqTvV0fRn9RAZ7B8rfilwmD+ueG9A/gcVajwKG1NHh6x0w4WblzR6aTxpdG4qMAreDWVmhRfz1U+X8fl/VEM3qZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z54ZS0SE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z54ZS0SE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SqRCAAezv5X59WozyWn/3ZVImfdJadBrgUQPFpWN0Xs=; b=z54ZS0SE0P65BvFlNYbk5jjZ+a
	hVOtUT6NKULxVyhDWhKyGJl3STEHA+i6O7dWoxNkKGE9GE4/AKFoDujyLEyIcGdFRb23r3mW7FPt4
	+g+gF8AW+WYfzq7Y6B/LBLTDuWERgpiEQilTMTKoPHVKOIuJa/zv7Sjmb9f+HdFWJ7hMrKCcBNv/k
	G4qePxgkaT0XGlU6/mLEwEFgkCUJxwrvsy9WiEhCkcB22Vx02yGMdv9yq3F4WahuJfLS3FssLgWy1
	IkWcEJzPK3Q9YAV7uztNm88LmRBlqCkKN8b1O/gPO9MqOrfPWYPDXgYdirlASzNhvMF0BR4Aq//XZ
	YzmsvOGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37mB-00000009iUq-0dxa;
	Tue, 22 Oct 2024 05:49:51 +0000
Date: Mon, 21 Oct 2024 22:49:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/29] xfs: rename metadata inode predicates
Message-ID: <Zxc8_8t64zBDTGF-@infradead.org>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069495.3451313.13697143366804161635.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172919069495.3451313.13697143366804161635.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 17, 2024 at 11:55:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The predicate xfs_internal_inum tells us if an inumber refers to one of
> the inodes rooted in the superblock.  Soon we're going to have internal
> inodes in a metadata directory tree, so this helper should be renamed
> to capture its limited scope.
> 
> Ondisk inodes will soon have a flag to indicate that they're metadata
> inodes.  Head off some confusion by renaming the xfs_is_metadata_inode
> predicate to xfs_is_internal_inode.

I don't really care either way, but the patch looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>

