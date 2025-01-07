Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E417184D2B
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215282; cv=none; b=pfNMWG9SJ9fRYXhkYbxSXrVDI6ZAWcjOzPa9GHIE+LhGgaww7DUtpz18KqJUrvGunQGqst8ptOj+ZxZFPVcd9+mpqnOP43mfZk3ARI4aIH3+tOuci702tuCCWm4FIWIEeZvmNotv23qcQ5+pMBN630yrhzYpE2OYVqSF4kvh2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215282; c=relaxed/simple;
	bh=rG+nh3oMDNRO7AhZA1OqTDAdl0rh+2BTZe54RueHtbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3bEcMyU7peHyh+U4qDWJ7H5ViiWDWIXa9HLhBR5flyxXDX1Ycp0pVr1hgWP9d7poq7D4wNZ0QMa5cEwOM6IJsCezNkfyYFFOya0AB6C84HRlqsbuP4GO6t/u3T7lGTAyMKTCq4g2CkIEYuJpLl6bhXhLx+9MNydS87GCQT6y80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvsqHxKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvsqHxKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF46C4CED2;
	Tue,  7 Jan 2025 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215280;
	bh=rG+nh3oMDNRO7AhZA1OqTDAdl0rh+2BTZe54RueHtbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fvsqHxKZSPWTr+3g8hLa3G16E8xHXimdU38rKC90/RraDtQKP+YS5JXv/sCjPrIUB
	 SL8cNKUTzBMmyaPPprZnyG8LiYUlpayESft2vYeghw0+45czIk4rgFa70fq91QbExz
	 QAKgX6J2FPa7wAQA8sIdHdKL10VfVBqLEeEw4cF/NcAVIQ8LHryv65sNQP2jhBIT0q
	 w4jtyLgdDhDxodfrGUqJIiHQU6rmi/1t/V2F8PmQwHKE47PmLT5ZfpI+P5IPCeFCBY
	 xY3awVNQwaQx1E3FARfwqS9rsDB0E2+ZRCc17xCv2UFoiDX9/DcaYv7JKCjKNr+X2V
	 RRHeTRLWTxK5A==
Date: Mon, 6 Jan 2025 18:01:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: remove the incorrect comment about the b_pag
 field
Message-ID: <20250107020119.GU6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-4-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:40AM +0100, Christoph Hellwig wrote:
> The rbtree root is long gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3d56bc7a35cc..da80399c7457 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -187,7 +187,7 @@ struct xfs_buf {
>  	int			b_io_error;	/* internal IO error state */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
> -	struct xfs_perag	*b_pag;		/* contains rbtree root */
> +	struct xfs_perag	*b_pag;
>  	struct xfs_mount	*b_mount;
>  	struct xfs_buftarg	*b_target;	/* buffer target (device) */
>  	void			*b_addr;	/* virtual address of buffer */
> -- 
> 2.45.2
> 
> 
