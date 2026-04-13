Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F809364927;
	Mon, 13 Apr 2026 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103162; cv=none; b=BITHl0e6U7T/Cx4PXqVhOmIE0xtV7O3vSNcdwM+tyuoRvXIJ4mw7o5GlZYg0uxhYYCMSPhML2fpxa6PQn/8+9woBdjh8W6zn8x6StfaKOY3cheeLH1lU+kJs1ipET88Rf6wrnvCUrzYuguql0dgGeaZ/ZwfzLmUdLtWRweYOmcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103162; c=relaxed/simple;
	bh=AbggZPHBgFYnLUxrCRt2ZMVZ9i380n4hm+7EU0DH++Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMBNZO0/QS/HDMADCOCDKEj9+MF1GE2CTaXF30jSXPBKQcmesbts+y5vG39lDc/vuaV/iQXA23MQtI6Yklf9V1SevM6ahO8FE5L+xUf4+8N5WsPhOghs5WhWm5CJMncjxjcTS6FnTnIQt2V2VvaHgTaEpc77PXLuoIumhP+D4Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tc+1ViWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tc+1ViWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60637C2BCAF;
	Mon, 13 Apr 2026 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776103162;
	bh=AbggZPHBgFYnLUxrCRt2ZMVZ9i380n4hm+7EU0DH++Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tc+1ViWG1re6+D/Dti2MWYS0vLKwNcw4kTrmmYQtV5yW55nr7V8QuIsppQ0gPdRWc
	 qLug1qcpSr/R7qtZuQoT6VlEyoxeJkyh8TpoBwzLvECWZFA+yHFQNG5rT3j9puRW9e
	 uuCk4qFc+8KtEWu62ZoyE+w9ks87BRJLqazI6tktfqa8ObGEtEVwNvh7OoW9QqyJHl
	 2QXAUeN27sHNEKeBDXqQHLmdeSr74tmI0/A2sOwx3xJ5XVCtyjEq/Eb+t5xqIauXKq
	 oZzTWOablWjzOeOM/3GjmzbuJNNdZCpaEQKoHxwS2L9jQps27+2EKu76uZe4VtbHLN
	 FK4ur/urX/92g==
Date: Mon, 13 Apr 2026 10:59:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: zero directory data block padding on write
 verification
Message-ID: <20260413175921.GM1048989@frogsfrogsfrogs>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
 <20260411142411.72194-7-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260411142411.72194-7-ytohnuki@amazon.com>

On Sat, Apr 11, 2026 at 03:24:14PM +0100, Yuto Ohnuki wrote:
> Old kernels did not zero the pad field in xfs_dir3_data_hdr when
> initializing directory data blocks, so existing filesystems may have
> non-zero padding on disk.
> 
> Zero the pad field in xfs_dir3_data_write_verify alongside the existing
> LSN and checksum updates. The pad field is pure alignment padding with
> no runtime meaning, so zeroing it during write verification is safe and
> has no additional I/O cost. This lets filesystems gradually self-heal
> stale non-zero padding as directories are modified, without requiring an
> explicit repair pass.
> 
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 35ff119aa84b..aecbab61014c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -382,6 +382,7 @@ xfs_dir3_data_write_verify(
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> +	struct xfs_dir3_data_hdr *datahdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
>  	fa = xfs_dir3_data_verify(bp);
> @@ -396,6 +397,11 @@ xfs_dir3_data_write_verify(
>  	if (bip)
>  		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
> +	/*
> +	 * Zero padding that may be stale from old kernels.
> +	 */
> +	datahdr3->pad = 0;

This needs to be gated on the directory block actually having a dir3
data header (aka xfs_has_crc()).

--D

> +
>  	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
>  }
>  
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
