Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDE0194A65;
	Wed,  4 Dec 2024 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300861; cv=none; b=HZqtK3etCS8UJ5taHu8SJTI0MYBhUnKvLtJ4bLSEVkjyqGfiVUo65G/vUBG3Y90losVm9Bv88+Q2jDNUkFkqaKjd07/ITVk6gPewiY15k/OTPux9Zy+pARsj84Sb1de2OG+QkbH63WYwNGY0GOnsCF87wGoJTDRQd4UN3Fq4n6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300861; c=relaxed/simple;
	bh=3PAdGlK1PBb/5QbKhuXphs8txq5Ea4b1Kv9m/dTFb7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoKa7ljK8hTIyOLPx3+OvspquBPVo8xtL/KthJ91FLtTgT9vwPTtVG3l+5niqdY9GmaPZ/glmeyhuwA6dHaWYELosfwtSMcXmocTYSRwOwyW8Deg1EYQAmR1/gHFUoc8tesRiusbHeELcIaf4bRXzEVx+fxO/nh9gFazkThhH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hH/OI7he; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hH/OI7he"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BsXSuJk3ItUrYBEbPwAqLO9YHFFao95G+5kD9387LRI=; b=hH/OI7hewtJI3yjcgveARXop1L
	CqCdHmRmuYvg0AZpUuXo4z19krwR6/Gma7p6YNLrHmtu29OcbClsJMjhYkTFFLN4S+kyF3JjyBH3G
	QCu/d1WX8rVQiS1CP83hhKVsYy3Ow+adPhddarCD2yI0zjSX52TpeLV6Qt/jaKg283h00KVLQroO2
	c/V93w/GAVeh1DXg2rDTPZUaGVNX4182KUEx6EeDXU2tgkhNCxAy4np0CGPMJC/qXlVyeXpH3slZk
	XR8HYbQeBWAcay0ZN8TJFKYOAxIKP0fwgCwUv9oe1efq0ct7UOHlYhDt/vPiH/SRM2Tgzh/LiUPZQ
	hP5/GCVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkjS-0000000Bsi7-3S86;
	Wed, 04 Dec 2024 08:27:38 +0000
Date: Wed, 4 Dec 2024 00:27:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/6] xfs: fix zero byte checking in the superblock
 scrubber
Message-ID: <Z1ASehwdTewFiwZE@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 03, 2024 at 07:03:16PM -0800, Darrick J. Wong wrote:
> +/* Calculate the ondisk superblock size in bytes */
> +STATIC size_t
> +xchk_superblock_ondisk_size(
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_has_metadir(mp))
> +		return offsetofend(struct xfs_dsb, sb_pad);
> +	if (xfs_has_metauuid(mp))
> +		return offsetofend(struct xfs_dsb, sb_meta_uuid);
> +	if (xfs_has_crc(mp))
> +		return offsetofend(struct xfs_dsb, sb_lsn);
> +	if (xfs_sb_version_hasmorebits(&mp->m_sb))
> +		return offsetofend(struct xfs_dsb, sb_bad_features2);
> +	if (xfs_has_logv2(mp))
> +		return offsetofend(struct xfs_dsb, sb_logsunit);
> +	if (xfs_has_sector(mp))
> +		return offsetofend(struct xfs_dsb, sb_logsectsize);
> +	/* only support dirv2 or more recent */
> +	return offsetofend(struct xfs_dsb, sb_dirblklog);

This really should be libxfs so tht it can be shared with
secondary_sb_whack in xfsrepair.  The comment at the end of
the xfs_dsb definition should also be changed to point to this
libxfs version.

> +}
>  	/* Everything else must be zero. */
> -	if (memchr_inv(sb + 1, 0,
> -			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
> +	sblen = xchk_superblock_ondisk_size(mp);
> +	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))

This could be simplified to

	if (memchr_inv(bp->b_addr + sblen, 0, BBTOB(bp->b_length) - sblen))

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

