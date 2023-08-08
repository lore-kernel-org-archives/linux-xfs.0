Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DB1C04E69
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 17:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjHHRf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbjHHRfe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 13:35:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E68222E5
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233F2625AF
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87D43C43391
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691506507;
        bh=kf7PtziT/i4OHEAl5+CM182f1FHMr84W07TQ+FY/uT8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=S536PleOc2D3lRwwdMJ5su0jPYAo64obZxYKm0LzOPw5WA9+3MvoJ65RhClL/kb6C
         NvZRnzx5YFRRvWN1+q7agt/M+iIB0mBirUm1IEmzGYHN/iEC6q2YQEgOdt2bOmvgfO
         NtGQNwBafBYpsj1yh7C5q6PDPZ6g1d0dK3wOE3bovax3DbDIO1x/YCd6wfhzKedBiV
         HbgPcQhjXGs5by4hTxzeSpfd14r296s5YsE93HCOPGDtE6tsaxoSfbQHNQwiRMNHqb
         oSiwiXtiZOaaUpbne3QP2w0Md/jEkQUr4VBBgErjMGivu/0qbnEZz2k0EyLlyhGa6p
         QqdGZ8BABU8ag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 760C6C53BD1; Tue,  8 Aug 2023 14:55:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 14:55:06 +0000
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
Message-ID: <bug-217769-201763-4R6u3doUWL@https.bugzilla.kernel.org/>
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

--- Comment #10 from Mariusz Gronczewski (xani666@gmail.com) ---
I've attached metadata dump before and after xfs_repair

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
