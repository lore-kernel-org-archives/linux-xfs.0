Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ECBC001DB
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 22:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjHHWHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjHHWHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 18:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B8FE51
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 15:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8018A62D9E
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 22:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDCFCC433CD
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 22:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691532439;
        bh=mpO+5/tGMjscjqZ+Wh313++jAbWRfJ3iBA5btQNcpr4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i00kjFHDzp48GtoMUhTRmnANvevNwG6Dx68UHwrHZgRraY91+qIGUXK2bNgHBunB1
         7TJGIv+tm/iC7WjMtixKjQ2T/IYWCWv/Rm+3ws29LFoOGGh4r/sMqtYwhADJW4EOL0
         LNfUoTYa5jKUXKG4L3vJQP1+nO1nfDmvCMEKXRC7XQ47750uwLUKo5MYVxgUROxE3o
         HWTah1xo/help7l6EJmA+2CXaU5DSSPUd+hfHm/03swlbzTkM/hibt/EC02bBbNxpp
         AixjxHLy4ZuRDxkXEx//glaGib0O5gkCd4uxibU1SkMzjYj/Xc6c7qdCMWsKHPHLUQ
         1sT+tgzEq+KEQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CB61EC53BD0; Tue,  8 Aug 2023 22:07:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 22:07:19 +0000
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
Message-ID: <bug-217769-201763-aygvVCyCsS@https.bugzilla.kernel.org/>
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

--- Comment #12 from Mariusz Gronczewski (xani666@gmail.com) ---
The system was never marked as dirty so fsck (which fixed the problem) wasn=
't
happening on boot. So yeah, once I upgraded kernel if it failed the first t=
ime
it failed on every reboot after till manually fscking or downgrading kernel.

On the one machine where it failed after the boot (reading of certain files
triggered it), that too was repeatable

Maybe on "corruption of in-memory data" driver should also mark FS as dirty?
After all if data is corrupted from actual memory error (and not like here,
from loading bad data) there is nonzero chance some of that data ended up b=
eing
written to disk

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
