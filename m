Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7D2C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BFB60F3A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhJLV2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:28:25 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51740 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233387AbhJLV2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 17:28:24 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6BA60861970;
        Wed, 13 Oct 2021 08:26:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maPHw-005Wnr-R2; Wed, 13 Oct 2021 08:26:20 +1100
Date:   Wed, 13 Oct 2021 08:26:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] xfs: fix perag iteration raciness
Message-ID: <20211012212620.GR2361455@dread.disaster.area>
References: <20211012165203.1354826-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012165203.1354826-1-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6165fd7d
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=uyH2IjJe_btxmk8pKucA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:51:59PM -0400, Brian Foster wrote:
> v2:
> - Factoring and patch granularity.
> v1: https://lore.kernel.org/linux-xfs/20211007125053.1096868-1-bfoster@redhat.com/
> 
> Brian Foster (4):
>   xfs: fold perag loop iteration logic into helper function
>   xfs: rename the next_agno perag iteration variable
>   xfs: terminate perag iteration reliably on agcount
>   xfs: fix perag reference leak on iteration race with growfs

Looks good now. For the entire series:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
