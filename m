Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02DFE732C5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 12:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjI1MjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 08:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjI1MjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 08:39:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A5C139
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 05:39:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E806C433CB
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695904746;
        bh=tUobsekpSP2JRuk3QARQ8pWIIEt87439NVycDnF8YUM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hC4i3JxTOaRHnlOo7i5eIUagDMZDeiLvl2GLrkYXyORSvT5iUB07fHnYQKEpBN/pt
         nJBye1rc90Qi5PLc8s85BI7VkfnBWQPpdU8eZVwNDjY/88yFyqmyqhu1iebbwL4czk
         Msp7xG2c2HpcvPrNZ+ua4dXy5YJ7u2bfrVJpTVAABKON3zg4xqheQZWn/laTC/0IaZ
         JoJ3OAdWntMESMaLVHiNmKQ355iN1VLq7xxW+s5j7rC8V+IrKv7l2gQL62TaM7r7pR
         FICrvZ+dVkbBebAZTzTEGKeDCYfeDB456JgX/bx4Orxf36MiL1RGsuQC1RE275/vKM
         pk/HaYNx+nGEg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0E9C1C4332E; Thu, 28 Sep 2023 12:39:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 28 Sep 2023 12:39:05 +0000
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
Message-ID: <bug-217572-201763-z2qkmBIoaL@https.bugzilla.kernel.org/>
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

--- Comment #10 from Christian Theune (ct@flyingcircus.io) ---
@Dave I've seen this a second time now today. It also ended up being a copy
statement with postgresql and I'm going to take a consistent snapshot of the
full disk right now.

If you can point me to anything I can do to extract data from the filesyste=
m I
can boot this into an isolated machine and poke it. I'd also be open to loo=
k at
it together if you (or anyone) wants to poke around.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
