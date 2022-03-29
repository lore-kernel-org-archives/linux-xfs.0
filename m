Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16699C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 09:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiC2JUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiC2JUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 05:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E5A13DD4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 02:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D14960C35
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 09:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C96CBC34115
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 09:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648545537;
        bh=GKMlHuTJvjfcNviuf74JmvHez142KKymG5cU/rbNW+I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yzp5wukUe0Eq7yjk7W8S+ETwTieDAjgyA6wuobhB7BcLI1MVdO6pliHNEGSx1aLGm
         DdT1/TkLgqDIdWHFd9WxIAFfhROlPISsP/0z+mci/UmzK9OyC0JYnguRXSjYUKvF78
         gZ+vKQcPb982kzy7kvjDLDpdeGxzvpKJjBOIKHBjgOZ3cRr0gX7slM1iYfnKC+Es8Y
         UQe+Ypgsbugb80hDO24F9GiR8JtRVaRBraL74MmxSwiYp9E6DZ/XW/N9g9VaKdRAzf
         rVd/aBefyswbitxvrPNbOqt9gCIr+Z3rr94gCj0QROb3pIYm3zdtlYpcH50g8EiPV1
         KLZ82BPBuwVlg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B8AECC05FE2; Tue, 29 Mar 2022 09:18:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215693] [xfstests generic/673] file on XFS lose its sgid bit
 after reflink, if there's only sgid bit
Date:   Tue, 29 Mar 2022 09:18:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215693-201763-YOR9KYpYYO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215693-201763@https.bugzilla.kernel.org/>
References: <bug-215693-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215693

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #1 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Is this issue still happening? was it also discussed any maybe solved alrea=
dy,
like the other bug you mentioned? or should I poke the developers to get th=
ings
moving?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
