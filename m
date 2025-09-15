Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111D92749D9
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962550; cv=none; b=NLNjR2rtP0xA/eA5D75ORyDnuRnSOnqIEOo3sY5X3QBjGFm6Of/oiulpEKKqpE8ZhyX9ECquPly/HbWBotOD7VHWN+nPpPoCA3wXWRoL4tUwlPwr73O1lh/KLDt4UeaDFY6t1azsKciVNPReJ7hDIw1StWCikr7WK8QhvTDeHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962550; c=relaxed/simple;
	bh=i7yBo2R2eUXote71iU6DMrjNPLvg7e7ZLeFXrxvJat8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5fdVjLHHaBglLdKEFhemGCOBQvYT1R9tRrKqWuOHIxJXBcjOmDolqYvWuNHilDR9QLaTv+OYg1Pq1zn/ipPv9OQar0NlmsUczXGPnTAmJKAMVmjDLgkxZTmpHWeVw1nJKlvWBGBgS/tP3ZppJRkzas/+1DcS7cC+h4FRDBXWFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElzApBFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElzApBFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9179AC4CEF1;
	Mon, 15 Sep 2025 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757962549;
	bh=i7yBo2R2eUXote71iU6DMrjNPLvg7e7ZLeFXrxvJat8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ElzApBFxX2UL5o+gG8fzTr88jUEOcJTGmBWG1Q0xn67n1HxDdueQI/M4fHV0Xes+J
	 +pnpoGtE99B9wiCug2OaoQvr71G2LNRoQK8zChPIsfHdVhmR2ujkq1CCZJROTyzUTT
	 Vv5wgmICjVU7NdOJX0CTYCPTjQ5KAA6Z2J57B+yMwf7hjbu/hWJ0FodyQVIMnkJXZo
	 7QHePsDcuQj1yz3DV8ub1e3aXapRLKBI77xaRnSRKdSFgh+7P4/5HfDLS6Y3jtb3+4
	 SF8eDtKbe7D5h/eyh7kA6YnBhXulALonOSywIsIRgYEbShVv6RJaFuF4uWx6/dWCEO
	 yLkBkIQ3kFOeg==
Date: Mon, 15 Sep 2025 11:55:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: remove pointless externs in xfs_error.h
Message-ID: <20250915185549.GW8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133104.161037-5-hch@lst.de>

On Mon, Sep 15, 2025 at 06:30:40AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.h | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 8429c1ee86e7..fe6a71bbe9cd 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -8,22 +8,17 @@
>  
>  struct xfs_mount;
>  
> -extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> -			const char *filename, int linenum,
> -			xfs_failaddr_t failaddr);
> -extern void xfs_corruption_error(const char *tag, int level,
> -			struct xfs_mount *mp, const void *buf, size_t bufsize,
> -			const char *filename, int linenum,
> -			xfs_failaddr_t failaddr);
> +void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> +		const char *filename, int linenum, xfs_failaddr_t failaddr);
> +void xfs_corruption_error(const char *tag, int level, struct xfs_mount *mp,
> +		const void *buf, size_t bufsize, const char *filename,
> +		int linenum, xfs_failaddr_t failaddr);
>  void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
> -extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
> -			const char *name, const void *buf, size_t bufsz,
> -			xfs_failaddr_t failaddr);
> -extern void xfs_verifier_error(struct xfs_buf *bp, int error,
> -			xfs_failaddr_t failaddr);
> -extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> -			const char *name, const void *buf, size_t bufsz,
> -			xfs_failaddr_t failaddr);
> +void xfs_buf_verifier_error(struct xfs_buf *bp, int error, const char *name,
> +		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
> +void xfs_verifier_error(struct xfs_buf *bp, int error, xfs_failaddr_t failaddr);
> +void xfs_inode_verifier_error(struct xfs_inode *ip, int error, const char *name,
> +		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
>  
>  #define	XFS_ERROR_REPORT(e, lvl, mp)	\
>  	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> @@ -39,8 +34,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
>  #define XFS_CORRUPTION_DUMP_LEN		(128)
>  
>  #ifdef DEBUG
> -extern int xfs_errortag_init(struct xfs_mount *mp);
> -extern void xfs_errortag_del(struct xfs_mount *mp);
> +int xfs_errortag_init(struct xfs_mount *mp);
> +void xfs_errortag_del(struct xfs_mount *mp);
>  bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
>  		unsigned int error_tag);
>  #define XFS_TEST_ERROR(mp, tag)		\
> @@ -58,8 +53,8 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
>  		mdelay((mp)->m_errortag[(tag)]); \
>  	} while (0)
>  
> -extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
> -extern int xfs_errortag_clearall(struct xfs_mount *mp);
> +int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
> +int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
>  #define xfs_errortag_init(mp)			(0)
>  #define xfs_errortag_del(mp)
> -- 
> 2.47.2
> 
> 
