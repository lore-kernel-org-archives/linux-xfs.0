Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B170C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  1 May 2022 07:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiEAHOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 May 2022 03:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiEAHOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 May 2022 03:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162041EC7B
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 00:11:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A08B80B63
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 07:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BCF2C385B5
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 07:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651389074;
        bh=RpW7UnJXhJrwh00uBMXs/okJrSloDWDTZBb4GQJhZN8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fDiMDQXUJKRE62ZW678DBNiCZmwIEy701ot2DoxW/QBa9ZeHRRlXAYMf6MmyMn6WO
         dSM4Q7XPnL1dkWFdOoSnIpSmtJSP+zuEIS/mfb1j8TEQnbqFEzYRLhrmD+1AJFOVQl
         i2H9JYoSAkxHIfqNnwL48xjTdKZN3sDcmVWKyH//l/CruEqufPxDtFZ4rBnwiQkXSz
         1g1ZUfZmmj2mXTqc7LNFh9g9Biwq/+GcqG2ZDOu18PTuu/Hsgu8UStrPE6WMlHaXGk
         iuT1vE13OtTYf55RnbHbmCCS6ArcSkQIzrK8Pr6Q5k9AW/kP5Yzw9tpUM044QoAfjP
         R87yfMu0VHwiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0B2E1C05FD2; Sun,  1 May 2022 07:11:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] kernel deadlock when mounting the image
Date:   Sun, 01 May 2022 07:11:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-215927-201763-ohbMpaNSXz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215927-201763@https.bugzilla.kernel.org/>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215927

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |high

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---
When trying to mount the image the whole system deadlocks and nothing works.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
