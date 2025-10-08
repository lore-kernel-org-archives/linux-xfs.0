Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5E29B77C
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 06:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759903573; cv=none; b=jz5eUKdz/BoyHVozCZfiTrZEatmWJJrsam8o0LdsdYnyh6B6/+FCdaTLIahOEaULp/NGKVPuDMBP5qzP+89lWLLYVSGlB2YFkn2mHmZCTkIT2GPg9/8dawcQ9lnvQDcwO0ATys425C8bYPjZYr+5VYYFne0ySjQC0UcN5xtrFfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759903573; c=relaxed/simple;
	bh=y0YraCyrV9upLqsBC7yJrI5yRUA4uqWKUbfQkOjGTZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0H6ktnfrH7eU9u3SdgXuup0nNIpbWOrdfOdxyNor/XDoXftIQdIGkeo12Iao1woSe8aIh8MFLv9p4U3nSPAJLomBCOP7jVsyX5JwhxzD8FGZTT28yvZ5dF285FHr/3tSc+XvJM0KFihaZo1Ih87v/T18zjSPTUThgImJiVG5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lmfJZWNl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lmfJZWNl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wkvWyYCa6+BA0sxzXxtB1oCgrZGDRFI3+eCHjHf7GZQ=; b=lmfJZWNlD8aRITZf39VG9xorv7
	Vtpakb74E6OyCDdtIhLHof6LtoiMIYDbwuYeqr7NwTpTKFdaVI4kqoWU3SnQDoFYiWMR1xp+b+iOX
	WOThyutwFOJOIQjN6FDgzSbnJKiH8PLPDStEgOj8+HR3eAag0kBfGx8mDb+ncgwFk+WoqNRoplZ54
	55UjMfDrYWKCByASgFLXIYwHjNrzDyIOv3QKwlr4FXOt9+phDr3zWLDGgG5CFGz3sAICLP2x7/dNX
	ysQUou2iJrMmwrvrsGbxhfVFt7YEMPyCRcKEQYSb7e/SKDNm8o/b7l5dLA47nBEj5r7WZA2z+GRkX
	MI80sxcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6NJP-00000003GHF-2eGw;
	Wed, 08 Oct 2025 06:06:07 +0000
Date: Tue, 7 Oct 2025 23:06:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <aOX_TzJIxJWWC63x@infradead.org>
References: <aN9_ZfFEdDCuSTJW@infradead.org>
 <20251007071259.51015-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007071259.51015-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 07, 2025 at 09:13:00AM +0200, Lukas Herbolt wrote:
> >> and should be done in a prep patch
> Not sure if I got it right, but sending v2
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

The changes look good.  You'll want to send them out as a proper
Linux-style patch with a commit log explaining the changes in a separate
mail, although it would make sense to turn it into a series with your
other patch.  git send-email is neat to automate that.

