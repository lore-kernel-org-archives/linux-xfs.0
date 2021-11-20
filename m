Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9CAC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Nov 2021 22:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhKTWe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Nov 2021 17:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236491AbhKTWe6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Nov 2021 17:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7411060E9C
        for <linux-xfs@vger.kernel.org>; Sat, 20 Nov 2021 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637447514;
        bh=VRj2wmraq0pcA4bowdV4ANBrH9KdFHmJhp2Vjb7HkDM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Fi5hWIetEl5PYJa8C1mFJReA2IMT7lQWe9Zvvzv0tFxe9qKiXf9tkIEj54KnShXn0
         PYMR9TY4F5HKbV+aeZK4swxfbTHyU1r/M3ct7IJRtGvrQoO5/1RD/IMjmKxSw1PRkN
         lcnftDtVhIeN36+ZowmlepHOZ6Sk8bFDbf+TONJlWYBGs2UJ9UoNID/xzVOviMnbcQ
         qeH1i0LM99XmXkQzSx3y5V5hCRj+5RypQ089V+GI2kNOyVwCk8cjJJOm48pyJzi1ZE
         B7hqL53o0/jZg5ZuRGwXRWFg7JqomSFWUALPs+8xiwIbWCpshaLtLZ0IBOj+QQFNdo
         tE8mkWWqhOJYA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 7064961104; Sat, 20 Nov 2021 22:31:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Sat, 20 Nov 2021 22:31:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-75ZeSKlXLU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #17 from Dave Chinner (david@fromorbit.com) ---
On Wed, Nov 10, 2021 at 03:16:35PM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D214767
>=20
> --- Comment #16 from Christian Theune (ct@flyingcircus.io) ---
> I started trying out the fix that Dave and am using it with 5.10.76 (appl=
ied
> clean with a bit of fuzzing).
>=20
> @Dave do you happen do know whether there's a helper that can stress test
> live
> systems in this regard?

fstests has some tests in the "freeze" group that stress
freeze/thaw. And it has lots of other tests in it that will tell you
if there's a regression in your backport, so might be an idea to run
a full "auto" group pass rather than just the freeze group....

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
