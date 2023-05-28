Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB86C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 10:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjE1KVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 06:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1KVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 06:21:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DF0BC
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 03:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8359360C50
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9505C433A4
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685269310;
        bh=Hpg+Mh79buVCLuGC5F0D4NcQO8HsGeLaxk4ndQ2QDog=;
        h=From:To:Subject:Date:From;
        b=lJ5dvnA9R83N32x/79Xhwq9eir275xmWtZ2QX7mjqXFaHiDOS32OLus8jklP5fjGG
         PnKqxoMJHpSYUIeW6+cjDrkW5EzVdqtMD0hP7CjAm4obgYWYUlRETtE8tPhKCe3D4Z
         0rQCezncIgmwZB68jU1h4onABgjtrJnY6ebHZ7MlTBqsq/w0jnp6cAFV2n+EpJJKRT
         XKOE28r6lnLE/zIeyiuhOFg0VtL5h7nyiH4BHRuga95Bm+oT+DRE1vbNXVqo1CjALa
         6mQ+ne0TNgw6qlcS0wudcbXpzCK6KqX6N2u95QV5//iNa8rZTqA3XvVeVfIcnk4IG/
         yUHeH9F57/0ug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D5765C43143; Sun, 28 May 2023 10:21:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217496] New: XFS metadata corruption in 6.3 - 6.3.4 when using
 stripes
Date:   Sun, 28 May 2023 10:21:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217496-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217496

            Bug ID: 217496
           Summary: XFS metadata corruption in 6.3 - 6.3.4 when using
                    stripes
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: blocking
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: aros@gmx.com
        Regression: No

All the pertinent details are here:

https://bugzilla.redhat.com/show_bug.cgi?id=3D2208553

The most important bits:

Caused by: 74c36a8689d3d8ca9d9e96759c9bbf337e049097 ("xfs: use
xfs_alloc_vextent_this_ag() where appropriate")

Fixed by: 9419092fb2630c30e4ffeb9ef61007ef0c61827a xfs: fix livelock in del=
ayed
allocation at ENOSPC

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
