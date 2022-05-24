Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351B9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 10:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiEXKAP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 06:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbiEXKAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 06:00:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F44719FA
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7876CE19E8
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52224C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653386406;
        bh=nIDJX/a8lHztqsQFtib6jLQPM6FWKA3M9GIzoRLWAWA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=p97dWPhnOQ2zuQEG2HUhKIZEJGBPeESWJcMwvpq/gRFew0AugFmhgFlzTYmhi3n8I
         +r/UDKV9z2V5OO33WpQ6wSvCFDtQdpdX+5fAexvLXCjjPVxXTiDyBI2lLjUUtpwUji
         JXiYH9WygXV3mtLyTknwz1VosYC8Hfcx4+BsE3mPPXowDQbUHvUjZhjHeeYD/YmFEc
         gKICfth7F/8Dn2tO9gsEIYWvIBCdVyDTl7Sm//5dFGyB5g+aokCwf14zvzdv90BRLt
         b0uZVHI7j982qAgN0VtpHIqlYT6/2qVCACTb2zmYTA8tdFJkj0kDqqqAxdA0rarEcl
         aroU1wJRBit8A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 40755C05FD4; Tue, 24 May 2022 10:00:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 10:00:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-SdjJFQFJY9@https.bugzilla.kernel.org/>
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

--- Comment #11 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
I bisected the issue again, double checking every step, and I arrived at
another commit. This looks more promising:

c9fa563072e13337713a441cf30171feb4e96e6d is the first bad commit
commit c9fa563072e13337713a441cf30171feb4e96e6d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jun 1 13:40:36 2021 +1000

    xfs: use alloc_pages_bulk_array() for buffers

    Because it's more efficient than allocating pages one at a time in a
    loop.

    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>

 fs/xfs/xfs_buf.c | 62 ++++++++++++++++++++++------------------------------=
----
 1 file changed, 24 insertions(+), 38 deletions(-)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
