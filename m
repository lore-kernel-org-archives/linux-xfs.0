Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A29C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 08:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiDRIFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 04:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiDRIFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 04:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A5B19291
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 01:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B836F6103D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 08:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A962C385A1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 08:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650268964;
        bh=SW7JyPBZe9TW2HCk9A2cSTUThgtxy7xens3aer0OLRw=;
        h=From:To:Subject:Date:From;
        b=beDMIby7frcqvsIqZH7VhLaYAeFdxD7XxljhvUu0haY6HREnP/rLYnGrXHSnUSoIF
         y281W0Ymqzmp16DhO+SqrjCEGmt1w0QuEduvfantbx71flj4eWeke0ZbNnmUtJFHpL
         EZPkvC3hRZNYen4+aHxLh1/wFPptqCHwFuiyLUJYjGRv4LYkWsKNkKMy+/3HeCJOb/
         z7Spikg9AemMbJAFihRWU4W2sL7+NaHON9QWaIH5vXvlpkX7q6L4TC/eeitweNKYrk
         31KuWbaytz8Oq9wOiGV47DOUcFlQOSRhon1grDsq4CM4TidEbdnn4LgydJp0Y1o3vn
         ZtBrdWhWxVfvw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0E68CC05F98; Mon, 18 Apr 2022 08:02:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215851] New: gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Date:   Mon, 18 Apr 2022 08:02:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: Erich.Loew@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215851-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215851

            Bug ID: 215851
           Summary: gcc 12.0.1 LATEST: -Wdangling-pointer=3D triggers
           Product: File System
           Version: 2.5
    Kernel Version: 5.17.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: Erich.Loew@outlook.com
        Regression: No

Date:    20220415
Kernel:  5.17.3
Compiler gcc.12.0.1
File:    linux-5.17.3/fs/xfs/libxfs/xfs_attr_remote.c
Line:    141
Issue:   Linux kernel compiling enables all warnings, this has consequnces:
         -Wdangling-pointer=3D triggers because assignment of an address po=
inting
         to something inside of the local stack=20
         of a function/method is returned to the caller.
         Doing such things is tricky but legal, however gcc 12.0.1 complains
         deeply on this.
         Mitigation: disabling with pragmas temporarily inlined the compiler
         triggered advises.
Interesting: clang-15.0.0 does not complain.
Remark: this occurence is reprsentative; the compiler warns at many places

To go pass through the compilation I added "-Wno-stringop-overread
-Wno-dangling-pointer -Wno-address -Wno-array-bounds -Wno-stringop-truncati=
o"
to the Makefile root file of the kernel tree.

This is not the cleanest approach but it helps for time being.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
