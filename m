Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6DEC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Nov 2021 22:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhKTWez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Nov 2021 17:34:55 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53598 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236491AbhKTWez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Nov 2021 17:34:55 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 19B6B8A1144;
        Sun, 21 Nov 2021 09:31:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1moYth-00BFyW-H5; Sun, 21 Nov 2021 09:31:49 +1100
Date:   Sun, 21 Nov 2021 09:31:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 214767] xfs seems to hang due to race condition? maybe
 related to (gratuitous) thaw.
Message-ID: <20211120223149.GD449541@dread.disaster.area>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
 <bug-214767-201763-cXpP1tlDle@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-214767-201763-cXpP1tlDle@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61997756
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=Y7pbzP1Hdpi20SMr:21 a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=jlcF1eKb1ws7MjrhuLEA:9 a=CjuIK1q_8ugA:10
        a=W4iUb41TIiNtaFHdFdN3:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 10, 2021 at 03:16:35PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=214767
> 
> --- Comment #16 from Christian Theune (ct@flyingcircus.io) ---
> I started trying out the fix that Dave and am using it with 5.10.76 (applied
> clean with a bit of fuzzing).
> 
> @Dave do you happen do know whether there's a helper that can stress test live
> systems in this regard?

fstests has some tests in the "freeze" group that stress
freeze/thaw. And it has lots of other tests in it that will tell you
if there's a regression in your backport, so might be an idea to run
a full "auto" group pass rather than just the freeze group....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
