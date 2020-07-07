Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE32FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 12:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2C820708
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 12:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rc+dHefI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGGM7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 08:59:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726946AbgGGM7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 08:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594126742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jB1BoBWBMDJc7kO9rcy6QqBJLIpALf9uyhtgzM7j7Vs=;
        b=Rc+dHefIXWOLJZQ7BJPmQ7ESKFZMVFrT5MjYx8rtCl1n3GIEQGi6DygvCXObcMeE9lJQnH
        a3QJ1CJ36DMrgs+zp8b4PGC5PJkLiz2ouM+glzEHXMifxHjE0qyP6+fZQT7M1FdqsYJqkP
        YSc3aGkms7MvhzCWx1AzlgWgJr/mEkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-KIBJ0ELzPZKQIsgU5nc1yw-1; Tue, 07 Jul 2020 08:59:00 -0400
X-MC-Unique: KIBJ0ELzPZKQIsgU5nc1yw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC31464ACA;
        Tue,  7 Jul 2020 12:58:59 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 289ED10013D7;
        Tue,  7 Jul 2020 12:58:59 +0000 (UTC)
Date:   Tue, 7 Jul 2020 08:58:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: simplify free space btree calculations
 in init_freespace_cursors
Message-ID: <20200707125857.GA37141@bfoster>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362331.3579756.9359456822795462355.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159370362331.3579756.9359456822795462355.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:27:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a summary variable to the bulkload structure so that we can track
> the number of blocks that have been reserved for a particular (btree)
> bulkload operation.  Doing so enables us to simplify the logic in
> init_freespace_cursors that deals with figuring out how many more blocks
> we need to fill the bnobt/cntbt properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Nice simplification:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/agbtree.c  |   33 +++++++++++++++++----------------
>  repair/bulkload.c |    2 ++
>  repair/bulkload.h |    3 +++
>  3 files changed, 22 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index 339b1489..de8015ec 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
> @@ -217,8 +217,6 @@ init_freespace_cursors(
>  	struct bt_rebuild	*btr_bno,
>  	struct bt_rebuild	*btr_cnt)
>  {
> -	unsigned int		bno_blocks;
> -	unsigned int		cnt_blocks;
>  	int			error;
>  
>  	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
> @@ -244,9 +242,7 @@ init_freespace_cursors(
>  	 */
>  	do {
>  		unsigned int	num_freeblocks;
> -
> -		bno_blocks = btr_bno->bload.nr_blocks;
> -		cnt_blocks = btr_cnt->bload.nr_blocks;
> +		int		delta_bno, delta_cnt;
>  
>  		/* Compute how many bnobt blocks we'll need. */
>  		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
> @@ -262,25 +258,30 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
>  			do_error(
>  _("Unable to compute free space by length btree geometry, error %d.\n"), -error);
>  
> +		/*
> +		 * Compute the deficit between the number of blocks reserved
> +		 * and the number of blocks we think we need for the btree.
> +		 */
> +		delta_bno = (int)btr_bno->newbt.nr_reserved -
> +				 btr_bno->bload.nr_blocks;
> +		delta_cnt = (int)btr_cnt->newbt.nr_reserved -
> +				 btr_cnt->bload.nr_blocks;
> +
>  		/* We don't need any more blocks, so we're done. */
> -		if (bno_blocks >= btr_bno->bload.nr_blocks &&
> -		    cnt_blocks >= btr_cnt->bload.nr_blocks)
> +		if (delta_bno >= 0 && delta_cnt >= 0) {
> +			*extra_blocks = delta_bno + delta_cnt;
>  			break;
> +		}
>  
>  		/* Allocate however many more blocks we need this time. */
> -		if (bno_blocks < btr_bno->bload.nr_blocks)
> -			reserve_btblocks(sc->mp, agno, btr_bno,
> -					btr_bno->bload.nr_blocks - bno_blocks);
> -		if (cnt_blocks < btr_cnt->bload.nr_blocks)
> -			reserve_btblocks(sc->mp, agno, btr_cnt,
> -					btr_cnt->bload.nr_blocks - cnt_blocks);
> +		if (delta_bno < 0)
> +			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
> +		if (delta_cnt < 0)
> +			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
>  
>  		/* Ok, now how many free space records do we have? */
>  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
>  	} while (1);
> -
> -	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> -			(cnt_blocks - btr_cnt->bload.nr_blocks);
>  }
>  
>  /* Rebuild the free space btrees. */
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> index 81d67e62..8dd0a0c3 100644
> --- a/repair/bulkload.c
> +++ b/repair/bulkload.c
> @@ -40,6 +40,8 @@ bulkload_add_blocks(
>  	resv->len = len;
>  	resv->used = 0;
>  	list_add_tail(&resv->list, &bkl->resv_list);
> +	bkl->nr_reserved += len;
> +
>  	return 0;
>  }
>  
> diff --git a/repair/bulkload.h b/repair/bulkload.h
> index 01f67279..a84e99b8 100644
> --- a/repair/bulkload.h
> +++ b/repair/bulkload.h
> @@ -41,6 +41,9 @@ struct bulkload {
>  
>  	/* The last reservation we allocated from. */
>  	struct bulkload_resv	*last_resv;
> +
> +	/* Number of blocks reserved via resv_list. */
> +	unsigned int		nr_reserved;
>  };
>  
>  #define for_each_bulkload_reservation(bkl, resv, n)	\
> 

