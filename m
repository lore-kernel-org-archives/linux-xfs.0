Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE3135F5E9
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773128758; cv=none; b=T7192ADazm92LB+k3bzX6sYDMEuFZQ3f4wd48rJIZS3KLD4E1RcoE9Lw8illZ3Wx5AKy9FMiPJlauAR6tw8f3iQ7DbmxTBplnJKC4gX8EcrczKcJ+QLVObrTrROwE/hxSupYGHg5Dec8RhWrw3j8Kt1Gh5nxNVTgFRa0SCKVm+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773128758; c=relaxed/simple;
	bh=VUmvMU2tj2vLwW2jOez0tcSYgBjuCw2acALIHeHaaEY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFvYf44rI0qsfz861sooIt5c9Y2Na8iL7oA6hawjcxS5zS14cF+DI7Vt5WIeISnttwV6XVkyRSFjhEL3r/I8i2XUSWk/JkaxYLOuQi0tdk3s7gU/uV9P2uKpjk1V5Bc9+suSmPQh1vkPE4+cyTNKr7HZ+A8oJjEgcScEWGDsWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PGc9+Ma6; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PGc9+Ma6"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oOvwitENWS7MwyBr8yRxX/eyiilH896rzDZYLeDC8hc=;
	b=PGc9+Ma6S2Ws/PYAJ/kGyGhf/4qWWnD/KZWUcxPCC9HG108f0oJKEIr5nj+OspDzWfFj3GoL7
	wPD4nKSigMNHUsg15Nq84BnAlI8RvaNSYrYroMkb4z6ufV/MWzcchV9ZTCsVFChDxZwdBpEH7Fc
	keOcJFV1SfCxRryCl/jzL34=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVQlL2pzpznTY9;
	Tue, 10 Mar 2026 15:40:14 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id C578D4056D;
	Tue, 10 Mar 2026 15:45:50 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 15:45:49 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 10 Mar
 2026 15:45:49 +0800
Date: Tue, 10 Mar 2026 15:42:01 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 3/4] xfs: factor out xfs_attr3_leaf_init
Message-ID: <aa_LSbE9_Vvf5nfO@localhost.localdomain>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-4-leo.lilong@huawei.com>
 <20260309164437.GJ6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260309164437.GJ6033@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 09, 2026 at 09:44:37AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 04:27:51PM +0800, Long Li wrote:
> > Factor out wrapper xfs_attr3_leaf_init function, which exported for
> > external use.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 20 ++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 47f48ae555c0..6599b53f4822 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -1415,6 +1415,26 @@ xfs_attr3_leaf_create(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Wrapper function of initializing contents of a leaf, export for external use.
> > + */
> > +int
> > +xfs_attr3_leaf_init(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*dp,
> > +	xfs_dablk_t		blkno)
> > +{
> > +	struct xfs_buf		*bp = NULL;
> > +	struct xfs_da_args	args;
> 
> Same thing as previous patch:
> 
> 	struct xfs_da_args	args = {
> 		.trans		= tp,
> 		...
> 	};
> 
> Also I think this should just go in whichever patch uses the new
> function since this is pretty trivial.
> 
 Thanks for point that, it will be update in next version.

 Long Li
