Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE2FC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 03:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbjEYDEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 23:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbjEYDEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 23:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20F7B2
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 20:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 568E464211
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 03:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE00EC433A7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 03:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684983882;
        bh=NllsoWQ5M9PM0AmGAsWYC9xHWTNMjwr6SIz1dKn0kkY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=if8MVr3kpihbJKAEu/p/mJK2TBgk+vFjPUKT4KyYtVkFISdGxDCkrK+mVacmRvNXz
         HT5GT4I8VDTdEcWLawITKAAaeO2M2kD6UoS+dfPpRjgaK18DRBq8VUTbYGaKOYqSoF
         n6YjUnhLADhbXQ64+THpkaHnDItedLjSoRhl6wAFoFqUDtDk/wX+nFCDyIV13Mt5Br
         7y52Og3x7Rj3JBWG/ddHZF/uJewDY8s68yJAcvijR7oU9cSXMS/Vg0P/YZtw0in4fG
         viL1TIm6YGgNyOLAw3TJ/YoozOkvsVGy52wOmdNuljytYgwkrhgk2AHcDggTk2u/J7
         wtl4tTj0CjHqg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B01FFC43141; Thu, 25 May 2023 03:04:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217483] [Syzkaller & bisect] There is "soft lockup in
 __cleanup_mnt" in v6.4-rc3 kernel
Date:   Thu, 25 May 2023 03:04:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217483-201763-oCIyBeknwo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217483-201763@https.bugzilla.kernel.org/>
References: <bug-217483-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217483

--- Comment #1 from xupengfe (pengfei.xu@intel.com) ---
Related community link:
https://lore.kernel.org/linux-xfs/ZG7PGdRED5A68Jyh@xpf.sh.intel.com/T/#u

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
