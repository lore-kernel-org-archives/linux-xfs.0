Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D4BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 23:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiCGXc3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiCGXc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 18:32:29 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 255F212A9F
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 15:31:34 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E19CE10E1DF0;
        Tue,  8 Mar 2022 10:31:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRMpA-002mW5-7P; Tue, 08 Mar 2022 10:31:32 +1100
Date:   Tue, 8 Mar 2022 10:31:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     David Dal Ben <dalben@gmail.com>
Cc:     Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Message-ID: <20220307233132.GA661808@dread.disaster.area>
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=622695d5
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=q2rpgJM3of3wzYv4:21 a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=osnUa62Un3eFc04iFN4A:9 a=CjuIK1q_8ugA:10 a=aujFQpqGlDxcc9pqpD-7:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 08, 2022 at 06:46:58AM +0800, David Dal Ben wrote:
> This is where I get out of my depth. I added the drives to unraid, it
> asked if I wanted to format them, I said yes, when that was completed
> I started migrating data.
> 
> I didn't enter any XFS or disk commands from the CLI.

Is there any sort of verbose logging you can turn on from the
applicance web interface?

> 
> What I can tell you is that there are a couple of others who have
> reported this alert on the Unraid forums, all seem to have larger
> disks, over 14tb.

I'd suggest that you ask Unraid to turn off XFS shrinking support in
the 6.10 release. It's not ready for production release, and
enabling it is just going to lead to user problems like this.

Indeed, this somewhat implies that Unraid haven't actually tested
shrink functionality at all, because otherwise the would have
noticed just how limited the current XFS shrink support is and
understood that it simply cannot be used in a production environment
yet.

IOWs, if Unraid want to support shrink in their commercial products
right now, their support engineers need to be testing, triaging and
reporting shrink problems to upstream and telling us exactly what is
triggering those issues. Whilst the operations and commands they are
issuing remains hidden from Unraid users, there's not a huge amount
we can do upstream to triage the issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
