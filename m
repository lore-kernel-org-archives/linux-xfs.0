Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDC6C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 13:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DACB61363
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 13:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhECNgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 09:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234320AbhECNgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 09:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F37F061369
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 13:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620048944;
        bh=PxNYR2hv1VZrWPGgHmvqvuu6/UKznUMqryq6X7hhkZM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V3nqSeKSRhp9GtpYswCKDqpY4p61nCnh0Tz7Y79tdOWJ1D3Uz4MQ6aprtxmaCkx8X
         On361jagaf5VIbU8nj5bJNBeZOl/oDx1Cw18iMMmiisi8ABZlSNdMlWgSPgdlDWIou
         8a4OyMa3K2LC+4HdwJCf/DPuR902lzg2g5Bgp/3TT0ddrtwnch9SjcOWgSnPZpltay
         zzVOOiHAW10wmFLUUGfOw0X3GbNSlwHOBaFp8mHnLTYO5lT2hUoFTCWNMrr15ySqyE
         WOGal7SuAEJPLmnRzpeSdAcyyyFeFWiIDbUzRTTIEZw3XN4+F4G05c0HPHK8dtv+Gm
         uuL6fo8QmOeAw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Mon, 03 May 2021 13:35:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-211605-201763-qLeM5bANHa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |CODE_FIX

--- Comment #11 from Eric Sandeen (sandeen@sandeen.net) ---
Yep!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
