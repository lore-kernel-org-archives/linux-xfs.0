Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E5BE743C9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 22:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjI1Wox (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 18:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Wox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 18:44:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6A8180
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 15:44:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93ADCC43397
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 22:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695941091;
        bh=LL4Uaze6b3PMvcQ3GgVhp0U08k0NCMCliuZDqfoY4kI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bhom8LgKcEytNvy3GpEME+UZmw/agfrrRkex7f0PjDe+fx1XcRyzSc+GFDOt2mj8k
         iQ5Kct/nfB5e8dEkLUsKi8/RvFS1tAyv+hPdzWOvJD6BZGac2JbvBtq1Q41zMYx263
         7vqqcfNueNOYdn2tRi47A5qGbyjF4pj1y4FqZRFsnahrVe7s1AkEe/krcEqpdBvRKh
         WusjB6mkr/quXTYRftaFcX7nSUHJHUSqwLsiEIIKi1/IDW7F0GActtVCS0RTtHU+dh
         5LNBxReE0pau8O7weTZjx3lqDSUu/UwvzYzfwyQNT1ptUBtyrUvrdu3xV4mw7elEyp
         EWZC1ns+SzK7w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 83BE0C53BCD; Thu, 28 Sep 2023 22:44:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 28 Sep 2023 22:44:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-DStX702R4y@https.bugzilla.kernel.org/>
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

--- Comment #12 from Dave Chinner (david@fromorbit.com) ---
On Thu, Sep 28, 2023 at 12:39:05PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217572
>=20
> --- Comment #10 from Christian Theune (ct@flyingcircus.io) ---
> @Dave I've seen this a second time now today. It also ended up being a co=
py
> statement with postgresql and I'm going to take a consistent snapshot of =
the
> full disk right now.

Have you tried seeing if commit cbc02854331e ("XArray: Do not return
sibling entries from xa_load()") fixes the problem? That has been
marked for stable, so I'd expect that it eventually makes it back to
6.1.y or whatever LTS kernel you are running now....

As for debug, this isn't an XFS problem - it's a page cache problem
when high-order folios are in use (which XFS uses) - so you need to
be looking at in-memory page cache state that is being tripped over
first....

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
