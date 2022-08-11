Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED92C19F2D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 07:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiHKHEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 03:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiHKHEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 03:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D38E46D
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 00:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87123614B3
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 07:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4FF9C43140
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 07:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660201472;
        bh=6FE/UndFtS7Zksqpo6sBgHmtIEhQJjFSvQ/HA/QKZ5k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dWyCjwHRiWXLlPi95+pf7oxNbgxxJI110oIntnaGbj/+NT3YdOggYWPpiRLX9wiZK
         QMkPBvCPPJTSxgqgeVZ8n+sy2cx6MwKH9eQaekxywqBfiRta/P1At647spd4PH7bQp
         3s5ZWlh+2GbvxbNs6ZSLK2cX2pfKkIHL/d1qDHwRPyci6aRUSlw9SGwqSojmXaEKHB
         sfjLNlnaAQv6r7QzrCs3n7pGVnmsTWKVWgtC7mlgtAuUFJ4zMvA51wMzKpSoJcuss7
         USfEajJp2vdp3mmqvogOOkzdz89+OtvZBy7E/XihlgL0luNis2tkz37AUIwtsiuL0v
         dp3wIt9DO4Zow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D4065C433E9; Thu, 11 Aug 2022 07:04:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Thu, 11 Aug 2022 07:04:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-216343-201763-naK1B7R3v7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

zhoukete@126.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |high

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
