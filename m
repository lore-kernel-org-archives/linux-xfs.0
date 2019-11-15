Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F07CC432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 00:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03696206D9
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 00:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKOAVv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 19:21:51 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50283 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbfKOAVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 19:21:51 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 744207EA0EC;
        Fri, 15 Nov 2019 11:21:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iVPMu-0004p1-Kn; Fri, 15 Nov 2019 11:21:44 +1100
Date:   Fri, 15 Nov 2019 11:21:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 0/5] xfs: remove several typedefs in quota code
Message-ID: <20191115002144.GM4614@dread.disaster.area>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191114012811.GW4614@dread.disaster.area>
 <CAJc7PzXuXkA33FuBSoMBxOV9k0jWVKP9LtNC+oFYwp8SvZxm8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzXuXkA33FuBSoMBxOV9k0jWVKP9LtNC+oFYwp8SvZxm8g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=psAvrT4Wh6loqHFR7XQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 06:25:57AM +0100, Pavel Reichl wrote:
> Hi Dave,
> 
> sure, I'll do whatever you guys suggests me to do.
> 
> I believe that by change log you mean just a textual description of
> code changes which should be part of the cover letter, right?

Yeah, the patch 0/X of the series you post.

> I didn't do change log so far because I was just following the points
> you gave me during the review process, but I understand that since
> there were 2 reviewers I probably should have done some change
> summary.

FWIW, even if there is only one reviewer, they might be looking at
lots of different code and it may be a couple of days between them
looking at it. So the changelog still helps a single reviewer focus
on what they need to really look closely at this time around.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
