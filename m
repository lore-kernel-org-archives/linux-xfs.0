Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF995C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 05:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5F4520663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 05:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387811AbgCLFpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 01:45:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51338 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387802AbgCLFpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 01:45:07 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC77C7EAC8F;
        Thu, 12 Mar 2020 16:45:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCGeV-0007Lb-JD; Thu, 12 Mar 2020 16:45:03 +1100
Date:   Thu, 12 Mar 2020 16:45:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bart Brashers <bart.brashers@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mount before xfs_repair hangs
Message-ID: <20200312054503.GJ10776@dread.disaster.area>
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
 <20200308222646.GL10776@dread.disaster.area>
 <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
 <CAHgh4_KpizhD+V59+nV_Tr1W5i4N+yeSKQL9Sq6E5BwyWyr_aA@mail.gmail.com>
 <20200311232510.GG10776@dread.disaster.area>
 <CAHgh4_JXKSRbpC4zQfkfJDj6K9oeyLHb1SaeOfk2AXq0-QkU1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgh4_JXKSRbpC4zQfkfJDj6K9oeyLHb1SaeOfk2AXq0-QkU1Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=EvsSqxEjQh7TKRhUDcwA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 04:27:27PM -0700, Bart Brashers wrote:
> When this happened over the weekend, I left the mount running from
> 10pm till 7am, with no apparent progress.
> 
> That implies the HW raid controller card gets in some sort of hung
> state, doesn't it?

Yes, that seems quite probable from the evidence presented. Can you
query the raid controller when the mount is in this state?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
