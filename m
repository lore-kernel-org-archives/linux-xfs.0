Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80708C2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6551361C74
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhF1NMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhF1NMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jun 2021 09:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 880BF61C72
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624885812;
        bh=+HfGHfaRkpqwgG89GQeggyPWkbatVYCgKKp4ANAXJHU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HtEgPq7gcg5tMC8Zy4yZAcdyabIjGJNm66trNsR1uqkwIXaCGqm1U3hHXcNnjsylN
         rBXKuwBxEXFUkt1C2ssBqEwyhwYlOW9VjT+1qs7JYpyB24j8vjpSYG8Q6W0DMIa23z
         ViS0eYFb5kQKA1Upu/lbyRqCKubVyGvVmfpslfMiElHTtL0YDOknBIzdAImfSEVsuO
         LFh+yBhYOYNhvjdPmmoXT+/+aGw7/ae2gMCpFLX/ftBwDIgWVs3LLvh+RnYdJZOQtZ
         dGVhl+Jc3fpfJ0VsdNwt8lMIfnASYBBolG2wfHqoZPex11u9Ce3eqJowIgKJSOH1nX
         z1P2SxSzb0/sg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213609] [xfstests xfs/503] testing always hang on 64k directory
 size xfs
Date:   Mon, 28 Jun 2021 13:10:12 +0000
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
Message-ID: <bug-213609-201763-HSZHjunUYz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213609-201763@https.bugzilla.kernel.org/>
References: <bug-213609-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213609

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
Reproducible on xfs-5.14-merge-6.
Test with latest upstream xfsprogs for-next branch.
Build with:
CONFIG_XFS_FS=3Dm
CONFIG_XFS_SUPPORT_V4=3Dy
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
CONFIG_XFS_RT=3Dy
CONFIG_XFS_ONLINE_SCRUB=3Dy
CONFIG_XFS_ONLINE_REPAIR=3Dy
CONFIG_XFS_DEBUG=3Dy
# CONFIG_XFS_ASSERT_FATAL is not set

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
