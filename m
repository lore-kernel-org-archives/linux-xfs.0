Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741ECC4332B
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2005564DF6
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBGXhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 18:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBGXhB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 18:37:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 036B964E3A
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612740981;
        bh=nIflwO8ys5MPPDrXbHc9kra0fO9lE5cfAg9LOKPqFLM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ik2gham6EWYyhm0PrV3eSVluaMq7ZsTw3o1R0Z0lf+MatbFaKn0J8NAV+p3SdtJ3t
         R4aiE5Rrfk5N32MLCbPfIaOHLvG7+Ws457DgvJdVPr2qReWSrik8IpfdRADfjUv8+N
         9f1wBT+odWupQGI2VB0LItt998zhju5oClNuXsk8ubGAcWuB7vG2ytsii3p8+e5J+B
         jXIpWzEW+xesciELlqcKdYy6fBCsIa6MhoIdV5U5AJ0eFD954SZ5zlAhc8QxOeJFQ7
         U+901Oo6vK05AOwwjM3Hm/0w6W8ilgOqoUiOELc/L6y2pkGhKH1ZJt78ieiGpHk0C2
         Wjf8tUD0izSwg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Sun, 07 Feb 2021 23:36:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-xkwFOStpFO@https.bugzilla.kernel.org/>
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

--- Comment #7 from Eric Sandeen (sandeen@sandeen.net) ---
On 2/7/21 4:53 PM, Eric Sandeen wrote:
>=20
> Pavel, can you fix this up, since your patch did the deprecations? I gues=
s we
> missed this on review.

Scratch that, Dave points out that they need to stay until they are removed.

> Ideally the xfs(5) man page in xfsprogs should be updated as well to refl=
ect
> the
> deprecated items.

man page probably should still be updated tho (unless I missed a patch...)

-Eric

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
