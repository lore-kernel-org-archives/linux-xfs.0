Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA43130AEE
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711558422; cv=none; b=e2vui7uV2126pw1FdKi8h2DknKYSkhDAtnorsy1E+DAxBapVXE6cDmjs8wtV6yhi/SGgtRHiQn2BpRkoysNmzvBDj6DyhBmkPhfjzKE042xxpxXAKuR5dQmIjkddWGwMSNWeM49Sj7XU3Bv1GOpBg2xEhOJsZ/v7Zxr9Ec2mx2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711558422; c=relaxed/simple;
	bh=BYOVYvB+T33DZHifvjrRMfoE8T5k3I3ED/XoZxoLDnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1EqIM9e5ZNdGhBak2NkRViJn7j2fMmdIUzTqcMIxPw/qgr4FRbPbhZr9O8BIq9jVpGmlapyroXTy5EM1M6M4HDXcFl526LZFl3JqetGxMWlhTVj5D+Dpda9aDpE6iopF0lrM1+vckTfT9kiH7GIWJMTe72i0jdAz0E92w8FNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VNWSIY8E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VNWSIY8E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SE7GuIqi6lGJALhB7BEUDqjdAa2j/ZIqa2FTDFf62NM=; b=VNWSIY8EdsG4puRwmFceKaCXYV
	78EL5nuPihVyrb5Q9EVdHRmwC8SvqMJlVttKq03lPmnqwvBVyaFs3xFJ49+v+j6qF9DmSde4/7Zjw
	Z7gyfn88nnlVOVK9T1xYlPftnFTNlfhrhHFPxFs/B/+fSEWH5j1AdsKN0vIpJZ0Ctx40DB6CNpiqq
	s8kwSvlvknvH83ai12O1fErEQFxrONXde8rVksRFUXeRmm6/+6C3CCHG7Y1BOH/i9Pu55oRDPi6Rs
	0UJLBYkyvimXuJxHB68OlHqncPinb1EEsA8ma9bQ0EtjuEBv1MEdEAhESU83gUts30/dnQOd9lage
	z9CXrIMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpWWw-0000000A9o9-1dlM;
	Wed, 27 Mar 2024 16:53:38 +0000
Date: Wed, 27 Mar 2024 09:53:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <ZgRPEk9MdwbPK64Y@infradead.org>
References: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
 <171150384365.3219922.12182012253523618503.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150384365.3219922.12182012253523618503.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  /* Write the symlink target into the inode. */
>  int
> -xfs_symlink_write_target(
> +__xfs_symlink_write_target(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
> +	xfs_ino_t		owner,

The xfs_symlink_write_target/__xfs_symlink_write_target split seems
a bit pointless with just a single real caller for either variant.
Why not just pass the owner to xfs_symlink_write_target and do away
with __xfs_symlink_write_target?

> +/*
> + * Symbolic Link Repair
> + * ====================
> + *
> + * We repair symbolic links by reading whatever target data we can find, up to
> + * the first NULL byte.  Zero length symlinks are turned into links to the
> + * current directory.

Are we actually doing that?  xrep_setup_symlink sets up a link with
the "." target (and could use a comment on why), but we're always
writing the long dummy target below now, or am I missing something?

> +/* Set us up to repair the rtsummary file. */

I don't think that's what it does :)

> +	 * We cannot use xfs_exchmaps_estimate because we have not yet
> +	 * constructed the replacement rtsummary and therefore do not know how
> +	 * many extents it will use.  By the time we do, we will have a dirty
> +	 * transaction (which we cannot drop because we cannot drop the
> +	 * rtsummary ILOCK) and cannot ask for more reservation.

No rtsummary here either..

> +
> +#define DUMMY_TARGET \
> +	"The target of this symbolic link could not be recovered at all and " \
> +	"has been replaced with this explanatory message.  To avoid " \
> +	"accidentally pointing to an existing file path, this message is " \
> +	"longer than the maximum supported file name length.  That is an " \
> +	"acceptable length for a symlink target on XFS but will produce " \
> +	"File Name Too Long errors if resolved."

Haha.  Can this cause the repair to run into ENOSPC if the previous
corrupted symlink was way shorter?

