Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D20C38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 02:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJ3CnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 22:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3CnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 22:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C03833A3E
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 19:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3EE260BFB
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 02:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CA69C43470
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 02:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667097784;
        bh=I70LevGtnYSiS5M1bydeNqq2DYOAvg4IF3T+DwEj48A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VgnQX9OAnIbq0BOfhIL277Lq66H/wquZVDIcqXagjBy/Oaw7NcjX1dHokEHHmrzR6
         9kQ4Zyt0RkNBkMqqI2Sg5o/tqoIYfkssDLNj7uz9Sl2SJ7sdUuPdWIzSF/faQk9vi5
         aj9fTD3Q+1vCsXxlcR8en/jHNDPcMY3519sY+EgtkqoD8MDadHq9klGQVVrI68Co3d
         GL5n9CV/OmzsxjjBOGTb7STMXYUHh4KYJ3ke1xP1E8fBzH2L80FlJ5ke0GwwLDpaN2
         Hay9GRVObHu2QENpoBJVyDJbw790DyG4AFUMEdudEvZ+sK7GnMVaHfhz/wx7z+xTA8
         9vTXRWBg550UA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0DA85C433E7; Sun, 30 Oct 2022 02:43:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216639] [xfstests] WARNING: CPU: 1 PID: 429349 at
 mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
Date:   Sun, 30 Oct 2022 02:43:03 +0000
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
Message-ID: <bug-216639-201763-Ui0Mh0P7HQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216639-201763@https.bugzilla.kernel.org/>
References: <bug-216639-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216639

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
BTW, I didn't hit this warning on ext4.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
