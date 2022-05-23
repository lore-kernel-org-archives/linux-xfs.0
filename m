Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE4EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 10:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiEWK22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 06:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiEWK21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 06:28:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66064B430
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 03:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 657E0B81031
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 10:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21EB8C3411A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 10:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653301704;
        bh=G08NA29cCBvY07Sb/oUP4lOYpdPWGcx77qOn/ihG6kQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kfpM6TBYFutpj1JOwLre6OHVeGrrTJKEtoNPpljiYOjQojlVdpPVkkFkpG+Abs6sN
         NTQSE0jTK19L4YEsGjzxNDaUvGaei76HaQohST9K+8gz4ho9UnrPg3e9i/+b+/be0Z
         hyv90m1vTmYhjAjXnYZmb1Hdn76nu4v3+tb3RfKig8i3eF/VQ91Prf89qT5DSW/U7V
         6JyBi8DKwdeq732Tcln9vP+0EIaHfJ5p981+K6e2MncJRMxW3KgVikAUyJEDUM7lIN
         tWblePRh6XSIfEamnROTljCD9dhl76+X2scLXtInyTkTIkm5b5Wl+GtR2YJll0JjUa
         2LMcQLwcdtPeg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0B2ECCC13B1; Mon, 23 May 2022 10:28:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Mon, 23 May 2022 10:28:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: holger@applied-asynchrony.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216007-201763-UezoAaDOb7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

Holger Hoffst=C3=A4tte (holger@applied-asynchrony.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |holger@applied-asynchrony.c
                   |                            |om

--- Comment #9 from Holger Hoffst=C3=A4tte (holger@applied-asynchrony.com) =
---
Shot in the dark: can you try the latest plain 5.15.x + 9a5280b312e2
aka:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/xfs?id=3D9a5280b312e2e7898b6397b2ca3cfd03f67d7be1

I suspect your stack traces are not really representative of what's
going on..

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
