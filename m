Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF88C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 15:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DDC610D2
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 15:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhKJPTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 10:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232111AbhKJPTY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Nov 2021 10:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A532361221
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636557396;
        bh=l1v1GheslsaKhdEoJd1LIIvXQPZPX9boyDBW8n9XtWA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qjS7kgSN3zDJb1m4+Y+mPbbn90K/x0PzBAxhDXa51w6Dg9lfpmFkQJbKxJmVbJr//
         wM3klCQ+nHL/iKuD65+LfEFBFdBrDizryNQw8Rj4Ja+VJqinjO3Rfw1dOZY/PAoc/5
         q7drLCpEl8NJfMG2abCpUU/yxxOpKHStKzmIwaxbjmLOUQO1zXmvCQGIubGzaA5P5w
         dEKuNjX4p5G7+G8BwCrcLWSByoZ9K4T+slswa1A3qLNnHpNkwFDqi8SCJ+EgvJQylp
         UgBwNYfjdChlx0X6YsZcq+rRvcxdO57koymTsBfu0zV72GqOkFOfmTzp7+pikqrEYd
         WkmtCT9JF1tKA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 10 Nov 2021 15:16:35 +0000
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
Message-ID: <bug-214767-201763-cXpP1tlDle@https.bugzilla.kernel.org/>
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

--- Comment #16 from Christian Theune (ct@flyingcircus.io) ---
I started trying out the fix that Dave and am using it with 5.10.76 (applied
clean with a bit of fuzzing).

@Dave do you happen do know whether there's a helper that can stress test l=
ive
systems in this regard?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
