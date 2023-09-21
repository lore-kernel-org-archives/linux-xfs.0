Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCB0E7D0A4
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 19:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjIUTBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjIUTBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 15:01:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9CC7B453
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:37:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C6D1C433B8
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 06:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695279545;
        bh=RbaN/cQ6MtGLngLtS9O+hJ3Z5FGr4JKBMez0CgHR0Zs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=b0/kMFtbQExtG+fnFzWD/KxpyJlyQrEJUooXgZDerSxveM3VVNAXxEctXF1r2rO5y
         E//ZA9DQlQ5gpNeapr38bKcAK/CYuMqFtTWZJE5rQi+viFabrfQAsGZWKKZfiTmk2n
         6GgO3JyGDo052Ot4++Qu+9wfGftU16TwxOf/8WhtlDfbJxdjby8MhoUOwsa+d8mbiA
         xHR7WtKMEnNe4vZWHlJymNUIOdnjT9xy+kpuTeMhUO/7fcPwoqVVGx/OYui6r9aYBB
         PQjscRssVDYaE1vWTJw2uIgZSfSlOl/hKJbe7M1RtEHTk5MxTnPnWLlKPIBvG9X62k
         LOOIWXDezryyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8BDCBC53BD0; Thu, 21 Sep 2023 06:59:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Thu, 21 Sep 2023 06:59:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216343-201763-zmJNwe6esA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

zhoukete@126.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
