Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A4CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 11:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiDLL5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 07:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiDLL47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 07:56:59 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 919E960CFF
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 03:42:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 869D910C76AC;
        Tue, 12 Apr 2022 20:42:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neDyM-00GnPu-Q0; Tue, 12 Apr 2022 20:42:10 +1000
Date:   Tue, 12 Apr 2022 20:42:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: Re: [PATCH 00/10] xfs: LARP - clean up xfs_attr_set_iter state
 machine
Message-ID: <20220412104210.GJ1544202@dread.disaster.area>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62555783
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=qiK4W3WCQAx_Ls6xAb0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 02:25:33PM +1000, Dave Chinner wrote:
> Hi Allison,
> 
> This is first patchset for fixing up stuff in the LARP code. I've
....

> The patchset passes fstests '-g attr' running in a loop when larp=0,
> but I haven't tested it with larp=1 yet - I've done zero larp=1
> testing so far so I don't even know whether it works in the base
> 5.19 compose yet. I'll look at that when I finish the state machine
> updates....

With patch 11, larp=1 passes all but generic/642 - I screwed up a
state change that affects the larp=1 mode, so there's small changes to
patch 7 and rebasing for 8-10 as a result. Overall the code
structure doesn't change, just the transition to REPLACE/REMOVE_OLD
states.

I'm testing the updated series now - it seems like it is working in
both larp=0 and larp=1 mode. I'll let it run overnight and go from
them.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
