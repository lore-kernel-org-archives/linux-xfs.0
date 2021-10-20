Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FF3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 19:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 603D26135F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 19:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJTT27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 15:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhJTT26 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 15:28:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20FA66137C
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 19:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634758004;
        bh=zbbCSa2t4c2fR4zgIX7kQ92zRpNsaRUeXsylo4l0AKs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kK3yF/24l7yxfF9D1jtvkpC9e32gNHNE0BpJIgdJyLm2BqD304pHx6PcfgGjUlNRS
         /85+3wtlNKHyPKIRkz+g2C8LGgLGFsNjW2gvNQww+nA/xXfAYrYU8erp9xGSL7N7xA
         280x8TRzd+k+h+hmMNQ10TytxzIRTntyCzSsSconBcGEcXIKvmGjPqlVpI0A/cxYVi
         g5OXrRvRAw6fzQxDbjBuIwIe/VUJAjAvznrn2p/hbPZMvDmfpYH6ITJQqjyelZhVRU
         emsKfkUVHICAgq1GN0E4hNsQpCx8FTnZEpryQj/sNQI72FrLiawc72aXtMG5q87AKb
         BAclgxctT4EHA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 19:26:43 +0000
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
Message-ID: <bug-214767-201763-eLaGUjGMyN@https.bugzilla.kernel.org/>
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

--- Comment #7 from Christian Theune (ct@flyingcircus.io) ---
Thanks, I'll try to do something like that, likely by using a qemu monitor
command to send in the trigger via keyboard when I catch this the next time=
 it
happens.

The freezing/thawing is part of our image backup structure and over the yea=
rs
we established to regularly call 'thaw' gratuitously as thawing can once in=
 a
blue moon cause VMs to get stuck infinitely if an initial thaw doesn't go
through. This has been reliable for at least 2-3 years by now and I'm not s=
ure
whether this will turn out a red herring or not.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
