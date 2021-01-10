Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1360C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 06:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8571F23715
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 06:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725270AbhAJGrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 01:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbhAJGrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 01:47:09 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3BAC061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 22:46:28 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a188so8994268pfa.11
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 22:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=miekOL+AW08wJY6mQkQQTUDLjA579j/x+Bbo1p3gbZo=;
        b=QRP3OKN/whw0DclaYwGLe+skcrXfl2x/1vEKpp6qFP9HCX0dm+ufGzX2lQW+PKKKFe
         wPLc/kF/Tra4beCQy9r8pWW6LlbRYmsqrgaETtYcwB9QHd6ia+ZwnW74nVqbsuOqYD+U
         597TybV/rgK4ZBxy3dGmfDoFxF+3m75E2zSSz/k7JWQMM1lSxCHMaTF9WPy1kgOyxDCu
         BpzuSNMKri7h6fYRc0I70FU8GJzeBiTsWSMp4zz5NIkElxaS4QrdBOVIn7eSgJd4ztqZ
         HsoTqiKcJkeFfW/q+8mmNlX5sOA/Pq11vRFNK+xnN3aSSqAw4C7/+Fga5Ik0SK69ZvrO
         iR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=miekOL+AW08wJY6mQkQQTUDLjA579j/x+Bbo1p3gbZo=;
        b=jXZth0ciemUq3aJ3CxGIDelwPNfMZWtGjRDGYiLNZBEhDswXU4/glxU5nQHzCKMsga
         +VsPGQCiYOh+RL2truMi0ULOg8P1tpydoi7DAye3fDkuTDqGIlm74xo2VuV+f7HWB4wY
         Ll/JZWxE+vi6Dkd8OC8BGNwgJErnqxMyx8zIhicoHwupA9UdS5Wcm9Uh74mkvIaJdZby
         GLxC5A5NgaNt6cpUqcisLvzWNr1DmJ9SjDxkB2PRM2izaazL3AFNllOcamlsX9E5Ph5F
         En8AjpvEEjxECGHA0SiRFpeTm6IQYKj1Y68IihT6fHlPXzIK+AqKgmI4NyKU8DbVxFBc
         g4tQ==
X-Gm-Message-State: AOAM530wHVX9Mjj0adaFq53GFYn3oZD1you1fz5ntuNTD0+ifzb0qKGW
        N94fG5DFUZOVmN82WUut34s=
X-Google-Smtp-Source: ABdhPJx2v5p4mE2WG2r3N0xn3QrHvdWeosxPT6xBwGFI579DXnsoRdEkYjIi46ezKyjC7aJL4CoNVA==
X-Received: by 2002:a62:6d06:0:b029:1a8:4d3f:947a with SMTP id i6-20020a626d060000b02901a84d3f947amr14497682pfc.6.1610261188008;
        Sat, 09 Jan 2021 22:46:28 -0800 (PST)
Received: from garuda ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id y3sm10385144pjy.13.2021.01.09.22.46.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Jan 2021 22:46:27 -0800 (PST)
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: Re: [PATCH V13 00/16] Bail out if transaction can cause extent count to overflow
In-reply-to: <20210110032928.3120861-1-chandanrlinux@gmail.com>
Date:   Sun, 10 Jan 2021 12:16:23 +0530
Message-ID: <877dolb874.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


The changes in the patch "[PATCH V13 05/16] xfs: Check for extent overflow
when removing dir entries" are not correct. I noticed this only after sending
the patchset. The correct change should be,

       error = xfs_iext_count_may_overflow(ip, whichfork, 1);
       if (error) {
               ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
                       whichfork == XFS_DATA_FORK);
               error = -ENOSPC;
               goto done;
       }

Hence please ignore this patchset. I will send the fixed version soon. Sorry
about the noise.

