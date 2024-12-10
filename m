Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63B81D89E3
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807226; cv=none; b=BTX3M1dC6v0OnSuwswrdPgp48N308dy9Btq9oee8Kh8ekLBreo107rXkqvd/wn9AbUjydG68RC9THYqFKIx4Qz0oyHbLeUEx36gbrPMe6GGpHHJ5G0EE41FShRnJxzI55QRt9gU8Vm3+WQznO4ChunmLLFoKWi3mNTfXJNOzvdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807226; c=relaxed/simple;
	bh=VJyBJYOR/U+jJgZCxcOvb/ra6bS4KfnVSyRC54lzQO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXRkocFrhoCU5S8yiJT4ONHigCMzcAJ3oyZYjyGHQ7JgIzrjp0WPI1LHBl2rksTl6yhyv3apE8V+ap0G6F6rslSuMozZIGBLteSKioCg+MQvvpksaSuTOH01DU6gohn8kCYLfJvTLnZec0hjR+uhNRjBclv9ws0y9PjF5bc5LCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NlyqZ0SB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NlyqZ0SB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jxbI7xEBn4sGnzgLaMxPB3BG3s+Eds3TEhszaWTIdvc=; b=NlyqZ0SBXgXWXHkzPjhVl5x9xK
	0mFh6hJMA0os8YJL6rrILeVQw744+WkUEKFMsDbuhOFo8vhEJuky0F+KaS8t6Bpkd2EKmrKDPVspz
	If566PfEJgHRRQcqrxgftq6UQROCYRldVWZhlUF68o41L5bISCceO0UcvUiW9gHcrG88sJbALRMSe
	fWfZzdhAHFn65YoTYkCPpLfGVs3x9ENwjRYKbZr5QDpk8xDHV/CmfNOsKemj84mPkPHFVUsa4ksfB
	sY11OtzKSkNytwgogTSc8SrPcPDLzWmx2Nx8YvtM1k1O7g+5YldFeosKRK8VdlnhrHBTk/5f5IR9g
	jKDdLXwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsSe-0000000AFOb-1aPc;
	Tue, 10 Dec 2024 05:07:04 +0000
Date: Mon, 9 Dec 2024 21:07:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/41] xfs_repair: refactor marking of metadata inodes
Message-ID: <Z1fMeIC3XEMK2sgh@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748603.122992.7502270004875178872.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748603.122992.7502270004875178872.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +mark_inode(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	struct ino_tree_node	*irec;
> +	int			offset;
> +
> +	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp, ino));
> +
> +	offset = XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
> +
> +	add_inode_reached(irec, offset);

Nit: I'd just skip the local offset variable.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

