Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8D3E732CA
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 13:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjI1NGR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 09:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjI1NGQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 09:06:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D141A2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 06:06:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDBDAC43391
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695906373;
        bh=34rF1x0pA3zUDAOJmyobIWtKm+I+XiOyjk+pCa2nhvI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=meHIxyYnehvEm7h5HEawJddobE+weE8G9AQCdQCx9PEoqIn4y5Zuldc1JupkepuIc
         OLevOanVVyOcK5l6IKWYqjo8R6ak89RxtRJVi7n1cf63BxMFX9TPdGu4ek2Dkxxg0W
         vDhpB6YBrq93WGkCLHhzctmQtmhIYv0BzrR5Q2HqhGgjNpmEOZ5x1mujno5I0RIDGX
         2gM4QuPxF048iE3FN4eOaUiWy05O2w/Dx3lfKHti0G2NBENxiQIQg6O+bdDVlHVeUl
         wXvNTgIsa0AVW3i0xH9DTCrX8EoJfgXw6HKj1+J5nJB83yup4JaV16esepiw4AtYX9
         5OV6TnSsI+1lA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B29F6C53BCD; Thu, 28 Sep 2023 13:06:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 28 Sep 2023 13:06:13 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-LLIaQBGbPY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #11 from Christian Theune (ct@flyingcircus.io) ---
Ok, so the issue didn't directly appear again after a reboot, but the
PostgreSQL needed vacuuming (and luckily didn't looks data again).

I can provoke some issues in the machine when booted, but they might be
after-effects in the filesystem due to the suspected memory bug dave mentio=
ned.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
