Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9809BC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F42D20828
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfH0F1c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 01:27:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34197 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbfH0F1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 01:27:32 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 23E3943D5FE;
        Tue, 27 Aug 2019 15:27:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2U0s-00035K-2J; Tue, 27 Aug 2019 15:27:26 +1000
Date:   Tue, 27 Aug 2019 15:27:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_scrub: check summary counters
Message-ID: <20190827052726.GZ1119@dread.disaster.area>
References: <156685445746.2839983.1426723444334605572.stgit@magnolia>
 <156685446969.2839983.12626550627146659080.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685446969.2839983.12626550627146659080.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=qCuZFA_DoIHLVE0PdMQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach scrub to ask the kernel to check and repair summary counters
> during phase 7.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/phase4.c |   12 ++++++++++++
>  scrub/phase7.c |   14 ++++++++++++++
>  scrub/repair.c |    3 +++
>  scrub/scrub.c  |   13 +++++++++++++
>  scrub/scrub.h  |    2 ++
>  5 files changed, 44 insertions(+)
> 
> 
> diff --git a/scrub/phase4.c b/scrub/phase4.c
> index 49f00723..c4da4852 100644
> --- a/scrub/phase4.c
> +++ b/scrub/phase4.c
> @@ -107,6 +107,18 @@ bool
>  xfs_repair_fs(
>  	struct scrub_ctx		*ctx)
>  {
> +	bool				moveon;
> +
> +	/*
> +	 * Check the summary counters early.  Normally we do this during phase
> +	 * seven, but some of the cross-referencing requires fairly-accurate
> +	 * counters, so counter repairs have to be put on the list now so that
> +	 * they get fixed before we stop retrying unfixed metadata repairs.
> +	 */
> +	moveon = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
> +	if (!moveon)
> +		return false;

"moveon" doesn't really make sense to me here. i.e. I can't tell if
"moveon = true" meant it failed or not, so I hav eno idea what the
intent of the code here is, and the comment doesn't explain it at
all, either.

> +
>  	return xfs_process_action_items(ctx);
>  }
>  
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 1c459dfc..b3156fdf 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -7,12 +7,15 @@
>  #include <stdint.h>
>  #include <stdlib.h>
>  #include <sys/statvfs.h>
> +#include "list.h"
>  #include "path.h"
>  #include "ptvar.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
> +#include "scrub.h"
>  #include "fscounters.h"
>  #include "spacemap.h"
> +#include "repair.h"
>  
>  /* Phase 7: Check summary counters. */
>  
> @@ -91,6 +94,7 @@ xfs_scan_summary(
>  	struct scrub_ctx	*ctx)
>  {
>  	struct summary_counts	totalcount = {0};
> +	struct xfs_action_list	alist;
>  	struct ptvar		*ptvar;
>  	unsigned long long	used_data;
>  	unsigned long long	used_rt;
> @@ -110,6 +114,16 @@ xfs_scan_summary(
>  	int			ip;
>  	int			error;
>  
> +	/* Check and fix the fs summary counters. */
> +	xfs_action_list_init(&alist);
> +	moveon = xfs_scrub_fs_summary(ctx, &alist);
> +	if (!moveon)
> +		return false;
> +	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
> +			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
> +	if (!moveon)
> +		return moveon;

same here - "moveon" doesn't tell me if we're returning because the
scrub failed or passed....

> +
>  	/* Flush everything out to disk before we start counting. */
>  	error = syncfs(ctx->mnt.fd);
>  	if (error) {
> diff --git a/scrub/repair.c b/scrub/repair.c
> index 45450d8c..54639752 100644
> --- a/scrub/repair.c
> +++ b/scrub/repair.c
> @@ -84,6 +84,9 @@ xfs_action_item_priority(
>  	case XFS_SCRUB_TYPE_GQUOTA:
>  	case XFS_SCRUB_TYPE_PQUOTA:
>  		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
> +	case XFS_SCRUB_TYPE_FSCOUNTERS:
> +		/* This should always go after AG headers no matter what. */
> +		return PRIO(aitem, INT_MAX);
>  	}
>  	abort();
>  }
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index 136ed529..a428b524 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -28,6 +28,7 @@ enum scrub_type {
>  	ST_PERAG,	/* per-AG metadata */
>  	ST_FS,		/* per-FS metadata */
>  	ST_INODE,	/* per-inode metadata */
> +	ST_SUMMARY,	/* summary counters (phase 7) */
>  };

Hmmm - the previous patch used ST_FS for the summary counters.

Oh, wait, io/scrub.c has a duplicate scrub_type enum defined, and
the table looks largely the same, too. Except now the summary type
is different.

/me looks a bit closer...

Oh, the enum scrub_type definitions shadow the kernel enum
xchk_type, but have different values for the same names. I'm
just confused now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
