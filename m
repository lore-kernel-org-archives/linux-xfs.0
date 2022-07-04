Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3A8C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jul 2022 16:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiGDQV5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jul 2022 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiGDQV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jul 2022 12:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A190BD0
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jul 2022 09:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F0DE61440
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jul 2022 16:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0887C341D3
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jul 2022 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656951714;
        bh=AA6NtL0p/+BkVWnKILo0qiYMncuUxFc1uQmaZejUMmw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BLeo/8z4JBIYCw7fhZqS3pezMeABD54B0DsL6L/0A33CTK3Txg/Xn7dLzD2ZNXj7h
         P/Ybrzr9LrGZarxLSYYnjXZuq3HX6//+UUL/Yd2i3wsrBmrUabKe33R5m3g0Vq6rY1
         301+yteuahqypNiJcXUAhfWhOEZwcZSZobpdSvhGQkvmPmp12H7v/YtHpyr/MVftyr
         3x3AzZv8IU0HHIYKtWZnBRK3ELjsoYZlFWxQ4IAqK5jqNZpHsHpWLTW6hrMXggZZSc
         xVmNWhiC5mCoRvMI+EzY6M1K4lTFtPKvOVi1VC3uaXCfLew5gakusuG9J7Mxvb3VFK
         dPLPOt7s6WioA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8E2B6CC13B0; Mon,  4 Jul 2022 16:21:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216151] kernel panic after BUG: KASAN: use-after-free in
 _copy_to_iter+0x830/0x1030
Date:   Mon, 04 Jul 2022 16:21:54 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216151-201763-cMaHQpy6a0@https.bugzilla.kernel.org/>
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

--- Comment #5 from Chuck Lever (chuck.lever@oracle.com) ---
Commit a23dd544debc ("SUNRPC: Fix READ_PLUS crasher"), which addresses this
issue, appears in v5.19-rc5.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
