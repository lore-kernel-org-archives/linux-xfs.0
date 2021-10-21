Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651EBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 04:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA22610FF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 04:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhJUEXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 00:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhJUEXp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 00:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC74A6112D
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 04:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634790090;
        bh=s10WRcG3eBRB+JbkdqkxmUiHGZrlKLgZHWB44o+7Na8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LKUlMnlyXBb57VhB6sY5EzJy1nEESEqcrnz6qtoy80NmFL+LKuScAa7sMFM5CE8xK
         OKeaTUF/cR80iLSswKa0iipod/EQFk8FbE0Xbn3WO4HUpB6A31ueZqXsfpfRD6NMVt
         hm+bhcZa2e7KODf2brKjknVN4FpVKVKwA8WXvwPj1boQcrR3jTelk63C4bIPTinEzC
         pn6BCTuh1AuoQhM53//LMy7rpXTwdqu4Wf6kbhfjX1OsXMX6nmL4Xt+LZCRJzEuVFr
         agW9uzXEXQ0UeEeUBIvsOCdf8ZPAx9kvQN4p7Oj5FLyh5WHzLzZtePJXwY+OgvcPYu
         o4o5j5R0DZUdA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Thu, 21 Oct 2021 04:21:30 +0000
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
Message-ID: <bug-214767-201763-MmX5niGkPJ@https.bugzilla.kernel.org/>
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

--- Comment #9 from Christian Theune (ct@flyingcircus.io) ---
Thanks Dave!

From what I can tell this fix was merged into 5.14 with a largish bunch of
other changes (via 9f7b640f001f). I checked that the fix you mentioned appl=
ies
cleanly to the current 5.10 codebase (it does) but I'm not sure whether we
missed some more backports for 5.10.

I wonder whether "we" (I don't think I'm expert enough to do this reliably)
need to check for other fixes that didn't make it back to 5.10. Do you have=
 a
recommendation how/who to approach?

As I'm not doing this often, I would contact GKH and ask for a backport of =
the
patch you mentioned (given that you consider it appropriate to apply to 5.10
from a semantic perspective) but maybe you have better advice.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
