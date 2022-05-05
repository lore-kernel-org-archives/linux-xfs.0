Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9CFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 08:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbiEEIyr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 04:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiEEIyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 04:54:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26BD02899B
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 01:51:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 64CB310E6268;
        Thu,  5 May 2022 18:51:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmXCS-008FmJ-Tb; Thu, 05 May 2022 18:51:04 +1000
Date:   Thu, 5 May 2022 18:51:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215927] kernel deadlock when mounting the image
Message-ID: <20220505085104.GH1098723@dread.disaster.area>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
 <bug-215927-201763-qVJPAGrN3y@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-215927-201763-qVJPAGrN3y@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62738ffa
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7YfXLusrAAAA:8
        a=7-415B0cAAAA:8 a=sIvyb8evvIpBUfk83LEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=SLz71HocmBbuEhFRYD3r:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 05:46:45AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215927
> 
> --- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
> XFS maintainers? This looks like a serious issue.

A fix has already been written and pushed into the upstream tree.

It's not a real world problem - exposing this issue requires
significant malicious tampering with multiple filesystem structures.
We can't (and have never tried to) defend against such a threat
model - our verification mechanisms are intended to defend against
known storage corruption vectors and software bugs, not malicious
actors.

If anyone wants credit for discovering fuzzer induced bugs like
this, then they need to be responsible in how they report them and
perform some initial triage work to determine the scope of the issue
they have discovered before they report it.  Making potentially
malicious reproducer scripts public without any warning does not win
any friends or gain influence.

We're tired of having to immediately jump to investigate issues
found by format verification attack tools that have been dumped in
public with zero analysis, zero warning and, apparently, no clue
of how serious the problem discovered might be.

The right process for reporting issues found by format verification
attacks is called "responsible disclosure". This is the process that
reporting any issue that has potential system security impacts
should use.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
