Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AB7EB64DC
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 14:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjGCOK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjGCOKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 10:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73552E5D
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 07:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E14160F56
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 14:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08426C43397
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688393432;
        bh=YbSzFXPGaAfE+hP40MLr93pEOvLumUzvSJDSdYNZWhg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DWmNCOnncsDDrB3fpo70ERi05t64ra+54ifQ6KX7UH9RgFrGNKui7plFHVSht0x8S
         9HcNEwdnFTOiRhwCSxyJV1qC/FWanhvhEorX6A4iQyEEYw79zY2AYnTkn4nDWFvJWe
         866+8TWmBSVFRRPOsK7f3WU6FVrd+wA5lQirWmARHgbMYL7jFmVv3Nth2gHRcCjoTa
         nDIRh2cY0NMWt5SxCufbXixRKjaIDpMbnaHowa0kGEJo4WF5C51nDqlKoZqpLb7iv3
         gKLP6ys6ZAqRufeRySE/TnQ0fnRRT44g1SjmcpPKeiUFU1Ns7cflPCQV7/ISDttudi
         Oo5EGdT7ZxIFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ECBF4C53BD2; Mon,  3 Jul 2023 14:10:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Mon, 03 Jul 2023 14:10:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mironov.ivan@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217572-201763-Af0rfKd1p8@https.bugzilla.kernel.org/>
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

Ivan Mironov (mironov.ivan@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mironov.ivan@gmail.com

--- Comment #5 from Ivan Mironov (mironov.ivan@gmail.com) ---
It looks like I had similar issues on Fedora with 6.3.* kernels, XFS and
RocksDB: https://bugzilla.redhat.com/show_bug.cgi?id=3D2213967

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
