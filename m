Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815A44CE09;
	Wed,  1 May 2024 06:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714546635; cv=none; b=D1wT2jPaFXWbWhRlleLgv12ymDsH9guctqs+KLqzjKoiMtY6ONruEnmYKX2MiHoWK2bh5g1zKprhLJy1JeRtEFBWXe33cF6vj8mCALjlOzynNAUjMRXrEcEyymTc9XQgyGLUDxEvnunfvpSfbZZLnSn4XVdR9h9r0fQ/VYep8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714546635; c=relaxed/simple;
	bh=TgsqZADJgD730AIpatlVDp2WR/96NYFk27VPU5WiLEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDQbp888FamGHsjHTUdX+AgDW8bcJkOm/rVZgN//yVxv0bFe2Wq+FKuFJ9+aLAh0+KfPLZhOrAxCegKgdFdmRTqAMrfJ5d1fQVErupgo95OboybdczO6IG52cST64aqs+peuCW4Zk+4zZdqvR+1SJiToedYozDM98JGoRgaKTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iMYG2f/D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iMYG2f/D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oLnvVjwPNkzWIlGu6hUqTl/c3cOhSMGJXMdiRPXFwlY=; b=iMYG2f/DJB/rV3e7rGBDpFm2CA
	Z9kMvT0OeNfojucORm6T/RPqmSXVY1KofdDv80+qipcVFE2E4IXRpY8ESAj8gJrIstxOrSyGo7Ylk
	eT4LFL+g2byt0XLTvEl6hVFmwu9H5R9V23ehAJby0YGUWdfYAPN6/H9tDa/YcFUQrxv4SAF0bbzDG
	99WTaXeV+giEBV/MKRL7yzt31379xbbPT18ddgovX1XhYdZ6qWwbiYwyYdA8wZgk5hCsFOClwpTEm
	buJ1YuTFezSCsQv4+RN1nxySVKU3BKZ9eZlYEDun+3PwHdGIZfLtF0QKGHTvS0J+OqcmQ+jHTH72v
	eQ0RsYmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s23tx-00000008iRS-3F75;
	Wed, 01 May 2024 06:57:13 +0000
Date: Tue, 30 Apr 2024 23:57:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@redhat.com, ebiggers@kernel.org, linux-xfs@vger.kernel.org,
	alexl@redhat.com, walters@verbum.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: use an empty transaction to protect
 xfs_attr_get from deadlocks
Message-ID: <ZjHnya1jaNR1MpGP@infradead.org>
References: <171444680291.957659.15782417454902691461.stgit@frogsfrogsfrogs>
 <171444680446.957659.9938547111608933605.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444680446.957659.9938547111608933605.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (error)
> +		return error;
> +
>  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
> +
> +        /*
> +	 * Make sure the attr fork iext tree is loaded.  Use the empty
> +	 * transaction to load the bmbt so that we avoid livelocking on loops.
> +	 */
> +        if (xfs_inode_hasattr(args->dp)) {
> +                error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);

Overly long line here.  But I'd expect the xfs_iread_extents to be in
xfs_attr_get_ilocked anyway instead of duplicated in the callers.

