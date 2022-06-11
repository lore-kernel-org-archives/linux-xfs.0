Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC0EC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 20:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiFKU0n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiFKU0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 16:26:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA189692B7
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 13:26:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CFACB80B49
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 20:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DC52C341CB
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654979199;
        bh=oy4d1yisagW+ZmDqFEWIhNOPW2tiNx+MI6tMKhRCr6Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YwaixsoV4bR5wJYR8S2ZYD9AwxNQxelvfwn95KIsLTVGnjULXkbzQrZuLjIdKZAJ6
         xpl/LAHgXF+9tVlarvv+xXt08M6gPYxSpaI7lKe7fbVE9SSjvwsEetpGiv/t4FnOa3
         gp4jT36G/aVI21VE/ZaLyeN5VH0eP8YkDibbsdDJIuGJIAhdldjDdcOqKLtL5ovH47
         wMnq2CU4sg9CDj554eBfxsU7jz10vR09IAtPiV+GldsD4hvykQDC2K0r6yyFz2lQ/0
         E9X3SYIWBHstaLv+Ad7iGIcCOpqKtaHMGG4NaV/dUPFcqFQlmDRwGPpueVS6a1jnQl
         AczUCX0AsQAmg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F179CC05FF5; Sat, 11 Jun 2022 20:26:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sat, 11 Jun 2022 20:26:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: akpm@linux-foundation.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-o37u8Cb3wy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #9 from Andrew Morton (akpm@linux-foundation.org) ---
Zorro, linux developers don't use buugzilla.  Nobody saw your most
recent comment.

Please resend it, as an emailed reply-to-all.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
