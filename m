Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62853EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 22:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjGCWax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 18:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjGCWaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 18:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D66DE69
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 15:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B126108B
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 22:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 484D1C433CA
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688423450;
        bh=31ffmsl14ELTB3DdrOraU8vY3r6XgQ7G6XXid/264Wc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o5O9pDcV1oCvEyOXaorFD0gcTevDxObe+50LJDEYlJgNUF4ypFNVHhEgkoL7H/jQE
         zajwwFlSIhBjF1g6MydwdSBkM14o0SDLprUaDECRX57NY1rHtvLIdx6Q4ZYlwq+GSP
         X9vR7GngKstgIHWlpbOL7e6FX8/Fie6P+iMYFhIn4B1rhG7T/pj5o23xitcME7rbQt
         whDLsLJpBiKCT+MdTi0mCy1jzwGMqjGz0Qpj+/uIWOU/DjCzV368fK6ICE1b846XZR
         EOUgGWYkefVwa+styrE0oloU6AqiIODFMkVA4JaSELd9cnrZaU1fpyRjiT+VZ0b1Yd
         KUk0TN4T+x/tg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 37536C53BD3; Mon,  3 Jul 2023 22:30:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Mon, 03 Jul 2023 22:30:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-kZ0EnQ2aFc@https.bugzilla.kernel.org/>
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

--- Comment #7 from Dave Chinner (david@fromorbit.com) ---
On Mon, Jul 03, 2023 at 07:56:36PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217572
>=20
> --- Comment #6 from Christian Theune (ct@flyingcircus.io) ---
> Daniel pointed me to this patch they're considering as a valid fix:
>
> https://lore.kernel.org/linux-fsdevel/20221129001632.GX3600936@dread.disa=
ster.area/

No, that has nothing to do with the problem you are seeing on 6.1.31
kernels. That was a fix for a regression introduced in 6.3-rc1, and
hence does not exist in 6.1.y kernels.

The problem you are tripping over appears to be a livelock in the
page cache iterator infrastructure, not an issue with the filesystem
itself. This has been seen occasionally (maybe once every couple of
months of testing across the entire dev community) during testing
since large folios were enabled in the page cache, but nobody has
been able to reproduce it reliably enough to be able to isolate the
root cause and fix it yet.

If you can reproduce it reliably and quickly, then putting together
a recipe that we can use to trigger it would be a great help.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
