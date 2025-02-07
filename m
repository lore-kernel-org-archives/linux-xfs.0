Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A521D47F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902936; cv=none; b=e2ZyzdW2u0dO9JIQwlKdUcuUoSWK8rZGVvIiaYXL/U69Y8dDB+HpPkb3j92iEfWUdWJjMD849LadDi0icK+SV7uIc2scEAU2Yd+Ev8zSH0KrL893EbibJa57TLr4hfI9uR5hUHXR/2HOIyDK5NzCRog1I5qbJBMsc1bpXSnZ1gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902936; c=relaxed/simple;
	bh=jEJFao4/bEYnGWQGMQ9XzZCGjLsIx/k7RfouiLuJeDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElqdlvoSoGPh9VRet7ybdnChuOSIaNlJ0wmYiz4EwL2xT8tC+hrBMdzWM9TPihSkHm2qILb161tY8t3AlP2n7EP1NNSkzkKucOh0ODYb6ZLitG3YPWa0R+mw6thiXkggwfpr1+a75qAW4ANYjfSwYiI1E0h7Z/P7L+JElZFFyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nPUr2M0t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nPUr2M0t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dOwjIQkHSe6gaYZ1Y7Tl185cjWmw9TASiKe8ZEaeADo=; b=nPUr2M0tMbHZFbsfkEQrGY4vxA
	Mr0WzDB6OxD4aGA4a1rUW5IprxA7T647VZD7yL+v/GgdumaOqymReHjQdO3w2oE7UytLzApDn2WyO
	/RfA3l8ICdK/YZCnlt42x+lVWwoM6CVONSUKVoAmDRga1J2/Yr8vkp3Gj/wA/hMZ4L3IIqVyIwcGR
	uBejDBy0uxWNHjt6A79Q5XmlDjHsTtogbr6aogrUe08hOEjkwd2AZOCW4xGhEIARk3ZyGrX40KhcF
	8rpnircW9khgJpRsCiajjkHVx4B/nB2+4xPbfLQNskCXe3bbhzTKy6bN0OVRUJJmkotkshVjmO9L/
	aW/txm7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG5W-00000008It2-0bwd;
	Fri, 07 Feb 2025 04:35:34 +0000
Date: Thu, 6 Feb 2025 20:35:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] xfs_scrub: don't report data loss in unlinked
 inodes twice
Message-ID: <Z6WNljC0UV4LbxPB@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086136.2738568.12499263697186080933.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086136.2738568.12499263697186080933.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:31:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If parent pointers are enabled, report_ioerr_fsmap will report lost file
> data and xattrs for all files, having used the parent pointer ioctls to
> generate the path of the lost file.  For unlinked files, the path lookup
> will fail, but we'll report the inumber of the file that lost data.

Maybe also add this to the code as a comment?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

