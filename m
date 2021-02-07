Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAF4C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90A864E31
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBGXT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 18:19:27 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57912 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229570AbhBGXT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Feb 2021 18:19:26 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D41FE1129505;
        Mon,  8 Feb 2021 10:18:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l8tKD-00BiLL-Ac; Mon, 08 Feb 2021 10:18:41 +1100
Date:   Mon, 8 Feb 2021 10:18:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org,
        Pavel Reichl <preichl@redhat.com>
Subject: Re: [Bug 211605] New: Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Message-ID: <20210207231841.GX4662@dread.disaster.area>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
 <20210207221505.GW4662@dread.disaster.area>
 <e83dce44-6120-e688-fec2-b0109cc6f617@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e83dce44-6120-e688-fec2-b0109cc6f617@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=JTgszmPQJKAltIoOXwEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 07, 2021 at 04:53:34PM -0600, Eric Sandeen wrote:
> On 2/7/21 4:15 PM, Dave Chinner wrote:
> > On Sun, Feb 07, 2021 at 05:06:36AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=211605
> >>
> >>             Bug ID: 211605
> >>            Summary: Re-mount XFS causes "noattr2 mount option is
> >>                     deprecated" warning
> >>            Product: File System
> >>            Version: 2.5
> >>     Kernel Version: 5.10.13
> >>           Hardware: All
> >>                 OS: Linux
> >>               Tree: Mainline
> >>             Status: NEW
> >>           Severity: low
> >>           Priority: P1
> >>          Component: XFS
> >>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >>           Reporter: cuihao.leo@gmail.com
> >>         Regression: No
> >>
> ...
> 
> > The kernel is warning about a mount option being specified that
> > isn't even in the set emitted in /proc/mounts. Nor is it on your
> > command line. Yet the kernel is warning about it, and that implies
> > that mount has passed it to the kernel incorrectly.
> 
> I am confused about how "noattr2" showed up.
> 
> But we do still emit "attr2" in /proc/mounts, and a remount will complain
> about /that/, so we do need to stop emitting deprecated options in /proc/mounts.

No, it does not warn on my systems about attr2, either. Like I said,
there are no warnings on remount at all because mount it not passing
the /proc/mounts information back into the kernel:

# strace -emount -v mount -o remount,ro /mnt/scratch
mount("/dev/vdc", "/mnt/scratch", 0x561f3b93c690, MS_RDONLY|MS_REMOUNT, NULL) = 0
#

This really looks like a mount version/distro issue, not a kernel
issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
