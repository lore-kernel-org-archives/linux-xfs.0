Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2922EC04A95
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 16:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJYQrv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 12:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiJYQrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 12:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE6045F69
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 09:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AAE061A05
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 16:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB517C433C1;
        Tue, 25 Oct 2022 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666716467;
        bh=sRTaYCtrRHpu/COHl8Zsnw+MUnU2PxEF5ibArVXDcRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUiNRPCzsBVtSmur2LOVMGV/w/oXOfJKs+280pHJGakRHrbGmYGfophU94rf/W7Gd
         mYbRj0cuYV3Hby4CxjiYZVLL/WVtbNeVEEmWicZng2lGurqBfyfg3M9unRuqqU6RnE
         EYMj9xdZr0F1MsYrEeNNxrZYr9PrvyVZjKPRyQlr08XBuTXRtYMZHMzsGq6yuTHWFm
         bBdzNgA8N1JLuO7HeJ1SW0i6lSTWk/D/ql4+MF6LAxhDjRvEiikDW27US3uodtilmJ
         FpwK8gHJSO89C7htdS990I/uCCWa7oSiHwUepgZFzvdplwhZmVJMA+SE2tr+03TsCX
         79jCDSItliwJg==
Date:   Tue, 25 Oct 2022 09:47:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/26] xfs stable candidate patches for
 5.4.y (from v5.7)
Message-ID: <Y1gTM2KOJhDwroCK@magnolia>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
 <Y1cHC/khE7GDesH2@magnolia>
 <87v8o8l740.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8o8l740.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2022 at 11:14:53AM +0530, Chandan Babu R wrote:
> On Mon, Oct 24, 2022 at 02:43:39 PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 24, 2022 at 10:22:48AM +0530, Chandan Babu R wrote:
> >> Hi Darrick,
> >> 
> >> This 5.4.y backport series contains fixes from v5.7 release.
> >> 
> >> This patchset has been tested by executing fstests (via kdevops) using
> >> the following XFS configurations,
> >> 
> >> 1. No CRC (with 512 and 4k block size).
> >> 2. Reflink/Rmapbt (1k and 4k block size).
> >> 3. Reflink without Rmapbt.
> >> 4. External log device.
> >> 
> >> The following lists patches which required other dependency patches to
> >> be included,
> >> 1. dd87f87d87fa
> >>    xfs: rework insert range into an atomic operation
> >>    - b73df17e4c5b
> >>      xfs: open code insert range extent split helper
> >> 2. ce99494c9699
> >>    xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
> >>    - 8d57c21600a5
> >>      xfs: add a function to deal with corrupt buffers post-verifiers
> >>    - e83cf875d67a
> >>      xfs: xfs_buf_corruption_error should take __this_address
> >> 3. 8a6271431339
> >>    xfs: fix unmount hang and memory leak on shutdown during quotaoff
> >>    - 854f82b1f603
> >>      xfs: factor out quotaoff intent AIL removal and memory free
> >>    - aefe69a45d84
> >>      xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
> >>    - fd8b81dbbb23
> >>      xfs: remove the xfs_dq_logitem_t typedef
> >>    - d0bdfb106907
> >>      xfs: remove the xfs_qoff_logitem_t typedef
> >>    - 1cc95e6f0d7c
> >>      xfs: Replace function declaration by actual definition
> >
> > For the patches necessary to fix these first three problems,
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> >> 4. 0e7ab7efe774
> >>    xfs: Throttle commits on delayed background CIL push
> >>    - 108a42358a05
> >>      xfs: Lower CIL flush limit for large logs
> >> 5. 8eb807bd8399
> >>    xfs: tail updates only need to occur when LSN changes
> >>    (This commit improves performance rather than fix a bug. Please let
> >>    me know if I should drop this patch).
> >
> > Are there customer/user complaints behind items #4 and #5?  If not, I
> > think we ought to leave those out since this is already a very large
> > batch of patches.
> >
> 
> Ok. I will drop them from the patchset.
> 
> >>    - 4165994ac9672
> >>      xfs: factor common AIL item deletion code
> >> 6. 5833112df7e9
> >>    xfs: reflink should force the log out if mounted with wsync
> >>    - 54fbdd1035e3
> >>      xfs: factor out a new xfs_log_force_inode helper
> >
> > That said, item #6 looks good to me since they strengthen xfs'
> > persistence guarantees, so for these two patches,
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> 
> Hi Darrick,
> 
> Please let me know what you think about the following patches which didn't
> have any dependencies and hence wasn't part of the above list,
> 
> xfs: trylock underlying buffer on dquot flush
> xfs: check owner of dir3 data blocks
> xfs: check owner of dir3 blocks
> xfs: preserve default grace interval during quotacheck
> xfs: don't write a corrupt unmount record to force summary counter recalc
> xfs: move inode flush to the sync workqueue
> xfs: Use scnprintf() for avoiding potential buffer overflow

Ahh.  I meant to include those in the acked list, and now realize I
should've stated which patch #s I was acking.

That said, it's been a quiet morning so I've had the time to
refamiliarize myself with the four log changes and they seem reasonable
to add to 5.4.

For the entire series,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D


