Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbfEJReN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:34:13 -0400
Date: Fri, 10 May 2019 10:34:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190510173413.GD18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> @@ -724,8 +723,6 @@ xfs_alloc_ag_vextent(
>  	args->wasfromfl = 0;
>  	switch (args->type) {
>  	case XFS_ALLOCTYPE_THIS_AG:
> -		error = xfs_alloc_ag_vextent_size(args);
> -		break;
>  	case XFS_ALLOCTYPE_NEAR_BNO:
>  	case XFS_ALLOCTYPE_THIS_BNO:
>  		error = xfs_alloc_ag_vextent_type(args);
> @@ -817,6 +814,8 @@ xfs_alloc_cur_setup(
>  
>  	if (args->agbno != NULLAGBLOCK)
>  		agbno = args->agbno;
> +	if (args->type == XFS_ALLOCTYPE_THIS_AG)
> +		acur->cur_len += args->alignment - 1;

At this point we can just kill that switch, or even better
merge xfs_alloc_ag_vextent_type and xfs_alloc_ag_vextent.
