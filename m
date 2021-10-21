Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610D6C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A13611C7
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJUNV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 09:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhJUNV4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 09:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CB4460ED5
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634822380;
        bh=lht1FZhwoYCry5dI4I3F3GEpDw7RS6pAIABm4P2s6xs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=J7/EP20IMS9/zIA49oZUQssGFJtomB2Xc5xud4g0FYSLdlZtbWtBzEmNjB7jWcOo7
         SKjkO+ZFiWUI5wt5tWXlC/9SFAtp92hV9sOx1QG79HPxue92xcxan7IF8YEY8taQ/K
         TlCnErRt33o08R0q0kZv1lLrOU+VoGv9MOu7vmMmh65WcdwXE1oagaum0n20f4T5bu
         /Zj5TxQ0DfD3eHNrQK21IDbY7qzuP5sqcWlbwNZNwh6ytlyTY2HvMZ3psyIsSHu80I
         qAbDbcLezoJlevVnk4/LO9W2/0UVXgyLckFgnQOCmVfCM69XyMWmGHiX/1JJhQ/udQ
         10rvGeXk9o6nA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Thu, 21 Oct 2021 13:19:38 +0000
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
Message-ID: <bug-214767-201763-EbB5L7Q9rR@https.bugzilla.kernel.org/>
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

--- Comment #11 from Christian Theune (ct@flyingcircus.io) ---
Going through the log I can see that aside from 'sync' and the workers ther=
e is
a tar process that is stuck since 13:20 and not making any progress. I can =
also
not see any IO on the block device.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
