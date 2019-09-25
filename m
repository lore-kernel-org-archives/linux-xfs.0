Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E98FC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 17:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7B420872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 17:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfIYRvg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 13:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfIYRvg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Sep 2019 13:51:36 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204997] New: fsck.xfs prints a vague message "XFS file system"
 when skipping a boot time check
Date:   Wed, 25 Sep 2019 17:51:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: nf8kh699qb@liamekaens.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-204997-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204997

            Bug ID: 204997
           Summary: fsck.xfs prints a vague message "XFS file system" when
                    skipping a boot time check
           Product: File System
           Version: 2.5
    Kernel Version: 5.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: nf8kh699qb@liamekaens.com
        Regression: No

Created attachment 285173
  --> https://bugzilla.kernel.org/attachment.cgi?id=285173&action=edit
Suggested patch to improve the error message seen on boot.

When an XFS filesystems is configured to be checked on boot via the /etc/fstab,
the /usr/sbin/fsck.xfs is called. It does nothing but print "XFS file system"
which can mislead admins into thinking the filesytem was checked when it has
not been.

This was previously reported via RedHat bug
https://bugzilla.redhat.com/show_bug.cgi?id=1546294 and is a minor issue.

Steps to Reproduce:
1. Change the "0 0" in /etc/fstab for /home to "0 1"
2. Reboot and watch console messages

Actual results:

Observe "Started file system check on /dev/mapper/<name of home LV>"

Observe "systemd-fsck[<PID>]: /sbin/fsck.xfs: XFS file system"

Expected results:

Observe "systemd-fsck[<PID>]: /sbin/fsck.xfs: XFS file system checks always
skipped on boot"

Or some other message to make it clear that the check was 1) skipped and 2)
this was intentional

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
