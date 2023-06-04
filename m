Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C84C77B73
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 18:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjFDScD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 14:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbjFDScC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 14:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311BCF
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 11:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9388261357
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0638FC433A1
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685903521;
        bh=h09fOL9psxjglrIL+/DNUMP56HN1DHkG7s9325M1iPI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P/hwCacEhxjenUBlfat0lzBRvX3QsGo1askZV2goREiL9zTro4fW+UoLL1fADhtg2
         qeptu+myKn9oJSdibaLZHWOpGC+3VMgX3FHVKRSbysI7N9QB1QZoZSkjXJxSKucQi3
         wiigYCn1hdOUmEHlOTVc1jyGjx3eoV2KxAPdL9SYUVJZ4Y7JocBuS5s5AqQZ58v0MH
         BZtV0gO3qz6k0n/yeCYlbODR503iIRylyQ6yUlvx7vDaIjXC4IP0EiDT5hf5JXNEaJ
         7TWSntuIrXAIp5NjKdLGi3b1vZyO+017AuLi6mVXz4tS+9Hbf+/+ohIvWwTjWaUw+d
         q9ZP9ihVZjJgw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E866CC43144; Sun,  4 Jun 2023 18:32:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217522] xfs_attr3_leaf_add_work produces a warning
Date:   Sun, 04 Jun 2023 18:32:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217522-201763-yHqrELziHe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217522-201763@https.bugzilla.kernel.org/>
References: <bug-217522-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217522

--- Comment #3 from Darrick J. Wong (djwong@kernel.org) ---
On Sun, Jun 04, 2023 at 03:31:20AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217522
>=20
> --- Comment #2 from Vladimir Lomov (lomov.vl@bkoty.ru) ---
> Hello
> ** bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org> [2023-06-03
> 14:50:24
> +0000]:
>=20
> >https://bugzilla.kernel.org/show_bug.cgi?id=3D217522
> >
> >--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
> >On Sat, Jun 03, 2023 at 03:58:25AM +0000, bugzilla-daemon@kernel.org wro=
te:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=3D217522
> >>
> >>             Bug ID: 217522
> >>            Summary: xfs_attr3_leaf_add_work produces a warning
> >>            Product: File System
> >>            Version: 2.5
> >>           Hardware: All
> >>                 OS: Linux
> >>             Status: NEW
> >>           Severity: normal
> >>           Priority: P3
> >>          Component: XFS
> >>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >>           Reporter: lomov.vl@bkoty.ru
> >>         Regression: No
> >>
> >> Hi.
> >>
> >> While running linux-next
> >> (6.4.0-rc4-next-20230602-1-next-git-06849-gbc708bbd8260) on one of my
> hosts,
> >> I
> >> see the following message in the kernel log (`dmesg`):
> >> ```
> >> Jun 02 20:01:19 smoon.bkoty.ru kernel: ------------[ cut here
> ]------------
> >> Jun 02 20:01:19 smoon.bkoty.ru kernel: memcpy: detected field-spanning
> write
> >> (size 12) of single field "(char *)name_loc->nameval" at
> >
> > Yes, this bug is a collision between the bad old ways of doing flex
> > arrays:
> >
> > typedef struct xfs_attr_leaf_name_local {
> >         __be16  valuelen;               /* number of bytes in value */
> >         __u8    namelen;                /* length of name bytes */
> >         __u8    nameval[1];             /* name/value bytes */
> > } xfs_attr_leaf_name_local_t;
>=20
> > And the static checking that gcc/llvm purport to be able to do properly.
>=20
> Something similar has caused problems with kernel compilation before:
> https://lkml.org/lkml/2023/5/24/576 (I'm not 100% sure if the origin is t=
he
> same though).

Yup.

> > This is encoded into the ondisk structures, which means that someone
> > needs to do perform a deep audit to change each array[1] into an
> > array[] and then ensure that every sizeof() performed on those structure
> > definitions has been adjusted.  Then they would need to run the full QA
> > test suite to ensure that no regressions have been introduced.  Then
> > someone will need to track down any code using
> > /usr/include/xfs/xfs_da_format.h to let them know about the silent
> > compiler bomb heading their way.
>=20
> > I prefer we leave it as-is since this code has been running for years
> > with no problems.
>=20
> Should I assume that this problem is not significant and won't have any
> effect
> to the FS and won't cause the FS to misbehave or become corrupted? If so,=
 why
> does the problem only show up on one host but not on the other? Or is thi=
s a
> runtime check, and it somehow happens on the first system (even rebooted
> twice), but not on the second one.

AFAICT, there's no real memory corruption problem here; it's just that
the compiler treats array[1] as a single-element array instead of
turning on whatever magic enables it to handle flexarrays (aka array[]
or array[0]).  I don't know why you'd ever want a real single-element
array, but legacy C is fun like that. :/

--D

> [...]
>=20
> ---
> Vladimir Lomov
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
