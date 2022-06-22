Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDCCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiFVXjO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiFVXjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:39:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CA927CC3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 886E261BA6
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4F8BC341CD
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655941150;
        bh=2oQV43UuvDwn3WVNxWw1MPnNLbZlbHbh0DvbJKYxClo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DeBCROxFnFHtL0gto6iD+L81htWDjPn2IqsG1cj1sDyPqaCLUpLm4LWDJiqftl06Y
         ePefBogkHS2P7oIwIEIeiN9Lc/t0dQfOH5RkNmQDYaSVQ5YoPFnutiojIo1kt0KWjM
         9FdeAzURU95sOPQZgsiG/9y2IZVz8tDpMujZCNWZjDrNsWJXRKmiY40Ok+56v1v6Il
         xEAYgogj/0r293jyy+RszhBNSTuzuzoiawKaGdGcOFQTTyRUlWEb099pTdzt2Rto5I
         MOQ5sZH/kSit8ZEGS7aDzJSJaN1F56VIveNNw1KCl0NEH9hm5zcNxPAVNUgSx5iPaF
         q5qsTszg7SlnA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D5537C05FD2; Wed, 22 Jun 2022 23:39:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Wed, 22 Jun 2022 23:39:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-216110-201763-qG72xa3PnS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216110-201763@https.bugzilla.kernel.org/>
References: <bug-216110-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216110

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |INVALID

--- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
I agree with Darrick here, this is the upstream bug tracker, and upstream c=
an't
help users with distribution kernels, especially on older distributions.

-Eric

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
