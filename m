Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC074C25B08
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 12:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbiHEMgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 08:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbiHEMgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 08:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98FA1EEFE
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 05:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C62961A3F
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 12:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB948C43140
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659702969;
        bh=B2mrKO1jNeTNtf0bVrr+B8mImUC2DrB6tCjT3F7ZA6w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FiMjE9GJss7G6mY57RnIWTk62VcE90LPqnSqgbAVOOdHhH/nuHaEKUZS8TUydVImw
         Y5C3sOYTkH+s7mJTOBCjRHoYqoGvYGn+fJflUKYbYg0Rj5igDA+EHIf3DSd73lbptI
         45fzvT+bkv+6Y54GyAIAjmp93nBy14hthSOC8V1Jg7V26P0bLrTGwAtrtpzDQl7vQW
         cAyMV24BJaat5WGOjJCgbmIhVMmBwoOpWSClZ/+4kNTRbGN5XGyS8mxc9LnEdWRgx9
         fxwBW3EHthazybRhgR2c4lQDS5gd7s/5BQTudTd1GrTZcfNMQDgVDVfgVP7SeBgims
         FhbKSEqCqx16Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C3D70C433E4; Fri,  5 Aug 2022 12:36:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216329] kernel crash and hung up while umounting
Date:   Fri, 05 Aug 2022 12:36:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216329-201763-6eeVbUttJ1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216329-201763@https.bugzilla.kernel.org/>
References: <bug-216329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216329

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
-> https://bugs.launchpad.net/ubuntu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
