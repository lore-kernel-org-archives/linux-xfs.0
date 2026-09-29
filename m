Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4361E9B1A;
	Tue, 29 Sep 2026 01:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645243; cv=none; b=dIe//B3/a0pfDjML2veeycaSrpzpRcO0Ey9FZbVBb4SqspYaXPOk9uX4iy09rsfbo4lZHEqD5H8N2VUbTrOku+jtDtRJuDE7oqaB9kJVoonnmomYRNfp4al79aZ5tlySprdXOeiu6ND0k6M2XNv55sP/8VxAVsbH0gN07RUzuhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645243; c=relaxed/simple;
	bh=ZJP5ZBXOfSPBQ1GK+SSKgvdFegeUPoLvyFmg7+Y0RH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipJ4xX8lMgNiBvoz7GOGgDEBMZb6zFdf5AkH7zECww6HOv4cLmRO5rZ5r7vweMUEW+Uze5SQyL4+/Fcv/IzXgto6K6GNkWa+j5wOr3oXqx6WAxp6i86k3l8YSBu9D9QYBqa7imj/4Nr6Y6TAsXlidzkR52P9nZ0A3IbSXU0VpuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOKp081W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOKp081W"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 19DF41F000FF;
	Tue, 29 Sep 2026 01:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645242;
	bh=NDec3bSfBd5SG5vhPkIFstWrkmcw8VGW1qvFxBG0uns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOKp081WRjoTRMc7hkiuoqS3SkDrxKCoKr7x6EeBirNIqjF9P+XqT67xNauhAmAF7
	 UhOOZ/lm2WW06mhGsEBK9SFOYXuZs3P/FJI5Q1XVCepLD+p3z2Un/AZtU6Rmwrv6vn
	 /6LYdWksmNpIulb/g2RuvZXY2BiH3PER8WfAkOVTvcvFFefP4B6PPaE53r6mRxEx+C
	 t75f1aPEi/RB7A3pfPgsxf3ZmdPs6tUDU2riVa9g0Hni9dwq5gcmhRe9dPE0TdIC0O
	 wegvusya/4PhS73eK/CnUTSacX/LxyDTW9/HY7bdxCtws/c3v8P5qqruqMyS2lERWM
	 YwZEWJE9t7bPA==
Date: Mon, 28 Sep 2026 18:27:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/21] xfs: add an experimental feature warning for RT
 data checksums
Message-ID: <20260929012721.GB2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-21-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:52AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_message.c | 4 ++++
>  fs/xfs/xfs_message.h | 1 +
>  fs/xfs/xfs_mount.h   | 2 ++
>  fs/xfs/xfs_rtcsum.c  | 2 +-
>  4 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 0243e509a468..53e8ed976a9b 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -149,6 +149,10 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_LARP,
>  			.name		= "logged extended attributes",
>  		},
> +		[XFS_EXPERIMENTAL_CSUM] = {
> +			.opstate	= XFS_OPSTATE_WARNED_CSUM,
> +			.name		= "data checksum",

Nit: checksums (plural)?  Seeing as the xfs_info() below also says
checksums.

> +		},
>  	};
>  	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
>  	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 811b885f41c3..d858e93e5426 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -93,6 +93,7 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
> +	XFS_EXPERIMENTAL_CSUM,
>  
>  	XFS_EXPERIMENTAL_MAX,
>  };
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fa86697f463a..c62eb42e490a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -586,6 +586,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>   */
>  #define XFS_OPSTATE_BLOCKGC_ENABLED	6
>  
> +/* Kernel has logged a warning about checksums */
> +#define XFS_OPSTATE_WARNED_CSUM		8
>  /* Kernel has logged a warning about shrink being used on this fs. */
>  #define XFS_OPSTATE_WARNED_SHRINK	9
>  /* Kernel has logged a warning about logged xattr updates being used. */
> diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
> index 7cdc5a5029eb..47a7b67f7412 100644
> --- a/fs/xfs/xfs_rtcsum.c
> +++ b/fs/xfs/xfs_rtcsum.c
> @@ -310,8 +310,8 @@ xfs_rtcsum_mount(
>  	}
>  	mp->m_features |= XFS_FEAT_DAX_NEVER;
>  
> +	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_CSUM);
>  	xfs_info(mp, "using %s for RT device data checksums",
>  		xfs_data_csum_names[mp->m_sb.sb_rtcsum_type]);
> -

Extraneous deletion?

With that dealt with,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
