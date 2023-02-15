Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CF1C636CC
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 14:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBOOFm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 09:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBOOFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 09:05:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18892940C
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 06:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C11361C2E
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 14:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3729C433A4
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676469930;
        bh=q6uaeCT0KRryR4DVu78Get4WQesW/tPCVwQxVjReuY8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X7tKoMBrTTOrxthPF3XBs7cec0TlQV9doahlOGdmFpM039kd43+fqfcy7k5OZZ06a
         Y2eHXOW1F8tmlbVehKmTqRNVWl0pkIgkzB3EOUfKIX9IVp7sjRWPH1wd33fFLG7J9/
         DM0hfCOf50TPkbdXqaVp4bJKpa1B6brJ3UDmwpH4UWjSp2CzpQtVKxVn7rlQvod5ht
         mLXEE8+6OfgbBcH180SyNlye6qgnQEbdPTA4vIfk10Tl9SCyQPi03QLY+YMK/7j6S9
         4xeKda9QaVgD9XP7tKMlKytDwyrzvsYBBGSu3v/DuDOLgmjH4UY4vgmlRwWU2KeggB
         Ls5yTPjbR3hGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A009C43141; Wed, 15 Feb 2023 14:05:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215851] gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Date:   Wed, 15 Feb 2023 14:05:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: polacek@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215851-201763-1aDPuQohiP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215851-201763@https.bugzilla.kernel.org/>
References: <bug-215851-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215851

Marek Polacek (polacek@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |polacek@redhat.com

--- Comment #2 from Marek Polacek (polacek@redhat.com) ---
I agree that gcc shouldn't warn here.  I just pushed a patch to suppress th=
at
warning:
https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dcommitdiff;h=3Dd482b20fd346482635a=
770281a164a09d608b058
and I plan to backport it to gcc 12 as well.  gcc 11 doesn't have
-Wdangling-pointer.
So I think you should be able to re-enable -Wdangling-pointer soon.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
