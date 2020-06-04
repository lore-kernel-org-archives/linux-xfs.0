Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE0AC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 18:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C8E206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 18:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S62zzm5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgFDSIV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 14:08:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58715 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730008AbgFDSIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 14:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591294099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pme17xM+S7I1NoHGCVfO2lGu6npj2s651GmfNp2LUSE=;
        b=S62zzm5L2+5pAz+blUoN7Qi8tb7W1Dx2DIy5LwksWX+jB3k3ZEaAXzIeKk1h5hjV6ki+M4
        Jz78dxgDxs91nlOmZsJ6r/PHXPHzDX7L125xgR6Mz2ST2N5OFtAgsu75t9wqJITDKkCz2N
        YO6LfSN0MloBXJ/uBD35DeneSV89fNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-8rUCh_oaMPSDbLYL7N99Ew-1; Thu, 04 Jun 2020 14:08:17 -0400
X-MC-Unique: 8rUCh_oaMPSDbLYL7N99Ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 879C12C21;
        Thu,  4 Jun 2020 18:08:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E2455D9D3;
        Thu,  4 Jun 2020 18:08:16 +0000 (UTC)
Date:   Thu, 4 Jun 2020 14:08:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/30] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200604180814.GG17815@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-19-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer need to issue IO from shrinker based inode reclaim to
> prevent spurious OOM killer invocation. This leaves only the global
> filesystem management operations such as unmount needing to
> writeback dirty inodes and reclaim them.
> 
> Instead of using the reclaim pass to write dirty inodes before
> reclaiming them, use the AIL to push all the dirty inodes before we
> try to reclaim them. This allows us to remove all the conditional
> SYNC_WAIT locking and the writeback code from xfs_reclaim_inode()
> and greatly simplify the checks we need to do to reclaim an inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c | 117 ++++++++++++--------------------------------
>  1 file changed, 31 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a6780942034fc..74032316ce5cc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -1341,9 +1288,8 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				if (!batch[i])
>  					continue;
> -				error = xfs_reclaim_inode(batch[i], pag, flags);
> -				if (error && last_error != -EFSCORRUPTED)
> -					last_error = error;
> +				if (!xfs_reclaim_inode(batch[i], pag, flags))
> +					skipped++;

Just a note that I find it a little bit of a landmine that skipped is
bumped on trylock failure of the perag reclaim lock when the
xfs_reclaim_inodes() caller can now spin on that. It doesn't appear to
be an issue with current users, though (xfs_reclaim_workers() passes
SYNC_TRYLOCK but not SYNC_WAIT).

>  			}
>  
>  			*nr_to_scan -= XFS_LOOKUP_BATCH;
...
> @@ -1380,8 +1314,18 @@ xfs_reclaim_inodes(
>  	int		mode)
>  {
>  	int		nr_to_scan = INT_MAX;
> +	int		skipped;
>  
> -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	if (!(mode & SYNC_WAIT))
> +		return 0;
> +

Any reason we fall into the loop below if SYNC_WAIT was passed but the
above xfs_reclaim_inodes_ag() call would have returned 0?

Looks reasonable other than that inefficiency:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	do {
> +		xfs_ail_push_all_sync(mp->m_ail);
> +		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	} while (skipped > 0);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -1402,7 +1346,8 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 

