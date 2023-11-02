Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE923C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 16:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376894AbjKBQXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 12:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376572AbjKBQXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 12:23:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087F4186
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 09:23:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96B27C43395
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698942183;
        bh=gU1Oz+3H4/l1E75NTi1S17cerKs0yLv3yoc/v/fOjVc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NiIFs3IFwGP7WvxUyzQL9oqowx7yQteilCLnWLhoedbLWrBwJn3e0iGcqtQsxWNn9
         u9kA+VFr+Hpr56lINV3iedvrCo8r0BmPt1Dq/rbTHPoBfjJ1VK/0Z6vPVB5OEoKxQC
         hGmLqfb1zqoS0Cs7BQ2UJiCOg1M+waUvccqVr7GbGIKth134GVGoUJTKnf+wdd3ssD
         DbsgT6Cmyl4i9vji1nwnfSAARaUzuYPkG9g2sRhP8R1rWbFMs0maXK19I/jjqoU+hW
         vGFMjjvEo4biF7XXV/ZpcOAhlNfehrigwewT81qV9oqntjk0qeyIrLaivEQO1GI6i/
         hIjqKAcbaErMQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8704DC53BD1; Thu,  2 Nov 2023 16:23:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 02 Nov 2023 16:23:02 +0000
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
Message-ID: <bug-217572-201763-h0CSPU41zY@https.bugzilla.kernel.org/>
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

--- Comment #20 from Christian Theune (ct@flyingcircus.io) ---
A collague noticed that the assignee is still set to the XFS default virtual
assignee, but that's something I can't change ...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
