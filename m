Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77086C2D0F6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 03:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7CB206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 03:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgEMDCL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 23:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMDCL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 May 2020 23:02:11 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207713] New: xfs: data races on ip->i_itemp->ili_fields in
 xfs_inode_clean()
Date:   Wed, 13 May 2020 03:02:10 +0000
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
Message-ID: <bug-207713-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207713

            Bug ID: 207713
           Summary: xfs: data races on ip->i_itemp->ili_fields in
                    xfs_inode_clean()
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

The function xfs_inode_clean() is concurrently executed with the functions
xfs_inode_item_format_data_fork(), xfs_trans_log_inode() and
xfs_inode_item_format() at runtime in the following call contexts:

Thread 1:
xfsaild()
  xfsaild_push()
    xfsaild_push_item()
      xfs_inode_item_push()
        xfs_iflush()
          xfs_iflush_cluster()
            xfs_inode_clean()

Thread 2 (case 1):
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_commit()
          __xfs_trans_commit()
            xfs_log_commit_cil()
              xlog_cil_insert_items()
                xlog_cil_insert_format_items()
                  xfs_inode_item_format()
                    xfs_inode_item_format_data_fork()

Thread 2 (case 2):
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_log_inode()

Thread 2 (case 3):
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_commit()
          __xfs_trans_commit()
            xfs_log_commit_cil()
              xlog_cil_insert_items()
                xlog_cil_insert_format_items()
                  xfs_inode_item_format()

In xfs_inode_clean():
  return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);

In xfs_inode_item_format_data_fork() (case 1):
  iip->ili_fields &=
        ~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);

In xfs_trans_log_inode() (case 2):
  ip->i_itemp->ili_fields |= flags;

In xfs_inode_item_format() (case 3):
  iip->ili_fields &=
        ~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);

The variables ip->i_itemp->ili_fields and iip->ili_fields access the same
memory, and thus data races can occur.

These data race were found and actually reproduced by our concurrency fuzzer.

I am not sure whether these data races are harmful and how to fix them
properly, so I want to listen to your opinions, thanks :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
