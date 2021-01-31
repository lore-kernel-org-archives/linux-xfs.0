Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B606C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jan 2021 06:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD8264E04
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jan 2021 06:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhAaGrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 01:47:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhAaGqE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 01:46:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 26BFF64E29
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jan 2021 06:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612075476;
        bh=5Sc0O8tDQ/00SbaEa04AZu69Jze0n5PS63/qWshlxd0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NZbv9GUWJ9Hb12pnxEAVcCUkyy6rIbdt76/lD6QerTOAK0jjaUinPjmbmDod4pEc4
         ++06TptyoF/5/oIi0TrxbtgBlLEREhWfpCA+60er3dHaibHu/CJx3V3JyXstsxSQt5
         GM3MG/1y038OOygO2yaHgzNX+THdRxgJOKsWz7tZwkYs7VMUDvnhaD656E06bofv+M
         zPYCREk/KVU4WI11MU/Lk5tkf5lIbZ8XqZmYQ2hGAzq75AB5wtAd5BHASkjdNmkCeS
         MPCL8w29HD5Vv/02+niZqHe3Am8wIcZy69wc2BMEliF0uMDYd+j4Qh0LwbqApOYf/C
         MIB9TKRqW2F3A==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211329] blkg_alloc memory leak on ppc64le
Date:   Sun, 31 Jan 2021 06:44:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Block Layer
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kch@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211329-201763-q1Q0GSWUnE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211329-201763@https.bugzilla.kernel.org/>
References: <bug-211329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211329

kch@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kch@kernel.org

--- Comment #7 from kch@kernel.org ---
Is also seems to me that you are using bacache. Did you try to bisect the
problem?

Or did you try to reproduce it on the membacked null_blk with xfs to make s=
ure
it is not the device before coming to the conclusion that xfs is the proble=
m?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
