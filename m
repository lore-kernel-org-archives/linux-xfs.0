Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1A4C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E236864DE8
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBGWPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:15:52 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59353 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhBGWPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Feb 2021 17:15:51 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E2C1F827F36;
        Mon,  8 Feb 2021 09:15:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l8sKf-00BeBj-Af; Mon, 08 Feb 2021 09:15:05 +1100
Date:   Mon, 8 Feb 2021 09:15:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 211605] New: Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Message-ID: <20210207221505.GW4662@dread.disaster.area>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=IaQNggFhbr6_QPJ8trUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 07, 2021 at 05:06:36AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=211605
> 
>             Bug ID: 211605
>            Summary: Re-mount XFS causes "noattr2 mount option is
>                     deprecated" warning
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.10.13
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: cuihao.leo@gmail.com
>         Regression: No
> 
> Created attachment 295103
>   --> https://bugzilla.kernel.org/attachment.cgi?id=295103&action=edit
> proposed fix
> 
> After recent kernel update, I notice "XFS: noattr2 mount option is deprecated."
> kernel message every time I shutdown the system. It turns out that remounting a
> XFS causes the warning.
> 
> Steps to Reproduce:
> 1) Mount a XFS and remount it with different options:
> > $ mount some_xfs.img /mnt/test
> > $ mount -o remount,ro /mnt/test
> 2) Check kernel message. Remounting causes a line of warning:
> > XFS: noattr2 mount option is deprecated.

That sounds like a mount(1) bug, not a kernel bug. Something is
adding the "noattr2" option to the remount line. Running you test
on my system doesn't show that warning. I'm running a 5.11-rc5 kernel
and:

$ mount -V
mount from util-linux 2.36 (libmount 2.36.0: selinux, smack, btrfs, namespaces, assert, debug)
$

And there is no such "noattr2 is deprecated" output. What version of
mount are you running?

What we really need from your system is debug that tells us exactly
what the mount option string that the mount command is handing the
mount syscall.

> I had checked my fstab and kernel params and didn't found any use of "attr2"
> option. It doesn't break things, but is a little confusing.

"attr2" != "noattr2"

The kernel is warning about a mount option being specified that
isn't even in the set emitted in /proc/mounts. Nor is it on your
command line. Yet the kernel is warning about it, and that implies
that mount has passed it to the kernel incorrectly.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
