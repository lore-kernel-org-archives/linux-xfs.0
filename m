Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AFF22B8DB
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739867795; cv=none; b=f6X/2WUHBmeFntzk4UJCb3q1uuGjqTDvjiRENdi8eqybNqAEZKDTgiPmF9NdOgPhRnLurM2umrzzSXnOPhC7ejiFrQ3g9eoMJiXd7fKMpwEWS8eWnt6Qskj38rGv1nSPT+M3D2PkibklVQiVw/Oj4xqDSuWx/OilsemEiT1+tpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739867795; c=relaxed/simple;
	bh=Evw8ea2IITCLJhUaRVyu+0up8Ohy5CyKrPBiSBudg9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMCW0Jzs5Ncm8zUyAkixj4C0j8LHUAme/NWScn+CRkHNG1tHXK+HF4LjekytPDsNKs6MsYCbHCkcSoH5Wb4XLhYC2bfORSXnVQf/SY+x49OgbEOMW+ua1sXIyejv+fbV007A4M3tnMJRJ0MEMh6MliNCEYbwA796yjpxIPz8zZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K8+/jhWZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K8+/jhWZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kSdthDIet6IpMOYDOG3pdsi48quFrcMrtZAZLjqiuMg=; b=K8+/jhWZxmt4zdvPDpkJXVDswc
	E/Zsm2dXJxjyfmcieIxKT4IsbGI1FMhdTSb9jjxg1DImMHsfzfXoGrY+b9/W2Y3/+9pZOJU1LR29m
	PCA4O1Uptp5fsokSJiMf9wpvo13WiURERBV9eXN2hLAbMea70m1qRd/AYeMatGX0l0h2QPVLL5hQX
	VijP5siGS03QBE14FVGq99vpHcZmKuAw3HK30mZnJzLZd+12gXwXJmKzxANzuhf2K55HshqlJL7IE
	TGqayflyFl3ODYq/2jqdx65zP5lXojRp95U8SwdZ3+aUjrAp28sGItiWY+PlANKaedbgbQ503k3SY
	MP+eda0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkJ5l-00000007JGQ-2uL2;
	Tue, 18 Feb 2025 08:36:33 +0000
Date: Tue, 18 Feb 2025 00:36:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <Z7RGkVLW13HPXAb-@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 03:03:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Aheada of deprecating V4 support in the kernel, let's give people a way
> to extract their files from a filesystem without needing to mount.

So I've wanted a userspace file access for a while, but if we deprecate
the v4 support in the kernel that will propagte to libxfs quickly,
and this code won't help you with v4 file systems either.  So I don't
think the rationale here seems very good.

>  extern void		bmapinflate_init(void);
> +extern void		rdump_init(void);

No need for the extern.

> +	/* XXX cannot copy fsxattrs */

Should this be fixed first?  Or document in a full sentence comment
explaining why it can't should not be?

> +		[1] = {
> +			.tv_sec  = inode_get_mtime_sec(VFS_I(ip)),
> +			.tv_nsec = inode_get_mtime_nsec(VFS_I(ip)),
> +		},
> +	};
> +	int			ret;
> +
> +	/* XXX cannot copy ctime or btime */

Same for this and others.

> +	/* Format xattr name */
> +	if (attr_flags & XFS_ATTR_ROOT)
> +		nsp = XATTR_TRUSTED_PREFIX;
> +	else if (attr_flags & XFS_ATTR_SECURE)
> +		nsp = XATTR_SECURITY_PREFIX;
> +	else
> +		nsp = XATTR_USER_PREFIX;

Add a self-cotained helper for this?  I'm pretty sure we do this
translation in a few places.

> +	if (XFS_IS_REALTIME_INODE(ip))
> +		btp = ip->i_mount->m_rtdev_targp;
> +	else
> +		btp = ip->i_mount->m_ddev_targp;

Should be move xfs_inode_buftarg from kernel code to common code?

