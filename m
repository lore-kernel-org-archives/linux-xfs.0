Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B05EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 04:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjGDEWm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 00:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGDEWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 00:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9D0EA
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 21:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B28456112D
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 04:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2090AC433CC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 04:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688444560;
        bh=HNioCF3O7grki3tIMc4zINJwEb2l5Vh6zBFRa7oinDU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jwWTiE+pYqjRu19b9uRybG9ePUvLPW5aOH3Qv1qbKWhgSg6SbODOmHpW1n8/S4OB8
         cGA45mUUNU0431u0R16/LoVYWOlm6KR30EPAMAQNpITPXnW8iKzpUZ+BTaYR7xTlpT
         VUzBQnEeI7x7F3kGqo6pJoVlhIeSS6haQVOBBeglsfc8PoYmSrBqNFS+gwJhjFTUk+
         Hgk2Vr6iLZ8TfifkIBUisak6i4ToL6EkmErYJTwfu0ukWSTv/QUG6u+QdsNd0OTizs
         iO8R1lM59SBfUg5lYo/eIPNz3rCnoDVuVWG/21I+MAc6eY2rbvoeDqJvRBEnWR/+Wb
         z/oyGIyZnaB2w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0CB78C53BCD; Tue,  4 Jul 2023 04:22:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 04 Jul 2023 04:22:39 +0000
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
Message-ID: <bug-217572-201763-gDWskmMcCP@https.bugzilla.kernel.org/>
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

--- Comment #8 from Christian Theune (ct@flyingcircus.io) ---
Ah, great, thanks! Superficially it looked related, but I saw that the patch
never made it to 6.1.

I have only seen it once yet, too. If I can make out anything to make
reproduction more likely, I'll make sure to let you know.

As Daniel isn't on CC on this, I'll let him know as well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
