Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E302BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 10:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbiCXKY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 06:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiCXKYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 06:24:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619123DDE2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 03:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14407B8232C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 10:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE9C0C340F7
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 10:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648117371;
        bh=sU/QgERA0U4hsPRTr5W7AhHuPpp7XHFW1AQiZSaSZ2A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GwFT6CrKEZOyIBB2G76bWbmzUgZxFC8drlf1Q13q0oU6MLXrebCD5sTijdqzxRkCt
         kxXoS3y+jObH3kQr6suKEp6UQRaVa4Gszy1+HqO9Cl946jtVFfaE6PkQSRsEwhtruT
         QC7NMZnFATtuJWbDUuTPJ7pF7FDXAOWDKvfrjh+SRicZIx50rDRz6nqSR8051rAhh2
         VY112V85bVXlGvbIGx4fsiuMvH32PXYNgabiwWfOVHoKWfD+4XyBXwk5g0uNfkYJ+J
         +/8vSaAc2YGoe1NGzLEkyQIBnSJLYqCp7IsL0LeF+Yau+PGjphwjdqyZQEgtvr670W
         aS+qlHhh4dLUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BC8DEC05FD0; Thu, 24 Mar 2022 10:22:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] chown behavior on XFS is changed
Date:   Thu, 24 Mar 2022 10:22:51 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215687-201763-2rxh8qLcB4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

--- Comment #3 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

On 15.03.22 09:12, bugzilla-daemon@kernel.org wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
>=20
>            Summary: chown behavior on XFS is changed

Darrick, what's up with this bug reported more than ten days ago? It's a
a regression reported the reporter even bisected to a change of yours
(e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") --
see the ticket for details) =E2=80=93 but nothing happened afaics. Did the
discussion about this continue somewhere else or did it fall through the
cracks?

Anyway: I'm adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced e014f37db1a2d109afa750042ac4d69cf3e3d88e
#regzbot title xfs: chown behavior changed
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
