Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972B2C0044D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 22:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 903F1206E7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 22:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgCKWJV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 18:09:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49095 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729513AbgCKWJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 18:09:20 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8020A7E9690;
        Thu, 12 Mar 2020 09:09:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jC9XO-0004h9-Gh; Thu, 12 Mar 2020 09:09:14 +1100
Date:   Thu, 12 Mar 2020 09:09:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200311220914.GF10776@dread.disaster.area>
References: <20200311093552.25354-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311093552.25354-1-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=sWHsXWf-S5lEzRmjrkUA:9 a=u5Ln46p_Nl4ZK3xF:21
        a=7wEdtmMinWqdUzu7:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 10:35:52AM +0100, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  fs/xfs/xfs_stats.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

what about all the other calls to snprintf() in fs/xfs/xfs_sysfs.c
and fs/xfs/xfs_error.c that return the "would be written" length to
their callers? i.e. we can return a length longer than the buffer
provided to the callers...

Aren't they all broken, too?

A quick survey of random snprintf() calls shows there's an abundance
of callers that do not check the return value of snprintf for
overflow when outputting stuff to proc/sysfs files. This seems like
a case of "snprintf() considered harmful, s/snprintf/scnprintf/
kernel wide, remove snprintf()"...

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
