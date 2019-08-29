Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B480C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 22:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FC922CEA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 22:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH2WAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:00:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60534 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727969AbfH2WAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 18:00:49 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 85CDA361399;
        Fri, 30 Aug 2019 08:00:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3STF-00014l-Lm; Fri, 30 Aug 2019 08:00:45 +1000
Date:   Fri, 30 Aug 2019 08:00:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: remove all *_ITER_ABORT values
Message-ID: <20190829220045.GV1119@dread.disaster.area>
References: <20190829162122.GH5354@magnolia>
 <20190829162229.GB5360@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829162229.GB5360@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=gkw7ESRJ6vXp_dHBzmIA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:22:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use -ECANCELED to signal "stop iterating" instead of these magical
> *_ITER_ABORT values, since it's duplicative.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine to me. One nit:

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index fa3cd8ab9aba..0099053d2a18 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -466,7 +466,6 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
>  
>  /* return codes */
>  #define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
> -#define XFS_BTREE_QUERY_RANGE_ABORT	(XFS_ITER_ABORT)    /* stop iterating */
>  typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
>  		union xfs_btree_rec *rec, void *priv);

Can you add an explicit comment to describe the iteration return
values here so that a reader will know what behaviour to expect
from the query range functions...

I'd suggest the same thing for each of the iteration functions
that we're removing the special defines from if they don't already
have them.

Same for the next patch, which also looks fine apart from
describing the "return 0 means continue" comments.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
