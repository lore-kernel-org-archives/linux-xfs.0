Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49994C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  1 May 2022 05:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiEAFzX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 May 2022 01:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiEAFzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 May 2022 01:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6E02019E
        for <linux-xfs@vger.kernel.org>; Sat, 30 Apr 2022 22:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7F0611C8
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 05:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AE52C385B5
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 05:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651384316;
        bh=pPvyvQw3ZLHS/IVXNrFrbkJAbhbqlOfDjIJr2cmThSk=;
        h=From:To:Subject:Date:From;
        b=iYfgKZrurITCfZeder4FMW/ts72A7nBsDMOPvI9sKUmAd2NIZwsrILdh9mUHuVqZn
         P9N13qXNC7moPnXhGfD+KmzPmNYtv3u9t9AA6CUXnbEVZlIymw0gK2OA4r+82wSJuu
         ABE2KRLn/5TeKjmtOwMpb5ArP2TfHNj19GGdCeG72iDvhiw/X9vOOWbN6eYUWuNNng
         9eCDs/zi9O3mU3I8FWc0ZWP7nPcEHdYVGISTm+g4kZh8yzyDUzG1EeMMghBDf4cJtl
         iLyi7P5/WcmZQvP9oIYiYpufqAvBPtIdQTUKXQZ9MHcZnUn0/jajWz/BtqJFWp3F42
         HKFtrDEWWdp1Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 243BCCAC6E2; Sun,  1 May 2022 05:51:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] New: kernel deadlock when mounting the image
Date:   Sun, 01 May 2022 05:51:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yanming@tju.edu.cn
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215927-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215927

            Bug ID: 215927
           Summary: kernel deadlock when mounting the image
           Product: File System
           Version: 2.5
    Kernel Version: 5.17
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: yanming@tju.edu.cn
        Regression: No

The kernel (v5.17) deadlocked when I was going to mount a XFS image. I'd tr=
ied
to kill the mount process, but failed. Nothing I can do to recover the kern=
el
but reboot. I am wondering is there a bug in the kernel?

I have uploaded the XFS image to google net disk
(https://drive.google.com/file/d/16pFbMkWkx692DWQX-3cE7yRO5JRsCzd0/view?usp=
=3Dsharing).
You can reproduce this issue by running:
losetup /dev/loop0 case.img
mount /dev/loop0 /mnt/test/

Hoping someone can help me with this issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
