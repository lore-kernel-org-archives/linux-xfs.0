Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4F39FEB
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245366; cv=none; b=LJl3yjDQVsfXmdS0aVFJCiy1oyQd3ZZL5EynzFVoTSegZi7x8p4xJSkAW9fHGQXO33CTJ1QY5aHJNXCvoitY2rbdT2D7RF4wiKY3TkQVx1Dbuwc1p67ZPZnCebNy0iUjdkOwjkl2NzfA86tvjJ+YtHgKL1QhJtPR/T18b7x4uvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245366; c=relaxed/simple;
	bh=gwVOls5+q66vCmA0GKZfgSvWljOCO5X913vh2NUE5zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfRxvY2sY8D0Nyq/5X3kXGasby+JcSsAtU98ExwDI+ymcRRKQ2haunBTPa179uSCneyxafPoVUtT0wkxWw5V1FBXeMLoHCaYPsyEHWNKVNdbfAH/mYRvJ6cEqaxrG1Bvz36aSGzDMpG7QXejCK3x4J1s33kN7ruJeC5aWjG3/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kyDA/T+T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kyDA/T+T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WXIgtRa3eTkyzsiKPoklkwRVFVYIkNE0Y0cKb/Sk2ho=; b=kyDA/T+TImgqiVhWQ30Da3YzWY
	9gx0FQpxpBHey7dLNwpJNaQasWvXA8ZM8/W2P6kwL1QZ8pLmm9As5N9zvVpRhoYO4IvXpRbh5qpPF
	EiPHYGti6vAPmfAP0GaZ61k+nQSv3tXQTpXH8/Nnp3WwxiJ/Pylp3lQ3pZzFIqldgmdyn2IG7BFCc
	6E1qBb/TNE3pKMukDINpITUz6yOQ6MCRrUlx/ccsyHGQI9T7erp0/a9C+4OiJvv7bKKNqI4veJxDq
	HkXN1RxxgTThbI+16Uk4ao9p5/R0fI/fnhG1c3+tNjwG/jfcka0SBpq1i8oY6JODal+3sn21/nW8s
	z7GOPaVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbNl-0000000AwF4-0RVB;
	Tue, 16 Apr 2024 05:29:25 +0000
Date: Mon, 15 Apr 2024 22:29:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <Zh4MtaGpyL0qf5Pa@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:36:43PM -0700, Darrick J. Wong wrote:
> +			if (args->attr_filter & XFS_ATTR_PARENT)
> +				xfs_attr_defer_parent(args,
> +						XFS_ATTR_DEFER_REMOVE);
> +			else
> +				xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);

> +		if (args->attr_filter & XFS_ATTR_PARENT)
> +			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REPLACE);
> +		else
> +			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);

> +		if (args->attr_filter & XFS_ATTR_PARENT)
> +			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_SET);
> +		else
> +			xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);

Given how xfs_attr_defer_add/xfs_attr_defer_parent are basically
duplicates except for setting op_flags, shouldn't this move into
xfs_attr_defer_add?

