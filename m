Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66031984E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738367; cv=none; b=qYviUQ/uJXpQwL3ytNTMJVZCZ5kOh+0Gvh7LZ+XalvfwohSFJQBM9YOE02k6CdUhhhjkPV+hPH9KXePDhHJwsAfUsAUHQq4WHA6Tzz0zkacPZmHe5GobyBVWdz2jYK0X4r7SyntLYxmuIXpZeiiNiH8dNIf4cZKhCcNyGF8N2AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738367; c=relaxed/simple;
	bh=3vdv+nyRUv/tsEOWpVFsCWcKxGBbZKKjdzR2Rb3o9ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS3PNynP0lTMuNUhDLG5eSkpFQRmAlUhfb+zoP6aoGCTodMP8kDdQymX9Y9GG7bwyUtxVJf4EI2GBhZSQKmaD323qMZTCh1uPJTuevgw632Ju2QRkwc92+l3xGd6i5soN+iy0pDR2UJJVyyOY9qxNisxKJVHiAihcitXhjg/+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WB6jC+Pg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WB6jC+Pg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d+o59NCZNoHwSAtOv/yseyt0jbQRTGlFQnxihXNwCzs=; b=WB6jC+PgUPRKVsIMqd5XA2hb4z
	qWwger2lWhZPtqkFjG7Lz9T3B+Zk6QVNefG+myVqQQx71K4ioTI9i73hJ+iLu7ISr9+8gLSbWykum
	W6J4Fjw0sT5LiCGsfHHiis6sF2g4gQha0glzhlDKgPnwnxRCanOivAFBoaOdimZzMaJ2ymWjwskGo
	VFZM6U1nxINuxgXqVqflpPqfXdm4E4WeOxiZo5uF2SbybreIefExYm/C/zaT3a0JJgaWpi7nNzbs0
	r/VEQc4oQ5Yra7Z2tVdRh1bL3izlZvQnXPiHrb6l2feUJZjtpo2p0QzoDdNxPSje9+1wluxq/G2sF
	oDou7PPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vppwC-0000000H9GL-44Dj;
	Tue, 10 Feb 2026 15:46:04 +0000
Date: Tue, 10 Feb 2026 07:46:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: nirjhar@linux.ibm.com
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: Re: [patch v1 2/2] xfs: Replace &rtg->rtg_group with rtg_group()
Message-ID: <aYtSvJLCAPZXywit@infradead.org>
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
 <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 10, 2026 at 05:56:35PM +0530, nirjhar@linux.ibm.com wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Use the already existing rtg_group() wrapper instead of
> directly accessing the struct xfs_group member in
> struct xfs_rtgroup.

Doesn't really save much, but I guess we should be consistent:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Nit: your commit message could be condensed a bit by using up all 73
characters.

