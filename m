Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F34EE92714
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 15:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbjJEPpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbjJEPo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 11:44:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FF66187
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 07:31:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6D85C116A4
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696516309;
        bh=lk1688ueisq7BdC7Dmgxhx2LcpqiO0wKN3b0iV4rplY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kJb6bOXdhvp9vumItuNNDRuyrW12JUP4krKMAWNECRZkPTs4iOaNtNxPkZy4yp1B/
         vHlhwyGe13JEEcTNHukgi2+Q4ViLB9nmtvKbP7GInXDDE6lF9i+krf0Eb19JaXACCU
         +hU51iYsbfpiQYPLeS3TNXEtEuJpZ+5KasR8nIuLVtWsB4BNSIT7cz1d7cCwR2fQAw
         dqwyxZ1xRAyXUXmR4xm0fUwJdnHJED56S14CPpOhs7arVeh7b/p59tcy39jbAc9e22
         iKaS2l/Qk7rMai1Unqa6OtfQVSkcBrBfYLLA8mDfiPIxDbhskYiPmJuq4OxtoCTCim
         f9maXrB4SaZxw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D019BC4332E; Thu,  5 Oct 2023 14:31:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 05 Oct 2023 14:31:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: thomas.walker@twosigma.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217572-201763-ojTEXcBrEU@https.bugzilla.kernel.org/>
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

Thomas Walker (thomas.walker@twosigma.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thomas.walker@twosigma.com

--- Comment #15 from Thomas Walker (thomas.walker@twosigma.com) ---
We seem to be hitting this with quite some regularity, also on 6.1(.44).=20
Including after applying the proposed patch (cbc02854331e ("XArray: Do not
return sibling entries from xa_load()")

Curious whether this has actually solved the problem for anyone else?
(This issue should also probably be changed from XFS, which we know now is =
just
a victim, to something in the memory management subsystem to get proper
visibility).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
