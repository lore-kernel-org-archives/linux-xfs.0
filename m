Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BDCC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 11:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiEXLsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 07:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiEXLsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 07:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C3022BCA
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 04:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EB00B81893
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03009C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653392891;
        bh=luoV2UdrilMBs8QJ6lbtU9/KRDY1VFCzegZpIZqwIgM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P0u7Z1JlVRrPYr8y7+rmuTKwNJmJCildcdhukOFrX6JR4Km4WTdZ++8nhxnQyO20k
         2rG2RuPsQLmddjt4x8T5q0la4khW9XjT7734w5/fA/boVuTWtrFGoNUGY6Xu7KCJd3
         I9Jr4HqlyBzmtUUDDmB3shxUaouiWphZMplMAsw4xlJ7OYjp0ummHbmL9yGuNJeOke
         n4Hk/iNwK+ismnVA0Ns4DoeHHMPFagWbbsR1X+XmpKZeXV6BeBhghRTONM/cA8R9MX
         WhT7onnbfkIEQ+m50DO6aO0XjziImvM+QbUcvJzsPSlLo/aIbothcX7TNyAhJHeGh4
         xVzssPMM1MTcw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E5934CC13B4; Tue, 24 May 2022 11:48:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 11:48:10 +0000
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
Message-ID: <bug-216007-201763-8S2THOZRm8@https.bugzilla.kernel.org/>
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

--- Comment #16 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Jan Kara from comment #10)
> You've mentioned another kernel config does not exhibit the problem. Can =
you
> perhaps post it here for comparison?

certainly... but I'm afraid that the differences between the two .config fi=
les
are too big to be of any use

I'll attach it shortly

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
