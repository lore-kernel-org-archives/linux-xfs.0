Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A3BC352A2
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 12:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B72821741
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 12:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgBEM2J convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 07:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbgBEM2J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Feb 2020 07:28:09 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206429] New: xfs_admin can't print both label and UUID for
 mounted filesystems
Date:   Wed, 05 Feb 2020 12:28:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vtrefny@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-206429-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206429

            Bug ID: 206429
           Summary: xfs_admin can't print both label and UUID for mounted
                    filesystems
           Product: File System
           Version: 2.5
    Kernel Version: n/a
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: vtrefny@redhat.com
        Regression: No

Created attachment 287143
  --> https://bugzilla.kernel.org/attachment.cgi?id=287143&action=edit
patch for xfs_admin

Using "xfs_admin -lu" to print both label and UUID of a mounted XFS filesystem
stopped working in xfs_admin version 5.4.0.
Label is correctly printed, but the UUID is missing:

$ sudo xfs_admin -lu /dev/sda
label = "aaa"

Printing only UUID works as expected:

$ sudo xfs_admin -u /dev/sda
UUID = a3367b49-6f3f-4f50-9b34-38b1561da085

Command also works as expected for an unmounted filesystem
$ sudo xfs_admin -lu /dev/sda
label = "aaa"
UUID = a3367b49-6f3f-4f50-9b34-38b1561da085

The bug is caused by this change --
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=3f153e051abccce0c120ade5c08a675a50cecee9
-- xfs_io is now used to print label and xfs_admin exists after printing it.
I'm attaching a simple naive patch for xfs_admin that fixes this issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
