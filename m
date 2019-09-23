Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B87C3A5A6
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 13:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4263220882
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 13:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407726AbfIWNYp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 09:24:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407567AbfIWNYp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 09:24:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BFBB8AC6F7;
        Mon, 23 Sep 2019 13:24:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF4B5D9E2;
        Mon, 23 Sep 2019 13:24:44 +0000 (UTC)
Date:   Mon, 23 Sep 2019 09:24:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH] fs:xfs:scrub: Removed unneeded variable.
Message-ID: <20190923132443.GB9071@bfoster>
References: <1568985464-31258-1-git-send-email-aliasgar.surti500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568985464-31258-1-git-send-email-aliasgar.surti500@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 23 Sep 2019 13:24:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 06:47:44PM +0530, Aliasgar Surti wrote:
> From: Aliasgar Surti <aliasgar.surti500@gmail.com>
> 
> Returned value directly instead of using variable as it wasn't updated.
> 
> Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
> ---

I'm not sure we need the funky fs:xfs:scrub prefix thing on the patch
title. I'd just call it something like:

  xfs: remove unused error variable from xchk_allocbt_rec()

Otherwise looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index a43d181..5533e48 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -97,7 +97,6 @@ xchk_allocbt_rec(
>  	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
> -	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->alloc.ar_startblock);
>  	len = be32_to_cpu(rec->alloc.ar_blockcount);
> @@ -109,7 +108,7 @@ xchk_allocbt_rec(
>  
>  	xchk_allocbt_xref(bs->sc, bno, len);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /* Scrub the freespace btrees for some AG. */
> -- 
> 2.7.4
> 
