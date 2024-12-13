Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B716F189F57
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130871; cv=none; b=JUT7QuL6Mwt2j3mf7mu90jpLJF+MmQfINrqHf63SIc1ymQ4A8wUMMVTF2KmwKHR76FkDhSIbB8Ehj41mAC2gXyhv1RCQrCmFlkUg9l1W6qFphqWryuCmFPivnU8nrbW5IkxDw58N+1hHguhvOCIquQVQCsglYP2SSI2rOihVGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130871; c=relaxed/simple;
	bh=wtROa2JvCbyZCfhGwuilSFfKPYdwVo5A+LyGAeZvT88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6nVnk1zUASz5cioHAh7FGgV7a4SvmkVi2o+kLDXii5klWkgM5RHaNvXCfLRFpOt2GikUTAY0+O0rmzlUjyjhQBB3XgeUy854OCpBzWha3drvq6MwAiAeWpBAFddT15zYr4BerIWDr9Hveyo7+zaWg+1UUXwCIWujHm9TR6PTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1UdobPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1UdobPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24506C4CED0;
	Fri, 13 Dec 2024 23:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130871;
	bh=wtROa2JvCbyZCfhGwuilSFfKPYdwVo5A+LyGAeZvT88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C1UdobPuZ9SBI4Xo5bOQ1B31jO+bRh9QgNvlcgipwF/+bLz4tplq8elrGq9+KutpS
	 TpILfZWAstu7/Bnoi4ble4loxO/qej4jgVfo/KBdb4cFnGVlVsrXpEOqrkDGTgMOfk
	 KTr4B89RETAWe617hsYXShxyXjgC0L0+bQQft4m+KDcMFWg9Q8vv4WnE+sMaATlIrK
	 kCYj92UQJrqpQ6ROoqYsFIPDbDvXUA+IC1xDSZjKuBwoeia9jGkcGoFQszuiFN+V8s
	 eV82TGrzQKaycQkU339m6O/RmbL11UDCIZ6Zxxp6n5Dd3u62rYH6EeMutItlbhnUu6
	 X76QI5mH5oHaQ==
Date: Fri, 13 Dec 2024 15:01:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/43] xfs: wire up the show_stats super operation
Message-ID: <20241213230110.GC6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-43-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-43-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:07AM +0100, Christoph Hellwig wrote:
> The show_stats option allows a file system to dump plain text statistic
> on a per-mount basis into /proc/*/mountstats.  Wire up a no-op version
> which will grow useful information for zoned file systems later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d2f2fa26c487..47468623fdc6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1238,6 +1238,14 @@ xfs_fs_shutdown(
>  	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REMOVED);
>  }
>  
> +static int
> +xfs_fs_show_stats(
> +	struct seq_file		*m,
> +	struct dentry		*root)
> +{
> +	return 0;
> +}
> +
>  static const struct super_operations xfs_super_operations = {
>  	.alloc_inode		= xfs_fs_alloc_inode,
>  	.destroy_inode		= xfs_fs_destroy_inode,
> @@ -1252,6 +1260,7 @@ static const struct super_operations xfs_super_operations = {
>  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  	.shutdown		= xfs_fs_shutdown,
> +	.show_stats		= xfs_fs_show_stats,
>  };
>  
>  static int
> -- 
> 2.45.2
> 
> 
