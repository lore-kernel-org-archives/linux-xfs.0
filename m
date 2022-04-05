Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF97C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiDFCyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457663AbiDEQ3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 12:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0677C166
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 09:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C85617D0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 16:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 872CDC385A7
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649176068;
        bh=DXp3HLSv0SXr9DOLt0Q5kGGwGZ8vXA7HHZOktyVfHak=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QlPFEBOhKh3xOeaBmAa0q+7TwvfjkMEfmkZqDthyQL76QiSXG5OcjxaZniqsy1f0a
         RomgHJu+5p0hgu4rBAQP9EjD9Tl7GovQt1Cm6anVFtfFVHVhSRZcLlpAU+A5vMb7Ic
         8Th6tPapGNIi8VeBZvcMlRFtl6JVGUafpDFKU6baDumpFwc8mPajeR7wl1ZYMYTOKL
         QL+G2geM+JHz+ui1AzNW/J2FI9EsrbOu0sV6K/GvbuY1IKPFKfLdOuFbQqIWNBfkIQ
         q2u7zAJXNKEdeNUoTJMt2D6KB74bP8GbMnDIeoA3400LRERlZQ28klYztLJ419F7bS
         SmzWE7RamIEww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5F5F2CC13B0; Tue,  5 Apr 2022 16:27:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 16:27:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215804-201763-f0aoIh4JkW@https.bugzilla.kernel.org/>
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

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
(In reply to Dave Chinner from comment #3)
> Hi Zorro,
>=20
> On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215804
> >=20
> >             Bug ID: 215804
> >            Summary: [xfstests generic/670] Unable to handle kernel pagi=
ng
> >                     request at virtual address fffffbffff000008
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: xfs-5.18-merge-4
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: zlang@redhat.com
> >         Regression: No
> >=20
> > xfstests generic/670 hit a panic[1] on 64k directory block size XFS
> (mkfs.xfs
> > -n size=3D65536 -m rmapbt=3D1 -b size=3D1024):
> .....
> > [37285.246770] Call trace:=20
> > [37285.246952]  __split_huge_pmd+0x1d8/0x34c=20
> > [37285.247246]  split_huge_pmd_address+0x10c/0x1a0=20
> > [37285.247577]  try_to_unmap_one+0xb64/0x125c=20
> > [37285.247878]  rmap_walk_file+0x1dc/0x4b0=20
> > [37285.248159]  try_to_unmap+0x134/0x16c=20
> > [37285.248427]  split_huge_page_to_list+0x5ec/0xcbc=20
> > [37285.248763]  truncate_inode_partial_folio+0x194/0x2ec=20
> > [37285.249128]  truncate_inode_pages_range+0x2e8/0x870=20
> > [37285.249483]  truncate_pagecache_range+0xa0/0xc0=20
>=20
> That doesn't look like an XFS regression, more likely a bug in the
> new large folios in the page cache feature. Can you revert commit
> 6795801366da ("xfs: Support large folios") and see if the problem
> goes away?

Sure, I'm going to test that, thanks!

>=20
> Cheers,
>=20
> Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
