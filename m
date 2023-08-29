Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41902C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241186AbjH2XnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbjH2Xmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1981BB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD1163F0C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F96CC433BD
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693352563;
        bh=KpzmP+VYRrGSZRLu8C4D08nKNZPuCENhXGX4+Uk2cMw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YIqjTYlaXN3EMqr60xryz+hNNcdU/2UA5KJjZl0fNF5Q8KvzEHUn2O1DUxWlr1xjB
         zdlpiAuhpMbr569ZqLw1oE2IRLO7pk5oHjUeifJ+hQBYl+HkkFVNtkBicFJ5Rs9P3X
         QfNpRfa3d2UcZanneeUgD3zHn8PI2gIZUOHEv1saqG7CsgrR2VVit2Ux1UoKpa1Pk6
         tq/aYtnn/tzhY5lEaKGuAKe9xFn/BzXNCGAd+PLMziJVbi3CGduUHa12afWV5SVN7q
         c1s3Ksmz0wmsJ6IW9c7j2+KMww1L4NSZbOZajizSz8TWqffoKBYAqC1tbjpSELqWe7
         0xbeOr+/wMSaw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 01E76C53BD0; Tue, 29 Aug 2023 23:42:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 29 Aug 2023 23:42:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-hOfPrfWktm@https.bugzilla.kernel.org/>
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

--- Comment #16 from Darrick J. Wong (djwong@kernel.org) ---
On Wed, Aug 09, 2023 at 07:10:03PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217769
>=20
> --- Comment #15 from Richard W.M. Jones (rjones@redhat.com) ---
> No problems.  We had a similar bug reported internally that
> happens on VMware guests, and I'm just trying to rule out VMware
> as a factor.

Does this:
https://lore.kernel.org/linux-xfs/20230829232043.GE28186@frogsfrogsfrogs/T/=
#u

help in any way?

--D

> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
