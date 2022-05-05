Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A03C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 06:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbiEEGZO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 02:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiEEGZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 02:25:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73BF205E9
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 23:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8815B829A1
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFC12C385A4
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651731691;
        bh=fiwwsRch9VRZoQDj7Aw0o06Ms14ANNg/wJIEmpPomVY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Q05RDD3lDQ10VnL2MumMEHbMYCx2MFFwr/nmNUfWXvisuPlfaMrrzu34UfgfyzbXH
         gQs469qRgm8NgJK7mRyUG+kkwjqj5Uw67ngw2ndgUeCigO3T23lLY7qMNTid7VP390
         2McTo/1qSINf2VxaEedVFB1SxaSjcAaORC9xKyJbFFEO8dGHVi1LtwE51HnV/KVJb+
         p33h1Mkb/RlbH44P9mfztjLrvqNPifCW+1Jsgf82OdQ8m08d/v4ZM3YIemO19FVf+j
         dH8sa4ucG4YXpi9Egrv3MbCP2l5IBuqol9UDMFggHYEvEPbvHZfOsULkxdQQoyomcs
         1Dv7mVtG/xpbg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9CE1DC05FCE; Thu,  5 May 2022 06:21:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] kernel deadlock when mounting the image
Date:   Thu, 05 May 2022 06:21:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215927-201763-cOCp31pZZB@https.bugzilla.kernel.org/>
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

--- Comment #4 from Darrick J. Wong (djwong@kernel.org) ---
On Thu, May 05, 2022 at 05:46:45AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215927
>=20
> --- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
> XFS maintainers? This looks like a serious issue.

Well then, you'd better help us triage and fix this.

"If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work."

--D

>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
