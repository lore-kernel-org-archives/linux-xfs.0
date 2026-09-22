Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED74E0B84;
	Tue, 22 Sep 2026 07:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061346; cv=none; b=MJxowVEb4DiHTSWXd+wnrSyMffgqP5HpdALZ6IYzO7EuC1xSeCg4BBBUekNKZjL5gHBQHR0IALw/plv2BY00bZIjNZcls/3DokYte6jRffTBSqp8/e+4KTMOL95k6aogsv8npp0Ve5UCBKSXkZaasGeQpLuV9GMG1VeNIu6rXgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061346; c=relaxed/simple;
	bh=5byt+2rHZaPcwPvvMI1gHXVbkt0+YuMXKm3uNUejKTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOTMlcdhYsUfWzwSBhfoo8PzmAav2ldmpYlxMCZnE8tTCY3lpnOjdmDpzQ5SLknwH9WTYAuOqjjjMewxS1CgSzCA02R/XD+eYDoERozJshsuVYDgEoD30nHmAJgRxvs7hA9oIxg1rxQ2PekLRHdwN7PFrOo3shaz/8YH5ruJ7Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yzYmUF4l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yzYmUF4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PLrBUdYaBS0OotZ3Q1WVCL0MGnoMFhhmmfO07iCfEQM=; b=yzYmUF4lTr7WORXAoGiIFoEZh3
	aV4JtMaY9XStjqr3jAExeKtko7blJ7VLCfXbIQboEGtnpowxV2fUyrbI3Q/Uc5Ro1+rT2WMkhHoim
	pPakcuUs2aurFN65Ezf9KS/yNpfrpL0/w6sC4dyhlHCkqKkxGuwANcmuQCJcW4/0+RhxcoYPf87Y/
	MmEMQRD9iyK0O68i/LbUKfmL9urNLnDN5STIEv6O3fQSjY3/3gjZGic/Q/sw73KGnILqbEdw7N2Jy
	WdZ3ozGiUkj4X9nltkrSHPNUv7oYyhM0QcoqTrXPfgDpLrckjyTp4Ig7fJqoYc8aU3c7SVXONuLPU
	tr4nhJ8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8uj7-00000004Tuk-1iOI;
	Tue, 22 Sep 2026 07:15:41 +0000
Date: Tue, 22 Sep 2026 00:15:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v16 11/21] xfs: handle fsverity I/O in write/read path
Message-ID: <arIrHUj9SMUW6WSD@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-12-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-12-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 18, 2026 at 01:15:23PM +0200, Andrey Albershteyn wrote:
> For write/writeback set IOMAP_F_FSVERITY flag telling iomap to not
> update inode size and to not skip folios beyond EOF.
> 
> Initiate fsverity writeback with IOMAP_F_FSVERITY set to tell iomap
> should not skip folio that is dirty beyond EOF.
> 
> In read path let iomap know that we are reading fsverity metadata. So,
> treat holes in the tree as request to synthesize tree blocks and hole
> after descriptor as end of the fsverity region.
> 
> Introduce a new inode flag meaning that merkle tree is being build on
> the inode.

Sashiko had some comments on this that did not sound entirely stupid
to me.

