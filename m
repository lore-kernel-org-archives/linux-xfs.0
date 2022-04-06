Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3A5C43217
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 16:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiDFQIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 12:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbiDFQIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 12:08:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4EE3C499
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 21:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C0461984
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 04:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31C5AC385AA
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 04:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649219569;
        bh=D8WjfePwVmFD0j7sbqlx8p7BCyMQphfpSkQ+/Q5lOGk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OmhOwEf7CML4hgGnFTSicCk+Iql/M+xctfJN01JarCZbF3AAz+j1Yi9t1up+JqbmD
         akrCp2L+oOfXmsFUJcG00XXPIhbzVERjt3Zns5Uy4CbUOaqGW+PZp5CR0AdMkTd4uF
         uVbo+370G4w9Huxg3iBHL+SfO1w8Yh1mrkyJYG0OAkPQ79ancHeV2SZD/4E8+UqB/r
         4iIyMe8MyEQL7PbgKFf1ldDc6RYGy6QnGYmNMC0pHaVktpnB2sJ/l66C7HNG8yJNqc
         8dmTg1DrbPi/u6qYuTBkDZZE3aqIA25f9cn8c/kLyiQ03/O5Gw/RSzRCr2Hv7U3ij8
         1HGHXh9LTp0OA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1CA76C05F98; Wed,  6 Apr 2022 04:32:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Wed, 06 Apr 2022 04:32:48 +0000
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
Message-ID: <bug-215804-201763-f5wHx2aMUb@https.bugzilla.kernel.org/>
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

--- Comment #8 from Zorro Lang (zlang@redhat.com) ---
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

Hi Dave,

You're right, by reverting that patch this bug can't be reproduced anymore.

Thanks,
Zorro

>=20
> Cheers,
>=20
> Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
