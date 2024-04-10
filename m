Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271828363
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729050; cv=none; b=pAcCTs37OVc8r+fpLLx8Y2lWgkp2KLAh/Cb76jrnHG9HR28Ungij17mXTmcEL/wk0qRCgZmCnLPs8uJFaiDvTD1mf2EgXLHY790CMZIBf90b/LCBLJYEQQ3196LISnk+2sb8ddCWLmAl+8ffmR4f8k7epGDVkcKSgKFunTQYeus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729050; c=relaxed/simple;
	bh=PlbT8XAdqaNMjA8Z73a29cJsvs6YiIv9H+aqZVCIJrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaXjCMTj8MAzdupAZrfJixt3M54eEeWPPF6JZSfP9KE8FnBvu9rHFjWDvtwPZT/Uivd7rRQRtkxUSnFOTEsFenkbbkM/ZbDey6Vz5kwhhfl3Z+VVC70EtnhPpk8P1mpzS1z7Kxm1NjxKROUKvogzrnibaZummaYKn6KQC8pyE1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=44MHu2Ec; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="44MHu2Ec"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mB65EplBkbsN0Ng1LfcZjBcNfnKQ507NNiREE1ZsU8Y=; b=44MHu2EcBjhvz/OFOrNvJz3vVy
	8IquD9D12Ef6X9pRrPR6A3ao8JLpi0e0wPeTO8KZok2zDElgGSxkEC2Wezjiv3mWsMe2WnM36rBnq
	7s+vUF76rJW1RA7i/zpRfbADWmpyBMcc/WxTMWyFla3NgheZmYycBiXkBMveafwAeUMTmHea9P0Pe
	GcfXdh61eAswkG5p7+VxRCtkHl7FriHqWIJ9Hh+93nwb4SN7tfQhsSQYsCDWDUixvCCFtO38H5nli
	TpEQ6l+CVM9MI7ne7cRh/HGDk/8LsLKbU+yCSHFsBqV5QK+q3BM/L6cRDhH/Kl6KJoi78DoDr3Z5C
	ycHHF6cw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR44-00000005IS2-2CFR;
	Wed, 10 Apr 2024 06:04:08 +0000
Date: Tue, 9 Apr 2024 23:04:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <ZhYr2PCHeVAdCn3K@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Maybe replace the subject with 'add parent pointer listing ioctls' ?

On Tue, Apr 09, 2024 at 06:00:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch adds a pair of new file ioctls to retrieve the parent pointer
> of a given inode.  They both return the same results, but one operates
> on the file descriptor passed to ioctl() whereas the other allows the
> caller to specify a file handle for which the caller wants results.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: adjust to new ondisk format, split ioctls]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Note that the first signoff should always be from the patch author.
as recorded in the From line.

> +	/* Size of the gp_buffer in bytes */
> +	__u32				gp_bufsize;
> +
> +	/* Must be set to zero */
> +	__u64				__pad;

We don't really need this as padding.  If you want to keep it for
extensibility (although I can't really think of anything to use it
for in the future) it should probably be renamed to gp_reserved;

> +static inline struct xfs_getparents_rec *
> +xfs_getparents_next_rec(struct xfs_getparents *gp,
> +			struct xfs_getparents_rec *gpr)
> +{
> +	char *next = ((char *)gpr + gpr->gpr_reclen);
> +	char *end = (char *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
> +
> +	if (next >= end)
> +		return NULL;
> +
> +	return (struct xfs_getparents_rec *)next;

We rely on void pointer arithmetics everywhere in the kernel and
xfsprogs, so maybe use that here and avoid the need for the cast
at the end?

> + */
> +int
> +xfs_parent_from_xattr(
> +	struct xfs_mount	*mp,
> +	unsigned int		attr_flags,
> +	const unsigned char	*name,
> +	unsigned int		namelen,
> +	const void		*value,
> +	unsigned int		valuelen,
> +	xfs_ino_t		*parent_ino,
> +	uint32_t		*parent_gen)
> +{
> +	const struct xfs_parent_rec	*rec = value;
> +
> +	if (!(attr_flags & XFS_ATTR_PARENT))
> +		return 0;

I wonder if this check should move to the callers.  That makes the
calling conventions a lot simpler, and I think it probably makes
the code a bit easier to follow as well.  But I'm not entirely sure
either and open for arguments.

> +static inline unsigned int
> +xfs_getparents_rec_sizeof(
> +	unsigned int		namelen)
> +{
> +	return round_up(sizeof(struct xfs_getparents_rec) + namelen + 1,
> +			sizeof(uint32_t));
> +}

As we marked the xfs_getparents_rec as __packed we shouldn't really
need the alignment here.  Or if we align, it should be to 8 bytes,
in which case we don't need to pack it.

> +	unsigned short			reclen = xfs_getparents_rec_sizeof(namelen);

Please avoid the overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
