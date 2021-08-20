Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D44DC43216
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 13:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E68610CB
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 13:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240757AbhHTNV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 09:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240706AbhHTNV1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Aug 2021 09:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 951C86113E
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 13:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629465649;
        bh=ri9ZtoHUprd8fCJeLlD3J0p2lkzqBDny3bjmnW8lTu4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tvJMg3IzaFr2bhmv2nUdU38jT6q6RXzEX/3mhrTwFPEUqOd4CIMA1X0ALG6lAttE2
         QivOpey2mxVj7/SRJscKvPEaRnhB2rXe2JYmIfi6lYEvCDAvbtlf8SOyKaqQvzSydG
         mU0vkc5iM7hE+P+MkaJx+3Yun6NwQmhgve8jpj7+lypBygHEQhiX9gc1poq+CAIcs/
         suXGOhe19TyrrPVuTxUnGmzxjMEdwK1cV6q6TNuu3dZ1OKG16OXT/rvP7R12yNacqY
         NqyBsTX6mlDtZcuPIZmV85pkTO0axe7MIpYUGcjUthQ2cSSSq+6XncQAwL6bvZJ9JD
         Q0tEu4gxuykNw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Fri, 20 Aug 2021 13:20:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214077-201763-08xzMYu3zT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214077-201763@https.bugzilla.kernel.org/>
References: <bug-214077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214077

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
*** Bug 214079 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
