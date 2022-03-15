Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC3CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 08:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiCOINu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 04:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345763AbiCOINt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 04:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8574AE11
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 01:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6744B6147D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 08:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C550FC340F6
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 08:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647331947;
        bh=jYRE/5sHm07hCsts2qXQEpPaWzyS2mMlIdDyzgY/kMI=;
        h=From:To:Subject:Date:From;
        b=Xty4JzYHb5xVSJZCBYOueugLXOEnkl+2qMcbOMK7auwYDetmfpXBV4zjf+bJcIjMj
         J20Uz0SxWvydwrQvNQSiAoSs01KsbHurimjcIA5YLaexetsuvmfMsfw6BH/KN/oU1q
         OkNuQdarVQMfBPrsu1p5yQMbEuQc0PsQxdGvkfsWg68roNUCuF3aISauek/sEGyS7S
         Pqi/HAD92gDw0jjlIMV7mMZYIZg7XQXvnfgUU44ToXMKhDbDMIPUjvKGx8eJs51wFj
         yNRi3GvrOzzSZa2OnIFutnJIlZJWuAER8RfpjYW0UfpR1vo8z1pVvY4O0/qkFh9Pve
         HFsqCy2njRNow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AD9A1C05FCE; Tue, 15 Mar 2022 08:12:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] New: chown behavior on XFS is changed
Date:   Tue, 15 Mar 2022 08:12:27 +0000
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
Message-ID: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

            Bug ID: 215687
           Summary: chown behavior on XFS is changed
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

From our regular regression test on XFS, we found a failure which never fai=
led
before:
# prove -rf /root/git/pjd-fstest/tests/chown/00.t=20
/root/git/pjd-fstest/tests/chown/00.t .. 83/171=20
not ok 84
not ok 88
/root/git/pjd-fstest/tests/chown/00.t .. Failed 2/171 subtests=20

Test Summary Report
-------------------
/root/git/pjd-fstest/tests/chown/00.t (Wstat: 0 Tests: 171 Failed: 2)
  Failed tests:  84, 88
Files=3D1, Tests=3D171, 31 wallclock secs ( 0.10 usr  0.04 sys +  1.04 cusr=
 15.50
csys =3D 16.68 CPU)
Result: FAIL

That means chown behavior has been changed on XFS. To reproduce this failure
you can:
1) mkfs.xfs -f /dev/sdb1
2) mount /dev/sdb1 /mnt/test
3) cd /mnt/test
4) git clone git://git.code.sf.net/p/ntfs-3g/pjd-fstest
5) cd pjd-fstest; make;
6) echo -e "os=3DLinux\nfs=3Dxfs" > tests/conf
7) cd /mnt/test
8) prove -rf /path/to/pjd-fstest/tests/chown/00.t

I'm going to look into it, to found out what specified behavior is changed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
