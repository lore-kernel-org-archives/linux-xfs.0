Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B9DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC346115B
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJTHmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 03:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJTHl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 03:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 738F161359
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 07:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634715585;
        bh=5rvqshmz677WIrmI10Di5ZgSnc50wt57OUsjGbaAgeo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HmjZ+JuR2YFffF6jnaj8G0dyyasH6yccahcQUJQHX334RoYoGLrxqc80gOcMGx9DT
         1Ns6jozJqnGu1v06EYWObRx5wi2Mtn3er2kmJfS/ZWFpD7HJlBwgRFR/DDhfPWeCvA
         0xg6/2fhka99/1wLaFApir4T3x01oF7F7qyK1szXGz9Els+4jjVI3EdVUO9n7/zKVs
         antjPLBscA9SInu8hih13R6mkrC8zMTxlie092oU8MDeSdr0dpPamzdN8DzeLCu76c
         ME0p7t2cdV+EvawdLpMhnckvJktD5nHAGF/C74VAAoQAmtCCxif75rCPWxhbe4rCzs
         pnV820FgXVK8Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 07:39:45 +0000
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
Message-ID: <bug-214767-201763-90IDBYiFjp@https.bugzilla.kernel.org/>
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

--- Comment #1 from Christian Theune (ct@flyingcircus.io) ---
Also not that I'm not sure that it's related to the thaw at all because the
stuck thaw info comes exactly 122 seconds after the first blocked task repo=
rt
which IMHO indicates that it's a subsequent error, not a cause.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
