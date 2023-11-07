Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F24C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 14:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbjKGOM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 09:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjKGOM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 09:12:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4CCB4
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 06:12:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52855C433CA
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699366344;
        bh=AjVQ5oWlA1U72lmOy7efV2oe5bVc/bkKayG2ey8vgig=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hs5k7L9hRcWfSdMApZ6PqpzrauyYa3OhPjPPVo/salYgbt27IB6Wke7NfyNFCTsho
         y+nTE9fKZpD2RHjHmOeG7rrHaXZc9clAPs+dMZoWRJn98KfHY2OZC0abs89FXypeIU
         8reAOl0BmEjgae8U+1rrYHW6fbosa/sIUZyxXJ5jDzCWIbJGeBbKUw/ALblC8bC2C7
         2AFaMjQQ/UQlw0X63r7BnGWms2xNCCUdQ0aTfYao2WZrT7rROX9L+CaXPc35C5rjbt
         +8CXQi+RE8kn5MBpw3PWyvQcARcugMLNXrfcmCvC6m5m0aLH7ifVZp/N0HIBm6N0Sv
         VVRVbysKmb78w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4042BC53BC6; Tue,  7 Nov 2023 14:12:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 07 Nov 2023 14:12:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
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
Message-ID: <bug-217572-201763-dwAt4SnYL2@https.bugzilla.kernel.org/>
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

--- Comment #25 from Christian Theune (ct@flyingcircus.io) ---
Unfortunately building the rocksdb benchmark utilities is weirdly complicat=
ed
(on NixOS) and I failed. We tried a number more stress tests with MySQL and
PostgreSQL workloads today while stressing IO and swap but could not find a
reproducer.

As we've seen slight data corruption issues due to this previously we're go=
ing
to downgrade to the 5.15 series in our environment for now.=20

I'd love to be of more help. If anyone ever can recommend any tests that we
could perform, then please feel free to reach out. We're happy to help, but
I've exhausted our capabilities for now. :/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
