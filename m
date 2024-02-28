Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0885D15D5CB
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135850; cv=none; b=o2i46x4N4Lvlnnuhwyae/DtdfP8ARZht2LjO8pv5n4w+3pkOGk2gaEu6wKRp3mcMTyHZK2dqyGzTjxw+T7TBq/jAchLk7ecHa7W4OrfO/lZhwkoSCHT/w0OBVgo7h1h/Idk3jImXVSUXPKJWHy+aKHyCDgDDhwR/RoZPX89KA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135850; c=relaxed/simple;
	bh=zInkXezxcNAksY8QdawU7pJWb3rhWsF/lrCRcO1nFJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAw/087IHvVOF2RimtHWPKm+wdJ03P4y4LNsUNwbjBwptdRiN6/AcT+ugrhB+rtWfEiJ6JitjNu4qAkfkv5CkbZiG2n5JvAuFht7TZQe0LqiLcW68tSxw0+e92nyn1Z42jl1I/7AQ1M8c3dK8x8hdJnN3uXA9RLxnnBcdSTJvBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sy21Vsi9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sy21Vsi9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F6/zpPkr0S4PtktP2ci8PTSeSfV/AAC2W+tEYU2i+Fk=; b=Sy21Vsi9FC9JipyeXumTxZuT57
	5/Yl6I2uJy1pbj3WdAzOUFre5ORJEQX5yf/EQ71Q72NYAsUsQ7sX82dQDXHPH9NrPWsYIIYn9RFec
	rzTll/S/HBtQaBrkxBCJf9MN7E7SreQgXCuVniP0QhWUzYPH55kzwvDXW0RD7D1fuCGIMCu9FRgEF
	33LZ/yyVIIvTIRl0Aig6HeGXzc/dc4PjbpDsRIdD5bs9bNt2+TnrYTxAujfTOFp769aPFKVgEpZ7G
	mhkdbh1lq6W4F1kRBCer7hMe20sh8XgCNMYZ4p3s9QvUtGH2Pb8LljMV7VNuHB+qgZkBq23319vWE
	AObQ4/3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMJE-00000009zy1-1xj1;
	Wed, 28 Feb 2024 15:57:28 +0000
Date: Wed, 28 Feb 2024 07:57:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/9] xfs: validate attr leaf buffer owners
Message-ID: <Zd9X6EqqX3hi56I4@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013143.938940.11677015146987204748.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013143.938940.11677015146987204748.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	trace_xfs_attr_node_list(context);
> @@ -330,6 +339,15 @@ xfs_attr_node_list(
>  			case XFS_ATTR_LEAF_MAGIC:
>  			case XFS_ATTR3_LEAF_MAGIC:
>  				leaf = bp->b_addr;
> +				fa = xfs_attr3_leaf_header_check(bp,
> +						dp->i_ino);
> +				if (fa) {
> +					__xfs_buf_mark_corrupt(bp, fa);
> +					xfs_trans_brelse(context->tp, bp);
> +					xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);

Nit: overly long line here.

Note: this function would really benefit from factoring out the
body inside the "if (bp)" into a helper to make it more readable..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
