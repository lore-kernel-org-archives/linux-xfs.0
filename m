Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8A4EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 17:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjFTR0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 13:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFTR0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 13:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F6795
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 10:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B4B6133B
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 17:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E69D1C433D9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687282012;
        bh=BWvBTQKteymHGctXM4bANScBRr4EHame+hAF2D8mG0c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H9DEPw/GyEThs36CCWUu44HTucekX2DRK0iXdR+KUqsTyBiKUf+FkO9ijg26CeSqF
         WVekCGxHJfE8Nn2cNe7spJ7knWqGiagJMMe9Wk0AatPHhkS/6IHNHObXBxN1oLFjDp
         4v8O7bo50xNoSjbSC+TkhsHQvKjf2wHiKEVi87yd1DF47oA+eWC9UnXqUPm2hK17CO
         zmoiQqN+08Yo3mV+CnF0Wy1f8o/ffvoqsIDaqibpqBqElgY8oUYuJN129tQ5iFm0xr
         kIl3VXmMTpheHD/uMYIQhW0Rz4pX9Kq7jLPvvUgqMdgnAVB4rww3/JlyPZFb8dwWYA
         0rDUnl2C5hoWA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D5F2FC4332E; Tue, 20 Jun 2023 17:26:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 20 Jun 2023 17:26:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-D1nIchj1yJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #4 from Christian Theune (ct@flyingcircus.io) ---
I've only seen this once, so no indication on older or newer kernels, yet,
either with smaller or larger databases. I fortunately could repair the
PostgreSQL database with a FULL VACUUM on the table and then the dump worked
fine again.

Hanging in the past typically indicated a network storage issue, so I'm awa=
re
of the multiple causes the hung tasks can have, I still appreciate the link=
. :)

At the time of the hung tasks, I can see almost no IO (but also no IO press=
ure)
and 60% (of 3 CPUs) are reported as using up SYSTEM time.=20

Something that made me think XFS was that we ended up with inconsistent data
within PostgreSQL which I haven't seen in a decade.

Nevertheless, it appears this might be a MM issue as I stumbled over this
inquiry which also mentions a 6.1 kernel:
https://www.spinics.net/lists/kernel/msg4783004.html

I'm trying to get in touch with Daniel to see whether his analysis went
anywhere ...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
