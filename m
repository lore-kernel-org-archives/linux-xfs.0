Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33894C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 05:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13ACF61151
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 05:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhKIFV5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 00:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhKIFVv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Nov 2021 00:21:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9ECE461279
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 05:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636435146;
        bh=VIr23RixrSBGae+ycLL5tVlsX/4L73cBUPhb+43E8+Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aRRBhZwbpetSDsVp5EBSTrhy7bIodiAdLoly456JsBvK+oF3dWobjewajbIQHHw9/
         DRD3ejD9ec4qDXLKnPP+6IJexHEpWo+B79MqT6JT5n4bH3d3Ca6j3lo0Y2ljsZUhdw
         ccOhLI+0Hk52OrjNJGPemXjJvFQ5O9fDOrLPCYtXbvkdop1oBK/tviLPAyYYxbyexR
         PW/kO58UwYRt6CKxkfRGy7OmLhoNK6brVNRfwDx8QrzlWW4j5FDTEfeHiDZCqTdnvF
         AGdYTRBfCVHWOFtBxhplXI/EJCCUNhKO3R6xBOvfszGH72uJU/Pl0xbybdTfPMYAsn
         fWINRK1tCNoNw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Tue, 09 Nov 2021 05:19:05 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-BzXrHI5k7u@https.bugzilla.kernel.org/>
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

--- Comment #15 from Christian Theune (ct@flyingcircus.io) ---
@Pedram: not sure those are related. I'm 50/50 whether my issue is
freeze-related and all my stacktraces have a 'xfs_log_commit_cil' in there
which I don't see in yours, could be a separate issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
