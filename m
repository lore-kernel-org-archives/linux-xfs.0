Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49636C77B7C
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 10:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjE1K2E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 06:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1K2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 06:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C9BBD
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 03:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4423860CA0
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A34F4C433A1
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685269681;
        bh=vZ4hPAr0j1N+5lOGIt/9u7qfZ4NQsxdC4S6h/BsR9ZY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=C7j+9sHdPf7AVdEThNySmCoSYcBieUhocuUI5dGxtWTLNTnGj8ZNuJFg2bWOv2RkX
         wAlRrjvkPQeBrkoJNeHVTlUglglehcGr8vtTbb49UcUFxvyAyFVXUKWYJ4WKoAF/uT
         LXQDsVhFHvXtgnWNF6XaC6gbb2N9tyDjarm+3gvUin5j9RGxZcjtdNJjO40jhOTdcj
         oqDNftqZWl/RQ2MmjBJkRc7N6OkdcsQxj0Mau+zjrLJ2Cn56obzArx7FPHGLelRJLj
         Uy8dFSJZo2CSJVz+HoSrBeZf992fQp65j3KvMeVu1vB9c1wsS0S9JeX+nkIE4ClpZb
         k5OAiHKDGkrkA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 93D84C43142; Sun, 28 May 2023 10:28:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217496] XFS metadata corruption in 6.3 - 6.3.4 when using
 stripes
Date:   Sun, 28 May 2023 10:28:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: holger@applied-asynchrony.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217496-201763-uxhcOmac08@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217496-201763@https.bugzilla.kernel.org/>
References: <bug-217496-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217496

Holger Hoffst=C3=A4tte (holger@applied-asynchrony.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |holger@applied-asynchrony.c
                   |                            |om

--- Comment #2 from Holger Hoffst=C3=A4tte (holger@applied-asynchrony.com) =
---
(In reply to Artem S. Tashkinov from comment #1)
> I want to hope patch 9419092fb2630c30e4ffeb9ef61007ef0c61827a will be
> submitted for stable ASAP.

It is already queued for 6.3.5.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
