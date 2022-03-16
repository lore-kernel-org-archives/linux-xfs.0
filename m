Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618E1C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 09:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354894AbiCPJa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 05:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346468AbiCPJay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 05:30:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFB16542D
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 02:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB63B81A64
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 09:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6775BC340F6
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 09:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647422973;
        bh=b1FsDwTJ/klAMYyMN6NrveYFLvNO1D3I4xzeUjYV3io=;
        h=From:To:Subject:Date:From;
        b=nvpqBT1TY6t8QJAFJMQIowmzfQJMu6EXo6/MegUAhgm20xvQNlmcUiTh951F2z1NJ
         nAY+Y0aUOqb5T77vBTBFYAyVYYmHoh5xWfpFeKgbLvhqWbfQ0ZM7ETf1Mxl/Xz21EL
         j9vjCkvm0La4QAYJh+1YVHSbCH8364KHwPE8+wfWi9SOGfU3/Rw4U6lEPDoPmUqhzu
         S3qhu7IjfEtOki9wxr0u0KBDz5eHyzErimLveYLYxsMEV0+DJZJKBZoo/KCbXBgL3N
         OstBHoyPH1XxCND2SM7H2aMaFBvcJ/mLRVhPOeSwukJhT53ObkQ2UrSL3ahJuWEO4e
         Zg0ClxTyCAjrQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 55A82CAC6E2; Wed, 16 Mar 2022 09:29:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215693] New: [xfstests generic/673] file on XFS lose its sgid
 bit after reflink, if there's only sgid bit
Date:   Wed, 16 Mar 2022 09:29:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215693-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215693

            Bug ID: 215693
           Summary: [xfstests generic/673] file on XFS lose its sgid bit
                    after reflink, if there's only sgid bit
           Product: File System
           Version: 2.5
    Kernel Version: xfs-5.18-merge-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests suddently generic/673 fails on latest xfs-5.18-merge-1:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/aarch64 hpe-xxx-xx-x-xxxx-xx 5.17.0-rc8+ #1 SMP Mon =
Mar
14 15:30:26 EDT 2022
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/vda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda3
/mnt/xfstests/scratch

generic/673     - output mismatch (see
/var/lib/xfstests/results//generic/673.out.bad)
    --- tests/generic/673.out   2022-03-14 19:50:16.969436417 -0400
    +++ /var/lib/xfstests/results//generic/673.out.bad  2022-03-15
12:12:33.080620337 -0400
    @@ -3,7 +3,7 @@
     310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
     6666 -rwSrwSrw- SCRATCH_MNT/a
     3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
    -2666 -rw-rwSrw- SCRATCH_MNT/a
    +666 -rw-rw-rw- SCRATCH_MNT/a

     Test 2 - qa_user, group-exec file
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/673.out
/var/lib/xfstests/results//generic/673.out.bad'  to see the entire diff)
Ran: generic/673
Failures: generic/673
Failed 1 of 1 tests

The diff output is:
--- /dev/fd/63  2022-03-15 09:42:11.044230787 -0400
+++ generic/673.out.bad 2022-03-15 09:42:10.514261066 -0400
@@ -3,7 +3,7 @@
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
 6666 -rwSrwSrw- SCRATCH_MNT/a
 3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
-2666 -rw-rwSrw- SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a

 Test 2 - qa_user, group-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
@@ -15,7 +15,7 @@
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
 6766 -rwsrwSrw- SCRATCH_MNT/a
 3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
-2766 -rwxrwSrw- SCRATCH_MNT/a
+766 -rwxrw-rw- SCRATCH_MNT/a

 Test 4 - qa_user, all-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a

According to the generic/673.out, the failed lines are
QA output created by 673
Test 1 - qa_user, non-exec file
310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
6666 -rwSrwSrw- SCRATCH_MNT/a
3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
2666 -rw-rwSrw- SCRATCH_MNT/a                    <------ fail

Test 2 - qa_user, group-exec file
310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
6676 -rwSrwsrw- SCRATCH_MNT/a
3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
676 -rw-rwxrw- SCRATCH_MNT/a

Test 3 - qa_user, user-exec file
310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
6766 -rwsrwSrw- SCRATCH_MNT/a
3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
2766 -rwxrwSrw- SCRATCH_MNT/a                    <------ fail
...
...

I've reported another about losing sgid or suid bits after chown:
https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
I doubt they're same issue, but due to they're about different testing (cho=
wn
and reflink), and the file not always lose its sgid bit after reflink(only =
Test
1 and 3). So I hope to get review from xfs expert, to make sure the behavior
changes are all as your expected, then we can change the test case's expect
result.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
