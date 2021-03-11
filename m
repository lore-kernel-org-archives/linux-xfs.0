Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624D4C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C28F64FC9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCKDRt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCKDRq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E633F64FA0;
        Thu, 11 Mar 2021 03:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615432666;
        bh=Ulzk4EkRgY5GGXvOsF1K/JTP4e+vMGk4v2EpJKJtV8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBk80hK3SLcbwhHIBvvYm9il1coYyIFfj6VE+6m6c+1PhV9+ywYlCuZtyoHNJ7zEr
         vt3V7njjRic2QG87hzj7SKt6R4xYTK0TEoKpOTpEGqjqRR67E7CjiWTwjon/Kb43XM
         VfdEPGxslC28TPwC8xUJJkZo84ZvzNzHnoG1AcvE/DUdak8lss0IBSRWc0uU/HEcDk
         oO/k10qRiizVZbwSt5f8MUUMfixbv+2aL7n5KszAV1OXB4t1zXuIpskdnSgSeXSf6Q
         2tVYaVoNPFT7C+sE8cFAGJKdpuFxHwHdBrk6x1QvRvtYwF+yl7MLBWAcakjtyCoo9z
         kLCndAcVTyvzw==
Date:   Wed, 10 Mar 2021 19:17:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210311031745.GT3419940@magnolia>
References: <20210310020108.GA279881@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210310020108.GA279881@embeddedor>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 08:01:08PM -0600, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of flexible-array members in
> multiple structures, instead of one-element arrays. Also, make use of
> the new flex_array_size() and struct_size() helpers to properly calculate
> the size of multiple structures that contain flexible-array members.
> 
> Below are the results of running xfstests for groups shutdown and log
> with the following configuration in local.config:
> 
> export TEST_DEV=/dev/sda3
> export TEST_DIR=/mnt/test
> export SCRATCH_DEV=/dev/sda4
> export SCRATCH_MNT=/mnt/scratch
> 
> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
> 
> These are the results of running ./check -g shutdown and ./check -g
> log, respectively, on 5.12.0-rc2-next-20210309 kernel WITHOUT this patch
> applied:
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g shutdown 2>&1 | tee xfs-shutdown-no-patch.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.12.0-rc2-next-20210309 #21 SMP Tue Mar 9 17:48:24 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/042 2s ...  2s
> generic/043 13s ...  13s
> generic/044 14s ...  15s
> generic/045 18s ...  17s
> generic/046 14s ...  14s
> generic/047 21s ...  20s
> generic/048 50s ...  51s
> generic/049 9s ...  9s
> generic/050 1s ...  1s
> generic/051 77s ...  76s
> generic/052 1s ...  1s
> generic/054 70s ...  31s
> generic/055 15s ...  18s
> generic/388 82s ...  80s
> generic/392 5s ...  4s
> generic/417 11s ...  12s
> generic/461 22s ...  21s
> generic/468 12s ...  3s
> generic/474 2s ...  1s
> generic/475 87s ...  97s
> generic/505 1s ...  1s
> generic/506 2s ...  2s
> generic/507     [not run] file system doesn't support chattr +AsSu
> generic/508 4s ...  5s
> generic/530 14s ...  14s
> generic/536 2s ...  2s
> generic/599 2s ...  1s
> generic/622 23s ...  24s
> xfs/051 18s ...  18s
> xfs/079 14s ...  14s
> xfs/121 6s ...  32s
> xfs/181 12s ...  12s
> xfs/212 2s ...  2s
> Ran: generic/042 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/054 generic/055 generic/388 generic/392 generic/417 generic/461 generic/468 generic/474 generic/475 generic/505 generic/506 generic/507 generic/508 generic/530 generic/536 generic/599 generic/622 xfs/051 xfs/079 xfs/121 xfs/181 xfs/212
> Not run: generic/507
> Passed all 33 tests
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g log 2>&1 | tee xfs-log-no-patch.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.12.0-rc2-next-20210309 #21 SMP Tue Mar 9 17:48:24 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/034 0s ...  1s
> generic/039 1s ...  1s
> generic/040 5s ...  5s
> generic/041 8s ...  7s
> generic/043 13s ...  13s
> generic/044 14s ...  15s
> generic/045 18s ...  17s
> generic/046 14s ...  15s
> generic/051 75s ...  76s
> generic/052 2s ...  1s
> generic/054 32s ...  31s
> generic/055 19s ...  23s
> generic/056 1s ...  2s
> generic/057 1s ...  1s
> generic/059 2s ...  2s
> generic/065 1s ...  1s
> generic/066 1s ...  1s
> generic/073 1s ...  1s
> generic/090 1s ...  1s
> generic/101 1s ...  1s
> generic/104 1s ...  1s
> generic/106 1s ...  1s
> generic/107 1s ...  1s
> generic/177 1s ...  1s
> generic/311 68s ...  66s
> generic/321 1s ...  2s
> generic/322 2s ...  1s
> generic/325 1s ...  1s
> generic/335 1s ...  2s
> generic/336 1s ...  1s
> generic/341 1s ...  1s
> generic/342 1s ...  1s
> generic/343 1s ...  1s
> generic/376 1s ...  1s
> generic/388 93s ...  81s
> generic/417 11s ...  12s
> generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> generic/475 98s ...  81s
> generic/479 2s ...  2s
> generic/480 1s ...  1s
> generic/481 1s ...  1s
> generic/483 7s ...  7s
> generic/489 1s ...  1s
> generic/498 1s ...  1s
> generic/501 56s ...  57s
> generic/502 1s ...  1s
> generic/509 1s ...  1s
> generic/510 1s ...  1s
> generic/512 1s ...  1s
> generic/520 16s ...  16s
> generic/526 2s ...  1s
> generic/527 1s ...  1s
> generic/534 1s ...  1s
> generic/535 1s ...  1s
> generic/546 3s ...  3s
> generic/547 2s ...  2s
> generic/552 1s ...  1s
> generic/557 2s ...  2s
> generic/588 1s ...  1s
> shared/002 9s ...  9s
> xfs/011 18s ...  18s
> xfs/029 1s ...  1s
> xfs/051 17s ...  18s
> xfs/057 24s ...  24s
> xfs/079 14s ...  13s
> xfs/095 2s ...  2s
> xfs/119 2s ...  2s
> xfs/121 6s ...  7s
> xfs/141 16s ...  10s
> xfs/181 40s ...  12s
> xfs/216 2s ...  3s
> xfs/217 2s ...  2s
> xfs/439 [not run] test requires XFS bug_on_assert to be off, turn it off to run the test
> Ran: generic/034 generic/039 generic/040 generic/041 generic/043 generic/044 generic/045 generic/046 generic/051 generic/052 generic/054 generic/055 generic/056 generic/057 generic/059 generic/065 generic/066 generic/073 generic/090 generic/101 generic/104 generic/106 generic/107 generic/177 generic/311 generic/321 generic/322 generic/325 generic/335 generic/336 generic/341 generic/342 generic/343 generic/376 generic/388 generic/417 generic/455 generic/457 generic/475 generic/479 generic/480 generic/481 generic/483 generic/489 generic/498 generic/501 generic/502 generic/509 generic/510 generic/512 generic/520 generic/526 generic/527 generic/534 generic/535 generic/546 generic/547 generic/552 generic/557 generic/588 shared/002 xfs/011 xfs/029 xfs/051 xfs/057 xfs/079 xfs/095 xfs/119 xfs/121 xfs/141 xfs/181 xfs/216 xfs/217 xfs/439
> Not run: generic/455 generic/457 xfs/439
> Passed all 74 tests
> 
> These are the results of running ./check -g shutdown and ./check -g
> log, respectively, on 5.12.0-rc2-xfstests-patched-next-20210309+ kernel
> WITH this patch applied on top:
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g shutdown 2>&1 | tee xfs-shutdown-patched.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.12.0-rc2-xfstests-patched-next-20210309+ #20 SMP Tue Mar 9 17:02:09 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/042 2s ...  3s
> generic/043 13s ...  12s
> generic/044 14s ...  15s
> generic/045 18s ...  18s
> generic/046 14s ...  14s
> generic/047 21s ...  21s
> generic/048 51s ...  51s
> generic/049 8s ...  8s
> generic/050 1s ...  2s
> generic/051 76s ...  75s
> generic/052 1s ...  2s
> generic/054 35s ...  70s
> generic/055 16s ...  21s
> generic/388 77s ...  76s
> generic/392 29s ...  6s
> generic/417 12s ...  11s
> generic/461 21s ...  22s
> generic/468 3s ...  3s
> generic/474 1s ...  1s
> generic/475 99s ...  91s
> generic/505 2s ...  2s
> generic/506 1s ...  1s
> generic/507     [not run] file system doesn't support chattr +AsSu
> generic/508 2s ...  4s
> generic/530 12s ...  9s
> generic/536 2s ...  3s
> generic/599 1s ...  1s
> generic/622 24s ...  24s
> xfs/051 18s ...  19s
> xfs/079 16s ...  13s
> xfs/121 7s ...  7s
> xfs/181 11s ...  11s
> xfs/212 2s ...  2s
> Ran: generic/042 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/054 generic/055 generic/388 generic/392 generic/417 generic/461 generic/468 generic/474 generic/475 generic/505 generic/506 generic/507 generic/508 generic/530 generic/536 generic/599 generic/622 xfs/051 xfs/079 xfs/121 xfs/181 xfs/212
> Not run: generic/507
> Passed all 33 tests
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g log 2>&1 | tee xfs-log-patched.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.12.0-rc2-xfstests-patched-next-20210309+ #20 SMP Tue Mar 9 17:02:09 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/034 1s ...  0s
> generic/039 1s ...  1s
> generic/040 5s ...  5s
> generic/041 7s ...  8s
> generic/043 12s ...  12s
> generic/044 15s ...  15s
> generic/045 18s ...  18s
> generic/046 14s ...  14s
> generic/051 75s ...  76s
> generic/052 2s ...  5s
> generic/054 70s ...  32s
> generic/055 21s ...  15s
> generic/056 1s ...  1s
> generic/057 1s ...  1s
> generic/059 2s ...  2s
> generic/065 1s ...  1s
> generic/066 2s ...  1s
> generic/073 1s ...  1s
> generic/090 1s ...  1s
> generic/101 1s ...  1s
> generic/104 1s ...  1s
> generic/106 1s ...  1s
> generic/107 1s ...  1s
> generic/177 1s ...  1s
> generic/311 67s ...  68s
> generic/321 2s ...  1s
> generic/322 2s ...  2s
> generic/325 1s ...  1s
> generic/335 1s ...  1s
> generic/336 1s ...  1s
> generic/341 1s ...  1s
> generic/342 1s ...  1s
> generic/343 1s ...  1s
> generic/376 1s ...  1s
> generic/388 76s ...  79s
> generic/417 11s ...  12s
> generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> generic/475 91s ...  98s
> generic/479 2s ...  2s
> generic/480 1s ...  1s
> generic/481 1s ...  1s
> generic/483 6s ...  7s
> generic/489 1s ...  1s
> generic/498 1s ...  1s
> generic/501 63s ...  56s
> generic/502 1s ...  1s
> generic/509 1s ...  1s
> generic/510 1s ...  1s
> generic/512 1s ...  1s
> generic/520 17s ...  16s
> generic/526 1s ...  2s
> generic/527 1s ...  1s
> generic/534 1s ...  1s
> generic/535 1s ...  1s
> generic/546 3s ...  3s
> generic/547 2s ...  2s
> generic/552 1s ...  1s
> generic/557 2s ...  2s
> generic/588 1s ...  1s
> shared/002 9s ...  9s
> xfs/011 18s ...  18s
> xfs/029 1s ...  1s
> xfs/051 19s ...  18s
> xfs/057 23s ...  24s
> xfs/079 13s ...  14s
> xfs/095 1s ...  2s
> xfs/119 3s ...  2s
> xfs/121 7s ...  10s
> xfs/141 26s ...  16s
> xfs/181 11s ...  11s
> xfs/216 2s ...  2s
> xfs/217 2s ...  2s
> xfs/439 [not run] test requires XFS bug_on_assert to be off, turn it off to run the test
> Ran: generic/034 generic/039 generic/040 generic/041 generic/043 generic/044 generic/045 generic/046 generic/051 generic/052 generic/054 generic/055 generic/056 generic/057 generic/059 generic/065 generic/066 generic/073 generic/090 generic/101 generic/104 generic/106 generic/107 generic/177 generic/311 generic/321 generic/322 generic/325 generic/335 generic/336 generic/341 generic/342 generic/343 generic/376 generic/388 generic/417 generic/455 generic/457 generic/475 generic/479 generic/480 generic/481 generic/483 generic/489 generic/498 generic/501 generic/502 generic/509 generic/510 generic/512 generic/520 generic/526 generic/527 generic/534 generic/535 generic/546 generic/547 generic/552 generic/557 generic/588 shared/002 xfs/011 xfs/029 xfs/051 xfs/057 xfs/079 xfs/095 xfs/119 xfs/121 xfs/141 xfs/181 xfs/216 xfs/217 xfs/439
> Not run: generic/455 generic/457 xfs/439
> Passed all 74 tests
> 
> Notice that the test results before and after this patch is applied are
> identical and successful. Other tests might need to be run in order to
> verify everything is working as expected. For such tests, the intervention
> of the maintainers might be needed.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>  - Use struct_size() helper in more places.
>  - Update changelog text with testing results on Linux 5.12.0-rc2.
>  - Fix issue with use of struct_size() with the right struct object.
>  - Use flex_array_size() helper.
> 
>  fs/xfs/libxfs/xfs_log_format.h | 12 ++++----
>  fs/xfs/xfs_extfree_item.c      | 56 ++++++++++++++++------------------
>  fs/xfs/xfs_ondisk.h            |  8 ++---
>  3 files changed, 37 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8bd00da6d2a4..9934a465b441 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -574,7 +574,7 @@ typedef struct xfs_efi_log_format {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_t		efi_extents[1];	/* array of extents to free */
> +	xfs_extent_t		efi_extents[];	/* array of extents to free */
>  } xfs_efi_log_format_t;
>  
>  typedef struct xfs_efi_log_format_32 {
> @@ -582,7 +582,7 @@ typedef struct xfs_efi_log_format_32 {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
> +	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
>  } __attribute__((packed)) xfs_efi_log_format_32_t;
>  
>  typedef struct xfs_efi_log_format_64 {
> @@ -590,7 +590,7 @@ typedef struct xfs_efi_log_format_64 {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
> +	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
>  } xfs_efi_log_format_64_t;
>  
>  /*
> @@ -603,7 +603,7 @@ typedef struct xfs_efd_log_format {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> +	xfs_extent_t		efd_extents[];	/* array of extents freed */
>  } xfs_efd_log_format_t;
>  
>  typedef struct xfs_efd_log_format_32 {
> @@ -611,7 +611,7 @@ typedef struct xfs_efd_log_format_32 {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
> +	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
>  } __attribute__((packed)) xfs_efd_log_format_32_t;
>  
>  typedef struct xfs_efd_log_format_64 {
> @@ -619,7 +619,7 @@ typedef struct xfs_efd_log_format_64 {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
> +	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
>  } xfs_efd_log_format_64_t;
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 93223ebb3372..939206483720 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -73,8 +73,8 @@ static inline int
>  xfs_efi_item_sizeof(
>  	struct xfs_efi_log_item *efip)
>  {
> -	return sizeof(struct xfs_efi_log_format) +
> -	       (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
> +	return struct_size(&efip->efi_format, efi_extents,
> +			   efip->efi_format.efi_nextents);
>  }
>  
>  STATIC void
> @@ -153,17 +153,14 @@ xfs_efi_init(
>  
>  {
>  	struct xfs_efi_log_item	*efip;
> -	uint			size;
>  
>  	ASSERT(nextents > 0);
> -	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(struct xfs_efi_log_item) +
> -			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efip = kmem_zalloc(size, 0);
> -	} else {
> +	if (nextents > XFS_EFI_MAX_FAST_EXTENTS)
> +		efip = kmem_zalloc(struct_size(efip, efi_format.efi_extents,
> +					       nextents), 0);
> +	else
>  		efip = kmem_cache_zalloc(xfs_efi_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> -	}
>  
>  	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
>  	efip->efi_format.efi_nextents = nextents;
> @@ -186,12 +183,12 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
>  {
>  	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
>  	uint i;
> -	uint len = sizeof(xfs_efi_log_format_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_t);  
> -	uint len32 = sizeof(xfs_efi_log_format_32_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_32_t);  
> -	uint len64 = sizeof(xfs_efi_log_format_64_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);  
> +	size_t len = struct_size(src_efi_fmt, efi_extents,
> +				 src_efi_fmt->efi_nextents);
> +	uint len32 = struct_size((xfs_efi_log_format_32_t *)0, efi_extents,

Why not use size_t instead of uint?  You converted the @len declaration
above.

> +				 src_efi_fmt->efi_nextents);
> +	uint len64 = struct_size((xfs_efi_log_format_64_t *)0, efi_extents,

Also, please don't use the struct typedefs, we're trying to get rid of
those slowly.

TBH I wonder if these could just be turned into static inline helpers to
decrapify the code:

static inline size_t
sizeof_efi_log_format32(unsigned int nr)
{
	return struct_size((xfs_efi_log_format_32_t *)0, efi_extents, nr);
}

Then you only need:

	size_t len = sizeof_efi_log_format(src_efi_fmt->efi_nextents);
	size_t len32 = sizeof_efi_log_format32(src_efi_fmt->efi_nextents);
	size_t len64 = sizeof_efi_log_format64(src_efi_fmt->efi_nextents);

	if (len == len32) ...
	else if (len == len64) ...

And down below you can clean up the asserts a bit:

	ASSERT(item->ri_buf[0].i_len ==
			sizeof_efi_log_format32(efd_formatp->efd_nextents) ||
	       item->ri_buf[0].i_len ==
			sizeof_efi_log_format64(efd_formatp->efd_nextents));

--D

> +				 src_efi_fmt->efi_nextents);
>  
>  	if (buf->i_len == len) {
>  		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
> @@ -253,8 +250,8 @@ static inline int
>  xfs_efd_item_sizeof(
>  	struct xfs_efd_log_item *efdp)
>  {
> -	return sizeof(xfs_efd_log_format_t) +
> -	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
> +	return struct_size(&efdp->efd_format, efd_extents,
> +			   efdp->efd_format.efd_nextents);
>  }
>  
>  STATIC void
> @@ -328,14 +325,12 @@ xfs_trans_get_efd(
>  
>  	ASSERT(nextents > 0);
>  
> -	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> -				(nextents - 1) * sizeof(struct xfs_extent),
> -				0);
> -	} else {
> +	if (nextents > XFS_EFD_MAX_FAST_EXTENTS)
> +		efdp = kmem_zalloc(struct_size(efdp, efd_format.efd_extents,
> +					nextents), 0);
> +	else
>  		efdp = kmem_cache_zalloc(xfs_efd_zone,
>  					GFP_KERNEL | __GFP_NOFAIL);
> -	}
>  
>  	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
>  			  &xfs_efd_item_ops);
> @@ -666,11 +661,13 @@ xfs_efi_item_relog(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
>  	efdp->efd_next_extent = count;
> -	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
> +	memcpy(efdp->efd_format.efd_extents, extp,
> +	       flex_array_size(&efdp->efd_format, efd_extents, count));
>  	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
>  	efip = xfs_efi_init(tp->t_mountp, count);
> -	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
> +	memcpy(efip->efi_format.efi_extents, extp,
> +	       flex_array_size(&efip->efi_format, efi_extents, count));
>  	atomic_set(&efip->efi_next_extent, count);
>  	xfs_trans_add_item(tp, &efip->efi_item);
>  	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
> @@ -746,10 +743,11 @@ xlog_recover_efd_commit_pass2(
>  	struct xfs_efd_log_format	*efd_formatp;
>  
>  	efd_formatp = item->ri_buf[0].i_addr;
> -	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
> -	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
> +	ASSERT((item->ri_buf[0].i_len ==
> +		struct_size((xfs_efd_log_format_32_t *)0, efd_extents,
> +		efd_formatp->efd_nextents)) || (item->ri_buf[0].i_len ==
> +		struct_size((xfs_efd_log_format_64_t *)0, efd_extents,
> +		efd_formatp->efd_nextents)));
>  
>  	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
>  	return 0;
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0aa87c210104..f58e0510385a 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -118,10 +118,10 @@ xfs_check_ondisk_structs(void)
>  	/* log structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
> -- 
> 2.27.0
> 
