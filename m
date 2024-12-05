Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFD3239181;
	Thu,  5 Dec 2024 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733381321; cv=none; b=j5BXuOcMKf5G20AvfVLMbau//e+AbkqMbQOjnf1eRvMZ4nmrvrbsIE6Bo4tCdmGYK05KvifPuXhsb1bXFsb6UTeU3XVJa6BXvNITGqXUx3wavazzaK/0oIsDF3XgxUUJGWpQWX4azUyB28YJBtVfXZJSjr0X41AN7URJg3luYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733381321; c=relaxed/simple;
	bh=X23m02ZFHgalTmKz2rVjeEhdpTLDHeXYRSLa/RJ683c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEldKh2aAKNAA0ydci73d+ZgijKpb1a8+Qs4fBZLt+6Zj6xzY145749mphtao9IyGSf8xGCmLEZbrzeJ/6J3SdWdXl4cNa56dfWBxAHzIBrC+SrZ2jlnsziBxYm6iSZMW7NsVS6/vCeiAMqYvwySL1P/8pNp3qBwAg1GuDKNjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mbOzqGaA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mbOzqGaA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+ExZ4NJFlU1dp2ZizpLp6o3qY0sbfiXCI9fnV75tFg4=; b=mbOzqGaANuqBCuhLNy0YGQIVdM
	zq5sxkTzLJ/vfD+lxUqrLCN4bMI9313frmNeau21CMKCSwOsQ8Tzl/OE+BsroQhOBfLfQhHQggI+5
	8uN7+n+HCXpSSJGcT/fv1eDcF6wPR9eLgFlZZpJ+FOfCVAd0Xjr1lXFSv8Z8bOaWFdGWuaRaeXPUI
	pAtFD7hwne/mmQfPwi5O3ZCZkNZjm+qvnP5NdmlY8H7olonINTCRMwSS1wv7Gd0u7yfctdIl4BGkv
	vPli/M04cHEd84gldriKmOBGZxpKWteL7JUFlh2rKw75dd8OB8Kv22IqEupd1vA8Nk3TgX1nS/H4h
	o5S3Uobw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ5fD-0000000EvWJ-1rUN;
	Thu, 05 Dec 2024 06:48:39 +0000
Date: Wed, 4 Dec 2024 22:48:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/6] xfs: fix zero byte checking in the superblock
 scrubber
Message-ID: <Z1FMx63BD_KAUZna@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
 <Z1ASehwdTewFiwZE@infradead.org>
 <20241205055451.GB7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205055451.GB7837@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 04, 2024 at 09:54:51PM -0800, Darrick J. Wong wrote:
> > This really should be libxfs so tht it can be shared with
> > secondary_sb_whack in xfsrepair.  The comment at the end of
> > the xfs_dsb definition should also be changed to point to this
> > libxfs version.
> 
> The xfs_repair version of this is subtlely different -- given a
> secondary ondisk superblock, it figures out the size of the ondisk
> superblock given the features set *in that alleged superblock*.  From
> there it validates the secondary superblock.  The featureset in the
> alleged superblock doesn't even have to match the primary super, but
> it'll go zero things all the same before copying the incore super back
> to disk:
> 
> 	if (xfs_sb_version_hasmetadir(sb))
> 		size = offsetofend(struct xfs_dsb, sb_pad);
> 	else if (xfs_sb_version_hasmetauuid(sb))
> 		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
> 
> This version in online computes the size of the secondary ondisk
> superblock object given the features set in the *primary* superblock
> that we used to mount the filesystem.

Well, it considers the size for the passed in superblock.  Where the
passed in one happens to be the primary one and the usage is for the
second.

> Also if I did that we'd have to recopy the xfs_sb_version_hasXXXX
> functions back into libxfs after ripping most of them out.  Or we'd have
> to encode the logic manually.  But even then, the xfs_repair and
> xfs_scrub functions are /not quite/ switching on the same thing.

We don't really need the helpers and could just check the flag vs
the field directly.

I'd personally prefer to share this code, but I also don't want to
hold off the fix for it.  So if you prefer to stick to this
version maybe just clearly document why these two are different
with a comment that has the above information?

