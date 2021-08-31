Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F8FC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 23:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E04360F9E
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 23:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhHaXa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 19:30:27 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41217 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234343AbhHaXa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 19:30:27 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 93DFA11454D8;
        Wed,  1 Sep 2021 09:29:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLDC3-007FUM-ES; Wed, 01 Sep 2021 09:29:27 +1000
Date:   Wed, 1 Sep 2021 09:29:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: warn about V4 deprecation when creating new V4
 filesystems
Message-ID: <20210831232927.GV3657114@dread.disaster.area>
References: <20210831224438.GB9942@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831224438.GB9942@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Y3J0asmunZix-N3lV-UA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 03:44:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> September 2025 it will be turned off by default in the kernel and five
> years after that, support will be removed entirely.  Warn people
> formatting new filesystems with the old format, particularly since V4 is
> not the default.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 53904677..b8c11ce9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
>  		}
>  
>  	} else {	/* !crcs_enabled */
> +		/*
> +		 * The V4 filesystem format is deprecated in the upstream Linux
> +		 * kernel.  In September 2025 it will be turned off by default
> +		 * in the kernel and in September 2030 support will be removed
> +		 * entirely.
> +		 */
> +		fprintf(stdout,
> +_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
> +
>  		/*
>  		 * The kernel doesn't support crc=0,finobt=1 filesystems.
>  		 * If crcs are not enabled and the user has not explicitly
> 

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Do we need to update the mkfs filter in fstests now?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
