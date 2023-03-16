Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB50C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 21:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCPVCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCPVCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 17:02:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEDF9FE5D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 14:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A2C362122
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 21:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2425C433AE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679000526;
        bh=/aRMle82RewCrycg3VVGXlbxqXycCZakKB4tqnSkFbs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X6fa3wDQaMo6+U0aqL2m8XK3XrxGOJE08sYE2L4Lydok983H85r4eext20CN57QKj
         a3cQxFgpOF8P0cEADVMtIus0sqvuayz64LNdwUMt2OwnT3AIXNZR151xnNxDnVm5gP
         OJRHMTTVcVp/4H2py6HllVPSufBWS4sKfjwM9DDbeG75QH76de5mNlT9xqqqCDpUGU
         KQAF27rBGXphcaHvtmxphthYOX/pTf76K1yV9tUAN90wrwx5ANGGHOS5BLP8kXe4/6
         tznNC3z47oIkwUZxpV+o93+3ndPQjqaSFqvj4kg3I0ot5+HPIS0wqs2NJ9v1H4gBO9
         4RBZSEN8WG4EQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B251CC43165; Thu, 16 Mar 2023 21:02:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Thu, 16 Mar 2023 21:02:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207053-201763-7JDQZpHSWP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D207053

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #12 from Eric Sandeen (sandeen@redhat.com) ---
commit 4b674b9ac8529 should be in upstream kernel v5.7

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
