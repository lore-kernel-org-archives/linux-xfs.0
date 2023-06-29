Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7323EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 07:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjF2HKj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 03:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjF2HKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 03:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185F02114
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 00:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79C0614D7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 07:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12D5DC433CC
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 07:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688022636;
        bh=y+VUDPaVjiDOYBMuu9Ux9KPNSUrG8HnD2ecAUX7/mXQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m2bWjXxwwzKJ1ajhr7hSu0uoSa8BC9MY4Vi0GJcXuwTWUqs4pnxRDsDBTBcho7jaz
         mFcJhwkxpeUno1/R4gXgvpf0EXvD32tC+YV2kdR541N28cl28q2fwJwxtQ2pUdTThH
         WzV5cXgazvXE+FUP24epUPZKqszJ+GCDaGRSzl49EeA+CsbMnHafiiL49UvGwbr7HU
         vjSnFFVj5oPwM1ZRsUhlQKWaRNKDV+F9wvg8Fxobt6f5S8dQAePqD1m7ZfsyET9FjD
         iaXND2nCfDvxtngyaXyH+qiH/jUjAxBPn20R5mOj2IZe9aatY9t7TLS4GfW1iX38RX
         rtQNp/3MQGZrw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02072C53BCD; Thu, 29 Jun 2023 07:10:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217604] Kernel metadata repair facility is not available, but
 kernel has XFS_ONLINE_REPAIR=y
Date:   Thu, 29 Jun 2023 07:10:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: j.fikar@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217604-201763-INXcwbWsOM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217604-201763@https.bugzilla.kernel.org/>
References: <bug-217604-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217604

j.fikar@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DOCUMENTED

--- Comment #2 from j.fikar@gmail.com ---
OK Dave, I'll do that. Maybe the help for XFS_ONLINE_REPAIR can mention tha=
t it
is not yet working, to avoid future confusion.

Actually, I was reporting another kernel bug (vmalloc error), which was
probably seen before and currently it is in network drivers (no idea, why i=
t is
there).

I'm telling you, as it might be XFS related. I see the bug exactly once a d=
ay
and when I look at my cron.daily jobs, it happens during xfs_fsr run.

https://bugzilla.kernel.org/show_bug.cgi?id=3D217502

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
