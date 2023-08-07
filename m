Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE41C001B0
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 18:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjHGSGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 14:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjHGSGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 14:06:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20681A6
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 11:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1D98620BB
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22496C433CD
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691431595;
        bh=TBGMFSnfrWGJanv0YUBjrj84aCqXDj7nA1R3jBFTrQ8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lPTagKeM1YcoYVyQbwpugYxQ9y/5nn2DVqdfltVy6GdnXu4g1BSgLh7jfpfPSmXnY
         hidRBhgntLZWL/K8yLWvh8HIJ3DJg99fhZSF/y6zXmWFE3Nom/FGEKHgWOF4rZCGFJ
         31iQGZs2N7Z9gXSmbFhYx7zgw28buEFT9E76hEa9Jq+GQJV/XOnZqOfuRP/yjqDxyv
         SKvG/vbybo7BF1mZ1emcYn+u9kEf3hwZm4ECYr+JqKf9xYI6KH8eCMQeVycGx3I0f9
         hDRijriHvAYU2GzwuDdpeyUJrLo44YtF4xKwGdeUVuj7C9C4zWxdSUqbvBo+59chpc
         hnPDzqgNB/Ydg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 14652C53BD1; Mon,  7 Aug 2023 18:06:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 18:06:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xani666@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-1lboTqhyfY@https.bugzilla.kernel.org/>
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

--- Comment #2 from Mariusz Gronczewski (xani666@gmail.com) ---
It did, thanks for help! Why is that reported as "corruption of in-memory d=
ata"
?

The filesystem on other machine also had exactly 3 disconnected inodes

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 0 is 559936 in ag 2 (inode=3D34114368)
agi unlinked bucket 42 is 175466 in ag 2 (inode=3D33729898)
agi unlinked bucket 53 is 198581 in ag 2 (inode=3D33753013)
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 33729898, would move to lost+found
disconnected inode 33753013, would move to lost+found
disconnected inode 34114368, would move to lost+found
Phase 7 - verify link counts...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
