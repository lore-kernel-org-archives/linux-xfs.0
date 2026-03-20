Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3C2F1FDB
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 01:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773971327; cv=none; b=CWv++WOwpj63gVom7/OLPZ97cSfNx/gxOCzWU88qr4cB52PsyTtsP0DkEXeCGBqUrSNuJQLkqm9E0vaZIFOJGSUm4NADHG3C+e7vUI/LuA/ctx6uDquTTeErCiIP7GG805mQxmmnHSz+BQHlL3ELhaurbuGzbMFYVLO8LOHYbws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773971327; c=relaxed/simple;
	bh=/luZXRqzJaM2X4QN0S0PFV5VySeqnTmolBVuRIAMzpI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fe0jj5WJQGjmc9FG/gRckkBpqVuQVyaiauoJPIGTkYtZl8la6UKxj/vRHsiwFfn37/Hpha6OKjyLWacG7EYSo6fkLwDZw2AgLNTcWbbVzlze2RaC8+IxUcNYdvqWg/zBYuK430ZfdvdLJ1gkduqJjjLku5alCARxUhmnxpVtL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=UE6KTy5o; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="UE6KTy5o"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=91lD3F5Cu0NlCet7qoPfMHORrwyYTQ28B80cm+PSmW0=;
	b=UE6KTy5oe5t64bt4oawzv2kzsJXMQX/NPJzC+yaUceqGrlLPSrKZha2qF/7dMuHHc4Fg1EH7M
	X36reN/n8Of61ouZ3gl5kA41FnhQeLUNJCbEg7DbU/U4lHJdQ4thH2n5Yhe4OrkNYCal5/wzdGa
	x9EAKEMdt40IRJIQK3q+QXw=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fcQLl6h0Pz1T4jQ;
	Fri, 20 Mar 2026 09:43:11 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8AECE4056A;
	Fri, 20 Mar 2026 09:48:35 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 09:48:35 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 20 Mar
 2026 09:48:34 +0800
Date: Fri, 20 Mar 2026 09:44:15 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH v2 1/3] xfs: fix possible null pointer dereference in
 xfs_attri_recover_work
Message-ID: <abymb78z5v61vARS@localhost.localdomain>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
 <20260319010618.722448-2-leo.lilong@huawei.com>
 <20260319165200.GP1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260319165200.GP1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Thu, Mar 19, 2026 at 09:52:00AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 19, 2026 at 09:06:16AM +0800, Long Li wrote:
> > When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
> > not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
> > in the error path may dereference a null pointer.
> > 
> > Cc: <stable@vger.kernel.org> # v6.9
> > Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_attr_item.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 354472bf45f1..8ebdd0926b89 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -633,7 +633,7 @@ xfs_attri_recover_work(
> >  {
> >  	struct xfs_attr_intent		*attr;
> >  	struct xfs_da_args		*args;
> > -	struct xfs_inode		*ip;
> > +	struct xfs_inode		*ip = NULL;
> >  	int				local;
> >  	int				error;
> >  
> > @@ -653,7 +653,8 @@ xfs_attri_recover_work(
> >  		break;
> >  	}
> >  	if (error) {
> > -		xfs_irele(ip);
> > +		if (ip)
> > +			xfs_irele(ip);
> 
> Hrmm.  On second thought, there's a much more severe UAF bug here:
> 
> int
> xlog_recover_iget(
> 	struct xfs_mount	*mp,
> 	xfs_ino_t		ino,
> 	struct xfs_inode	**ipp)
> {
> 	int			error;
> 
> 	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
> 	if (error)
> 		return error;
> 
> 	error = xfs_qm_dqattach(*ipp);
> 	if (error) {
> 		xfs_irele(*ipp);
> 		return error;
> 
> ^^^^^ here we return a nonzero error, having previously set @ipp.
> The xfs_irele in xfs_attri_recover_work is, in this case, the wrong
> thing to do.
> 
> 	}
> 
> 	if (VFS_I(*ipp)->i_nlink == 0)
> 		xfs_iflags_set(*ipp, XFS_IRECOVERY);
> 
> 	return 0;
> }
> 
> With that fixed, the xfs_irele call in xfs_attri_recover_work becomes
> incorrect because the xlog*iget functions never return nonzero *and* set
> *ipp.  If you found this via static checker, I wonder if that's what is
> tripping it up?
> 

Yes, we found this through static analysis. Obviously, I didn't look
at this code carefully enough. Thank you for pointing it out and fixing
it.

Thanks,
Long Li
