Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36BF1C8603
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 06:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759127702; cv=none; b=niMSxPKvBks3abLFlqeTQldtZXTJcS+LH3C7bs3bTYUpJ2y1GAcxOuyGYlWkGj2oYyEFL8SK80RO6PfRsp6qWRaO5bzWgYejWyZu1jX7SxCHpEB4hKBG2r7ld08BHNzNKjldgx/Oh7gp8+JsbCZKGLb5lgwE/u9aLiujpdzY9bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759127702; c=relaxed/simple;
	bh=94rR2PzWHh2rKcSXnDEjOO3rvjyeY+6CKWdH4ggZqEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idfJjQIoFbuD3uZxJYnavRSN7Iy6uubZison9dt6wuTEUFVkYM1QtMVPJPP2wE+ad4MJbIAJQQvwembwV7gQMQOkyyYuw2QEZnt6tXWsDCKaWdn4xJCdEKr9lKbkKO6DqOthoy89UjxMdz7qO5zEBv0Ol4gtGmbYXaxAhYsYAi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xe17eTtQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xe17eTtQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zUG6wCDNXk/NymlkrVd9Df6zqgPbAOhi765Fabw9B8o=; b=xe17eTtQXBNUkwjsnw9DMJgvf7
	yzVFP24fHHiSLh8ElyKio9hjysW6OkLhzQ7HC0/ARLdQVxOYKUyBeWGedto8Wounq9K5w4vbe2bSQ
	pBmMZA39bndflDbW4ov98IQdjTU8gXgFkaU4xo4emCQossL7SVUcm2oXkUeY118lIY/5d9uqW8/nn
	nr7E9RDC6sNutHpo38WC1qHDiLuqC2Xo0+K+zmBExzVhjPBuxFKLNSExd8cDuspx8GCrDfzKVHu1a
	T60yoqHcLMueAK67h5uqrSJhEY9vNff44bftGh8X3IqH6vAAcTzSrnB/7eBs00Wlr8IqEtET6qOHD
	5j6bsQcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v37TP-00000001Uwi-0mqQ;
	Mon, 29 Sep 2025 06:34:59 +0000
Date: Sun, 28 Sep 2025 23:34:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <aNook1_KNirZRYY0@infradead.org>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
 <20250924005353.GW8096@frogsfrogsfrogs>
 <aNTuBDBU4q42J03E@infradead.org>
 <20250925200406.GZ8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925200406.GZ8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 25, 2025 at 01:04:06PM -0700, Darrick J. Wong wrote:
> Then looking through the glibc repository, that 28aff047818e commit
> comes from:
> 
> https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=28aff047818eb1726394296d27b9c7885340bead;hp=9deec7c8bab24659e78172dd850f4ca37c57940c
> 
> which turns strerror into strerror_l.  This commit only appears in glibc
> 2.32, which appeared in August 2020.  That version first appears in
> Debian 12 and RHEL 9, which are still fairly new.  musl apparently has
> had strerror call strerror_l since at least 2011.
> 
> Has strerror() been designated as thread-safe at a POSIX level, or is
> this just an implementation quirk of these two C libraries?  strerror
> definitely wasn't thread-safe on glibc when I wrote this program.

No POSIX gurantee (and I don't think that matters for xfs_scrub),
but glibc before wasn't exactly thread unsafe before.  It just simply
leaked the error buffer when it had to print "unknown erorr.." for
errors now known to it.

