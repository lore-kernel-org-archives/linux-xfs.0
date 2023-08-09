Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89568C04A94
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 16:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjHIQnr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjHIQnr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 12:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0581BD9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 09:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433B6640B3
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 16:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A7F1C43391
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691599425;
        bh=7Q1poei0wjv0i5311bDoxUsmDQQkxSFbcTRwzCkldNQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tnwt6V0VgJMj/urw64uCyVDmCGDc0goBe/Yys4aEEIzVULM58Ps1Tk0NuwHkulFRH
         ytJeof6wi8uWY2LAfLrmsiPEsjX6sC4WXXTOjtVe7G0PEa/gvyr7RGgvRtLIyKFNNW
         cOKkhLUH5tl9M4JAATY13dGNq5JuxgJad2MzN1UUcR19wleyAp78sAg/+SuD9h0fn6
         LDM1YdzFoE0n7sBrdvOLcrDpw/dXBTCVgBMdByUE4meYef8lMI7vQl+qxG0FYQs1lN
         sj/mfMVL8uMThbZpC8DBLcIypXFcVapEzwCZ0Zetd2544tzc4dg64YlSzdHnWfk1yU
         /EJ/IIwia65PA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 84546C53BD4; Wed,  9 Aug 2023 16:43:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Wed, 09 Aug 2023 16:43:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rjones@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-GCNeLFjj6j@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

--- Comment #13 from Richard W.M. Jones (rjones@redhat.com) ---
Was VMware (the hypervisor) ever involved here, eg. were these
VMware guests, was VMware Tools installed, were they converted
from VMware to KVM, or anything similar?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
