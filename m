Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795F7C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 10:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjE1KXC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 06:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1KXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 06:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0469BD
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 03:23:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BAB60C50
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9A82C433A4
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685269379;
        bh=2ycNA8jQxuTKKEYJPcj1VCgeeBgwiziXLpaHBcV7tEI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mOSHxWSrtaNWs627BjmFYPucLbll6ctRb4RMgq9i2AnOj7y1h5MnBKa9Bg28MjWwN
         wRCRx8lOJOV+pQw01EaYGmlxJjX0D1XnbtX0REkob0ugtvyxMkGNfUJbUGhJ3/1x9c
         yBHtNVV+gAw4dZxhaw2TNWpQpYm0HZCXC6jLZ9rtID2jDrYOpgoWbWZ+g/iJKS84a2
         +TbM3VlXPEYDRi+5UZXj+6v+01/O7k8r/lzz89/gEjU3bT93RDLmC/ILnwO3lS0vU/
         Ojsfyzqma1rv9MIZoGOcf3MhOlvDTEZTPHKczagljHUSwT/L1mMKy5Jd9kgiddYyU0
         sEzPKHZbtaWaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A14BC43145; Sun, 28 May 2023 10:22:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217496] XFS metadata corruption in 6.3 - 6.3.4 when using
 stripes
Date:   Sun, 28 May 2023 10:22:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217496-201763-vdQW68FTGo@https.bugzilla.kernel.org/>
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

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
I want to hope patch 9419092fb2630c30e4ffeb9ef61007ef0c61827a will be submi=
tted
for stable ASAP.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
