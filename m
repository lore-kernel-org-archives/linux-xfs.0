Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCADFC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 10:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5AAE2071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 10:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfKVKqx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 05:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729685AbfKVKqx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Nov 2019 05:46:53 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date:   Fri, 22 Nov 2019 10:46:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ivan@ludios.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202349-201763-NRem2ZwWhU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

Ivan Kozik (ivan@ludios.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ivan@ludios.org

--- Comment #14 from Ivan Kozik (ivan@ludios.org) ---
I have also had this problem with XFS; running 4.19 with
https://github.com/bobrik/linux/pull/3 ("xfs: add a sysctl to disable memory
reclaim participation") and fs.xfs.memory_reclaim = 1 ("async inode reclaim of
clean inodes only") has improved things for me.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
