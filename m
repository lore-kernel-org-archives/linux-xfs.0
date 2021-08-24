Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23689C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085A860F6F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhHXJDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 05:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234214AbhHXJDC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Aug 2021 05:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE6EA613AB
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629795738;
        bh=Spd/WYYsc85Lo8x0CPqtUKtIIe6a/TCyVQRGMumjzs4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TtxJusxs8AuVN7grbNR4NIsbkpXK1asm7Glbnpn0myXFex7lAoR+QhZAjzozJARC9
         u6nyOqaHTSz16xqLHTIPn9s6Ib3pBHMvKztw+lUl7xz94GbUcQATvxMJ9++73ESC3B
         qdbUGySlQQKobQHb8yawgDScEip8V6MxyFpD7wvXjxE970Vldt+HK37FbD88Zw6df0
         KtcdauhjtZCdwF4s1aKAa1hj+uY0bQ277wra7V5M3PVFUFc58TUZr9H43SCbM6PpNA
         WapgU+WSZcfNgFbVEHtTCmLsbLpEdKvRMyo+zTIfAFYHhJVFukNZ6IQ1Z/Q5aKIa3F
         xOsFCJ12+9F0g==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213941] [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Tue, 24 Aug 2021 09:02:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-213941-201763-cIxHqmnBRZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213941-201763@https.bugzilla.kernel.org/>
References: <bug-213941-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213941

Zorro Lang (zlang@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---


*** This bug has been marked as a duplicate of bug 213625 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
