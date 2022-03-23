Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCA0C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 08:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242658AbiCWI0T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 04:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242649AbiCWI0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 04:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338A76E8C3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 01:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F6FB81E3F
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 08:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33DC3C340F6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 08:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648023884;
        bh=Eqan6JrA1vv+wS5NChxWJ5DWibsBMpK53bJXq1wW1wk=;
        h=From:To:Subject:Date:From;
        b=OiOXbjjB57SL2rRnywbKmRGwUPFIGcRkYjq5vnj2EJgQfkgAqg2uY1wzvqqBOT8mO
         49sWGWfD1AQ92AXHcuxzYC1JE70S6CjvQ6yDsJTwkNic6iyl7+NQGVuzupdadtPoUw
         tI5r99xPZ1/+WPidfkR6YDogLWRtdKFxI2Dg/VuUy4ztjM2PGiF1TW4Ojumro6wCPd
         4+N5yJJ8Kz0YBLCMVzjwx6ScNqMxF5ruq3AvNNndht7UWt3GxX+S0rAEGavW5Hfn62
         WnMIS2KecYs66Uu0UGv4l9gjfVUrZX4AuGrcOGgQn50oG4Iv+zQ7ApGk+ezBfzpPK+
         hLBYrU891c49w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2130EC05FD4; Wed, 23 Mar 2022 08:24:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMTU3MzFdIE5ldzogU2VyaWFsIHBvcnQgY29udGludW91?=
 =?UTF-8?B?c2x5IG91dHB1dHMg4oCcWEZTIChkbS0wKTogTWV0YWRhdGEgY29ycnVwdGlv?=
 =?UTF-8?B?biBkZXRlY3RlZOKAnQ==?=
Date:   Wed, 23 Mar 2022 08:24:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xqjcool@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215731-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215731

            Bug ID: 215731
           Summary: Serial port continuously outputs =E2=80=9CXFS (dm-0): M=
etadata
                    corruption detected=E2=80=9D
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-514.26.2.el7.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: xqjcool@gmail.com
        Regression: No

Created attachment 300607
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300607&action=3Dedit
Serial log

We can't access device through SSH. Serial port continuously outputs =E2=80=
=9CXFS
(dm-0): Metadata corruption detected=E2=80=9D.


------------------------------------------------------
[5150496.250010] XFS (dm-0): Metadata corruption detected at
xfs_inode_buf_verify+0x75/0xe0 [xfs], xfs_inode block 0x1092340
[5150496.250011] XFS (dm-0): Unmount and run xfs_repair
[5150496.250011] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
[5150496.250012] ffff8808fe6cc000: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250012] ffff8808fe6cc010: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250013] ffff8808fe6cc020: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250013] ffff8808fe6cc030: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250024] XFS (dm-0): Metadata corruption detected at
xfs_inode_buf_verify+0x75/0xe0 [xfs], xfs_inode block 0x1092340
[5150496.250067] XFS (dm-0): Unmount and run xfs_repair
[5150496.250067] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
[5150496.250067] ffff8808fe6cc000: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250068] ffff8808fe6cc010: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250080] ffff8808fe6cc020: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250080] ffff8808fe6cc030: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250091] XFS (dm-0): Metadata corruption detected at
xfs_inode_buf_verify+0x75/0xe0 [xfs], xfs_inode block 0x1092340
[5150496.250094] XFS (dm-0): Unmount and run xfs_repair
[5150496.250094] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
[5150496.250322] ffff8800360ea000: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250323] ffff8800360ea010: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250323] ffff8800360ea020: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250324] ffff8800360ea030: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250336] XFS (dm-0): Metadata corruption detected at
xfs_inode_buf_verify+0x75/0xe0 [xfs], xfs_inode block 0x1092340
[5150496.250343] XFS (dm-0): Unmount and run xfs_repair
[5150496.250344] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
[5150496.250344] ffff8800360ea000: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250345] ffff8800360ea010: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250346] ffff8800360ea020: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250346] ffff8800360ea030: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250356] XFS (dm-0): Metadata corruption detected at
xfs_inode_buf_verify+0x75/0xe0 [xfs], xfs_inode block 0x1092340
[5150496.250361] XFS (dm-0): Unmount and run xfs_repair
[5150496.250361] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
[5150496.250362] ffff8800360ea000: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250362] ffff8800360ea010: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250362] ffff8800360ea020: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
[5150496.250363] ffff8800360ea030: 01 00 00 00 01 00 00 00 01 00 00 00 01 0=
0 00
00  ................
------------------

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
