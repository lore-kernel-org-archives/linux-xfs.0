Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D436301460
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 02:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773972395; cv=none; b=A8cSt9cJG4JZzhIjZCqq9S788zohDk5KFNl+4aHN4hKIL5uSjGtZDdwMlpeeP1+CpNO23RxqONbwf3i6sqpDROFj+csMrpzREjByzWMzm2a9j2wbZAhaxqh7xxZUij3ltzCRxNrTA3vy6z+Mv06DJFtkhuVczoTlWiGnGHY3JYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773972395; c=relaxed/simple;
	bh=4uLSWTR486ZpBi+E5EjR+iG2FNoWK3TEUBrkHNyiarg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRruYRSo38+jTJcR4eF+WyDzpDipejxVenqwk/tSWe26m0i5rxx5cdltSeT9OTdwwbNCe3LygDwobg9kV0KAWzSvNf2vB5q4qV96mXYnaI+Ssu1SlaB4/HfAlR7JrKhxhIGLEh0XioSeSgNIh6oWyNRyWyg2RDu2nTENd+JQO6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=JSjHlGlf; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="JSjHlGlf"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uIXIybARK+xn6OaDtWod06Xq33ksVd/ZTfeQ2J9d/cI=;
	b=JSjHlGlfTV1PaUFhLfPWSCy0Oalsri++pnjnnKLyQxyYu2Bx5T32qGzBLNgkabKprqK1iko9H
	+deXtpuiUAB1cfV1FFlyCWUP18UCrnsZBlkz8uMzP7pw6axvTteOynNSD95LQYi8+T13SozfEUg
	ktNE9qeqpXB9UCm3QQgLgvQ=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fcQlp70xszmV66;
	Fri, 20 Mar 2026 10:01:26 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8967D402AB;
	Fri, 20 Mar 2026 10:06:28 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:06:28 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 20 Mar
 2026 10:06:27 +0800
Date: Fri, 20 Mar 2026 10:02:08 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: don't allow UAF in xlog_recover_iget
Message-ID: <abyqoPTmtBVFfOuJ@localhost.localdomain>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260319170938.GS1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Thu, Mar 19, 2026 at 10:09:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this function to avoid touching the passed in ipp argument until
> we're 100% certain that we're returning zero.  This avoids creating a
> dangling pointer in the caller.  The xfs_irele call in
> xfs_attri_recover_work was never correct and should go away.
> 
> Cc: <stable@vger.kernel.org> # v5.15
> Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log_recover.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca4878e..0e91a62348eb79 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1745,21 +1745,23 @@ xlog_recover_iget(
>  	xfs_ino_t		ino,
>  	struct xfs_inode	**ipp)
>  {
> +	struct xfs_inode	*ip;
>  	int			error;
>  
> -	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
> +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
>  	if (error)
>  		return error;
>  
> -	error = xfs_qm_dqattach(*ipp);
> +	error = xfs_qm_dqattach(ip);
>  	if (error) {
> -		xfs_irele(*ipp);
> +		xfs_irele(ip);
>  		return error;
>  	}
>  
> -	if (VFS_I(*ipp)->i_nlink == 0)
> -		xfs_iflags_set(*ipp, XFS_IRECOVERY);
> +	if (VFS_I(ip)->i_nlink == 0)
> +		xfs_iflags_set(ip, XFS_IRECOVERY);
>  
> +	*ipp = ip;
>  	return 0;
>  }
>  
> 
Looks good
Reviewed-by: Long Li <leo.lilong@huawei.com>
