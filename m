Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B73CC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiF1XWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiF1XWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:22:46 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F41A931232
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:22:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B0EE010E783D;
        Wed, 29 Jun 2022 09:22:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KXb-00CFie-8i; Wed, 29 Jun 2022 09:22:43 +1000
Date:   Wed, 29 Jun 2022 09:22:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_db: identify the minlogsize transaction
 reservation
Message-ID: <20220628232243.GV227878@dread.disaster.area>
References: <165644945449.1091822.7139201675279236986.stgit@magnolia>
 <165644946000.1091822.9533075738203869891.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644946000.1091822.9533075738203869891.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb8d45
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=hHg9lrZoeinHXbFZ8-QA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:51:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Right now, we don't make it easy to spot the transaction reservation
> used to compute the minimum log size in userspace:
> 
> # xfs_db -c logres /dev/sda
> type 0 logres 168184 logcount 5 flags 0x4
> ...
> type 25 logres 760 logcount 0 flags 0x0
> type -1 logres 547200 logcount 8 flags 0x4
> 
> Type "-1" doesn't communicate the purpose at all, it just looks like a
> math error.  Help out the user a bit by printing more information:
> 
> minlogsize logres 547200 logcount 8
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/logformat.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/db/logformat.c b/db/logformat.c
> index 38b0af11..5edaa549 100644
> --- a/db/logformat.c
> +++ b/db/logformat.c
> @@ -160,8 +160,10 @@ logres_f(
>  	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
>  	for (i = 0; res < end_res; i++, res++)
>  		print_logres(i, res);
> +
>  	libxfs_log_get_max_trans_res(mp, &resv);
> -	print_logres(-1, &resv);
> +	dbprintf(_("minlogsize logres %u logcount %d\n"),
> +			resv.tr_logres, resv.tr_logcount);

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
