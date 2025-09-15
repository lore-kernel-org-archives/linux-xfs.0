Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D723A2E8896
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960852; cv=none; b=nO8QheAVp/PQLJsaDhrGhl9AKGfgUDo92+lhf9nQp4SWWzFKT3B3JYhG6uDW5iS9dHbFeqXkI9IiIecqCCKX0yfuoZpUqFA+oljgvD3zajnlM390AgT42YiBdwvQfM9fmEmGC5Xpta6oIRhxF7TNM1IL6klShNxN5Vwt76Cwozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960852; c=relaxed/simple;
	bh=NM6spyGOFsd27S7uLVoTClUkKao8+ScfJ4m062ugIW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXaIM7MKO47EcU8s7SJjuIXWTPuks6zrpKctgDSt9nGPidOUORkNtZ/gY36KTtKpRwStCkwREkCEla9dKV02d6D08H8rSO8MdK4jdT5cdp7UHsD+d6Lb3ARie9p1272JHt5t3mML999c/vZoo3Cs+8bpW2D5d35cSP4riEl+8SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tswdfq6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tswdfq6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B188BC4CEF1;
	Mon, 15 Sep 2025 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757960852;
	bh=NM6spyGOFsd27S7uLVoTClUkKao8+ScfJ4m062ugIW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tswdfq6Wgkh/tWs4WiOVgNcp1DW6QVah+8SkvNEBEw+GGk7WtDnIazSKxI2ta+0QR
	 Vww/yfOjL3uWZasQAxeelxYnSlY0NT6oNaqNhnShRSvAA7HVDU4QiRZqr9PtEDwuOz
	 +/Xg4UlkNg68+Q9h4bqLIYyxE5LIjWZKrw+akwmvC1W4UlxxKMoYX1V7mJ3aTcner7
	 Metu0TxNFUF0yAWKpwjGg+kzcNHT/0lN15kvbMytlpfD/WvqiA5dIPObj+aIkhN9vO
	 bXEy76dYmfclMotugImUqqdQ1sY+slQlETnb9T3jHmAXlYjuDpr3MdrPqgF+mEtiJm
	 a63GGv2q6bFEw==
Date: Mon, 15 Sep 2025 11:27:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
Message-ID: <20250915182732.GR8096@frogsfrogsfrogs>
References: <20250915132413.159877-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915132413.159877-1-hch@lst.de>

