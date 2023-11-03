Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4E1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Nov 2023 12:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjKCMwj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjKCMwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 08:52:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C60FB
        for <linux-xfs@vger.kernel.org>; Fri,  3 Nov 2023 05:52:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6189C433C8
        for <linux-xfs@vger.kernel.org>; Fri,  3 Nov 2023 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699015955;
        bh=/sOO+DN6SCQOGwxFSNpw/wPDf0+m9CO2WuCIcoHnhwM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jkGJG8VR4I9HNR6V7IaeuNuXNqI6x4Xybiz+f3947oXO7U9yyOHQpLJjeccFh3hjU
         83fj0LTgz8sDb8v2IKeh7ZhTbkZ5KwjwI+mYFmQbXYXjh/adfDsmKjtbG/QU5jSyBV
         qoEZU9p9kf1IP2tALjSNVnQY+V6Q0vByOYeui6IyG79Vp3xCJVHcT6Y6vuSGK//e26
         LTUfaEXCiv/f5Yygby4ZhJIVOoOwOgrOoO8srJoLNQcxnuNC5SM7SCOJICG+bX+yrd
         LuQpC7kf0QYXUEFxs9ljezbZiST+0+wPjy3iwOSaO+zB4kdfQXNcAIVM7IXHu68Pxb
         Km16VvQQhxPPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 96515C4332E; Fri,  3 Nov 2023 12:52:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Fri, 03 Nov 2023 12:52:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-daAbZgHO91@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #22 from Christian Theune (ct@flyingcircus.io) ---
(In reply to Dave Chinner from comment #21)
>=20
> This is still an unreproducable, unfixed bug in upstream kernels.
> There is no known reproducer, so actually triggering it and hence
> performing RCA is extremely difficult at this point in time. We don't
> really even know what workload triggers it.

It seems IO-pressure related and we've seen it multiple times with various
PostgreSQL activities.

I've planned time for next week to analyze this further and trying to help
establishing a reproducer.

> > We've had a multitude of crashes in the last weeks with the following
> > statistics:
> >=20
> > 6.1.31 - 2 affected machines
> > 6.1.35 - 1 affected machine
> > 6.1.37 - 1 affected machine
> > 6.1.51 - 5 affected machines
> > 6.1.55 - 2 affected machines
> > 6.1.57 - 2 affected machines
>=20
> Do these machines have ECC memory?

The physical hosts do. The affected systems are all Qemu/KVM virtual machin=
es,
though.

> > Here's the more detailed behaviour of one of the machines with 6.1.57.
> >=20
> > $ uptime
> >  16:10:23  up 13 days 19:00,  1 user,  load average: 3.21, 1.24, 0.57
>=20
> Yeah, that's the problem - such a rare, one off issue that we don't
> really even know where to begin looking. :(
>=20
> Given you seem to have a workload that occasionally triggers it,
> could you try to craft a reproducer workload that does stuff similar
> to your production workload and see if you can find out something
> that makes this easier to trigger?

Yup. I'm prioritizing this for the next weeks.


> This implies you are using memcg to constrain memory footprint of
> the applications? Are these workloads running in memcgs that
> experience random memcg OOM conditions? Or maybe the failure
> correlates with global OOM conditions triggering memcg reclaim?

I'll have to read up on what memcg is and whether we're doing anything with=
 it
on purpose. At the moment I think this is just whatever we're getting from =
our
baseline environment with kernel or distro defaults.=20

How do I notice a memcg OOM? I've always tried to correlate all kernel log
messages and haven't seen any other tracebacks than the ones I posted.

Global (so I guess a "regular") OOM wasn't involved in any case so far.

I can try digging deeper into system VM statistics. We're running
telegraf/prometheus and have a relatively exhaustive number of system varia=
bles
we're monitoring on all systems. Anything specific I could look for?

>=20
> Cheers,
>=20
> Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
