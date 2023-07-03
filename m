Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D59BC30654
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 19:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjGCT4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 15:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjGCT4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 15:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1D5E5F
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 12:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6EFB6101C
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 19:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5647EC433CC
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688414197;
        bh=YKdbp9+R5KnYCE/1njvW4lJ4BGmE+z4ebnO4xwaJlyM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Izxkyo7rpRe91/wSEGJRJ+5VQybm0VmqgjZ2qHEEPLu1GNnEe5poaH14uLV9x4GBh
         XRE0qEUsk1Tn1UAsTFaf58D92csO8HlGLvERIFClC2sam5SM3j9sWUSr1hs6iUZN7S
         NjCv1VxC2XjhGVX0XcyQfPFxesw58LamVtxkJfcqlwe9NREpS3N39cqu947hc3IdVO
         //7bqyYVXxFmro8Esn+gGstfkLmNU5tGpI4f64JuoMglP4Wnp6A2tRDpv/v7tAmEQm
         yQKqFpOq0XxbIRL5sqr5UcNfECVGUk7kcupZD3pCJ88cL2z1TI7hM1/N/2tcVCEyya
         EHexUJiwjHqyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 44C30C53BCD; Mon,  3 Jul 2023 19:56:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Mon, 03 Jul 2023 19:56:36 +0000
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
Message-ID: <bug-217572-201763-NK8GwkLh1R@https.bugzilla.kernel.org/>
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

--- Comment #6 from Christian Theune (ct@flyingcircus.io) ---
Daniel pointed me to this patch they're considering as a valid fix:
https://lore.kernel.org/linux-fsdevel/20221129001632.GX3600936@dread.disast=
er.area/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
