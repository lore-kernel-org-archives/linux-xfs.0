Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0C0C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 20:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJRUog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJRUoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 16:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E8AFAD3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 13:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE569B8210D
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 20:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B728C433D7;
        Tue, 18 Oct 2022 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666125865;
        bh=mgOex7y3sOnBUo89KQHwT+Tu6LykPf5SHLU0nCKUTas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R48A+rKr8aqP1+9XdhrzOykTv1So2wIkwLP9Q7t9Fjwmp3TEvV3Xi6wdfm/8D8Um/
         mTdCkLO9XuPFz1JVNltU8uLC5aDr44iQM0TEVf+RiUBawCA+fYyB4jdbWEuEJbxMQJ
         sQj36nopr5Fp7oYtzcRvl2omZlHrZLuBAwH+/pJIx/D1EnFvlV0a8mU3ecLR4KUQv/
         a2D8IedNy3fIGSIeC9WpvFRDl0Tq5DN5tLoBHf7w/sl2V/V4435RLyOfCYc+uGtN9t
         vVDJpOu9XlkK5DcBOwIVGFmVL0u2Yks6xTkhWGkopo2yFfdRPFIBvyxM6fGfsHF1UD
         ETnl6hemB/y2A==
Date:   Tue, 18 Oct 2022 13:44:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216563] [xfstests generic/113] memcpy: detected
 field-spanning write (size 32) of single field
 "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)
Message-ID: <Y08QKc6YMSOthy2N@magnolia>
References: <bug-216563-201763@https.bugzilla.kernel.org/>
 <bug-216563-201763-xMifTmrqrR@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216563-201763-xMifTmrqrR@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 09, 2022 at 10:42:29PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216563
> 
> --- Comment #3 from Dave Chinner (david@fromorbit.com) ---
> On Sun, Oct 09, 2022 at 10:08:46AM -0700, Darrick J. Wong wrote:
> > On Sun, Oct 09, 2022 at 11:59:13AM +0000, bugzilla-daemon@kernel.org wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=216563
> > > 
> > >             Bug ID: 216563
> > >            Summary: [xfstests generic/113] memcpy: detected field-spanning
> > >                     write (size 32) of single field
> > >                     "efdp->efd_format.efd_extents" at
> > >                     fs/xfs/xfs_extfree_item.c:693 (size 16)
> > >            Product: File System
> > >            Version: 2.5
> > >     Kernel Version: v6.1-rc0
> > >           Hardware: All
> > >                 OS: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: XFS
> > >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> > >           Reporter: zlang@redhat.com
> > >         Regression: No
> > > 
> > > I xfstests generic/113 hit below kernel warning [1] on xfs with 64k
> > directory
> > > block size (-n size=65536). It's reproducible for me, and the last time I
> > > reproduce this bug on linux v6.0+ which HEAD= ...
> > > 
> > > commit e8bc52cb8df80c31c73c726ab58ea9746e9ff734
> > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date:   Fri Oct 7 17:04:10 2022 -0700
> > > 
> > >     Merge tag 'driver-core-6.1-rc1' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
> > > 
> > > I hit this issue on xfs with 64k directory block size 3 times(aarch64,
> > x86_64
> > > and ppc64le), and once on xfs with 1k blocksize (aarch64).
> > > 
> > > 
> > > [1]
> > > [ 4328.023770] run fstests generic/113 at 2022-10-08 11:57:42
> > > [ 4330.104632] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > > your own risk!
> > > [ 4333.094807] XFS (sda3): Unmounting Filesystem
> > > [ 4333.934996] XFS (sda3): Mounting V5 Filesystem
> > > [ 4333.973061] XFS (sda3): Ending clean mount
> > > [ 4335.457595] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > > your own risk!
> > > [ 4338.564849] XFS (sda3): Unmounting Filesystem
> > > [ 4339.391848] XFS (sda3): Mounting V5 Filesystem
> > > [ 4339.430908] XFS (sda3): Ending clean mount
> > > [ 4340.100364] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > > your own risk!
> > > [ 4343.379506] XFS (sda3): Unmounting Filesystem
> > > [ 4344.195036] XFS (sda3): Mounting V5 Filesystem
> > > [ 4344.232984] XFS (sda3): Ending clean mount
> > > [ 4345.190073] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > > your own risk!
> > > [ 4348.198562] XFS (sda3): Unmounting Filesystem
> > > [ 4349.065061] XFS (sda3): Mounting V5 Filesystem
> > > [ 4349.104995] XFS (sda3): Ending clean mount
> > > [ 4350.118883] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > > your own risk!
> > > [ 4353.233555] XFS (sda3): Unmounting Filesystem
> > > [ 4354.093530] XFS (sda3): Mounting V5 Filesystem
> > > [ 4354.135975] XFS (sda3): Ending clean mount
> > > [ 4354.337550] ------------[ cut here ]------------
> > > [ 4354.342354] memcpy: detected field-spanning write (size 32) of single
> > field
> > > "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)
> > > [ 4354.355820] WARNING: CPU: 7 PID: 899243 at fs/xfs/xfs_extfree_item.c:693
> > > xfs_efi_item_relog+0x1fc/0x270 [xfs]
> > 
> > I think this is caused by an EF[ID] with ef[id]_nextents > 1, since the
> > structure definition is:
> > 
> > typedef struct xfs_efd_log_format {
> >       uint16_t                efd_type;       /* efd log item type */
> >       uint16_t                efd_size;       /* size of this item */
> >       uint32_t                efd_nextents;   /* # of extents freed */
> >       uint64_t                efd_efi_id;     /* id of corresponding efi */
> >       xfs_extent_t            efd_extents[1]; /* array of extents freed */
> > } xfs_efd_log_format_t;
> > 
> > Yuck, an array[1] that is actually a VLA!
> 
> Always been the case; the comment above both EFI and EFD definitions
> state this directly:
> 
> /*
>  * This is the structure used to lay out an efi log item in the
>  * log.  The efi_extents field is a variable size array whose
>  * size is given by efi_nextents.
>  */
> 
> The EFI/EFD support recording multiple extents being freed in a
> single intent. The idea behind this originally was that all the
> extents being freed in a single transaction would be recorded in the
> same EFI (i.e.  XFS_ITRUNC_MAX_EXTENTS) and the EFI and EFD could
> then be relogged as progress freeing those extents is made after the
> BMBT modifications were committed...
> 
> > I guess we're going to have to turn that into a real VLA, and adjust the
> > xfs_ondisk.h macros to match?
> > 
> > What memory sanitizer kconfig option enables this, anyway?
> 
> 54d9469bc515 fortify: Add run-time WARN for cross-field memcpy()
> 
> CONFIG_FORTIFY_SOURCE=y, committed in 6.0-rc2.
> 
> It effectively ignores flex arrays defined with [], but sees
> anything defined with [1] as a fixed size array of known size and so
> issues a warning when it's actually used as a flex array.
> 
> unsafe_memcpy() could be a temporary solution, given we know the
> code works fine as it stands...

Annoyingly, this now triggers fstests failures on xfs/436 when log
recovery tries to memcpy a BUI log item:

------------[ cut here ]------------
memcpy: detected field-spanning write (size 48) of single field
"dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)
WARNING: CPU: 0 PID: 20925 at fs/xfs/xfs_bmap_item.c:628
xlog_recover_bui_commit_pass2+0x124/0x160 [xfs]

Here we're using struct xfs_map_extent bui_extents[] for the VLA, so I
think this means the memcpy fortify macros aren't detecting the VLAs
correctly at all.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
