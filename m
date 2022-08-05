Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F804C00140
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 06:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiHEGe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 02:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiHEGe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 02:34:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01B771BF3
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 23:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09BFEB82757
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 06:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5FD8C43140
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 06:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659681264;
        bh=mHKOjC9HPc7NdnH+Jg4mn1EW9z8akUgx6NsTK78bB1Y=;
        h=From:To:Subject:Date:From;
        b=dA/Kuotli0wEDymC1RFTCcEvo51fn4l8PVDtLaXRiWX3COENI2P5CYL5VRfxlrY76
         cjSf+LXbaoDA4X23c6J1cdvSrTvTK6mQSLi4ryBZbvrlngJ+Udl2g7epJ7jOK0s8pP
         r9+EsiDUYGpAdzDoYPYwRUvB5yNLjF/5w/+z6elaBDFFh2uMC3OjGEqPym4ETlJsS7
         KdubMIGCC//Mmwasp+p4YtPlTzpoygbKYpCDWCtD1A92Qc/NhIP9Q2rVj2HJXfPdbu
         yfgt4kYd7UcM7gIyLv5wFKo+9YAZD4G6A6TNb0W5gxvIhlUgCyucUAjMy7Qpi7ElBV
         Y6xxwF7N5nh1g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B43FBC0422E; Fri,  5 Aug 2022 06:34:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216329] New: kernel crash and hung up while umounting
Date:   Fri, 05 Aug 2022 06:34:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hyz0906@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216329

            Bug ID: 216329
           Summary: kernel crash and hung up while umounting
           Product: File System
           Version: 2.5
    Kernel Version: 5.3.0-45-generic
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: hyz0906@qq.com
        Regression: No

OS: Ubuntu 18.04.1
Using XFS with Ceph rdb and mount by OverlayFS, sometimes system hung up wi=
th
kernel crash below:

2022-07-27 16:17
Jul 27 15:21:43 k8s-node-b01-17-05 kernel: [25666453.856553] VFS: Busy inod=
es
after unmount of overlay. Self-destruct in 5 seconds.  Have a nice day...
Jul 27 15:22:01 k8s-node-b01-17-05 kernel: [25666471.122435] XFS (rbd59):
Unmounting Filesystem
Jul 27 15:22:25 k8s-node-b01-17-05 kernel: [25666495.392431] BUG: Dentry
00000000d683c981{i=3D38c31f07,n=3DREADME_zh.md}  still in use (1) [unmount =
of xfs
rbd23]"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