> >> 
> >> Brian Foster (6):
> >>   xfs: open code insert range extent split helper
> >>   xfs: rework insert range into an atomic operation
> >>   xfs: rework collapse range into an atomic operation
> >>   xfs: factor out quotaoff intent AIL removal and memory free
> >>   xfs: fix unmount hang and memory leak on shutdown during quotaoff
> >>   xfs: trylock underlying buffer on dquot flush
> >> 
> >> Christoph Hellwig (2):
> >>   xfs: factor out a new xfs_log_force_inode helper
> >>   xfs: reflink should force the log out if mounted with wsync
> >> 
> >> Darrick J. Wong (8):
> >>   xfs: add a function to deal with corrupt buffers post-verifiers
> >>   xfs: xfs_buf_corruption_error should take __this_address
> >>   xfs: fix buffer corruption reporting when xfs_dir3_free_header_check
> >>     fails
> >>   xfs: check owner of dir3 data blocks
> >>   xfs: check owner of dir3 blocks
> >>   xfs: preserve default grace interval during quotacheck
> >>   xfs: don't write a corrupt unmount record to force summary counter
> >>     recalc
> >>   xfs: move inode flush to the sync workqueue
> >> 
> >> Dave Chinner (5):
> >>   xfs: Lower CIL flush limit for large logs
> >>   xfs: Throttle commits on delayed background CIL push
> >>   xfs: factor common AIL item deletion code
> >>   xfs: tail updates only need to occur when LSN changes
> >>   xfs: fix use-after-free on CIL context on shutdown
> >> 
> >> Pavel Reichl (4):
> >>   xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
> >>   xfs: remove the xfs_dq_logitem_t typedef
> >>   xfs: remove the xfs_qoff_logitem_t typedef
> >>   xfs: Replace function declaration by actual definition
> >> 
> >> Takashi Iwai (1):
> >>   xfs: Use scnprintf() for avoiding potential buffer overflow
> >> 
> >>  fs/xfs/libxfs/xfs_alloc.c      |   2 +-
> >>  fs/xfs/libxfs/xfs_attr_leaf.c  |   6 +-
> >>  fs/xfs/libxfs/xfs_bmap.c       |  32 +-------
> >>  fs/xfs/libxfs/xfs_bmap.h       |   3 +-
> >>  fs/xfs/libxfs/xfs_btree.c      |   2 +-
> >>  fs/xfs/libxfs/xfs_da_btree.c   |  10 +--
> >>  fs/xfs/libxfs/xfs_dir2_block.c |  33 +++++++-
> >>  fs/xfs/libxfs/xfs_dir2_data.c  |  32 +++++++-
> >>  fs/xfs/libxfs/xfs_dir2_leaf.c  |   2 +-
> >>  fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
> >>  fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +-
> >>  fs/xfs/libxfs/xfs_format.h     |  10 +--
> >>  fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
> >>  fs/xfs/xfs_attr_inactive.c     |   6 +-
> >>  fs/xfs/xfs_attr_list.c         |   2 +-
> >>  fs/xfs/xfs_bmap_util.c         |  57 +++++++------
> >>  fs/xfs/xfs_buf.c               |  22 +++++
> >>  fs/xfs/xfs_buf.h               |   2 +
> >>  fs/xfs/xfs_dquot.c             |  26 +++---
> >>  fs/xfs/xfs_dquot.h             |  98 ++++++++++++-----------
> >>  fs/xfs/xfs_dquot_item.c        |  47 ++++++++---
> >>  fs/xfs/xfs_dquot_item.h        |  35 ++++----
> >>  fs/xfs/xfs_error.c             |   7 +-
> >>  fs/xfs/xfs_error.h             |   2 +-
> >>  fs/xfs/xfs_export.c            |  14 +---
> >>  fs/xfs/xfs_file.c              |  16 ++--
> >>  fs/xfs/xfs_inode.c             |  23 +++++-
> >>  fs/xfs/xfs_inode.h             |   1 +
> >>  fs/xfs/xfs_inode_item.c        |  28 +++----
> >>  fs/xfs/xfs_log.c               |  26 +++---
> >>  fs/xfs/xfs_log_cil.c           |  39 +++++++--
> >>  fs/xfs/xfs_log_priv.h          |  53 ++++++++++--
> >>  fs/xfs/xfs_log_recover.c       |   5 +-
> >>  fs/xfs/xfs_mount.h             |   5 ++
> >>  fs/xfs/xfs_qm.c                |  64 +++++++++------
> >>  fs/xfs/xfs_qm_bhv.c            |   6 +-
> >>  fs/xfs/xfs_qm_syscalls.c       | 142 ++++++++++++++++-----------------
> >>  fs/xfs/xfs_stats.c             |  10 +--
> >>  fs/xfs/xfs_super.c             |  28 +++++--
> >>  fs/xfs/xfs_trace.h             |   1 +
> >>  fs/xfs/xfs_trans_ail.c         |  88 ++++++++++++--------
> >>  fs/xfs/xfs_trans_dquot.c       |  54 ++++++-------
> >>  fs/xfs/xfs_trans_priv.h        |   6 +-
> >>  43 files changed, 646 insertions(+), 421 deletions(-)
> >> 
> >> -- 
> >> 2.35.1
> >> 
> 
> -- 
> chandan
