Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8FCC2D0B1
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 13:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80BDE2087E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 13:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBDNsk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 08:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgBDNsk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 08:48:40 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206397] [xfstests generic/475] XFS: Assertion failed:
 iclog->ic_state == XLOG_STATE_ACTIVE, file: fs/xfs/xfs_log.c, line: 572
Date:   Tue, 04 Feb 2020 13:48:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chandanrlinux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206397-201763-sL4187HVsZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206397-201763@https.bugzilla.kernel.org/>
References: <bug-206397-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206397

--- Comment #1 from Chandan Rajendra (chandanrlinux@gmail.com) ---
I was unable to recreate this issue on a ppc64le kvm guest. I used Linux v5.5
and xfsprogs' for-next branch.

Can you please share the kernel config file? Also, Can you please tell me how
easy is it recreate this bug?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
