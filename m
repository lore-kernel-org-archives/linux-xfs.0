Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DE5C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 23:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0211B229C6
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 23:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbhAXXRQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 18:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbhAXXRQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Jan 2021 18:17:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D0EE22C9F
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 23:16:36 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211329] XFS related memory leak on ppc64le
Date:   Sun, 24 Jan 2021 23:16:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cam@neo-zeon.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211329-201763-Ft9B2oqW0O@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211329-201763@https.bugzilla.kernel.org/>
References: <bug-211329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=211329

--- Comment #1 from Cameron (cam@neo-zeon.de) ---
This also has not happened (yet) on my 2nd ppc64le box. Exact same kernel
configuration.

Specs:
Raptor CS Blackbird motherbord
1x 8 core POWER9
64 GB of memory

df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb3       470G  149G  321G  32% /

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
