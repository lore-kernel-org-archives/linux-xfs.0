Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4478CE743E1
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 05:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjI2FBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 01:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2FBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 01:01:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FDB195
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 22:01:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7210C43391
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 05:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695963678;
        bh=pMrUbTE1jeEGnMfI/qXbUlHYJ3P8C0e4BuGyuLC4wC4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=raqZyLUXTKbLT9QXYtemYGJB3ecwnkrLc2sGnkY7KjGoZsBbdqKbV5dxFP8Y2DWTl
         JaBlr+iOUkTtc/6cx3WiFPHWg+aWUljRAf0Jmvj1bBg3+egc2+P3t4J/LUeAk/H5VT
         qwmS/+qRn/GtbTY0xs0qqZ1U56giYrjx07NTFqtt8kvXQv2znq8Qe5nLYNG6Nydi/C
         sx7MUd5HfF778xtHMTUNB0QMkSNd7cggomYA6TJNPfwF8Iz2o/uMQPWnmEhlqHVPdf
         0liXV6nF6CCkKr8OS66Q+IV1SvBiIbvWbCaZzaKjq/Fm8jckDiXYcMf0IluCJrYGuK
         DifyqDf50NbiQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B787EC53BD2; Fri, 29 Sep 2023 05:01:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Fri, 29 Sep 2023 05:01:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-Icq4egjGIk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #14 from Christian Theune (ct@flyingcircus.io) ---
Forget my last question! I went through the changelogs more closely (my sea=
rch
engine didn't properly match the commit globally) and found that it made its
way into 6.1.53.

Which means this should show up soon in our environment.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
