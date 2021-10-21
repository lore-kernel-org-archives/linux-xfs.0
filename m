Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479E7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28046603E5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 13:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJUNTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 09:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231379AbhJUNTS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 09:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 461A16121E
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634822222;
        bh=GJFFWuJ1uL6UkBOfRyvJI1DBbVDDrFI7FFpn9HBIvrU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V98O8kpJqYygvpm+TMNOO5mQLSlIksXkZNwXieUA46fxDcizqysd2DlGrF2yyDplq
         nEIQUgKFJdLbX2p8TX3l3t19w1ZgjptBHg375mipbpmDzR7KxOwZpOtVUF76buoflN
         ExeJzqmDloUxHx/335wnUk2eMZsF6A3KcPlFx77cs/xBpzSenyqG7ETFPW86EyAqek
         LZfLNlIHpLHPdviYi9qWoUnhcdl/scvcAn1a7yC8TTnFQzQvmgCPENPrqgye9f30zj
         uZCkQEyj375rlt9fXpzISUCXp3AGivDwRkWKFTCq57+B1ng7rvi1qFLRY3fPFf+UYF
         /nS6DZYQR35cw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Thu, 21 Oct 2021 13:17:00 +0000
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
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-4HjS6fLMzp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #10 from Christian Theune (ct@flyingcircus.io) ---
Alright,

I managed to catch a machine that logged a blocked request for only the /tmp
partition. I logged in, ran a 'sync' and did the 'w' sysrequest. I'm attach=
ing
the log here where at first you see a number of blocked requests, then a wh=
ile
later I log in and run the sync and you can see the sync stuck as well as a
large number of workers.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
