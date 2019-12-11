Return-Path: <SRS0=bXuc=2B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14316C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 14:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA9722B48
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 14:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfLKODy convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 09:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbfLKODy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Dec 2019 09:03:54 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205833] New: fsfreeze blocks close(fd) on xfs sometimes
Date:   Wed, 11 Dec 2019 14:03:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel.org@estada.ch
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205833-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205833

            Bug ID: 205833
           Summary: fsfreeze blocks close(fd) on xfs sometimes
           Product: File System
           Version: 2.5
    Kernel Version: 4.15.0-55-generic #60-Ubuntu
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: kernel.org@estada.ch
        Regression: No

Dear all

I noticed the bug while setting up a backup with fsfreeze and restic.

How I reproduce it:

    1. Write multiple MB to a file (eg. 100MB) while after one or two MB freeze
the filesystem from the sidecar pod
    2. From the sidecar pod, issue multiple `strace tail /generated/data/0.txt`
    3. After a couple of tries strace shows that the `read(...)` works but
`close(...)` hangs
    4. From now on all `read(...)` operations are blocked until the freeze is
lifted

System: Ubuntu 18.04.3 LTS
CPU: Intel(R) Xeon(R) CPU X5650  @ 2.67GHz
Storage: /dev/mapper/mpathXX on /var/lib/kubelet/plugins/hpe.com/... type xfs
(rw,noatime,attr2,inode64,noquota)

I used this tool to generate the file. The number of concurrent files does not
appear to matter that much. I was able to trigger the bug, tested with 2, 4 and
32 parallel files:
https://gitlab.com/dns2utf8/multi_file_writer

Cheers,
Stefan

PS: I opened a bug at the tool vendor too:
https://github.com/vmware-tanzu/velero/issues/2113

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
