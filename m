Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A777CCA47A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 19:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFHTNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiFHTN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 15:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BD422B1B
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 12:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19DDCB829FE
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 19:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCE0DC341CB
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654715604;
        bh=n6CwT2r642IZfWuvetTuAqHG0kSbZWP/ooYg80myNBY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RT0388m6VXIyWxFPXlh0ko4Uvy8RWs/BE/HeNTVyqAKFJ2MQMC/a71vcqOYzS2UDt
         BzoM2la/7Vm8lsT7t9kesgPJiZJX+Hb5ZGgTqAmv0X0gN3JSQ837VJPkCUaZqhbEpU
         grEzhtz14BbxNgQQGBUiPWRQrhZEaz2kw/4CBwlj5D6pIKx2sRUEwyXrp5dCGlLIAv
         qcv9Hnd8kvJjFyLRRp2gjC3PeVl9S12ojFksPZXSiG1VZbcsYxBi2GPJ4SMddDur0F
         aq6sc4iPErbLV7kreMe+nZReWD77ArVO9CE5dq1/uqg7DpNuUebhTsMPaBiYPRlKIK
         3F5Kdx0P6tUQQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AF660CAC6E2; Wed,  8 Jun 2022 19:13:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Wed, 08 Jun 2022 19:13:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: agordeev@linux.ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-83pr7XVvTL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #6 from agordeev@linux.ibm.com ---
On Wed, Jun 08, 2022 at 10:19:22AM +0800, Zorro Lang wrote:
> One of the test environment details as [1]. The xfstests config as [2].
> It's easier to reproduce on 64k directory size xfs by running xfstests
> auto group.


Thanks for the details, Zorro!

Do you create test and scratch device with xfs_io, as README suggests?
If yes, what are sizes of the files?
Also, do you run always xfs/auto or xfs/294 hits for you reliably?

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
