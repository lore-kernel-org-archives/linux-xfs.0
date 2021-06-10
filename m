Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3D2C48BE0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324B4613F1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFJWEN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:04:13 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44611 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhFJWEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 18:04:12 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id C64A6102D835;
        Fri, 11 Jun 2021 08:01:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lrSkN-00BIbv-6t; Fri, 11 Jun 2021 08:01:55 +1000
Date:   Fri, 11 Jun 2021 08:01:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        noreply@ellerman.id.au
Subject: Re: [PATCH] xfs: Fix 64-bit division on 32-bit in
 xlog_state_switch_iclogs()
Message-ID: <20210610220155.GQ664593@dread.disaster.area>
References: <20210610110001.2805317-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610110001.2805317-1-geert@linux-m68k.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=tBb2bbeoAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=-m77PIS_ppZt2-LBGwIA:9 a=CjuIK1q_8ugA:10
        a=Oj-tNtZlA1e06AYgeCfH:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 10, 2021 at 01:00:01PM +0200, Geert Uytterhoeven wrote:
> On 32-bit (e.g. m68k):
> 
>     ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!
> 
> Fix this by using a uint32_t intermediate, like before.
> 
> Reported-by: noreply@ellerman.id.au
> Fixes: 7660a5b48fbef958 ("xfs: log stripe roundoff is a property of the log")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Compile-tested only.
> ---
>  fs/xfs/xfs_log.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<sigh>

64 bit division on 32 bit platforms is still a problem in this day
and age?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Maybe we should just put "requires 64 bit kernel" on XFS these days...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
