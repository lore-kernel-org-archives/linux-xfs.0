Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF898C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B94764E32
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBGXT3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 18:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhBGXT2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 18:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C2C8864E3B
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 23:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612739927;
        bh=lnpHxMyLKEPqIPSMFUTTbzqcjC1dWBDz3dtFjLtWb3M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZgwwrQ1wt7ABDBJ00gbQ6/vTFFbXUHADOKiobTojejI2YeGj/heUc7jjxrMnpCtRc
         iqB/aVCRN+8C0penpVWr7h/KNEURqcoV2gts2rcKYMtF+VLnk4aHNM1/ytSIXNHp3C
         zrUgTeTz459PW0xslf2vPvVVbG9ziXD1PaHfJpN4csEZx6wipezgz1dEOo+/kl/mTz
         nx0Lo8kxDpDyw3D8wpZle9yyun5sTn4xKwk0B0v0bGSaGQ8n1ThAdIxOh45lE40dja
         QP8QySAcyz0U0aWKcFikfo/YFhkjTPjxNHpKx4uwSgi/MwnCJO0LoQ1GZ4i8hoKtqy
         sueissKFzuntw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Sun, 07 Feb 2021 23:18:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-FTOGE6uyZL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

--- Comment #6 from Dave Chinner (david@fromorbit.com) ---
On Sun, Feb 07, 2021 at 04:53:34PM -0600, Eric Sandeen wrote:
> On 2/7/21 4:15 PM, Dave Chinner wrote:
> > On Sun, Feb 07, 2021 at 05:06:36AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=3D211605
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
>=20
> > The kernel is warning about a mount option being specified that
> > isn't even in the set emitted in /proc/mounts. Nor is it on your
> > command line. Yet the kernel is warning about it, and that implies
> > that mount has passed it to the kernel incorrectly.
>=20
> I am confused about how "noattr2" showed up.
>=20
> But we do still emit "attr2" in /proc/mounts, and a remount will complain
> about /that/, so we do need to stop emitting deprecated options in
> /proc/mounts.

No, it does not warn on my systems about attr2, either. Like I said,
there are no warnings on remount at all because mount it not passing
the /proc/mounts information back into the kernel:

# strace -emount -v mount -o remount,ro /mnt/scratch
mount("/dev/vdc", "/mnt/scratch", 0x561f3b93c690, MS_RDONLY|MS_REMOUNT, NUL=
L) =3D
0
#

This really looks like a mount version/distro issue, not a kernel
issue...

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
