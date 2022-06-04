Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4701C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jun 2022 16:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiFDQZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Jun 2022 12:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiFDQZX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Jun 2022 12:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6298107
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 09:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5104C60E76
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 16:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F412C341C8
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654359920;
        bh=bfk/D2ghnha/2IIXfOOyti4A1vEonCF1C03RyuLJ5AM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Vad8QYP9TKW4TmTrbX2KOxANY3aCiKUagzN+isS1FUJ1w8gSfObG+GSj/GB6srbF8
         nG3J8qFzhazjTvKGP+PaD0lAN+RWobDdnMjPxU/QIU+6TuO0y1kx/8QtsnVgfx7eHQ
         Wyw7p0xx97rwcrHDZms9PYBJ5zGlnyEc4PEysbE4lWsb3qHeaK/7TEDoydGU3IbPNm
         eg+eqMT2jy67cyuwnjHcSWN6FW6lQK2CI2U3u2CuRUEJ5tl1kAL2GGH3nHX8hZoUvN
         6Qf58wCyc7bZ50GCXTuJYqHX7MQ8k1wHKmQbbxt3tE+3eelCWACVBVU3oGHJZCKWxv
         baQ2yHipQFkCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 86CC9CC13B1; Sat,  4 Jun 2022 16:25:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Sat, 04 Jun 2022 16:25:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: clockwork80@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216007-201763-2ngVVg0hpq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

Jordi (clockwork80@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |clockwork80@gmail.com

--- Comment #24 from Jordi (clockwork80@gmail.com) ---
Hi

I can reproduce the issue with ext4 filesystem. I am checking at the moment
with different kernels from the Gentoo distro:
5.15.41
5.17.1
5.17.5
5.18.1-r2 (patch should be already applied here)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
