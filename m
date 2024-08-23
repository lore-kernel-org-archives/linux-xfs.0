Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9A9259C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387976; cv=none; b=fNaXCRkjBWyvUKgapUyFonaKMgtxTMJ9HOue34q2Z1vsh9/kIKEDUdYKTutOCurfR3/gDzrP5ewmQDdrrPAWBDXbbYRLrL4+bu7MafBsLF9un/lNzj8jfbfVDWPw0kT/kEGjafQzSDnjeQgEkaY9boNNFYgt1TLelcmLF27Mq9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387976; c=relaxed/simple;
	bh=3xdUn7jyiAtFPGqn0/lEJzPwcsyHfWpFmlTxGY3R4kU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1nrl3Y9jNboEh5RbaSvoqdsJFPIYPKKrV3Tuo/+uGIV9Gbkk7Yd2PUvjxhLwdhYVWkc+txoqhSLzXq38gnG9N5T2lwoAW+RHgGVQoQIZAGVBEKG5IEpO5l3jAv3e62SzW5DnJmwiwAXooEVBOT2JDRIkJKSaWfbHC6XAM6rE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CU5L6SzD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CU5L6SzD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ABWaQB8QPe8SHebpLN1mmKkBdkHFUz4YeIKgcwMTfms=; b=CU5L6SzDvV/CLXR5mglmGYkxaJ
	WL1fuLHNS7b9sGh1sVgMGo5nccCOmN2CHImrktkaDPSDBfZPzuTfs/ja7zQ3FwIO+WrsUUxFM5luh
	Kr/EEvEZ5zN5nZSEKhNkioCMiB35gTvsjYAKRZ5WA5GYdskkA6SmyqySypkaEC7b5WE03nStSTDTf
	2sphLF/LmqYCRjXqSI2TcQ96QMt/rDB8JYftTtuOawojS5ftegqcJVB1OqIFJUAC/O6rpKM97NL/B
	ZSUcphaCcJG+uYspEV9+IWtaxzuScfjRhac8pOPC7w6Bj+QiieFVEYj9IUg+jrFBV4U6oTtYOESHs
	ggNtFARA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM5G-0000000FDCa-0pC7;
	Fri, 23 Aug 2024 04:39:34 +0000
Date: Thu, 22 Aug 2024 21:39:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/26] xfs: read and write metadata inode directory tree
Message-ID: <ZsgShrMBgwk8u4T4@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085277.57482.11481599630110948290.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085277.57482.11481599630110948290.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:03:43PM -0700, Darrick J. Wong wrote:
> +#ifndef __KERNEL__
> +/*
> + * Begin the process of linking a metadata file by allocating transactions
> + * and locking whatever resources we're going to need.
> + */
> +int
> +xfs_metadir_start_link(
> +	struct xfs_metadir_update	*upd)

I kinda hate placing this repair only code in libxfs, but given the
dependencies on metadir internals I can't really think of anything
better, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

