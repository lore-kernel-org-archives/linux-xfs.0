Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562167BB0A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848481; cv=none; b=rcei0WKj36s2jHVmxQtUG/5oIQl4ZJOG4/LRylVahdHbxFN5WYW8Rk/lFjXc6hd6R/y0boPHWe4IsLXM2PAFToTzmsO40y1sV62KcMIoDyaUQRyA+X7IQxCvmPb2GsrrHgHQzKT35puT6H2BxaXFF2WLEG2f2tn2YfNYLHfOJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848481; c=relaxed/simple;
	bh=/dblQcdR571zu4uZWliXIkGwZrLJ/m/IOpdpIQL82IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7nOA2MXVXH7zvEKK7wck/RtR5Pv0Xg0HxKwWw4xolyZfPvn3x1oYxZ+LOf+Rro+Ieqo0BFjLnz0UPB7nlgKhrcLc1Ss2ODQnzFgqNm7oA3sZ+z8ChIkoyB8F+t0ZJ6pEWSTyhZjrSdp/3SHhV8HOLiu7Vtu03tehwpzdswiGcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=151rFOxq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="151rFOxq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1OPmNRc+ldPuxIeS6hwhoqkj28VFLIOvO4WfEX5aYtM=; b=151rFOxquXLvoU257njjIcQmpZ
	zKoAKMqpehCibrjzrP9Llzn/NWf22IEvv4PanY8T1QPkPEJF3LPFH/qwf63dQMkE7hWjhtitexOho
	s24ZWNQHmfDW3iYKoSMnnTrURE58G1KtBIkaKCE0GjF/66wN9JupLRA+PWZkPnNp5lG47Pj+Y4Zlt
	GGhgJC278aOMoVfJV+O+3Rv+gf9Up2tn3iL+rLNLmfoN/dIyWklFAve8KUASHkWVVwGjIKFsLtgkG
	NK1jEw9jL4kejJ19WH5YmAn22/pSb2LWPnX/c7lLKNrA3Zf87ZzIil+j7R9NPWYS415cVGiIrJX0K
	J5Y/5zEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsJr-00000004saE-3VDL;
	Wed, 02 Oct 2024 05:54:39 +0000
Date: Tue, 1 Oct 2024 22:54:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_db/mdrestore/repair: don't use the incore struct
 xfs_sb for offsets into struct xfs_dsb
Message-ID: <ZvzgHzB19AWcfSoQ@infradead.org>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103075.4038482.16400875402327891337.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <172783103075.4038482.16400875402327891337.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	if (xfs_sb_version_hasmetauuid(sb))
> -		size = offsetof(xfs_sb_t, sb_meta_uuid)
> +		size = offsetof(struct xfs_dsb, sb_meta_uuid)
>  			+ sizeof(sb->sb_meta_uuid);

It would be nice to fix the formatting here, or maybe even add a a
field_end() or simіlar helper here..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
