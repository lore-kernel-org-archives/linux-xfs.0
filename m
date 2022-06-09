Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E6DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jun 2022 02:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiFICtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiFICtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 22:49:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CCD1A0AE2
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 19:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90CFECE2CA8
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jun 2022 02:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB2EFC341CC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jun 2022 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654742967;
        bh=npc+clvE8htGfOHn5udHIqiqZp0i5gmmPZzzQeCy/hs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cKKiZk67GJWMx8rnCBnuxLt1t17vZoyCDQNdt+MKtExcPj3nzXjjj9wALZ1JKk957
         UleguYO5d589kFsip7iBtgG5wX3WuAoX2jrvx1bIwxZ8MNUoWr28nYXHQtMnf0Cosu
         1xe2hywmXSJ8aJZMIdA7vjXWLZkvG7NdJBNKbrkc27k/fOMtEHESYGZYFKs9Et2G8W
         kwoUGkrVgLOm47+TByakkSbtCDTR3iAY5Jr+IwkmhKVS74FjvLbFnEGy79Y3iZqQkR
         nq/b15lIxerESlKH3VmMy/HsZOSJbWCtlEu/7OJUT4YdkuT+koFkw/4idePglT/GLB
         0yram1W9DJzCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B9714CC13B4; Thu,  9 Jun 2022 02:49:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Thu, 09 Jun 2022 02:49:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-2nxRvnkofH@https.bugzilla.kernel.org/>
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

--- Comment #7 from Zorro Lang (zlang@redhat.com) ---
On Wed, Jun 08, 2022 at 09:13:12PM +0200, Alexander Gordeev wrote:
> On Wed, Jun 08, 2022 at 10:19:22AM +0800, Zorro Lang wrote:
> > One of the test environment details as [1]. The xfstests config as [2].
> > It's easier to reproduce on 64k directory size xfs by running xfstests
> > auto group.
>=20
>=20
> Thanks for the details, Zorro!
>=20
> Do you create test and scratch device with xfs_io, as README suggests?
> If yes, what are sizes of the files?

# fallocate -l 5G /home/test_dev.img
# fallocate -l 10G /home/scratch_dev.img
Then create loop devices.


> Also, do you run always xfs/auto or xfs/294 hits for you reliably?

100% for on my testing, I tried 10 times, then hit it 10 times last
weekend. Will test again this week.

>=20
> Thanks!
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
