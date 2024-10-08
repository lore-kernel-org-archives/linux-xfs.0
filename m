Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18813125A9
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353076; cv=none; b=uhVqSpWqzuxiI4HlQnfe+KYOA1/Hotg+qbAEEy8DfelLiIqN6wQTq3hjp5XZvS7fR96boMmAF96UuV8s1EYKWi9kzbAN5WYO+GsFi4fQQbxk+X7k6sYBbff/0l1+cb/rqoVxVclP3Gkyyur2P+Gj88w5fkL1UuOywe9ENi6ZddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353076; c=relaxed/simple;
	bh=ZIaDB+alYlJJ7VnulCPB9dlfPZU278NftcdsCKR+D8Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WS5HPNtd/acVjHIYwHkhWOxqtCgeBiRzSEtxsAl6D95OFN5RYmP8ClytB1Q1C9txgaFDeMzXBplHlUmzzT1WP7YjAEdlpNkG9KDIgjUEkFzqdt3ddfdJd960Rod+Kk64dSh6mAzhS5g+exhWckOgTPvEXvk2689nz+7BXTH/MA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XMznp47Xlz2DdH3;
	Tue,  8 Oct 2024 10:03:26 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CF2D1A0188;
	Tue,  8 Oct 2024 10:04:30 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 8 Oct
 2024 10:04:29 +0800
Date: Tue, 8 Oct 2024 10:19:07 +0800
From: Long Li <leo.lilong@huawei.com>
To: Carlos Maiolino <cem@kernel.org>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [next] xfs: remove the redundant xfs_alloc_log_agf
Message-ID: <20241008021907.GA361858@ceph-admin>
References: <20240930104217.2184941-1-leo.lilong@huawei.com>
 <5zvq7ax2ih27chjwl65keftyplz3bzyz4deblrnq4xe5pvoudb@va4yxbk7tqkb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5zvq7ax2ih27chjwl65keftyplz3bzyz4deblrnq4xe5pvoudb@va4yxbk7tqkb>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Mon, Sep 30, 2024 at 02:55:47PM +0200, Carlos Maiolino wrote:
> Hello.
> 
> What do you mean with the [next] tag in the subject, instead of usual [PATCH]
> tag?

I intended to use [PATCH-next] in the subject, but I made a mistake. Do I
need to resend?

> 
> On Mon, Sep 30, 2024 at 06:42:17PM GMT, Long Li wrote:
> > There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
> > The AGF does not change between the two calls. Although this does not pose
> > any practical problems, it seems like a small mistake. Therefore, fix it
> > by removing the first xfs_alloc_log_agf invocation.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 59326f84f6a5..cce32b2f3ffd 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3159,8 +3159,6 @@ xfs_alloc_put_freelist(
> >  		logflags |= XFS_AGF_BTREEBLKS;
> >  	}
> >  
> > -	xfs_alloc_log_agf(tp, agbp, logflags);
> > -
> 
> Hmm.. Isn't this logged twice because of lazy-count?
> 
> 
> Carlos
> 

I think that logging twice is unrelated to the lazy superblock count,
as the lazy superblock count is rebuilt using information from the AGF.
We only need to log AGF normally, not twice.

Thanks,
Long Li

> 
> >  	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
> >  
> >  	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
> > -- 
> > 2.39.2
> > 
> > 
