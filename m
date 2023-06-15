Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA736EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 03:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbjFODfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 23:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjFODfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 23:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A0C1FF9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA52960EC6
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 03:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 435C0C43397
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 03:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686800129;
        bh=QK1RwQLZMfL84+8r0G6f29sp+00Nxgj3wW3mcGAYJq0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JxMj0mo6xtLR+7iDeTJx14lfE6br0seCNda5/hIjgpyiJKjPloKCOTw3fpj4J9rnT
         md4qwUwnUyuHTGSKCgRHSLwK3/eBLIvKJD87L1Yl1v8C8uJTmgBix3U7a8xF6odvkK
         Q8TSwCE0j5at9JNCFXDNyrJ18p/66T6Vf+C1FpOHatRTVxhO3C/lSv7ihcgo3Eao9l
         IgnZuZGPEyBA0pvXZMC5HX/XeZFgzPJD20yKCUxXnmkQRa93hocgiLCeNBhHgZZyon
         1oI7o6XgLmjcF6xt5AiQ+dK4oistzSzTXiYDI7GeJvCN6ONNwc8HeQgiHoF4FwGlZJ
         rubbj2zbbPR6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 34BABC53BD3; Thu, 15 Jun 2023 03:35:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Thu, 15 Jun 2023 03:35:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: saxophonebritish@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216110-201763-fasPK8fACH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216110-201763@https.bugzilla.kernel.org/>
References: <bug-216110-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216110

swindlerproduct (saxophonebritish@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |saxophonebritish@gmail.com

--- Comment #6 from swindlerproduct (saxophonebritish@gmail.com) ---
As Darrick pointed out, this is the upstream bug tracker, and upstream cann=
ot
assist users with distribution kernels, especially on older distributions.
https://blobopera.io

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
