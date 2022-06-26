Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D542C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 21:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiFZVEP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 17:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiFZVEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 17:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC342388D
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 14:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91BE5B80DF5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59D7EC341D2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656277451;
        bh=t+Pt43C5xO3KW9dslDNOF7gVI0oqBLcIrJwVWZO/8ko=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R65n/BEM/7Ahfcbk/nEYtCSkOz3zjBVwpc5vkVrj692bp+BoZ3I0Q3Mcnkv87whLc
         fi8SWRirT7HhEH8T0zww/MLsLvDGVwJ5zIH3/RBCWhNtK7s+HYz+Aw2CNGOaQj+8Rl
         +xiM+tpwhhUB7PXmUvs8qcbA16KnDtKXoaNDecJyAxqbHhWblrtxygntZo+EHXU1rf
         h7D3ZmnByUp+jX0tTHa0ujlkyrg4ePGcRBygOgJOnJ5DXP8cdvT+mTM6j55CvgGbwU
         VxQjcIsxIaV+h63fT8LWJAn/hKiXkk7P/yXJw1rAKp/0Nv67dYjNlgox/M8CyczWY7
         UUgL+8NLwzC3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 48FA2CC13B3; Sun, 26 Jun 2022 21:04:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216151] kernel panic after BUG: KASAN: use-after-free in
 _copy_to_iter+0x830/0x1030
Date:   Sun, 26 Jun 2022 21:04:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chuck.lever@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216151-201763-OS2gMazDTt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216151-201763@https.bugzilla.kernel.org/>
References: <bug-216151-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216151

Chuck Lever (chuck.lever@oracle.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chuck.lever@oracle.com

--- Comment #4 from Chuck Lever (chuck.lever@oracle.com) ---
You can disable the client's use of NFSv4.2's READ_PLUS operation:

209 config NFS_V4_2_READ_PLUS
210         bool "NFS: Enable support for the NFSv4.2 READ_PLUS operation"
211         depends on NFS_V4_2
212         default n
213         help
214          This is intended for developers only. The READ_PLUS operation =
has
215          been shown to have issues under specific conditions and should=
 not
216          be used in production.

As an experiment to see if the problem goes away.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
