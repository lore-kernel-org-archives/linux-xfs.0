Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1278FA3735
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C0A21835
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfJQMyq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 08:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfJQMyp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 08:54:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F95C793D1;
        Thu, 17 Oct 2019 12:54:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19AB519C70;
        Thu, 17 Oct 2019 12:54:45 +0000 (UTC)
Date:   Thu, 17 Oct 2019 08:54:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: xrep_reap_extents should not destroy the bitmap
Message-ID: <20191017125443.GC20114@bfoster>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
 <157063972033.2913192.3828052500812376869.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157063972033.2913192.3828052500812376869.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 17 Oct 2019 12:54:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:48:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the xfs_bitmap_destroy call from the end of xrep_reap_extents
> because this sort of violates our rule that the function initializing a
> structure should destroy it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |    2 +-
>  fs/xfs/scrub/repair.c          |    4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 7a1a38b636a9..8fcd43040c96 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -698,7 +698,7 @@ xrep_agfl(
>  		goto err;
>  
>  	/* Dump any AGFL overflow. */
> -	return xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
> +	error = xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
>  			XFS_AG_RESV_AGFL);
>  err:
>  	xfs_bitmap_destroy(&agfl_extents);
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index b70a88bc975e..3a58788e0bd8 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -613,11 +613,9 @@ xrep_reap_extents(
>  
>  		error = xrep_reap_block(sc, fsbno, oinfo, type);
>  		if (error)
> -			goto out;
> +			break;
>  	}
>  
> -out:
> -	xfs_bitmap_destroy(bitmap);
>  	return error;
>  }
>  
> 
