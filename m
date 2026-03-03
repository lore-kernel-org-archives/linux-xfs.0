Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE163CC9FA
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553487; cv=none; b=mgvO4eKjxbwc9lRc0vEiXSnEyClxdihdf9NaPIpzeH+jASNAflWNsUEhFo6uy2ErJAn9UAm1J4vsdFY75jvwGWXuGDyZ0wOugyaW2/UpsaNmR/7kgL+WZ1C58EMKopZR2NIhkw9+qwxIhagqc5YI//i6JMT7iG/K/6vEEwwZLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553487; c=relaxed/simple;
	bh=5qQb/I6VKGYNEyMuwxFuuENE13EfOmQRf6dg0Ild2IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTENieohcYgpky50N257vcXBuz2heyD5C1eGwG46udIcZqrif59JaT0lmYJPJTqKfjWwuw+69xui0hFs8gkvdMixlxHKb1q+ju9YkF3Sjl39jIVJ/o63dhO/ddfdcpwXU6jlLgZJFIuXsoEdw/hqaJ1tcRNurlr2wmpQEgPG5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iUnjD8gA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iUnjD8gA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wSBz2VzdqT3daFRMZZazwWAtE5gC4fGWFEBTM5ZNxLo=; b=iUnjD8gAH9gB+eHCZ1PZ3SNoot
	26r399KkOhE5oYxlaDY3DSdRbkY8ZXxByM2dya+S5HDfVCuXfmxfaqh/rngfa9gCLMpHG3/z6wzUH
	ouUqSEuqqZG6HSkoBr2YKmgvX6a6EcbiMOkWkmcYWShcGy7aJ2mZnMf2+fgGzHfp+dSZINMjM/zr0
	cF+r7AUkIJwtwPNSyPJeJfH4Y5P0FYmSZG+rplIVBY0Ec5v8NNNBTWe7xTGSzAdkF9Mn8eUZFjS4F
	LlgTrw14PsuxKbTdHc+hNl+lUb2cYb9g1dv57hHXxS1zFPgJJaaO+ixq9xCfs/btu8sjys50QdO7b
	bbpSvyAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS8M-0000000FUbg-0XXH;
	Tue, 03 Mar 2026 15:58:06 +0000
Date: Tue, 3 Mar 2026 07:58:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <aacFDgyTFG8OhJOM@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783730.482027.15356275256378511742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783730.482027.15356275256378511742.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:40:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If all backreferences are enabled in the filesystem, then enable online
> repair by default if the user didn't supply any other autofsck setting.
> Users might as well get full self-repair capability if they're paying
> for the extra metadata.

Does this cause scrub to run by default or just healer on demand?
People might not be happy about the former.