On 10 Jan 2021 at 08:59, Chandan Babu R wrote:
> XFS does not check for possible overflow of per-inode extent counter
> fields when adding extents to either data or attr fork.
>
> For e.g.
> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>    then delete 50% of them in an alternating manner.
>
> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>    extents to be created in the attr fork of the inode.
>
>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
>
> 3. The incore inode fork extent counter is a signed 32-bit
>    quantity. However, the on-disk extent counter is an unsigned 16-bit
>    quantity and hence cannot hold 98511 extents.
>
> 4. The following incorrect value is stored in the xattr extent counter,
>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>    core.naextents = -32561
>
> This patchset adds a new helper function
> (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> per-inode data and xattr extent counters and invokes it before
> starting an fs operation (e.g. creating a new directory entry). With
> this patchset applied, XFS detects counter overflows and returns with
> an error rather than causing a silent corruption.
>
> The patchset has been tested by executing xfstests with the following
> mkfs.xfs options,
> 1. -m crc=0 -b size=1k
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
>
> The patches can also be obtained from
> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v13.
>
> I have two patches that define the newly introduced error injection
> tags in xfsprogs
> (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
>
> I have also written tests
> (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> for verifying the checks introduced in the kernel.
>
> Changelog:
> V12 -> V13:
>   1. xfs_rename():
>      - Add comment explaining why we do not check for extent count
>        overflow for the source directory entry of a rename operation.
>      - Fix grammatical nit in a comment.
>   2. xfs_bmap_del_extent_real():
>      Replace explicit checks for inode's mode and fork with an
>      assert() call since extent count overflow check here is
>      applicable only to directory entry remove/rename operation.
>
> V11 -> V12:
>   1. Rebase patches on top of Linux v5.11-rc1.
>   2. Revert back to using using a pseudo max inode extent count of 10.
>      Hence the patches
>      - [PATCH V12 05/14] xfs: Check for extent overflow when adding/removing xattrs
>      - [PATCH V12 10/14] xfs: Introduce error injection to reduce maximum
>      have been reverted back (including retaining of corresponding RVB
>      tags) to how it was under V10 of the patchset.
>
>      V11 of the patchset had increased the max pseudo extent count to
>      35 to allow for "directory entry remove" operation to always
>      succeed. However the corresponding logic was incorrect. Please
>      refer to "[PATCH V12 04/14] xfs: Check for extent overflow when
>      adding/removing dir entries" to find logic and explaination of
>      the newer logic.
>
>      "[PATCH V12 04/14] xfs: Check for extent overflow when
>      adding/removing dir entries" is the only patch yet to be reviewed.
>
> V10 -> V11:
>   1. For directory/xattr insert operations we now reserve sufficient
>      number of "extent count" so as to guarantee a future
>      directory/xattr remove operation.
>   2. The pseudo max extent count value has been increased to 35.
>
> V9 -> V10:
>   1. Pull back changes which cause xfs_bmap_compute_alignments() to
>      return "stripe alignment" into 12th patch i.e. "xfs: Compute bmap
>      extent alignments in a separate function".
>
> V8 -> V9:
>   1. Enabling XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag will
>      always allocate single block sized free extents (if
>      available).
>   2. xfs_bmap_compute_alignments() now returns stripe alignment as its
>      return value.
>   3. Dropped Allison's RVB tag for "xfs: Compute bmap extent
>      alignments in a separate function" and "xfs: Introduce error
>      injection to allocate only minlen size extents for files".
>
> V7 -> V8:
>   1. Rename local variable in xfs_alloc_fix_freelist() from "i" to "stat".
>
> V6 -> V7:
>   1. Create new function xfs_bmap_exact_minlen_extent_alloc() (enabled
>      only when CONFIG_XFS_DEBUG is set to y) which issues allocation
>      requests for minlen sized extents only. In order to achieve this,
>      common code from xfs_bmap_btalloc() have been refactored into new
>      functions.
>   2. All major functions implementing logic associated with
>      XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag are compiled only
>      when CONFIG_XFS_DEBUG is set to y.
>   3. Remove XFS_IEXT_REFLINK_REMAP_CNT macro and replace it with an
>      integer which holds the number of new extents to be
>      added to the data fork.
>
> V5 -> V6:
>   1. Rebased the patchset on xfs-linux/for-next branch.
>   2. Drop "xfs: Set tp->t_firstblock only once during a transaction's
>      lifetime" patch from the patchset.
>   3. Add a comment to xfs_bmap_btalloc() describing why it was chosen
>      to start "free space extent search" from AG 0 when
>      XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is enabled and when the
>      transaction is allocating its first extent.
>   4. Fix review comments associated with coding style.
>
> V4 -> V5:
>   1. Introduce new error tag XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT to
>      let user space programs to be able to guarantee that free space
>      requests for files are satisfied by allocating minlen sized
>      extents.
>   2. Change xfs_bmap_btalloc() and xfs_alloc_vextent() to allocate
>      minlen sized extents when XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is
>      enabled.
>   3. Introduce a new patch that causes tp->t_firstblock to be assigned
>      to a value only when its previous value is NULLFSBLOCK.
>   4. Replace the previously introduced MAXERRTAGEXTNUM (maximum inode
>      fork extent count) with the hardcoded value of 10.
>   5. xfs_bui_item_recover(): Use XFS_IEXT_ADD_NOSPLIT_CNT when mapping
>      an extent.
>   6. xfs_swap_extent_rmap(): Use xfs_bmap_is_real_extent() instead of
>      xfs_bmap_is_update_needed() to assess if the extent really needs
>      to be swapped.
>
> V3 -> V4:
>   1. Introduce new patch which lets userspace programs to test "extent
>      count overflow detection" by injecting an error tag. The new
>      error tag reduces the maximum allowed extent count to 10.
>   2. Injecting the newly defined error tag prevents
>      xfs_bmap_add_extent_hole_real() from merging a new extent with
>      its neighbours to allow writing deterministic tests for testing
>      extent count overflow for Directories, Xattr and growing realtime
>      devices. This is required because the new extent being allocated
>      can be contiguous with its neighbours (w.r.t both file and disk
>      offsets).
>   3. Injecting the newly defined error tag forces block sized extents
>      to be allocated for summary/bitmap files when growing a realtime
>      device. This is required because xfs_growfs_rt_alloc() allocates
>      as large an extent as possible for summary/bitmap files and hence
>      it would be impossible to write deterministic tests.
>   4. Rename XFS_IEXT_REMOVE_CNT to XFS_IEXT_PUNCH_HOLE_CNT to reflect
>      the actual meaning of the fs operation.
>   5. Fold XFS_IEXT_INSERT_HOLE_CNT code into that associated with
>      XFS_IEXT_PUNCH_HOLE_CNT since both perform the same job.
>   6. xfs_swap_extent_rmap(): Check for extent overflow should be made
>      on the source file only if the donor file extent has a valid
>      on-disk mapping and vice versa.
>
> V2 -> V3:
>   1. Move the definition of xfs_iext_count_may_overflow() from
>      libxfs/xfs_trans_resv.c to libxfs/xfs_inode_fork.c. Also, I tried
>      to make xfs_iext_count_may_overflow() an inline function by
>      placing the definition in libxfs/xfs_inode_fork.h. However this
>      required that the definition of 'struct xfs_inode' be available,
>      since xfs_iext_count_may_overflow() uses a 'struct xfs_inode *'
>      type variable.
>   2. Handle XFS_COW_FORK within xfs_iext_count_may_overflow() by
>      returning a success value.
>   3. Rename XFS_IEXT_ADD_CNT to XFS_IEXT_ADD_NOSPLIT_CNT. Thanks to
>      Darrick for the suggesting the new name.
>   4. Expand comments to make use of 80 columns.
>
> V1 -> V2:
>   1. Rename helper function from xfs_trans_resv_ext_cnt() to
>      xfs_iext_count_may_overflow().
>   2. Define and use macros to represent fs operations and the
>      corresponding increase in extent count.
>   3. Split the patches based on the fs operation being performed.
>
> Chandan Babu R (16):
>   xfs: Add helper for checking per-inode extent count overflow
>   xfs: Check for extent overflow when trivally adding a new extent
>   xfs: Check for extent overflow when punching a hole
>   xfs: Check for extent overflow when adding dir entries
>   xfs: Check for extent overflow when removing dir entries
>   xfs: Check for extent overflow when renaming dir entries
>   xfs: Check for extent overflow when adding/removing xattrs
>   xfs: Check for extent overflow when writing to unwritten extent
>   xfs: Check for extent overflow when moving extent from cow to data
>     fork
>   xfs: Check for extent overflow when remapping an extent
>   xfs: Check for extent overflow when swapping extents
>   xfs: Introduce error injection to reduce maximum inode fork extent
>     count
>   xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
>   xfs: Compute bmap extent alignments in a separate function
>   xfs: Process allocated extent in a separate function
>   xfs: Introduce error injection to allocate only minlen size extents
>     for files
>
>  fs/xfs/libxfs/xfs_alloc.c      |  50 ++++++
>  fs/xfs/libxfs/xfs_alloc.h      |   3 +
>  fs/xfs/libxfs/xfs_attr.c       |  13 ++
>  fs/xfs/libxfs/xfs_bmap.c       | 284 ++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_errortag.h   |   6 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  27 ++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  63 ++++++++
>  fs/xfs/xfs_bmap_item.c         |  10 ++
>  fs/xfs/xfs_bmap_util.c         |  31 ++++
>  fs/xfs/xfs_dquot.c             |   8 +-
>  fs/xfs/xfs_error.c             |   6 +
>  fs/xfs/xfs_inode.c             |  54 ++++++-
>  fs/xfs/xfs_iomap.c             |  10 ++
>  fs/xfs/xfs_reflink.c           |  16 ++
>  fs/xfs/xfs_rtalloc.c           |   5 +
>  fs/xfs/xfs_symlink.c           |   5 +
>  16 files changed, 512 insertions(+), 79 deletions(-)


--
chandan
