Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788F9C35280
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 17:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A951215EA
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 17:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfI3REK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 13:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfI3REJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 13:04:09 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5019302C066;
        Mon, 30 Sep 2019 17:04:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E3760A35;
        Mon, 30 Sep 2019 17:04:09 +0000 (UTC)
Date:   Mon, 30 Sep 2019 13:04:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: removed unused error variable from
 xchk_refcountbt_rec
Message-ID: <20190930170407.GE57295@bfoster>
References: <1569851934-10718-1-git-send-email-aliasgar.surti500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569851934-10718-1-git-send-email-aliasgar.surti500@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 30 Sep 2019 17:04:09 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 07:28:54PM +0530, Aliasgar Surti wrote:
> From: Aliasgar Surti <aliasgar.surti500@gmail.com>
> 
> Removed unused error variable. Instead of using error variable,
> returned the value directly as it wasn't updated.
> 
> Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/refcount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 93b3793b..0cab11a 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -341,7 +341,6 @@ xchk_refcountbt_rec(
>  	xfs_extlen_t		len;
>  	xfs_nlink_t		refcount;
>  	bool			has_cowflag;
> -	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->refc.rc_startblock);
>  	len = be32_to_cpu(rec->refc.rc_blockcount);
> @@ -366,7 +365,7 @@ xchk_refcountbt_rec(
>  
>  	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /* Make sure we have as many refc blocks as the rmap says. */
> -- 
> 2.7.4
> 
