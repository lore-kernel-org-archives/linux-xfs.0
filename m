Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A11C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 17:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbiEYRNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiEYRNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 13:13:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5FF20C
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 10:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6CC3B81D2A
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 17:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D67DC3411E
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653498815;
        bh=cIX9QwBgyHCI8O2zCVTz5n9GLxq+GQlIuA5sq1QA70E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=h9kOC/YOWHSSL6NcESh+WjiArFqZbGsfLr4hfR3LLL9biVW6gPmr7RsfqvPtF9Lw1
         y5NxvLgxp/YDH6UFlHwig5vq41yh4I/VtwHESEa2GX9dPCoDKzN0+FbfVnPOEjR35P
         u34MaolpPpAYRf4MqWaAIICBFEZaplsisj9izZ3oIvUDxSrrDoHIONUdHvdw5yHby6
         58+CcgPJhjQniOGwArOnS2GVJTFYN3S9bIHiFONBoaH3E4yrDo2wOYat8dwCYeC0nb
         DdQuLlxKZFYlUxLRyI7r/45pQcQLtQnHx17pqKGZa6pt7PIUWBSlpEY1M+SJApToWd
         /H55ilrgZNtIw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6CFA9CC13B2; Wed, 25 May 2022 17:13:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Wed, 25 May 2022 17:13:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgorman@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216007-201763-x9ruyK5v3d@https.bugzilla.kernel.org/>
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

--- Comment #18 from Mel Gorman (mgorman@suse.de) ---
Created attachment 301044
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301044&action=3Dedit
Patch to always allocate at least one page

Hi Peter,

Could you try the attached patch against 5.18 please? I was unable to repro=
duce
the problem but I think what's happening is that an array for receiving a b=
ulk
allocation is partially populated and the bulk allocator is returning witho=
ut
allocating at least one page. Allocating even one page should hit the path
where kswapd is woken.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