On Mon, Sep 15, 2025 at 06:24:13AM -0700, Christoph Hellwig wrote:
> These are purely in-memory values and not used at all in xfsprogs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, but why not move struct xfs_log_iovec as well?  It's also not
part of the ondisk log format.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 37 ----------------------------------
>  fs/xfs/xfs_log.h               | 37 ++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 942c490f23e4..890646b5c87a 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -86,43 +86,6 @@ struct xfs_unmount_log_format {
>  	uint32_t	pad2;	/* may as well make it 64 bits */
>  };
>  
> -/* Region types for iovec's i_type */
> -#define XLOG_REG_TYPE_BFORMAT		1
> -#define XLOG_REG_TYPE_BCHUNK		2
> -#define XLOG_REG_TYPE_EFI_FORMAT	3
> -#define XLOG_REG_TYPE_EFD_FORMAT	4
> -#define XLOG_REG_TYPE_IFORMAT		5
> -#define XLOG_REG_TYPE_ICORE		6
> -#define XLOG_REG_TYPE_IEXT		7
> -#define XLOG_REG_TYPE_IBROOT		8
> -#define XLOG_REG_TYPE_ILOCAL		9
> -#define XLOG_REG_TYPE_IATTR_EXT		10
> -#define XLOG_REG_TYPE_IATTR_BROOT	11
> -#define XLOG_REG_TYPE_IATTR_LOCAL	12
> -#define XLOG_REG_TYPE_QFORMAT		13
> -#define XLOG_REG_TYPE_DQUOT		14
> -#define XLOG_REG_TYPE_QUOTAOFF		15
> -#define XLOG_REG_TYPE_LRHEADER		16
> -#define XLOG_REG_TYPE_UNMOUNT		17
> -#define XLOG_REG_TYPE_COMMIT		18
> -#define XLOG_REG_TYPE_TRANSHDR		19
> -#define XLOG_REG_TYPE_ICREATE		20
> -#define XLOG_REG_TYPE_RUI_FORMAT	21
> -#define XLOG_REG_TYPE_RUD_FORMAT	22
> -#define XLOG_REG_TYPE_CUI_FORMAT	23
> -#define XLOG_REG_TYPE_CUD_FORMAT	24
> -#define XLOG_REG_TYPE_BUI_FORMAT	25
> -#define XLOG_REG_TYPE_BUD_FORMAT	26
> -#define XLOG_REG_TYPE_ATTRI_FORMAT	27
> -#define XLOG_REG_TYPE_ATTRD_FORMAT	28
> -#define XLOG_REG_TYPE_ATTR_NAME		29
> -#define XLOG_REG_TYPE_ATTR_VALUE	30
> -#define XLOG_REG_TYPE_XMI_FORMAT	31
> -#define XLOG_REG_TYPE_XMD_FORMAT	32
> -#define XLOG_REG_TYPE_ATTR_NEWNAME	33
> -#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
> -#define XLOG_REG_TYPE_MAX		34
> -
>  /*
>   * Flags to log operation header
>   *
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index af6daf4f6792..dcc1f44ed68f 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -20,6 +20,43 @@ struct xfs_log_vec {
>  	int			lv_alloc_size;	/* size of allocated lv */
>  };
>  
> +/* Region types for iovec's i_type */
> +#define XLOG_REG_TYPE_BFORMAT		1
> +#define XLOG_REG_TYPE_BCHUNK		2
> +#define XLOG_REG_TYPE_EFI_FORMAT	3
> +#define XLOG_REG_TYPE_EFD_FORMAT	4
> +#define XLOG_REG_TYPE_IFORMAT		5
> +#define XLOG_REG_TYPE_ICORE		6
> +#define XLOG_REG_TYPE_IEXT		7
> +#define XLOG_REG_TYPE_IBROOT		8
> +#define XLOG_REG_TYPE_ILOCAL		9
> +#define XLOG_REG_TYPE_IATTR_EXT		10
> +#define XLOG_REG_TYPE_IATTR_BROOT	11
> +#define XLOG_REG_TYPE_IATTR_LOCAL	12
> +#define XLOG_REG_TYPE_QFORMAT		13
> +#define XLOG_REG_TYPE_DQUOT		14
> +#define XLOG_REG_TYPE_QUOTAOFF		15
> +#define XLOG_REG_TYPE_LRHEADER		16
> +#define XLOG_REG_TYPE_UNMOUNT		17
> +#define XLOG_REG_TYPE_COMMIT		18
> +#define XLOG_REG_TYPE_TRANSHDR		19
> +#define XLOG_REG_TYPE_ICREATE		20
> +#define XLOG_REG_TYPE_RUI_FORMAT	21
> +#define XLOG_REG_TYPE_RUD_FORMAT	22
> +#define XLOG_REG_TYPE_CUI_FORMAT	23
> +#define XLOG_REG_TYPE_CUD_FORMAT	24
> +#define XLOG_REG_TYPE_BUI_FORMAT	25
> +#define XLOG_REG_TYPE_BUD_FORMAT	26
> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
> +#define XLOG_REG_TYPE_ATTR_NAME		29
> +#define XLOG_REG_TYPE_ATTR_VALUE	30
> +#define XLOG_REG_TYPE_XMI_FORMAT	31
> +#define XLOG_REG_TYPE_XMD_FORMAT	32
> +#define XLOG_REG_TYPE_ATTR_NEWNAME	33
> +#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
> +#define XLOG_REG_TYPE_MAX		34
> +
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
>  /*
> -- 
> 2.47.2
> 
> 
