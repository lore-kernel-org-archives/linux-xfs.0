Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13F11CBA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049088; cv=none; b=isoDJdnkt8vOqp+VD87eoookr6u7t0NAZKBaVTmqYOgx5IFD9V6UT+NzL61zgJndN6ygSAzyTo2Fg9ltVjD35V3hnp7SdTZXuUKyyCOOiUXIi5m7ABvaAfGDH85K7VBb2I4ayuCq7LRBbgnoJrgroPaKihk6preJ1rlkr4sUBNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049088; c=relaxed/simple;
	bh=LC4Fm36yIPyymSdJRF6O4bn6AANwKrdTor/EhKGJubg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETA1O/jvJWqLzPkapvORa2vuVH56Jpl63OV3G/fmkn9yQ2wBB22EQX7mpYzaFgwcvb2GpUKGRkyoMTJN69e70wRmxIgMHoMF157YqDrhfL71b6Agm+o9IGWgSqmHAOpSSmfSosBLNjf/HQcwO8ZqU6kSAuUEhbwQmlYT+qJ1s5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MiQGbvWr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MiQGbvWr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=30HaFkyVz+3IP4rI5GO1d+HJm/3k81R5W7wbrhaJ4xs=; b=MiQGbvWrI3ebTq2eDoxd5yARB5
	dpwz1CqW2O1lK4RnHp/e7KO3eSLdkfkmkPz918hlR25J6BqU/ALxlzdZDtsq88AlGLyTrtYZAsxc6
	6nMJsFXbyA70U86y2V6BalmFZ0avRNWhzy80HhaJhHfAzUWZr2IGeJJ8FtddhHiIEUaMiqFbcQKwd
	qO1Nc5GOEXWnBaZ941EKCEhdl8jfnCSKaacr4+R4OjdCG7oERGP49J/ZARjipqooQuRKLSZCDGCrD
	v3Q4LiQMJC7o+KG6dlX/AoMv8S9vZRVMXdhLnXS+tCe4g6lVbd/0SVUtvUA7B7sJ/jb6hUnBQDjKq
	/4MdFkrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rezjr-00000005rac-0oH6;
	Tue, 27 Feb 2024 15:51:27 +0000
Date: Tue, 27 Feb 2024 07:51:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs: hoist multi-fsb allocation unit detection to a
 helper
Message-ID: <Zd4E_0nWedVHXl6s@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011214.938068.18217925414531189912.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011214.938068.18217925414531189912.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
> +{
> +	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
> +}

Given that bigallocunit is an entirely new term in XFS, maybe add
a big fat comment explaining it?

Otherwise this looks useful.

