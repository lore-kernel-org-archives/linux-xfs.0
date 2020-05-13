Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B014C2D0F6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 02:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A82520714
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 02:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgEMCpz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 22:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgEMCpz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 May 2020 22:45:55 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207711] New: xfs: data race on ctx->space_used in
 xlog_cil_insert_items()
Date:   Wed, 13 May 2020 02:45:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: baijiaju1990@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207711-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207711

            Bug ID: 207711
           Summary: xfs: data race on ctx->space_used in
                    xlog_cil_insert_items()
           Product: File System
           Version: 2.5
    Kernel Version: 5.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: baijiaju1990@gmail.com
        Regression: No

The functions xlog_cil_insert_items() and xlog_cil_push_background() are
concurrently executed at runtime at the following call contexts:

Thread 1:
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_commit()
          __xfs_trans_commit()
            xfs_log_commit_cil()
              xlog_cil_insert_items()

Thread 2:
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_commit()
          __xfs_trans_commit()
            xfs_log_commit_cil()
              xlog_cil_push_background()

In xlog_cil_insert_items():
  ctx->space_used += len;

In xlog_cil_push_background():
  if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))

The variables ctx->space_used and cil->xc_ctx->space_used access the same
memory, and thus a data race can occur.

This data race was found and actually reproduced by our concurrency fuzzer.

I am not sure whether this data race is harmful and how to fix this data race
properly, so I want to listen to your opinions, thanks :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
