Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C37FECAAA2
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 18:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiH1Sj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 14:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH1Sjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 14:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827F510C9
        for <linux-xfs@vger.kernel.org>; Sun, 28 Aug 2022 11:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6775A60DF6
        for <linux-xfs@vger.kernel.org>; Sun, 28 Aug 2022 18:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1D36C43140
        for <linux-xfs@vger.kernel.org>; Sun, 28 Aug 2022 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661711992;
        bh=wpshRyE69IP179v/Y87Ur1SYNU0vihKgxQcYAlg6Lw4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=olCg9h7XhrQHwgR5T8j6NWoTEZWN04CQAFG01+GmNVDKY8WtjgdsmJTX5l/ENCJtv
         F62ZN2uk2JTT64+AEFMYnhTE0LpaShBCSD1WjzxVTXh0D8L8HSpi/5gcq34YoE3Bo8
         H3cbgjlSsPYrA1+pLlCNL08qti/ZjWRIjC1pUuCdK72ghoS8RqfksqeaIZcwXvWuSG
         uB/0eOdKJ5wnPQ4Nt47mUS70yuXPNkOOJdnXMc/lRMAQWodLOYCKtsqJTZH3Qz43B3
         3/zHB9iOKkJKHBRYBTWL90RDyNP6lzFXdD0p/mLC8I6x6RKplIvreXJDUeEZOvqXyA
         /DgMj50PbqeLQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B0C4BC433E7; Sun, 28 Aug 2022 18:39:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216419] Internal error XFS_WANT_CORRUPTED_RETURN at line 442 of
 file fs/xfs/libxfs/xfs_alloc.c
Date:   Sun, 28 Aug 2022 18:39:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216419-201763-H4Jvdjg9VU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216419-201763@https.bugzilla.kernel.org/>
References: <bug-216419-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216419

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
