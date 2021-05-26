Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF8FC47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 21:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B712613F0
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhEZVms (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 17:42:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49660 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233790AbhEZVmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 17:42:47 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C274510435AB;
        Thu, 27 May 2021 07:41:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm1H6-005a5m-Ia; Thu, 27 May 2021 07:41:12 +1000
Date:   Thu, 27 May 2021 07:41:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: add new IRC channel to MAINTAINERS
Message-ID: <20210526214112.GO664593@dread.disaster.area>
References: <20210526052038.GX202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526052038.GX202121@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=VwQbUJbxAAAA:8 a=YL6Xjd1eAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=TcckgDlWgJlwjqxtkKgA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=yLS1KB8ZbIgHeRWbGdJx:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 10:20:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add our new OFTC channel to the MAINTAINERS list so everyone will know
> where to go.  Ignore the XFS wikis, we have no access to them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 008fcad7ac00..ceb146e9b506 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19998,6 +19998,7 @@ F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
> +C:	irc://irc.oftc.net/xfs
>  M:	Darrick J. Wong <djwong@kernel.org>
>  M:	linux-xfs@vger.kernel.org
>  L:	linux-xfs@vger.kernel.org

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
