Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB1E41C68
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328870; cv=none; b=shzUk8V0v/0UkiGKb9C1IKPnWikhCRZL8eOfSYtPLYwXi0VhGEg2qpk/wrPgEt9mwhrkwmNWbGr3zXio6eJTFJDp59LAqMFU8DbSo9P2XKLWRfylro1U/SXVWFDYVV9TPmrDgIF28cGTGiSs0nYBWZ3VkAPHOowhAjEUMLGQvIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328870; c=relaxed/simple;
	bh=0JrYLRitvHSFTX3KWYZj73N6ctvMvcXNCwFwlGE7vp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUxjyfxbl3Odp2l4Rcu/CjhtxbcDzDCld6ba8Y93ugl9rKHPViSL5/HmgOFmx6jmG5nTEDkTo+1fgKdFc+VurgP59mihpOwW3vLxsnfU5XS3+PbEakIBWuP+vCoIJPg9m5PwCtKVnIj3+Ro8c5MQHKnFDWPuTmhxPSGQLGngnro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c2WX5rHN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c2WX5rHN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P4UkeEpVktKSzVTG69kHhT5IIKTYWY790GKmz2Opq44=; b=c2WX5rHNLBbfg7bT50aFf6TpEf
	VDykBnWaaYrN088QUuok+Nfa8h462klu/T4NGRDfHxIvVAwwqFTjaFFuxFEakQKb/C+MEwcppO1fe
	VcjBlEKH31VOIlCRvCZf2hPUPqDV0LpaEDoU3G38Sj05XY4AmY77IHxNlBrCTEf5x0aW+p2OoLHwc
	Uev3nJzLa6o7xMrcfS8ow9W1Tmds36VVDXjmEgvgM3tVFV0wgJPRNgW8fKYrg29rMQjgdG54+X6V4
	A95FbvMsM0UgFwozSDb9mdghIdrSB15xTD/UJBB2T+ME/w2G09l9RP3G0H9/NAwMHLwgUhiCXL6C4
	RGOG16aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rskxW-00000007bIM-2J68;
	Fri, 05 Apr 2024 14:54:26 +0000
Date: Fri, 5 Apr 2024 07:54:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
Message-ID: <ZhAQom2KGeUw8vpa@infradead.org>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 02, 2024 at 10:18:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the next patch which fixes an ABBA deadlock between the
> AGI and a directory ILOCK, someone asked a question about why we're
> holding the AGI in the first place.  The reason for that is to quiesce
> the inode structures for that AG while we do a repair.
> 
> I then realized that the xrep_dinode_findmode invokes xchk_iscan_iter,
> which walks the inobts (and hence the AGIs) to find all the inodes.
> This itself is also an ABBA vector, since the damaged inode could be in
> AG 5, which we hold while we scan AG 0 for directories.  5 -> 0 is not
> allowed.
> 
> To address this, modify the iscan to allow trylock of the AGI buffer
> using the flags argument to xfs_ialloc_read_agi that the previous patch
> added.

Well, I guess we need this as a quick fix, but any scheme based on
trylock and return is just fundamentally broken.

Same for the next one.
