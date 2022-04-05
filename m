Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A26C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 05:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiDEF3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiDEF3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 01:29:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56617377EB
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 22:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC394B81B90
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 05:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2D89C34114
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 05:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649136427;
        bh=0SF96X5ka+eQ3mP+UjmTL076QvFUx0Z5K2cgAF0NNkc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LUN+WVLy2EhlI09gYtihAZ5yFoBqCvoL73Jj4JvcEwIJOChM7F5HGIde5/woXg1sT
         eOyhZyqp/JpH1fHjLWXqIQi3jjy9rJKOQqnnsaFbbALr+JrwCPh7ZCKoiIPF+nl8b0
         JcKJ5FQup0Vh0TvjJF69ltm8N0glDcd9Gw1Ib/O6OiK69tp6BRTxB9YdGAt2TXDiLU
         oOvKhZso9AyX+X0xB6Hvo6MkwetQtoSu8XpeyAjJ9uy4S4UA9/uK0DSTaQQ8yQGqLn
         w17ExY6/rFKi/c7qn5wZE6n+vpfOP5baGopZt1pQRMvzBJ7JVlZM7E/IuOYtIoZvg5
         CZ1WtGhfVRvZA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9FBA2CAC6E2; Tue,  5 Apr 2022 05:27:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 05:27:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215804-201763-yvs5Nhy9fK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
Hi Zorro,

On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215804
>=20
>             Bug ID: 215804
>            Summary: [xfstests generic/670] Unable to handle kernel paging
>                     request at virtual address fffffbffff000008
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-5.18-merge-4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
>=20
> xfstests generic/670 hit a panic[1] on 64k directory block size XFS (mkfs=
.xfs
> -n size=3D65536 -m rmapbt=3D1 -b size=3D1024):
.....
> [37285.246770] Call trace:=20
> [37285.246952]  __split_huge_pmd+0x1d8/0x34c=20
> [37285.247246]  split_huge_pmd_address+0x10c/0x1a0=20
> [37285.247577]  try_to_unmap_one+0xb64/0x125c=20
> [37285.247878]  rmap_walk_file+0x1dc/0x4b0=20
> [37285.248159]  try_to_unmap+0x134/0x16c=20
> [37285.248427]  split_huge_page_to_list+0x5ec/0xcbc=20
> [37285.248763]  truncate_inode_partial_folio+0x194/0x2ec=20
> [37285.249128]  truncate_inode_pages_range+0x2e8/0x870=20
> [37285.249483]  truncate_pagecache_range+0xa0/0xc0=20

That doesn't look like an XFS regression, more likely a bug in the
new large folios in the page cache feature. Can you revert commit
6795801366da ("xfs: Support large folios") and see if the problem
goes away?

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
