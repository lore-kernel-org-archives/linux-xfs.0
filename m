Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2635C433DB
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F02D64E05
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBGWmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGWmV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 17:42:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 54FAD64E05
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 22:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612737701;
        bh=qna1EVles42Bj1Vd7/nCXP6sdbp/oYbh9EbA4+fAd2w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EjCtxO74pTWOHVSIliyInMQnNm2jb/Jp11sGHUJMd3upSC/ZCBGz3vBaHAYIMRRxT
         riW05SmMEMH1Y0QYEFKeP3lnsMYV8NQ0H+f5WkS7RnEJT/6AB6C4JHiBdfc/caaS32
         BT4NG2vqX/UQDF2qoL0eXeJ6HgrH4yJ8Kur+zzQ22RsMY4qckfOViJUCyD7cblN71C
         mUdZNU/weer2LY8s5Mk0k9579SDM59RWMK+o2zO0/Ya4efqSBbdQsEJ5+rrdWtPdwz
         wo5Tu7l0P9W536WeoiKYfYxfVp1xtHtP6Jp8LxTWbTScrmva5K23gB0/BQSMm9I1wT
         /wWuNsmhp7JJA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 22:41:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211605-201763-R6CrDBrNOD@https.bugzilla.kernel.org/>
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

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen (sandeen@redhat.com) ---
That's not the right fix ;) but thanks for the bug report, looks like this =
was
an oversight when attr2/noattr2 were deprecated, we'll get it fixed up.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
