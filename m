Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24C54652
	for <linux-xfs@vger.kernel.org>; Sat,  9 Nov 2024 07:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731138000; cv=none; b=npws4Yyp+DBGmInjwo0CdSjCHb3LZhojbEQTSpe4k0ZNku+nWl1eRhGCizhTlndTq8cHzitGBGMAUxzLZAvUg22wH3u46XpDhZlixvsMTOcFk8WDzt6D/aPY3LrUqAFV7Rio6dJiq/BBguDFMWsVhj8WfNxGXe4S9XJ8jxwZrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731138000; c=relaxed/simple;
	bh=0ekWJ7U4iMiXRf6siDmunObbSP0/vbuzxQc0e5ffL1E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+I4CTuslrfnu6bSW01BJ+FnWYH3BxS3wD1rNAvl3W3mHRg3gGdSGeryZlbK/if6a6ZSu4bVxg7MoieYU+fK+rcUtUxaF1O7Z+Fwbn1SQjSL1RMcIrQZPuPCOGwbrbT+k36HhxjQ68RiqIjHfny/KRBFtO16kf84Q+Ak0phj+g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XlnjG0Mdyz1jwJk;
	Sat,  9 Nov 2024 15:38:10 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 983201A0188;
	Sat,  9 Nov 2024 15:39:54 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 9 Nov
 2024 15:39:54 +0800
Date: Sat, 9 Nov 2024 15:38:55 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: remove unknown compat feature check in superblock
 write validation
Message-ID: <Zy8Rj7eISiraFIha@localhost.localdomain>
References: <20241021012549.875726-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20241021012549.875726-1-leo.lilong@huawei.com>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)


Friendly Ping ...

On Mon, Oct 21, 2024 at 09:25:49AM +0800, Long Li wrote:
> Compat features are new features that older kernels can safely ignore,
> allowing read-write mounts without issues. The current sb write validation
> implementation returns -EFSCORRUPTED for unknown compat features,
> preventing filesystem write operations and contradicting the feature's
> definition.
> 
> Additionally, if the mounted image is unclean, the log recovery may need
> to write to the superblock. Returning an error for unknown compat features
> during sb write validation can cause mount failures.
> 
> Although XFS currently does not use compat feature flags, this issue
> affects current kernels' ability to mount images that may use compat
> feature flags in the future.
> 
> Since superblock read validation already warns about unknown compat
> features, it's unnecessary to repeat this warning during write validation.
> Therefore, the relevant code in write validation is being removed.
> 
> Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d95409f3cba6..02ebcbc4882f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -297,13 +297,6 @@ xfs_validate_sb_write(
>  	 * the kernel cannot support since we checked for unsupported bits in
>  	 * the read verifier, which means that memory is corrupt.
>  	 */
> -	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> -		xfs_warn(mp,
> -"Corruption detected in superblock compatible features (0x%x)!",
> -			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
> -		return -EFSCORRUPTED;
> -	}
> -
>  	if (!xfs_is_readonly(mp) &&
>  	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
>  		xfs_alert(mp,
> -- 
> 2.39.2
> 
