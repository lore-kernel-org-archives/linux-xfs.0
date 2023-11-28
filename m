Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122251C30
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYSjrWm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F85C433C7;
	Tue, 28 Nov 2023 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701136305;
	bh=sthvGgotZ3urLITCsUWMTH+jBVb/FGQSuwWcZ7ANB5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WYSjrWm/cDUmwz9axcIAcKw5sWy2wel8o45zY/XcyCSWsZt9FM+HLR+XTKGw1rceI
	 5iexDCcO8NVvA+ZtYQDFvvgD+C7NWY9HiCWr+oE5EkHvFPA0TAKmKQH923gCnmgKjb
	 ebPOvLY8yFq5bIQTA6bp+6PjB/bXxel3UmjxjHSUEr2rxSzFJ0R43DjofZB8YjXlIy
	 IVHWO9XRer7lm0AG/U3PgyzqIRkMJNmt771tQV34Th2gXHFQ2CDV5LQVuzAX1LdEKA
	 +yX0oKj7TQHIho4Jr8J50cJl4vn3CbIt3PE0xi2Rzk4+3GT51LenLeYIQ9jGl175kX
	 25hjPN0GrhKlw==
Date: Mon, 27 Nov 2023 17:51:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: clean up xfs_fsops.h
Message-ID: <20231128015145.GP2766956@frogsfrogsfrogs>
References: <20231126130124.1251467-1-hch@lst.de>
 <20231126130124.1251467-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126130124.1251467-5-hch@lst.de>

On Sun, Nov 26, 2023 at 02:01:24PM +0100, Christoph Hellwig wrote:
> Use struct types instead of typedefs so that the header can be included
> with pulling in the headers that define the typedefs, and remove the
> pointless externs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Easy review!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsops.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 7536f8a92746f6..44457b0a059376 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -6,12 +6,12 @@
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
>  
> -extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
> -extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
> +int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
> +int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
>  int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
> -extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
> +int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
>  
> -extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> -extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
> +int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> +int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_FSOPS_H__ */
> -- 
> 2.39.2
> 
> 
