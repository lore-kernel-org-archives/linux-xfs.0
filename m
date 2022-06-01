Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B491C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 17:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356401AbiFARm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 13:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352351AbiFARmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 13:42:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC2652B08
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 10:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B649E61645
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 17:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 262F7C341C5
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654105343;
        bh=wNzgA7Fl6ojuR3oVT9qM9a3nS+gvFqy2jaEMGYwPckw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Hr7HieOdbv2ZnOuW59XHwcOANAkWbX1g8z82LOv7A76r6BkdFEgnDagMnxWlfq3VE
         q9823r0oY3iNflSshhrjEHcIEGVx+Ieq+4ey5wJtoAeYrruuvYwjS0f1zMEEI0cRH6
         HsOv8JWRLbwSv5wOZ+l6HPozoinMPK3FFNQYX3h64OPthVgLaksn8JOPSIh8+j/8A8
         E6YAWNYOK6RxKDf14RUPDVel7dhbPmBnPDbXI7MNQIl7JFD//FCcCM6md+4ROHBroh
         KoMr8gKWNUK//zb+k9cmS3hYsRvBj8Dc9iTtBuHNvwjwteNYy8vmroGCDm5mBvsVmh
         i7NaZC6ar2gDw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 15B4CCC13B0; Wed,  1 Jun 2022 17:42:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMTU3MzFdIFNlcmlhbCBwb3J0IGNvbnRpbnVvdXNseSBv?=
 =?UTF-8?B?dXRwdXRzIOKAnFhGUyAoZG0tMCk6IE1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0?=
 =?UTF-8?B?ZWN0ZWTigJ0=?=
Date:   Wed, 01 Jun 2022 17:42:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-215731-201763-3kz7gWLDho@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215731-201763@https.bugzilla.kernel.org/>
References: <bug-215731-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215731

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@redhat.com
         Resolution|---                         |INVALID

--- Comment #2 from Eric Sandeen (sandeen@redhat.com) ---
Agreed, this is simply a report of corruption, and there is not nearly enou=
gh
information to act on or triage.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
