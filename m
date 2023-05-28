Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55520C77B7C
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 10:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjE1KW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 06:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1KW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 06:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677EBD
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 03:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8373C60C50
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC65BC433A4
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685269346;
        bh=VZvLeokv15doElDO/LHYwnmi7qDonfERXbQ4L64w1dc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QeXU+RONRWbIb1OSj+aKjr315e49aUWFa/7R94TY6uX3JUJ6E0hwlXafRu5I1CUx4
         fSlvDkBikF7mGteYcA6Ei32MM0Z9Ghj3IT0N7khv/YsCF7H2cBKiT5PUb4xvumn6gH
         2xXEJAdxTYYaYt5a+41tfgXvPbHi9kqHtcpgK9nq99VWRaDt+EQ1pfrOx80xlFHHVh
         Qwu4wGQHtkSbBY9cOJHYsL3i//A7uRzaTH4dIRm3n8UPZjU0rcH+AhGI88buKjKiGu
         3I4uAkSidYCJ3BC9Jycu70dSpertb+5u6Neg1yO5P9lcl3tz++PoJCATucEQbMgpMT
         i8xm0a91l77OQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DCA0FC43144; Sun, 28 May 2023 10:22:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217496] XFS metadata corruption in 6.3 - 6.3.4 when using
 stripes
Date:   Sun, 28 May 2023 10:22:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit bug_status bug_file_loc
 cf_kernel_version resolution cf_regression
Message-ID: <bug-217496-201763-zePVGpmeXo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217496-201763@https.bugzilla.kernel.org/>
References: <bug-217496-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217496

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |74c36a8689d3d8ca9d9e96759c9
                   |                            |bbf337e049097
             Status|NEW                         |RESOLVED
                URL|                            |https://bugzilla.redhat.com
                   |                            |/show_bug.cgi?id=3D2208553
     Kernel Version|                            |6.3-6.3.4
         Resolution|---                         |CODE_FIX
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
