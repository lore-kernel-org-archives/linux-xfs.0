Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C97C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiJIXU4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiJIXUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AC843E67
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 15:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC0E760B85
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 539B3C43147
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665355350;
        bh=PwratzfjjcSIRB30VbUmFh0p9kGHHRFDTbw//MRMHOI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LESkajKdtmB4DOJ3VeEI9GpEBT9usk41p8ynhE95y3bhM8TCrYVMD33pNj3q/hIsF
         HHkF5Gzu+c0SmDBBrFh6YDeT09KtWmp6yZXO8r6aDryd8ig1vkDdLtsWIZ+uJmYW7b
         aBX4+GZZTA3GX7R8FbMGwNa52L1B/oqN9WbbuoSZ1yBvsLWHsRUaBYEj7JeyRpQdnC
         h3vd0jYUkiHhTAylyy1zhf4f/h7n0aepGJ2RH7cq7MAJNpPsCCH2VyDR4M+hJ/+EmY
         i4yQ058cn1jHd3pDaeeh5FmXG7Gi6g7gOvamOj8hQJuEcXsN/WxSq0E/5la5qIIO+l
         +7rrxVqXH2WSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 435C5C433EA; Sun,  9 Oct 2022 22:42:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216563] [xfstests generic/113] memcpy: detected field-spanning
 write (size 32) of single field "efdp->efd_format.efd_extents" at
 fs/xfs/xfs_extfree_item.c:693 (size 16)
Date:   Sun, 09 Oct 2022 22:42:29 +0000
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
Message-ID: <bug-216563-201763-xMifTmrqrR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216563-201763@https.bugzilla.kernel.org/>
References: <bug-216563-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216563

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
On Sun, Oct 09, 2022 at 10:08:46AM -0700, Darrick J. Wong wrote:
> On Sun, Oct 09, 2022 at 11:59:13AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216563
> >=20
> >             Bug ID: 216563
> >            Summary: [xfstests generic/113] memcpy: detected field-spann=
ing
> >                     write (size 32) of single field
> >                     "efdp->efd_format.efd_extents" at
> >                     fs/xfs/xfs_extfree_item.c:693 (size 16)
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: v6.1-rc0
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
> > I xfstests generic/113 hit below kernel warning [1] on xfs with 64k
> directory
> > block size (-n size=3D65536). It's reproducible for me, and the last ti=
me I
> > reproduce this bug on linux v6.0+ which HEAD=3D ...
> >=20
> > commit e8bc52cb8df80c31c73c726ab58ea9746e9ff734
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Fri Oct 7 17:04:10 2022 -0700
> >=20
> >     Merge tag 'driver-core-6.1-rc1' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
> >=20
> > I hit this issue on xfs with 64k directory block size 3 times(aarch64,
> x86_64
> > and ppc64le), and once on xfs with 1k blocksize (aarch64).
> >=20
> >=20
> > [1]
> > [ 4328.023770] run fstests generic/113 at 2022-10-08 11:57:42
> > [ 4330.104632] XFS (sda3): EXPERIMENTAL online scrub feature in use. Us=
e at
> > your own risk!
> > [ 4333.094807] XFS (sda3): Unmounting Filesystem
> > [ 4333.934996] XFS (sda3): Mounting V5 Filesystem
> > [ 4333.973061] XFS (sda3): Ending clean mount
> > [ 4335.457595] XFS (sda3): EXPERIMENTAL online scrub feature in use. Us=
e at
> > your own risk!
> > [ 4338.564849] XFS (sda3): Unmounting Filesystem
> > [ 4339.391848] XFS (sda3): Mounting V5 Filesystem
> > [ 4339.430908] XFS (sda3): Ending clean mount
> > [ 4340.100364] XFS (sda3): EXPERIMENTAL online scrub feature in use. Us=
e at
> > your own risk!
> > [ 4343.379506] XFS (sda3): Unmounting Filesystem
> > [ 4344.195036] XFS (sda3): Mounting V5 Filesystem
> > [ 4344.232984] XFS (sda3): Ending clean mount
> > [ 4345.190073] XFS (sda3): EXPERIMENTAL online scrub feature in use. Us=
e at
> > your own risk!
> > [ 4348.198562] XFS (sda3): Unmounting Filesystem
> > [ 4349.065061] XFS (sda3): Mounting V5 Filesystem
> > [ 4349.104995] XFS (sda3): Ending clean mount
> > [ 4350.118883] XFS (sda3): EXPERIMENTAL online scrub feature in use. Us=
e at
> > your own risk!
> > [ 4353.233555] XFS (sda3): Unmounting Filesystem
> > [ 4354.093530] XFS (sda3): Mounting V5 Filesystem
> > [ 4354.135975] XFS (sda3): Ending clean mount
> > [ 4354.337550] ------------[ cut here ]------------
> > [ 4354.342354] memcpy: detected field-spanning write (size 32) of single
> field
> > "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 1=
6)
> > [ 4354.355820] WARNING: CPU: 7 PID: 899243 at fs/xfs/xfs_extfree_item.c=
:693
> > xfs_efi_item_relog+0x1fc/0x270 [xfs]
>=20
> I think this is caused by an EF[ID] with ef[id]_nextents > 1, since the
> structure definition is:
>=20
> typedef struct xfs_efd_log_format {
>       uint16_t                efd_type;       /* efd log item type */
>       uint16_t                efd_size;       /* size of this item */
>       uint32_t                efd_nextents;   /* # of extents freed */
>       uint64_t                efd_efi_id;     /* id of corresponding efi =
*/
>       xfs_extent_t            efd_extents[1]; /* array of extents freed */
> } xfs_efd_log_format_t;
>=20
> Yuck, an array[1] that is actually a VLA!

Always been the case; the comment above both EFI and EFD definitions
state this directly:

/*
 * This is the structure used to lay out an efi log item in the
 * log.  The efi_extents field is a variable size array whose
 * size is given by efi_nextents.
 */

The EFI/EFD support recording multiple extents being freed in a
single intent. The idea behind this originally was that all the
extents being freed in a single transaction would be recorded in the
same EFI (i.e.  XFS_ITRUNC_MAX_EXTENTS) and the EFI and EFD could
then be relogged as progress freeing those extents is made after the
BMBT modifications were committed...

> I guess we're going to have to turn that into a real VLA, and adjust the
> xfs_ondisk.h macros to match?
>=20
> What memory sanitizer kconfig option enables this, anyway?

54d9469bc515 fortify: Add run-time WARN for cross-field memcpy()

CONFIG_FORTIFY_SOURCE=3Dy, committed in 6.0-rc2.

It effectively ignores flex arrays defined with [], but sees
anything defined with [1] as a fixed size array of known size and so
issues a warning when it's actually used as a flex array.

unsafe_memcpy() could be a temporary solution, given we know the
code works fine as it stands...

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
