Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465EEC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B63208E4
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgHXVDl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXVDl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 17:03:41 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] xfs_repair 5.7.0: missing newline in message: entry at
 block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Mon, 24 Aug 2020 21:03:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209005-201763-njhnZyhZxR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209005-201763@https.bugzilla.kernel.org/>
References: <bug-209005-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209005

--- Comment #3 from Eric Sandeen (sandeen@redhat.com) ---
IOWs this looks like more than just a missing "\n" - setting the first
character of a directory entry to "/" is an internal flag for certain entries
which is normally handled in a specific way.

But it doesn't look like your filenames are overwritten; it looks like they
actually started with "/" prior to repair?  So it may not be handling this
flagging properly when the leading "/" came from elsewhere... a metadump would
be helpful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
