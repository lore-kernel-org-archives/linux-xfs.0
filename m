Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CF2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B940B64DE8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhA1V1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:27:20 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:35319 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhA1V1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:27:19 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9A4BE1109A28
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jan 2021 08:26:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5EoB-003VoH-Ib
        for linux-xfs@vger.kernel.org; Fri, 29 Jan 2021 08:26:31 +1100
Date:   Fri, 29 Jan 2021 08:26:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: journal IO cache flush reductions
Message-ID: <20210128212631.GP4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-4-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=eJfxgxciAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=MuI-Bhq-SdOx07c8TSUA:9 a=CjuIK1q_8ugA:10
        a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:52PM +1100, Dave Chinner wrote:
> From: Steve Lord <lord@sgi.com>
> 

Oh, I just noticed that git mangled this commit message because I
quoted another commit in the commit message. i.e. it turned this:

> commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> Author: Steve Lord <lord@sgi.com>
> Date:   Fri May 24 14:30:21 2002 +0000

into a "from" directive to say this is who authored the patch.

Ok, my guilt header has "from dchinner@redhat.com" in it because my
local repos are owned by "david@fromorbit.com", so something in the
toolchain has mangled this. It'll need a resend...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
