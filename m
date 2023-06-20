Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A0EEB64D8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 15:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjFTPWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjFTPWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 11:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5171704
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 08:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 783A2612CB
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC8AAC433CB
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687274501;
        bh=5WeuJvVCDBYuQSwuxXX2s0ILjdH3QD7hv04/Qz/qusk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MXXf78McFUIcXv7ULAwCNOhAOIDGxkRTMNSUrp45J4tPIxpugPWhdVlwK23WN9l7E
         xhQgadXrUNEiquRTSnl2pYEAd5dCPmqFYoHzHLmi90E0F4Hu64twL06cg9qH5qLm0p
         japgBvIMERstSrCqUxS8P1F07DFmDBUhRUY3zUnRatHZ+oz4mRmk0iHkgQE1yx9+A1
         GEJnhoV4vb6TtjSmaXlRM1IDpSXHRFRX+C8HlZsTsVVsVQC5JexV38Q+BNF77icihR
         beKfg+iCGqpgJxxlqMOVjI3pKVYCodeEOoPfouyifMwRrWkhOu1pVQMcXUhQv+R69g
         Q/AvrVlhFHD9w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CBBDAC53BD0; Tue, 20 Jun 2023 15:21:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 20 Jun 2023 15:21:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@nerdbynature.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217572-201763-DjNQXleyB0@https.bugzilla.kernel.org/>
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

Christian Kujau (kernel@nerdbynature.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@nerdbynature.de

--- Comment #3 from Christian Kujau (kernel@nerdbynature.de) ---
So, these "blocked for more than" warnings are somewhat documented in
https://www.kernel.org/doc/html/latest/admin-guide/sysctl/kernel.html#hung-=
task-timeout-secs
and these warnings can be disabled.

These "rcu_preempt self-detected stall on CPU" messages may not be related =
to
XFS at all, see e.g. https://stackoverflow.com/a/35403677. Maybe the system=
 is
just too busy while doing file system operations, hence "xfs" showing up in
these backtraces.

Does this happen when dumping smaller databases too? Did this happen with
earlier kernels? With newer ones?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
