Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B1BC04FE1
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbjHHRZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjHHRZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 13:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C96420276
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C17625AC
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB314C433D9
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691506313;
        bh=/zBx8sqSYk6n/jXnkLEUwBLV1PH59HHTeeLdIpwGCmI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Zknrf2aZyhL1lDqfX9ts4ju5TK7fOxl+XABwxz3tstbXSzuNz0Zo9EKxweap/209V
         yv3rvh6bLaZDEOcytj/gzN1X7lg5BrmmuSKDsTTwjJylEtuUf3p1Q9cGiFmjzlYuIa
         jjMcLD2ag8/YWL+00QZdcrKZKU0KquA/fabHG7EyHF7yl1hMHZ6pU5TISL8SGtpz48
         lIlVyOuiewMXI9tOrLjN9uKq7wB1LIAZK9ly8UMK2QHkkE/VTsJKBxsceE1m8YRCb9
         JUnM927iUEQ4B3d/4w/D09JbUSlLXRtlNX82mXdNvMXA5njelVfIeCdU0Oi/9TPjwF
         tqm/WaHiyg7UA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CB6EDC4332E; Tue,  8 Aug 2023 14:51:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 14:51:53 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217769-201763-8s0wjB9n3S@https.bugzilla.kernel.org/>
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

--- Comment #8 from Mariusz Gronczewski (xani666@gmail.com) ---
Created attachment 304795
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304795&action=3Dedit
Metadata dump

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
