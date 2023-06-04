Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9BFC7EE29
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 18:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjFDScC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbjFDScB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 14:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C2CD
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 11:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8858460A72
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 18:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C84C433D2;
        Sun,  4 Jun 2023 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685903518;
        bh=3YkKeT4ylbUhLUS4Tb289F16aFWZygedXBHD926GAWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHQKAnyVdL27klcspeULUeXaKDW6KQhwtSwhkzSlwWPQpBbcyjMFg90k3GvZy0W/r
         GH/7NmbHGvzmZKnYXwKmxUjMSBayXrzjUTnR2vjtinafnhDC3/8MKABOPdHhh2N8Rg
         +JzmfuSo0jH3KoTisvj2RfnfVToKTReqJ9kpo8ydRvOgcu8bmxe6w5N6EjyTcx9YmX
         x6zDUeLFUIObWgeHaNW0T1Jgl8uSGzQr1moVkD+lhVAjxBw0OTQGbFehemgSxImHM5
         W98O8HWWqVkiC+F61Mlxs3HABoHjzfbpaopIdbK+cWepOD6Xiz0PXWSmFHDGE6tLm0
         E0OpNqyYUfc1A==
Date:   Sun, 4 Jun 2023 11:31:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217522] xfs_attr3_leaf_add_work produces a warning
Message-ID: <20230604183158.GI72241@frogsfrogsfrogs>
References: <bug-217522-201763@https.bugzilla.kernel.org/>
 <bug-217522-201763-NVge3HI5rt@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217522-201763-NVge3HI5rt@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 04, 2023 at 03:31:20AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217522
> 
> --- Comment #2 from Vladimir Lomov (lomov.vl@bkoty.ru) ---
> Hello
> ** bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org> [2023-06-03 14:50:24
> +0000]:
> 
> >https://bugzilla.kernel.org/show_bug.cgi?id=217522
> >
> >--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
> >On Sat, Jun 03, 2023 at 03:58:25AM +0000, bugzilla-daemon@kernel.org wrote:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=217522
> >>
> >>             Bug ID: 217522
> >>            Summary: xfs_attr3_leaf_add_work produces a warning
> >>            Product: File System
> >>            Version: 2.5
> >>           Hardware: All
> >>                 OS: Linux
> >>             Status: NEW
> >>           Severity: normal
> >>           Priority: P3
> >>          Component: XFS
> >>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >>           Reporter: lomov.vl@bkoty.ru
> >>         Regression: No
> >>
> >> Hi.
> >>
> >> While running linux-next
> >> (6.4.0-rc4-next-20230602-1-next-git-06849-gbc708bbd8260) on one of my hosts,
> >> I
> >> see the following message in the kernel log (`dmesg`):
> >> ```
> >> Jun 02 20:01:19 smoon.bkoty.ru kernel: ------------[ cut here ]------------
> >> Jun 02 20:01:19 smoon.bkoty.ru kernel: memcpy: detected field-spanning write
> >> (size 12) of single field "(char *)name_loc->nameval" at
> >
> > Yes, this bug is a collision between the bad old ways of doing flex
> > arrays:
> >
> > typedef struct xfs_attr_leaf_name_local {
> >         __be16  valuelen;               /* number of bytes in value */
> >         __u8    namelen;                /* length of name bytes */
> >         __u8    nameval[1];             /* name/value bytes */
> > } xfs_attr_leaf_name_local_t;
> 
> > And the static checking that gcc/llvm purport to be able to do properly.
> 
> Something similar has caused problems with kernel compilation before:
> https://lkml.org/lkml/2023/5/24/576 (I'm not 100% sure if the origin is the
> same though).

Yup.

> > This is encoded into the ondisk structures, which means that someone
> > needs to do perform a deep audit to change each array[1] into an
> > array[] and then ensure that every sizeof() performed on those structure
> > definitions has been adjusted.  Then they would need to run the full QA
> > test suite to ensure that no regressions have been introduced.  Then
> > someone will need to track down any code using
> > /usr/include/xfs/xfs_da_format.h to let them know about the silent
> > compiler bomb heading their way.
> 
> > I prefer we leave it as-is since this code has been running for years
> > with no problems.
> 
> Should I assume that this problem is not significant and won't have any effect
> to the FS and won't cause the FS to misbehave or become corrupted? If so, why
> does the problem only show up on one host but not on the other? Or is this a
> runtime check, and it somehow happens on the first system (even rebooted
> twice), but not on the second one.

AFAICT, there's no real memory corruption problem here; it's just that
the compiler treats array[1] as a single-element array instead of
turning on whatever magic enables it to handle flexarrays (aka array[]
or array[0]).  I don't know why you'd ever want a real single-element
array, but legacy C is fun like that. :/

--D

> [...]
> 
> ---
> Vladimir Lomov
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
