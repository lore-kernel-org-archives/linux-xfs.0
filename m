Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC01EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 22:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjGEWHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjGEWHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 18:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCCD1706
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 15:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C93D161784
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 22:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 388C5C43397
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 22:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688594838;
        bh=YyFgO/uHs5LgCuWwlZB6oRsQmBq+Q3CMtCKnAu8rkmc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hl4HqjX0JKaRDGwACeZ47e0oYI9KrZi+X44cXNOhq5dZqMqZyyDxiIj8pWFEunlHM
         c2KTU9aQGCnqDcb2r1MlILID0PsRDgLUldX/lVDP8K0V32cmGxROnO/Os0Qfez1wWS
         pDmgoDJgtw4p3GjZo+xAEpCSOgwrZSDsaLzIwVm2cV10Jt6flzYxh3zUHjsLNcq8mM
         BihTwSrZ+ISaJ6DScn7yCq0r2tBSsQ4k7n/VjLPuxgd3+6Ai9VV8luJdgfqIpfg9UM
         rWshns9MgDrWHyHxQ3kqe96YwH1uiZD8iiPdE+soYGPoKuMzh0pnpqYAFA8bfdim9c
         WVpmilDWjUfiQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2A3EDC53BD2; Wed,  5 Jul 2023 22:07:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Wed, 05 Jul 2023 22:07:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sam@gentoo.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-6nuT4mk9DJ@https.bugzilla.kernel.org/>
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

--- Comment #9 from Sam James (sam@gentoo.org) ---
Any chance this one is related to
https://bugzilla.kernel.org/show_bug.cgi?id=3D216646? It sounds similar in =
terms
of symptoms (the eventual lockup & stalled tasks) at least.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
