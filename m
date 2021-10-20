Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3C4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 22:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9425D61004
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 22:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTWkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWkr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 18:40:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5064C61374
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634769512;
        bh=Qh6zuz18ArqhCAOpoknt5oEp2rFDhQuYafpiunhwCyM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ppoDBudvp8q94HwWBbfvZ4oXIqbWu1ByKxBPpngBGw2QKWRZmMXvNytPvHWjEYBOJ
         OloNh0Nek8W+ltkDc5DBnMclCkg3TDNZ6ySVdZ+PjF14whLtiNgGgT/iqAtyB52IfO
         YtRmQxvfTxApTQ0s7MH7pxkieH7jBNtgPjx75OKS9JMZk/p2P3MkJeACSmfwbHltpc
         kn9e081ZpOQBoCIMuYEdwBYPlw7eyqjCiq6x/fCMBVjE6iHZJ1h6lkHvRSvTVR6q6y
         Fqw5sL8L7/KiLtPlZQ2rhxNq9tt9v2XRI2eTSE+ModjzN7tpKnINAoOUtXEGG3VtkU
         ebLd10Ukx/vMA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 22:38:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-KTu5ekbZNF@https.bugzilla.kernel.org/>
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

--- Comment #8 from Dave Chinner (david@fromorbit.com) ---
On Wed, Oct 20, 2021 at 07:36:07AM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg
wrote:
> [656898.034261] Call Trace:
> [656898.034538]  __schedule+0x271/0x860
> [656898.034881]  schedule+0x46/0xb0
> [656898.035226]  xfs_log_commit_cil+0x6a4/0x800 [xfs]

This looks like it is stuck on the hard throttle. Which means this
is the likely fix:

19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
