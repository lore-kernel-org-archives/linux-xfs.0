Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40636C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 09:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiCOJWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346566AbiCOJWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 05:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC74B4EA39
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 02:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793CB60A76
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 09:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D955BC340F7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647336097;
        bh=NmbGdiwQXXz0YpgY/S2/P1cqS/Ct3WhHCGBakjhtsWI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fo9QIPzvla3QcVYySA2ssjK1oEA5a2KFEYJpOFlVLup3aihhladmJy8aUxO6SO6vO
         /3Rbqzw0GrLy1WHmf3GlSf1pDNbHsgSAtib5e7XTHOoYA0mUhHMw94EaZ5zajKMySD
         +4DedMA7k09iAmyL4Jf8Dnk4Xab121bXYDxLcLbSInomCbJv58/vHjukK0fywD0LH+
         qkS//u9icbEPHDw5f7DhaGg+UbUNgswg7KcMZ6CGslufU1P302OyFnxp5Z+VHyvVMY
         HOXmNu44ED6YmP+8mMbwBKS5jzZWSMEB26znU7mHkTdZeyel72ejKlWhc5pOGfBDt5
         9KBGLEVQzvoRw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C9537CC13AD; Tue, 15 Mar 2022 09:21:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] chown behavior on XFS is changed
Date:   Tue, 15 Mar 2022 09:21:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215687-201763-fmDaSXYibs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
OK, by looking into xfs commits, I feel this patch brings in this behavior
change:

commit e014f37db1a2d109afa750042ac4d69cf3e3d88e
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Tue Mar 8 10:51:16 2022 -0800

    xfs: use setattr_copy to set vfs inode attributes

We treated it as an XFS behavior ~10 years, now it's changed ...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
