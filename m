Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6153BBC1
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724469647; cv=none; b=Ibk4Sc2Yl5tXpChI9+2D3ouOK3tQDidMbvtRaIDk39X8f/De5H1TewdJs2QqQpIjk/HJ0COYmjVRK8/FdeQGNOyPx7s8GII487X7wSX7YjBD3mmmtAzA7CzU6IIJIzS+6XUAJzC3WK2TC7FW7Rb0WRw/N/wArdhKkEBubIDXiK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724469647; c=relaxed/simple;
	bh=upUqEFRJ/Rhez4Ie0msQrFcIwoMtDLS1wkI+EQNdqCw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UyxaEhzVTJGXmmEdHtaTF7/n//M9V8WRQgsVkalSsyZCncgQ6DeB3gQ8OJDg64nHGMsv+hCU0YF8v+PKxktb4r4ZL7Sai4O2njtuG9LlHaN34m1MCZI/cnsA0Di/SjwgVqB2gKMF72QhaslOHIRRbP8yWIuh0Ud08b4XEDOJe0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WrMdV1gRjz1S8H3;
	Sat, 24 Aug 2024 11:20:30 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 943EB14035E;
	Sat, 24 Aug 2024 11:20:36 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 Aug
 2024 11:20:36 +0800
Date: Sat, 24 Aug 2024 11:30:39 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <20240824033039.GB871851@ceph-admin>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <20240823171709.GG865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240823171709.GG865349@frogsfrogsfrogs>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Aug 23, 2024 at 10:17:09AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> > After pushing log items, the log item may have been freed, making it
> > unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> > to indicate when an item might be freed during the item push operation.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_stats.h     | 1 +
> >  fs/xfs/xfs_trans.h     | 1 +
> >  fs/xfs/xfs_trans_ail.c | 7 +++++++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> > index a61fb56ed2e6..9a7a020587cf 100644
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -86,6 +86,7 @@ struct __xfsstats {
> >  	uint32_t		xs_push_ail_pushbuf;
> >  	uint32_t		xs_push_ail_pinned;
> >  	uint32_t		xs_push_ail_locked;
> > +	uint32_t		xs_push_ail_unsafe;
> >  	uint32_t		xs_push_ail_flushing;
> >  	uint32_t		xs_push_ail_restarts;
> >  	uint32_t		xs_push_ail_flush;
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index f06cc0f41665..fd4f04853fe2 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -117,6 +117,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> >  #define XFS_ITEM_PINNED		1
> >  #define XFS_ITEM_LOCKED		2
> >  #define XFS_ITEM_FLUSHING	3
> > +#define XFS_ITEM_UNSAFE		4
> >  
> >  /*
> >   * This is the structure maintained for every active transaction.
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 8ede9d099d1f..a5ab1ffb8937 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -561,6 +561,13 @@ xfsaild_push(
> >  
> >  			stuck++;
> >  			break;
> > +		case XFS_ITEM_UNSAFE:
> > +			/*
> > +			 * The item may have been freed, so we can't access the
> > +			 * log item here.
> > +			 */
> > +			XFS_STATS_INC(mp, xs_push_ail_unsafe);
> 
> Aha, so this is in reaction to Dave's comment "So, yeah, these failure
> cases need to return something different to xfsaild_push() so it knows
> that it is unsafe to reference the log item, even for tracing purposes."
> 

Yse ...

> What we're trying to communicate through xfsaild_push_item is that we've
> cycled the AIL lock and possibly done something (e.g. deleting the log
> item from the AIL) such that the lip reference might be stale.
> 
> Can we call this XFS_ITEM_STALEREF?  "Unsafe" is vague.
> 

Yes, it's seems reasonable, but doesn't XFS_ITEM_STALED looks more consistent??
 
Thanks,
Long Li
