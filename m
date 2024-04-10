Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40EA1BF3D
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725632; cv=none; b=uLAB2UdBNjGIkXPfZPWX9RdqbSLWOvieFOr9YgeIeLwIg9/Ri99DEl2M4Lx+a+QQmEswie3NqWg1VGs7im0zIp3rQ6WIkJBn8F/p6cPNJiFrx+P9h2UbF+9P0Q+9pq4PLu21jZAjZ4iF1lGQ783RMt0DmC9XCGIis64JjDAEfV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725632; c=relaxed/simple;
	bh=FACNiL3oAwnMj0unxEjqgqni5zQ78kMParjRigpfxLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gn13IDO+jm9/ryCYOw5+/NLp88sevoxBhH0y4bGsE0XpQ7X5osHpI8HSGh0QVxKjc9cpGZ9dsSdWMiv8EcKMqs9+AwDyL0f/ONREehSOeZP7ahNzUDg/gzcG3iy6a2e23UfuXtZDW1vWQXiD+/t8ZPx5Pzl1IdBe1vq0L12b3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FB+RRUo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FB+RRUo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DCF/+v/Mi53Cn+LzGEgbt4DTzQS6CACbPvauQZWoyrk=; b=FB+RRUo60smVILuPWja86/qp7A
	EG8ui3ekYAJ45YbKg0YTuS+ZHiPkSUDj5n/3f3AGN284oYBElt5dMWpWFrSDyVVOPuHHmRUkENcJg
	TGhwMnrWAHEx9nf8ZJN95oy1cRuHSWU/LfzPZ0SUK1chNX4g32VfiCOIltqk34hs7jBEinUjgSojK
	nBTrjrXyHsTSmrdZTYrSQoUBc9KVmyJm5z817XXIZc0tetYe0QT0F+DjCYcMw8eRBdJl7uAncmiyV
	0V7q/ngy4aJPOZRzESlOB4Ch+m8Fl71e0loVZmUAmk8OIrRnR11ObOBsyNBLvAYDnP3CdWLtIUZbs
	mkWSxHQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQAw-000000057Vn-1m8Q;
	Wed, 10 Apr 2024 05:07:10 +0000
Date: Tue, 9 Apr 2024 22:07:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: fix missing check for invalid attr flags
Message-ID: <ZhYefgcsDhixG9AG@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968933.3631545.17328111564626328171.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968933.3631545.17328111564626328171.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:51:41PM -0700, Darrick J. Wong wrote:
> +#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
> +				 XFS_ATTR_LOCAL | \
> +				 XFS_ATTR_INCOMPLETE)

Note that XFS_ATTR_LOCAL and XFS_ATTR_INCOMPLETE are not valid for
short form directories.  Should we check for that somewhere as well?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
