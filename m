Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2472C029F
	for <linux-xfs@vger.kernel.org>; Sat, 14 Mar 2026 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773456695; cv=none; b=SeU/Hp2bfYneg7B/DSd3CDe4C5TTh6z+tzW+Y5z51Qso3UDqfgvGc4FQGrtGt3lQND9kh0Oni/omnl7nyT64SlrEmnDHDiWZRA73NYlo81ByEA0sx9O1+Dq0TvA1gkpOixzluGACUPZV32PwGJPYObdpovmSkzn6iQzsPBJehIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773456695; c=relaxed/simple;
	bh=ItRd4u/aaJrg+efkRvFUHD5ZVP5W0BTWYpyp9KeU7sw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGR2ZEy4aGiWwQvXVpt9XogJgBAbJgV58tLO5k5p3xi9Xu97JWTXGYZEjerA+qCSq3oQ8v2bIk0JlyT3B2XpTv8kcrW0AtC7GKDRD/sBrIE7DW0MZQJx8LDuB+cOdvn4JJM1AfJARO9F9w51+4yGL1tfjulaVKwgRCFv1n1v2qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=ly412TmX; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="ly412TmX"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Gb5wYeSijoCJWFZxQtVfBsTrHC2RwnYBauFhwhYSeX4=;
	b=ly412TmXXYk2gXwC6Ts8WDpv8N5WceWw2X/VbvEGNIC/Pwuw3KNy5BT86EXg+YVHyFFwVmlcw
	Lq+II6tSe9MF60B17tCcOSphQcaUB+SiSxeDrwhInffdzywm414gnBmfebEgIGKz/E6ctTvFnHc
	ZrMSqHsXHM+XuyEqarYYnzo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fXm2D4mlWz1T4FX;
	Sat, 14 Mar 2026 10:46:12 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id E60E140569;
	Sat, 14 Mar 2026 10:51:27 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Mar 2026 10:51:27 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 14 Mar
 2026 10:51:27 +0800
Date: Sat, 14 Mar 2026 10:47:27 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH v2 3/4] xfs: factor out xfs_attr3_leaf_init
Message-ID: <abTMP-9JrsijFjTg@localhost.localdomain>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-4-leo.lilong@huawei.com>
 <20260313150417.GQ1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260313150417.GQ1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Fri, Mar 13, 2026 at 08:04:17AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 12, 2026 at 04:57:59PM +0800, Long Li wrote:
> > Factor out wrapper xfs_attr3_leaf_init function, which exported for
> > external use.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 22 ++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 47f48ae555c0..96a65141e812 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -1415,6 +1415,28 @@ xfs_attr3_leaf_create(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Create and initialize an empty attr leaf block at blkno, and attach the
> > + * buffer to tp.
> 
> Not sure why we "create and initialize" here -- there's already a block
> mapped at @blkno and we're rewriting it with a leaf header, right?
> 
> /*
>  * Reinitialize an existing attr fork block as an empty leaf, and
>  * attach the buffer to tp.
>  */
> 
> With that changed,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D

Thank you for the review. I'll update the comment to use the clearer format
you suggested. and appreciate the guidance on improving the documentation
clarity.

Thanks,
Long Li

