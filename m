Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E9EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945315; cv=none; b=YAsM7+mamSkNt25IhpYRUAl+zDL2lNVsVRIMvhI3MmwSOA1yctElluhO79oRZ6FYO5550qmBr5dWgVIl8CkRBYqvwnZrlNndd3upON2DHQItwZ7T3WX50azaEaktAbrI94RCuNIM+n3nRR+9Cz8UPXM7C+ojFkDDYAP/OEuFHmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945315; c=relaxed/simple;
	bh=fKnwnBTBGnfm4GdgZVNrsfZgS+FRi55sw3b9HRNUywg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmIBSSOmsouBytl1fAc/9lQ5GYGS3LKszD5tAWPNKSwgqyUAai6/2aWPFrCuqM8UMWe/3s3OmvBbULguiIXGhz/+FMqoKrL15pGyksqPerkoYrco3g434Y7nUV/5IdqVYSDUWsX8HhkjVPptI5oqu7RA8/n5faQH55Gorhi/wUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jXX+vMYJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXX+vMYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2uV7M+5IdYvBGuYS8r5hgTAneGcQaG4p+8dsNY+5QZ0=; b=jXX+vMYJiQ4soBCpHUgPwf3MiR
	BeFfNTcOiCTEwLthavER33GlDRl/vH5g8DVfu4G70kYPJdj8GdVRxWLSB6IgFuuxzeYKbOCc5UXpi
	fGSprMCdULnC8EVcBIOiR/8XpODcqiOw/PgoCEVIJnbcAFCYglvMYoWJ6rOaZ58h78g2IpS4dUAGH
	AEm0K2CoVxsbsoUw35jhxdWQNJWMtArGXtzinpCVO0yFdMM9psGBY9LmnZnzFO0I7vI7PY/4By8Ar
	YP7OeatzvHdBfy68eE/u5ZFteHUT0slGd+UsmplBLqPD/vAYe99EqTX9ccPsNVlnQu5Nq10Dfc8Pp
	1cudvd+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWCP-00000007gR9-34ZV;
	Fri, 21 Jun 2024 04:48:33 +0000
Date: Thu, 20 Jun 2024 21:48:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: move xfs_extent_free_defer_add to
 xfs_extfree_item.c
Message-ID: <ZnUGIfK7nby4-yKK@infradead.org>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
 <171892418851.3183906.15855078165036440030.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418851.3183906.15855078165036440030.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 20, 2024 at 04:07:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the code that adds the incore xfs_extent_free_item deferred work
> data to a transaction live with the EFI log item code.  This means that

s/live/to live/ ?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
