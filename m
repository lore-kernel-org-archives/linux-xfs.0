Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72521C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiJIXpj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJIXop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:44:45 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 515B35A2C7
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 16:16:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 248BC1101555;
        Mon, 10 Oct 2022 09:42:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ohezx-0004jQ-VC; Mon, 10 Oct 2022 09:42:17 +1100
Date:   Mon, 10 Oct 2022 09:42:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     bugzilla-daemon@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 216563] New: [xfstests generic/113] memcpy: detected
 field-spanning write (size 32) of single field
 "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)
Message-ID: <20221009224217.GR3600936@dread.disaster.area>
References: <bug-216563-201763@https.bugzilla.kernel.org/>
 <Y0MAHhIW4qqpbaLj@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0MAHhIW4qqpbaLj@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63434e4c
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=Z4Rwk6OoAAAA:8 a=7-415B0cAAAA:8 a=ESbuc5oQwcc4iB0716wA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=HkZW87K1Qel5hWWM3VKY:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 09, 2022 at 10:08:46AM -0700, Darrick J. Wong wrote:
> On Sun, Oct 09, 2022 at 11:59:13AM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=216563
> > 
> >             Bug ID: 216563
> >            Summary: [xfstests generic/113] memcpy: detected field-spanning
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
> > 
> > I xfstests generic/113 hit below kernel warning [1] on xfs with 64k directory
> > block size (-n size=65536). It's reproducible for me, and the last time I
> > reproduce this bug on linux v6.0+ which HEAD= ...
> > 
> > commit e8bc52cb8df80c31c73c726ab58ea9746e9ff734
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Fri Oct 7 17:04:10 2022 -0700
> > 
> >     Merge tag 'driver-core-6.1-rc1' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
> > 
> > I hit this issue on xfs with 64k directory block size 3 times(aarch64, x86_64
> > and ppc64le), and once on xfs with 1k blocksize (aarch64).
> > 
> > 
> > [1]
> > [ 4328.023770] run fstests generic/113 at 2022-10-08 11:57:42
> > [ 4330.104632] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > your own risk!
> > [ 4333.094807] XFS (sda3): Unmounting Filesystem
> > [ 4333.934996] XFS (sda3): Mounting V5 Filesystem
> > [ 4333.973061] XFS (sda3): Ending clean mount
> > [ 4335.457595] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > your own risk!
> > [ 4338.564849] XFS (sda3): Unmounting Filesystem
> > [ 4339.391848] XFS (sda3): Mounting V5 Filesystem
> > [ 4339.430908] XFS (sda3): Ending clean mount
> > [ 4340.100364] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > your own risk!
> > [ 4343.379506] XFS (sda3): Unmounting Filesystem
> > [ 4344.195036] XFS (sda3): Mounting V5 Filesystem
> > [ 4344.232984] XFS (sda3): Ending clean mount
> > [ 4345.190073] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > your own risk!
> > [ 4348.198562] XFS (sda3): Unmounting Filesystem
> > [ 4349.065061] XFS (sda3): Mounting V5 Filesystem
> > [ 4349.104995] XFS (sda3): Ending clean mount
> > [ 4350.118883] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> > your own risk!
> > [ 4353.233555] XFS (sda3): Unmounting Filesystem
> > [ 4354.093530] XFS (sda3): Mounting V5 Filesystem
> > [ 4354.135975] XFS (sda3): Ending clean mount
> > [ 4354.337550] ------------[ cut here ]------------
> > [ 4354.342354] memcpy: detected field-spanning write (size 32) of single field
> > "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)
> > [ 4354.355820] WARNING: CPU: 7 PID: 899243 at fs/xfs/xfs_extfree_item.c:693
> > xfs_efi_item_relog+0x1fc/0x270 [xfs]
> 
> I think this is caused by an EF[ID] with ef[id]_nextents > 1, since the
> structure definition is:
> 
> typedef struct xfs_efd_log_format {
> 	uint16_t		efd_type;	/* efd log item type */
> 	uint16_t		efd_size;	/* size of this item */
> 	uint32_t		efd_nextents;	/* # of extents freed */
> 	uint64_t		efd_efi_id;	/* id of corresponding efi */
> 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> } xfs_efd_log_format_t;
> 
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
> 
> What memory sanitizer kconfig option enables this, anyway?

54d9469bc515 fortify: Add run-time WARN for cross-field memcpy()

CONFIG_FORTIFY_SOURCE=y, committed in 6.0-rc2.

It effectively ignores flex arrays defined with [], but sees
anything defined with [1] as a fixed size array of known size and so
issues a warning when it's actually used as a flex array.

unsafe_memcpy() could be a temporary solution, given we know the
code works fine as it stands...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
