Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E86C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30E0206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y45zEN/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgF2TYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:24:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732234AbgF2TYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593458647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=clmwb/CbsbEbkY8yDMKGA0eXiWryHnB4mJrykLZvHm0=;
        b=Y45zEN/UoXQ8MxpOGOlZSFVdZzVNdGM9KHutMrqxsNLokNJS/yBdKNaD513Bom3x/h6f1/
        7K2MegYYt2VSclBZj+AHOhyB4EGMLKR1NslPQbykRyMy+futeghHJmmplt7jC4gdOdgEJo
        ChHHVBTIB5JkFG281ap67UWMD0LCcbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-RwyZVw6PMq-FCx4r0a6lsw-1; Mon, 29 Jun 2020 08:22:31 -0400
X-MC-Unique: RwyZVw6PMq-FCx4r0a6lsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20D221054F8B;
        Mon, 29 Jun 2020 12:22:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEE415C240;
        Mon, 29 Jun 2020 12:22:29 +0000 (UTC)
Date:   Mon, 29 Jun 2020 08:22:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200629122228.GB10449@bfoster>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835912.1065505.9943855193663354771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159311835912.1065505.9943855193663354771.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 01:52:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 9851fd79bfb1, we added a slight amount of slack to the free
> space btrees being reconstructed so that the initial fix_freelist call
> (which is run against a totally empty AGFL) would never have to split
> either free space btree in order to populate the free list.
> 
> The new btree bulk loading code in xfs_repair can re-create this
> situation because it can set the slack values to zero if the filesystem
> is very full.  However, these days repair has the infrastructure needed
> to ensure that overestimations of the btree block counts end up on the
> AGFL or get freed back into the filesystem at the end of phase 5.
> 
> Fix this problem by reserving blocks to a separate AGFL block
> reservation, and checking that between this new reservation and any
> overages in the bnobt/cntbt fakeroots, we have enough blocks sitting
> around to populate the AGFL with the minimum number of blocks it needs
> to handle a split in the bno/cnt/rmap btrees.
> 
> Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> of the reservation steps in phase 5, so the extra allocation should not
> cause repair to fail if it can't find blocks for btrees.
> 
> Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/agbtree.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 68 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index 339b1489..7a4f316c 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
...
> @@ -262,25 +286,59 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
...
> +
> +		/*
> +		 * Now try to fill the bnobt/cntbt cursors with extra blocks to
> +		 * populate the AGFL.  If we don't get all the blocks we want,
> +		 * stop trying to fill the AGFL.
> +		 */
> +		wanted = (int64_t)btr_bno->bload.nr_blocks +
> +				(min_agfl_len / 2) - bno_blocks;
> +		if (wanted > 0 && fill_agfl) {
> +			got = reserve_agblocks(sc->mp, agno, btr_bno, wanted);
> +			if (wanted > got)
> +				fill_agfl = false;
> +			btr_bno->bload.nr_blocks += got;
> +		}
> +
> +		wanted = (int64_t)btr_cnt->bload.nr_blocks +
> +				(min_agfl_len / 2) - cnt_blocks;
> +		if (wanted > 0 && fill_agfl) {
> +			got = reserve_agblocks(sc->mp, agno, btr_cnt, wanted);
> +			if (wanted > got)
> +				fill_agfl = false;
> +			btr_cnt->bload.nr_blocks += got;
> +		}

It's a little hard to follow this with the nr_blocks sampling and
whatnot, but I think I get the idea. What's the reason for splitting the
AGFL res requirement evenly across the two cursors? These AGFL blocks
all fall into the same overflow pool, right? I was wondering why we
couldn't just attach the overflow to one, or check one for the full res
and then the other if more blocks are needed.

In thinking about it a bit more, wouldn't the whole algorithm be more
simple if we reserved the min AGFL requirement first, optionally passed
'agfl_res' to reserve_btblocks() such that subsequent reservations can
steal from it (and then fail if it depletes), then stuff what's left in
one (or both, if there's a reason for that) of the cursors at the end?

Brian

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
> 

