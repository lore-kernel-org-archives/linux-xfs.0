Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671492BCF46;
	Fri, 17 Oct 2025 05:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760680091; cv=none; b=lSfC0o0M/i6lhM+lONIIY4kj6MppaMdWixoPJV4/rnwka71FIv0HHN8iL1PiFm1WXF80j5a55dLnFmZAIreIbG2eSsUWUiNA+RfjNgMoU0U4y4/LmZTquGeXVLEgJ1IApaSNqK9284za+gAQJlfCrxi9DuNYwjF4n5+lXy0ysjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760680091; c=relaxed/simple;
	bh=/D1xjtDE7vt7S5YR0II2CgOu0uNUMXVLlv+mb6ExZyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlkoXLjh4Kkw2/I6mErPZz1BeOmTrT74hLimQDVV9/XCnItsXZM5rmRLjfliIhPd/hkgkAUvohIeP6vNE6wTQ4xc/37LEJiXuv0R7QYIgyfbusqI7VaYuVVvTAqmoASgEl1DwT6rIbs29NMlBXS6I1994ligOixrqNgP7w4X8HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pvZJcKRr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pvZJcKRr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ui64RbRW2HAd1Vvnb+lfM4MFFsBWBkv2XNTXAnl7Z+I=; b=pvZJcKRrTqxh2ccjM6RYNmFEqz
	s4MwnQtEIUwXGvBypXxd8uLDtB9mNFW4/7W0St7m3tQ0TOJEbE+4GMUiZVlSakxzsOTMaMCxSyBkg
	txN2Euiq4iTEbZ4R2ZF83xy7vjmLzK7WhVXJ7blfpKTg2Is+JEcGfzx+qKOiY49kCaG7Tv9y+Y/e9
	4KEF8L+RkAb4t8acPS7mKhDMyd68vwxvL3hMq1M9mCIrGqqikN5zK/vVrHt4KYLw3XlUHKhiHhkDp
	ATyrlj5aXurlZMY+3PzFrN6UXftXV5PrC0p7+w2ltMa/4gXcnfs7oUV+ox56K6PupDJu1aRuNHIxr
	1oQt19bA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dJv-00000006eV8-2qly;
	Fri, 17 Oct 2025 05:48:07 +0000
Date: Thu, 16 Oct 2025 22:48:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 4/3] xfs: fix locking in xchk_nlinks_collect_dir
Message-ID: <aPHYl6uFyxQjhwP5@infradead.org>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251016162520.GB3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016162520.GB3356773@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static uint
> +xchk_nlinks_ilock_dir(
> +	struct xfs_inode	*ip)
> +{
> +	uint			lock_mode = XFS_ILOCK_SHARED;
> +
> +	if (xfs_need_iread_extents(&ip->i_df))
> +		lock_mode = XFS_ILOCK_EXCL;
> +
> +	if (xfs_has_parent(ip->i_mount) && xfs_inode_has_attr_fork(ip) &&
> +	    xfs_need_iread_extents(&ip->i_af))
> +		lock_mode = XFS_ILOCK_EXCL;

Please add a comment explaining the need for the conditions, this is too
much black magic otherwise.

