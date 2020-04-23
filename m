Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A53DC2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D335206B9
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgDWEKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 00:10:44 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49674 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgDWEKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:10:43 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 488623A2A10;
        Thu, 23 Apr 2020 14:10:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTCB-0000Av-Pq; Thu, 23 Apr 2020 14:10:39 +1000
Date:   Thu, 23 Apr 2020 14:10:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 02/13] xfs: factor out buffer I/O failure simulation
 code
Message-ID: <20200423041039.GG27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-3-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=XwABNfG7V3PN-dvlK5AA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:18PM -0400, Brian Foster wrote:
> We use the same buffer I/O failure simulation code in a few
> different places. It's not much code, but it's not necessarily
> self-explanatory. Factor it into a helper and document it in one
> place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
