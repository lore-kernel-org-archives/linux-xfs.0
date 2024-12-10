Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C10168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807874; cv=none; b=lWuVobGXbM6WQcTrn8eFby3qkaf3QDExLjq/aCjEvYmlodMqHkJsdtHsVSYFw04vh95B45TW+8nfTFFeHfdm5Q+1Upbc7oMaoRcy+mNc473IgzjAEsEiQ/62Cqpv3FuwBjWQLElY1fl5CLX9nvVNLzJ93osNETKGrFcM6ewDEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807874; c=relaxed/simple;
	bh=CeAiXzNedjfl5D6cYuLwrejSDSKxUHlReVs8guJV3gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNmKJsNVcJFaLPsIlExnd7Iymfrc227v0EMa8srUK2nLjiMRvZWK9wXUmVqj5p3qlzwMrUo43DQ/i1Ye/b12n+JSQ25PdoaeLX/n1j0TUEgE2yjkvNNxspYOun5Y2th1OCFuSykvuIQd/rYJTJctZBXVfbMRLS5Nh/M+CivoGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jkfq5l3h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jkfq5l3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1lOMVR3MRSJDF65Al8KkHlMMmR636yqaYaLAuDqbBPA=; b=jkfq5l3h4OBbACLHyqZ/NhIcRO
	VH45+MOz4H/TbAQqAGy4hBw3YLJ+dufDvcznhJobrj5hGrn76PrLNpYx/4w93DcSpEDOKnSRHEGxF
	Vtavzesrtpr6So1MrnVDHzx482KVdpGltzq+1+5coQKnWuVxGxSrwJWI2RRiEN8033KOmrk25xwPM
	6o7I6bg0iCOoxRxmH3v/dKgr8UQDQkzqxZZZmmRX7HzbY9+oskdrVcBtDkdNEbcuZ2bRIugnq779J
	QSy7L0LFCQUW/4RdLFw0K+vipJoqVNpvLPVw+TM/2RBqrl8lWuDeoZ9lX4IpankZ39R7RNKsPPSmT
	b/v0ZGiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsd7-0000000AGJD-06sz;
	Tue, 10 Dec 2024 05:17:53 +0000
Date: Mon, 9 Dec 2024 21:17:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/41] xfs_repair: update incore metadata state whenever
 we create new files
Message-ID: <Z1fPAUIK4dKEIBcD@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748710.122992.8928188548717908519.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748710.122992.8928188548717908519.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:47:43PM -0800, Darrick J. Wong wrote:
> +{
> +	struct ino_tree_node	*irec;
> +	int			ino_offset;
> +
> +	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp, ino));
> +	ino_offset = get_inode_offset(mp, ino, irec);
> +	set_inode_is_meta(irec, ino_offset);

Nit: I'd do away with the ino_offset variable here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
