Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2BFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885EC60ED5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhJUNWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 09:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230374AbhJUNWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 09:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 872E5611C7
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634822416;
        bh=Dk7Kzi/0RP2bBL0qzbqKzf0WX3UvmKa8x8ymtYcgdQM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=d3KdNLIPBl3G4HvTfw72b8rH9+ofcmkzV1vQ4sh4k7ZNqwu78vqe21K2U9t8vD00c
         sYzZxzh/Cg2bHpO0TLu+gGS8XpfJXAUJEhOVNCVCJieVK32WWxuxzuQQRYZwtBVD+Y
         8UmMAWpvk4GhkjgwUiVkiK8+OMWCL5yewfzJM9qjbN1USrbQp8Oit8YnkOEuOTGIhV
         21AGE5/STL/wH4tbCrP2B9wy8o+ztdjSoQivYZboaQHD6Mi4Pa4O+53AufIisZd+jx
         5MmnkgBo8mz4li/7QOZDTsO0XSiJ5frSqBgsfLwtCX+mwhxuNWpyWW9ZMv1Rhqdust
         S6d00MKXMTRnw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Thu, 21 Oct 2021 13:20:15 +0000
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
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-214767-201763-XAl7qUsGaE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #12 from Christian Theune (ct@flyingcircus.io) ---
Created attachment 299295
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D299295&action=3Dedit
log of a vm with only vdc1 (/tmp) stuck

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
