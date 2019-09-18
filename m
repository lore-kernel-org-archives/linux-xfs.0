Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96B2C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 12:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B09207FC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 12:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfIRM3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 08:29:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfIRM3F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 08:29:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B927810DCC8C;
        Wed, 18 Sep 2019 12:29:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A2D9A222;
        Wed, 18 Sep 2019 12:29:01 +0000 (UTC)
Date:   Wed, 18 Sep 2019 08:28:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190918122859.GB29377@bfoster>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918082453.25266-3-cmaiolino@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 18 Sep 2019 12:29:04 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> The original allocation request may have a total value way beyond
> possible limits.
> 
> Trim it down to the maximum possible if needed
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Confused.. what was wrong with the original bma.total patch that it
needs to be replaced? I was assuming we'd replace the allocation retry
patch with the minlen alignment fixups and combine those with the
bma.total patch to fix the problem. Hm?

>  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 07aad70f3931..3aa0bf5cc7e3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
>  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
>  		else
>  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> +
> +		/* We can never have total larger than blen, so trim it now */
> +		if (args.total > blen)
> +			args.total = blen;
> +

I don't think this is safe. The reason the original patch only updated
certain callers is because those callers only used it for extra blocks
that are already incorported into bma.minleft by the bmap layer itself.
There are still other callers for which bma.total is specifically
intended to be larger than the map size.

(I think the whole total thing is still kind of a confusing mess in this
regard, but fixing that is a separate problem.)

Brian

>  		if (error)
>  			return error;
>  	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> -- 
> 2.20.1
> 
