Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FEFC4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 15:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjKBP3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjKBP3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 11:29:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FF113E
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 08:29:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F607C43397
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698938977;
        bh=7J9IWClMUuQLl/OxzzTjjgd93Ypza0pQp6B6mR3+uFQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=L1yOU6g5KsO1OxcNYWz3kIdONMVe8EZgFCeK97dMQW9EyTiOMedQIL/JxFbvZ8aqX
         AJZXFkshLjscjog1fZvnTW0lByje0l62G2zFDO3nChD6vCcE86vA5RJpNPhZDZanyw
         rpWy6x18/4Ss9K5pGEPftRciUKxkIsEmLL34GO649YdDgJhCWx3mjfsmpc+1h3QxbR
         Gll51Xxf5Q7ww+apozGj/5m286pZNN2l2hUoiXsibCw9Lmw30iG6YwieOJQBk6P62p
         uz4dVgsBZKIusfXkOPbZXSXn0fAnlegCLQ+dERwP+V4YBOptK2Y5DNS+ejipH8qqB9
         wCun1wa2eAB6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4F957C53BD0; Thu,  2 Nov 2023 15:29:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 02 Nov 2023 15:29:36 +0000
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
Message-ID: <bug-217572-201763-fmGipHFrYD@https.bugzilla.kernel.org/>
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

--- Comment #19 from Christian Theune (ct@flyingcircus.io) ---
As Dave pointed out that this is more of a MM issue, I'm moving this to MM =
but
I'm not sure what the correct component would be, so I placed it in "other".
Maybe this helps getting it to the right eyeballs. :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
