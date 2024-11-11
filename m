Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDF017F7
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 02:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731291367; cv=none; b=JuLLNEkZUQR6xxhQ5pvQCHodu/8kEKiw7wsa64GowdKcolzATYzWOh2Ybe/w2mORPNSxLHBNA9xPECya/aXWM3EAdk2jw1bz1GzDJFyvKa/9uOxcCjcCaIbvlkyV/dMX9moA9qKzqDfFEbZIzkvcC1ngq+6RlL4cMOouzcFODZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731291367; c=relaxed/simple;
	bh=UpLygm05GUQy+iPLOZcJEsnhb5R7brPWCguqTWSsDmY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXEOkrnXUMJ7O2KpJIIYUN1wFbh4yYUqDhUUHQJPbTucFSsCXnaJYCR9kJimgmaZW9iAMIFjqbG+5knCxHv5+mUwRe9BVgp//wcfzqgS/JxTMYXQ7TO5+tyfLnS72qHBC4ZxWzWx+5Pyr+lVHGe8qcOp2yYnlDHdFZLqzaPTILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XmtQZ13s9z2DgwS;
	Mon, 11 Nov 2024 10:14:14 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C03C14011F;
	Mon, 11 Nov 2024 10:16:01 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 11 Nov
 2024 10:16:00 +0800
Date: Mon, 11 Nov 2024 10:14:55 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: remove unknown compat feature check in superblock
 write validation
Message-ID: <ZzFon-0VbKscbGMT@localhost.localdomain>
References: <20241021012549.875726-1-leo.lilong@huawei.com>
 <Zy8Rj7eISiraFIha@localhost.localdomain>
 <20241109162124.GA9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20241109162124.GA9438@frogsfrogsfrogs>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Sat, Nov 09, 2024 at 08:21:24AM -0800, Darrick J. Wong wrote:
> On Sat, Nov 09, 2024 at 03:38:55PM +0800, Long Li wrote:
> > 
> > Friendly Ping ...
> 
> Sorry about that, I missed this one.
> 
> > On Mon, Oct 21, 2024 at 09:25:49AM +0800, Long Li wrote:
> > > Compat features are new features that older kernels can safely ignore,
> > > allowing read-write mounts without issues. The current sb write validation
> > > implementation returns -EFSCORRUPTED for unknown compat features,
> > > preventing filesystem write operations and contradicting the feature's
> > > definition.
> > > 
> > > Additionally, if the mounted image is unclean, the log recovery may need
> > > to write to the superblock. Returning an error for unknown compat features
> > > during sb write validation can cause mount failures.
> > > 
> > > Although XFS currently does not use compat feature flags, this issue
> > > affects current kernels' ability to mount images that may use compat
> > > feature flags in the future.
> > > 
> > > Since superblock read validation already warns about unknown compat
> > > features, it's unnecessary to repeat this warning during write validation.
> > > Therefore, the relevant code in write validation is being removed.
> > > 
> 
> You might want to add this so it actually gets backported:
> 
> Cc: <stable@vger.kernel.org> # v4.19
> 

Thanks for your review, indeed, it should backport to v4.19+.

> > > Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> 
> Makes sense, so
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 7 -------
> > >  1 file changed, 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index d95409f3cba6..02ebcbc4882f 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -297,13 +297,6 @@ xfs_validate_sb_write(
> > >  	 * the kernel cannot support since we checked for unsupported bits in
> > >  	 * the read verifier, which means that memory is corrupt.
> > >  	 */
> > > -	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> > > -		xfs_warn(mp,
> > > -"Corruption detected in superblock compatible features (0x%x)!",
> > > -			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
> > > -		return -EFSCORRUPTED;
> > > -	}
> > > -
> > >  	if (!xfs_is_readonly(mp) &&
> > >  	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > >  		xfs_alert(mp,
> > > -- 
> > > 2.39.2
> > > 
> > 
> 
