Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF3CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 19:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2035260E9B
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 19:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJTTYg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 15:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhJTTYd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 15:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F19461355
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634757739;
        bh=lsBQmBP9xPaIyGu907whthMKrj2flGSrbLkuvTHP71I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UNwna0VhToAXaCG9oUgIw9ZhBvkgHAeNbjMQS1UjhEV6QAGcMIxMKB9kB/66P/qK5
         hiED4zWBd8QbpYoiaiJxWWrjyB3u0DCOUhckPzFvOXVVG9LyqvSwnTjRxPe5B1eM04
         JMC9VQ+rh2na1BGUxQ9BMg8JCT0NA4c62FVVwKdMzqxPMUiYv9QcNun9P1EciFdK0i
         Oiq4A9gsxE+3HTHXeFCJXjThlPbBFGWwm1qgzgCVnwLm0EDljwv87hsVQMbesqP+o9
         Sz63AAnMKPL8N/yICAODKRcE/xcVkoA7RM+Ojq0ECdyZ6SvUl8JI9CQvUuDdPmNZ21
         rn9m4m4fpG3kQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 19:22:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214767-201763-cngojUoB8o@https.bugzilla.kernel.org/>
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

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #6 from Eric Sandeen (sandeen@sandeen.net) ---
You might want to do an "echo w > /proc/sysrq-trigger when this happens, to=
 get
all blocked tasks.

The thaw seems a little suspicious, what all is going on there with freezing
and thawing?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
