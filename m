Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDB483BCF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633912; cv=none; b=Y1xES3xGPw3TkSr9i2x4WzkKRnzje3zySKWeopP+zXY+YdBpEDVuHo89FyQKiXrWRsG0gekBCrVOgBxLlt4nm8YlnQL1Q2jajXI91CrdJNTi3v+JU0n1eAPuyObLjPYFRLsAgPHIyehQ4BekPYiEG3v1tg+WL8LEdt4FQtSeVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633912; c=relaxed/simple;
	bh=ylN1Fuvlo7Iaty5TIDgkjGvxPyjeAbj4jcm16r1m50s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkB/keK+ZqqskhVPF+rPvNELm2AJ6uFX50NFcc4elAOAOOALzenBEplRrIdfP/JSNc0DVAkqa9qykE0Y3ayNVDlNFyJjCr8/eQDedWRH7idhvn6eTXzwkkWMlPCH5XlDqlnOzkBLNY26O7evtSmAFD/ho2V/hGhYAs0esWB7OW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fw2AgbVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fw2AgbVc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 144121F000E9;
	Thu, 13 Aug 2026 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633911;
	bh=Ob5SAyqP8HGwvU8Yfrkremn2KDNmSJn0CYQz2d5fyYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fw2AgbVc3+uk9pDBDhtF0ZE5g+MIRW1Xp5jtO07TPUE5F3uPYsj0OP8TdPLe+uzCi
	 8rnGwy5SalRBCyB+7t5duLlu/Bj9s37wC8IBQvo9wfbfEzEoKbw/BF7vB060EJijGA
	 Py/CAmajHJPUSe81YpIorV8JuoyJlMmohffM2Yf7Ltr0KHeIipQyEyNSlDayG6Pvo6
	 CYLfWGVIFNh/NW/K4X6+SoOXH5BQ6nhpNpSLmDzO4GsaS4vmNM8a82+lqdzqFYv0Lx
	 qZg85TlyC/gSEQKI+40CB9hFljcfgFS+XiGzGbJtO45SV3D89HxUsaSbNQTOL8zwXS
	 bBL7WmfJuckLw==
Date: Thu, 13 Aug 2026 08:11:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, hans.holmberg@wdc.com, dlemoal@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
Message-ID: <20260813151150.GE3556460@frogsfrogsfrogs>
References: <20260813145617.419537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813145617.419537-1-hch@lst.de>

On Thu, Aug 13, 2026 at 04:56:12PM +0200, Christoph Hellwig wrote:
> xfs_zone_gc_write_chunk relies on bi_bdev to still be valid, which is not
> true when XFS is used on top of a stacked block device.  This can lead to
> misdirected GC writes, writing of plain text when using dm-crypt, or
> miscalculated I/O limits in xfs_zone_gc_split_write.
> 
> Fix this by reassigning bi_bdev.

ewww, what??

Should bio_reuse take a bdev parameter and set_dev itself?  I had no
idea that bi_bdev could get changed by the time the bio completes.

> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

From a purely defensive standpoint this makes sense, so

Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 7ab8f2218c6a..5cc5ad1e3483 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -869,6 +869,11 @@ xfs_zone_gc_write_chunk(
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_move_tail(&chunk->entry, &data->writing);
>  
> +	/*
> +	 * If we run on top of stacked block device, the read I/O might have
> +	 * reset bi_bdev, restore it to the one we want.
> +	 */
> +	bio_set_dev(&chunk->bio, mp->m_rtdev_targp->bt_bdev);
>  	bio_reuse(&chunk->bio, REQ_OP_WRITE);
>  	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
>  		xfs_zone_gc_submit_write(data, split_chunk);
> -- 
> 2.53.0
> 
> 
