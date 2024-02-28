Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB0B3FBA5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140272; cv=none; b=NmijgtaHYqAd9B/sd3UDqRXvWZPLspUfE0WbyJWNlgkk6EGX/qBMi773XPftmsPI2slTs1NgOJ4gD4FXAb8PSq3QaVTzSqdTkNamTOnuFk1XZ+Cpb9ot1iMFXaB81tDRmOnTt74qf78QUkxlTc0flfpzO8Zr6kYkcyvqSF4LvUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140272; c=relaxed/simple;
	bh=O+zTO0Dkv5oi0PcPW/b8Mgla1zUoXhhbZ7ByxXvNMJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6duGSquU9j5fSpRgs0icDXa4DNiQph1YCp1h2b7Ls4VzG5QvkGQMxi+TYOPFnjuL1SvwUZ4CIr1Owat60FLy5ADC2vvMHGZxzgtA3bgL0alOuzFmK356qrz29iElXXp8HF/f1zRzcrCUVL7JEMPiD4qDMXJ6BJfyUxbc5beVeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EdovEVxD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EdovEVxD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QQIQUsEriPoMSduU7gjwzehHjwfycq53jo2Dx1qXFZU=; b=EdovEVxD0YWhXOZCyWq3808WQH
	NfqWGbutCyQFEwrh2ca8Z2qpAifjUcRH4X4jh5qiJSWL/oJLS4ag9E9QOb113RGdCgsH0RfgbRR7u
	HFB0YQfntk3YXq4PqpB6QSGHK64MKszmIeJu9LW2lmOvym110FMo6hUUMmtmgo5oG9K+SVZbRG7A6
	2bcJK2buRt1mnOOLPxWtxeiVUmCBAjVHFB0Q+bKg6Ees8MwJzaTgLekj1InZDx9LakOJBbQhYMf+o
	fs4OiNkLccV32hmPU2+p3t5rg42/z6LHHIu+SLxSzBcESfgXbzB4/R+acc5VP7npNJx7cvxi8Yy+U
	zwtwmZ/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNSY-0000000AFEH-2As5;
	Wed, 28 Feb 2024 17:11:10 +0000
Date: Wed, 28 Feb 2024 09:11:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs: create an xattr iteration function for scrub
Message-ID: <Zd9pLkEZUrmuizXW@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013728.939212.1549856082347244818.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013728.939212.1549856082347244818.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:30:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a streamlined function to walk a file's xattrs, without all the
> cursor management stuff in the regular listxattr.

So given that the Linux xattr interface doesn't have cursors and they
are only around for the XFS listattr by handle interface, why can't
the normal listxattr syscall also use this cursors-less variant,
which probably more efficient?  (assuming it is, maybe a little more
explanation on why you've added this variant would be useful).

No need to hold this series for optimizing regular listxattr, just
thinking out loud here.
