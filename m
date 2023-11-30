Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f3+gK1po"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB6B10D4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zi9nHBxVkGMiLEWLSu+pw4kCrdsNfCXEkI8Je61acx4=; b=f3+gK1posDK7q5Uh2yyMJYakj9
	Od3euPo620flr+zxI1g9ojN1QSoMW7wLzNhMMAOPUKzQTqexPK6ATkR5lbGtAQjB+iJK0BaWt94wL
	IjMkHkcERTC0yF2NBcj0W+sozp5pFBGvY/2ZEYEqRaj6d+QyNgW754Vvb/pMLfTaTFiuJYd+7Hzd/
	hLmyNONUkNfmwtJPGMdGUmCh4xA11Rhd8mS57lx6M+mm+X2vsmKooqextq95lUyrkXuwem3A+mkUC
	acYmFppQT2PpNPudqkL9WVmjahSk6pa0aYlex62sGxbQg9JJcBEf0pwBIplJ1Xc/s9aVRQCXs3DQ3
	cDyNZP/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Yv5-009vgu-31;
	Thu, 30 Nov 2023 04:44:59 +0000
Date: Wed, 29 Nov 2023 20:44:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: zap broken inode forks
Message-ID: <ZWgTSyc4grcWG9L7@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Verify the consistency of an inline attribute fork. */
> +xfs_failaddr_t
> +xfs_attr_shortform_verify(
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_attr_shortform	*sfp;
> +	struct xfs_ifork		*ifp;
> +	int64_t				size;
> +
> +	ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
> +	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
> +	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
> +	size = ifp->if_bytes;
> +
> +	return xfs_attr_shortform_verify_struct(sfp, size);

Given that xfs_attr_shortform_verify only has a single caller in the
kernel and no extra n in xfsprogs I'd just change the calling
convention to pass the xfs_attr_shortform structure and size there
and not bother with the wrapper.

> +/* Check that an inode's extent does not have invalid flags or bad ranges. */
> +xfs_failaddr_t
> +xfs_bmap_validate_extent(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	return xfs_bmap_validate_extent_raw(ip->i_mount,
> +			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
> +}

.. while this one has a bunch of caller so I expect it's actually
somewhat useful.

> +extern xfs_failaddr_t xfs_dir2_sf_verify_struct(struct xfs_mount *mp,
> +		struct xfs_dir2_sf_hdr *sfp, int64_t size);

It would be nice if we didn't add more pointless externs to function
declarations in heders.

> +xfs_failaddr_t
> +xfs_dir2_sf_verify(
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> +	struct xfs_dir2_sf_hdr		*sfp;
> +
> +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> +
> +	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> +	return xfs_dir2_sf_verify_struct(mp, sfp, ifp->if_bytes);
> +}

This one also only has a single caller in the kernel and user space
combined, so I wou;dn't bother with the wrapper.

> +xfs_failaddr_t
> +xfs_symlink_shortform_verify(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> +
> +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> +
> +	return xfs_symlink_sf_verify_struct(ifp->if_u1.if_data, ifp->if_bytes);
> +}

Same here.

Once past thes nitpicks the zapping functionality looks fine to me,
but leaves me with a very high level question:

As far as I can tell the inodes with the zapped fork(s) remains in it's
normal place, and normaly accessible, and I think any read will return
zeroes because i_size isn't reset.  Which would change the data seen
by an application using it.  Don't we need to block access to it until
it is fully repaired?

