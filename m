Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0871D9A54
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773714224; cv=none; b=eHFnaNc+2u7VJBYuxIilY60cr7lK4G1oStzzJoFKvxUsnSSKXI/kMEUDPkwOrsZTE75BgMMmd3Cge+goeAzMSNZhih0oOLJeRHK4fJ4CN302dOi7IMFnMgjK/uzhPYR/Avd8SqClZIpEYrbAVktDDMAX0jqsWft+BTwGJRKs2YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773714224; c=relaxed/simple;
	bh=U+0rXWG43OHuY4kOidXvfpA06fKII0bmwJQr5eJhJ6Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPXiO1rQqDo0iCG4wbAIHBgTaz+tdEWYauESJq6nniiL3BvGNa38MOt8QxtQjQbVK0L9mMbKTqUx+6tAtrFXKE6DiecDc94qgqigVnzuJcE6efgrf86bVyx+CqeihsA+b4UURhpiQ9z4T24GoaGKJQGxG0y2t3AcL3+iP/Z1nhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=ooq/+EL7; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="ooq/+EL7"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zS2+eW7Hyohl1GQXQs2fL3YUuX8/yJ1ifKqDHU57lsY=;
	b=ooq/+EL7iA0eKeZsnvuK4SD9Dz0RkJipoCDZjqgij8JXSycX7an1UFtmcgo7rrKd3fzbktTyo
	xs8O0yteXg1+5vy/jl74jODzfR8KjL4k8PISwqDK5RNrZMLTxeVAO7fVvzLYjX4CnT+lkhVv11d
	Ku1Y9pBRB0RPr7/miHYQcec=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fZbH721Ryz1K98h;
	Tue, 17 Mar 2026 10:18:43 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id BD95F4055B;
	Tue, 17 Mar 2026 10:23:39 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:23:39 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:23:39 +0800
Date: Tue, 17 Mar 2026 10:19:29 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/3] xfs: fix possible null pointer dereference in
 xfs_attri_recover_work
Message-ID: <abi6MfJFz0RBNffU@localhost.localdomain>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-2-leo.lilong@huawei.com>
 <20260316223357.GC1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260316223357.GC1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 16, 2026 at 03:33:57PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 09:24:14AM +0800, Long Li wrote:
> > When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
> > not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
> > in the error path may dereference a null pointer.
> 
> Don't you need to fix the variable declaration with a null initializer
> too?
> 
> --D

Sorry, I didn't notice, it will be update. :)

Thanks,
Long Li

> 
> > Cc: <stable@vger.kernel.org> # v6.9
> > Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_attr_item.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 354472bf45f1..3d3ac8dad519 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -653,7 +653,8 @@ xfs_attri_recover_work(
> >  		break;
> >  	}
> >  	if (error) {
> > -		xfs_irele(ip);
> > +		if (ip)
> > +			xfs_irele(ip);
> >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
> >  				sizeof(*attrp));
> >  		return ERR_PTR(-EFSCORRUPTED);
> > -- 
> > 2.39.2
> > 
> > 
> 
