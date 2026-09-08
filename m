Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B744AA1DE
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878696; cv=none; b=JYO2R3Fwz0JlnDSM1UMgV6vQu/oexOZOwr6QBErwxUN1Dq0UEVArO14PMc/JwBHZ1+j2jIAkFSambsL8czAo/OXWHvu9HzaWzbtux2pAw6thu9gKhc20NqWoGi2EBtE4hqVJU6/mqmVyOFjP9tz134cLoV2vgrWYRJRV4famI9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878696; c=relaxed/simple;
	bh=7KpOooR7+Hu0dlV+clct71p5W9wA0QCy7n4a9BbycQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjB77A90WBU4H1xcZ5r+3BxmhIX/rchrWyzIErQbeoTWz4J96ZveVSL5zT0zHFp4eNMVBt3Gi3yA4qrLqz8BjrDJEtxoiuPiODFEhmVoU9npMbyls8dIPjhvvDDcDHOesF3qnVCAZudaf3fiFsjQeD8MZQYT0amTqSiLuMODc0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMwb39Q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMwb39Q0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 851E91F00A3A;
	Tue,  8 Sep 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788878684;
	bh=/FQ6ZPv0a9m4jc5Hzmpcm/SGgIqQyRyk268I98QrRMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gMwb39Q0U4yBsMxmyXrCMzK7UgRIZF09z1wZI3B6OvBznQeNrtfOjr/ZFH14k2gqu
	 fOkqKYSmXIWmNoysCdT2is6F+34RAk2amWr7SXGdOEQnPSeKsl4oJumLVeASlekvuk
	 i4/1wDzjAVpwK6xVcVzZE8pBTQbQWhML8lfBouEOjHTxBLo9vQtH2dRLOkCgNLtPOE
	 c+oxsP5ASaoCpMGe3pa69T42ksRjZQMK6/O99l+k09jCIXZ9e4deB0Qgw/5D1LwFNt
	 mf85DEL91cLtPbSIYpJ2aE0znG7oXttz7p0csv2vB59NuacbUnTQlGLXzDEpZKqkUy
	 +gLgK6+8efeaQ==
Date: Tue, 8 Sep 2026 07:44:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, anuj20.g@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity
 devices
Message-ID: <20260908144443.GC2619314@frogsfrogsfrogs>
References: <20260907072739.719289-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907072739.719289-1-hch@lst.de>

On Mon, Sep 07, 2026 at 10:27:39AM +0300, Christoph Hellwig wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> xfs_iomap_set_anon_write does not set IOMAP_F_INTEGRITY based on
> bdev_has_integrity_csum(), so file system PI generation is silently
> skipped for zoned writes on integrity-enabled devices, and left to
> the block layer PI generation.
> 
> Fixes: 6bbb4d96f797 ("xfs: support T10 protection information")
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> [hch: ported to the recently introduced xfs_iomap_set_anon_write()]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,

Cc: <stable@vger.kernel.org> # v7.1
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index c906c62d46f3..f2520a9b3a13 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -41,6 +41,8 @@ xfs_iomap_set_anon_write(
>  	iomap->offset = offset;
>  	iomap->length = length;
>  	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
> +	if (bdev_has_integrity_csum(iomap->bdev))
> +		iomap->flags |= IOMAP_F_INTEGRITY;
>  }
>  
>  static inline xfs_filblks_t
> -- 
> 2.53.0
> 
> 
