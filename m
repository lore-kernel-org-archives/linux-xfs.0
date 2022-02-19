Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8078C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Feb 2022 21:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbiBSVOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Feb 2022 16:14:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243167AbiBSVOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Feb 2022 16:14:42 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 747E83BFA4
        for <linux-xfs@vger.kernel.org>; Sat, 19 Feb 2022 13:14:22 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 246AC52FB38;
        Sun, 20 Feb 2022 08:14:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nLX3b-00E25x-3k; Sun, 20 Feb 2022 08:14:19 +1100
Date:   Sun, 20 Feb 2022 08:14:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Theune <ct@flyingcircus.io>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Help deciding about backported patch (kernel bug 214767,
 19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards)
Message-ID: <20220219211419.GG59715@dread.disaster.area>
References: <C1EC87A2-15B4-45B1-ACE2-F225E9E30DA9@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C1EC87A2-15B4-45B1-ACE2-F225E9E30DA9@flyingcircus.io>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62115dad
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=P2CHeGlxbLGvncAdJl4A:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 17, 2022 at 10:22:49AM +0100, Christian Theune wrote:
> Hi,
> 
> I’ve been debugging an elusive XFS issue that I could not track
> down to any other parameters than it being an xfs internal bug.
> I’ve recorded what I’ve seen so far in
> https://bugzilla.kernel.org/show_bug.cgi?id=214767 and Dave
> recommended that "19f4e7cc8197 xfs: Fix CIL throttle hang when CIL
> space used going backwards” is likely the issue. AFAICT this was
> not backported to the 5.10 branch and we’ve been updating to
> vanilla kernels diligently and still keep seeing this issue.
> Unfortunately within a fleet of around 1k VMs it strikes about
> once every week or so and there’s no way to predict when and
> where.
> 
> So, I took Dave’s pointer and applied the patch to our 5.10 series
> (basd on 5.10.76 at that point) and it applied cleanly. The
> machine boots fine and I ran the XFS test suite. However, I
> haven’t done any tests using the test suite before and I’m getting
> a number of errors where I don’t know how to interpret the
> results. Some of those seem to be due to not having the DEBUG flag
> set in the kernel, others … I’m not sure.

Run the "auto" group tests ('-g auto') only, which will weed out
tests that are broken, likely to fail or crash the machine (i.e.
test-to-failure scenarios). You can ignore "not run" reports - they
aren't failures, just indicative of the kernel not supporting that
functionality (like not being built with DEBUG functionality).

Then run the tests across an unmodified kernel 2-3 times to get a
baseline set of results (should be identical each run), then do the
same thing for the patched kernel.

Now compare baseline vs patched results, looking for things that
failed in the patched kernel that didn't fail in the baseline kernel
- those are the regressions that need more investigation. If there
are no regressions (very likely), you are good to go.

> I’m attaching the test runner output, unfortunately I lost the
> actual outputs as the test ran quite long and the outputs where
> cleaned up by the tempfile watcher faster than I could retrieve
> them. I can run them again, my estimation currently is it takes
> around 3-4 days to complete them, though.

The auto group tests should take ~3-6 hours to run a full cycle
depending on storage config.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
