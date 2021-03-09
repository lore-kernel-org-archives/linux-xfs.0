Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC06AC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 706356523A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhCIRmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCIRmN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 12:42:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB4965215;
        Tue,  9 Mar 2021 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615311733;
        bh=lGz8OCb+6Ha0kwYXBZ2JD6T2ep7bDWYjvWAxd10OD0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sSIt8Sr8emjTWu1QPOCdLOpmZ7HR+RpddC4byNwQAO8kVJ6hRpeRE6B9UaKNTVVS7
         gpCJ3A1S3CrjicxQpqv09Udj1MQUOQrBtLTJi69lD6+haMVDIeSwpFoT48aPMnz6uc
         UH1ixdblr6nVDKfwXLYCKnuoII+zTHgdrnWn0gzT7pyT56In0DK8Afeaf3mfHQKVou
         YEoYo1oyyV1j+UMGPnF31/YmXNgh6hIL2pCH/Vh5yHULMfLjFnHU5t4R7/eDPSS5ZA
         Q/4l1q0WPejgIsaOqlY1rsb4rc1unB6qluZnm1Crj4T/Ylk1oc5Xj8gAc6c0zmSWCV
         0M5AmRG2gnX8g==
Date:   Tue, 9 Mar 2021 09:42:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210309174212.GV3419940@magnolia>
References: <20210302150558.GA198498@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210302150558.GA198498@embeddedor>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 09:05:58AM -0600, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of flexible-array members in
> multiple structures, instead of one-element arrays. Also, make use of
> the new struct_size() helper to properly calculate the size of multiple
> structures that contain flexible-array members.
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
> log, respectively, on 5.11.0-next-20210301 kernel _without_ this patch
> applied:
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g shutdown 2>&1 | tee xfs-shutdown-no-patch.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.11.0-next-20210301 #4 SMP Mon Mar 1 05:42:06 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/042 2s ...  2s
> generic/043 13s ...  13s
> generic/044 14s ...  14s
> generic/045 18s ...  18s
> generic/046 14s ...  14s
> generic/047 20s ...  22s
> generic/048 51s ...  50s
> generic/049 9s ...  8s
> generic/050 2s ...  1s
> generic/051 76s ...  75s
> generic/052 1s ...  2s
> generic/054 31s ...  30s
> generic/055 16s ...  21s
> generic/388 89s ...  75s
> generic/392 5s ...  5s
> generic/417 11s ...  11s
> generic/461 21s ...  22s
> generic/468 3s ...  3s
> generic/474 1s ...  1s
> generic/475 86s ...  93s
> generic/505 2s ...  2s
> generic/506 2s ...  2s
> generic/507     [not run] file system doesn't support chattr +AsSu
> generic/508 1s ...  1s
> generic/530 10s ...  10s
> generic/536 3s ...  2s
> generic/599 1s ...  1s
> generic/622 23s ...  24s
> xfs/051 18s ...  18s
> xfs/079 15s ...  14s
> xfs/121 6s ...  16s
> xfs/181 12s ...  15s
> xfs/212 1s ...  3s
> Ran: generic/042 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/054 generic/055 generic/388 generic/392 generic/417 generic/461 generic/468 generic/474 generic/475 generic/505 generic/506 generic/507 generic/508 generic/530 generic/536 generic/599 generic/622 xfs/051 xfs/079 xfs/121 xfs/181 xfs/212
> Not run: generic/507
> Passed all 33 tests
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g log 2>&1 | tee xfs-log-no-patch.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.11.0-next-20210301 #4 SMP Mon Mar 1 05:42:06 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/034 1s ...  1s
> generic/039 1s ...  1s
> generic/040 5s ...  5s
> generic/041 7s ...  7s
> generic/043 13s ...  13s
> generic/044 14s ...  14s
> generic/045 18s ...  18s
> generic/046 14s ...  14s
> generic/051 76s ...  76s
> generic/052 1s ...  2s
> generic/054 30s ...  48s
> generic/055 23s ...  15s
> generic/056 1s ...  1s
> generic/057 1s ...  1s
> generic/059 2s ...  2s
> generic/065 1s ...  1s
> generic/066 1s ...  2s
> generic/073 1s ...  1s
> generic/090 1s ...  1s
> generic/101 1s ...  1s
> generic/104 1s ...  1s
> generic/106 1s ...  1s
> generic/107 1s ...  1s
> generic/177 1s ...  1s
> generic/311 67s ...  67s
> generic/321 2s ...  2s
> generic/322 1s ...  2s
> generic/325 1s ...  1s
> generic/335 1s ...  1s
> generic/336 2s ...  1s
> generic/341 1s ...  1s
> generic/342 1s ...  1s
> generic/343 1s ...  1s
> generic/376 1s ...  1s
> generic/388 75s ...  97s
> generic/417 15s ...  12s
> generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> generic/475 88s ...  89s
> generic/479 2s ...  2s
> generic/480 1s ...  1s
> generic/481 1s ...  1s
> generic/483 7s ...  6s
> generic/489 1s ...  1s
> generic/498 1s ...  1s
> generic/501 61s ...  63s
> generic/502 1s ...  1s
> generic/509 1s ...  1s
> generic/510 1s ...  1s
> generic/512 1s ...  1s
> generic/520 16s ...  17s
> generic/526 2s ...  1s
> generic/527 0s ...  1s
> generic/534 0s ...  1s
> generic/535 2s ...  1s
> generic/546 3s ...  3s
> generic/547 2s ...  2s
> generic/552 1s ...  1s
> generic/557 1s ...  2s
> generic/588 2s ...  1s
> shared/002 9s ...  9s
> xfs/011 18s ...  18s
> xfs/029 1s ...  1s
> xfs/051 18s ...  18s
> xfs/057 23s ...  23s
> xfs/079 14s ...  14s
> xfs/095 1s ...  1s
> xfs/119 3s ...  3s
> xfs/121 6s ...  6s
> xfs/141 14s ...  26s
> xfs/181 14s ...  14s
> xfs/216 3s ...  2s
> xfs/217 2s ...  2s
> xfs/439 [not run] test requires XFS bug_on_assert to be off, turn it off to run the test
> Ran: generic/034 generic/039 generic/040 generic/041 generic/043 generic/044 generic/045 generic/046 generic/051 generic/052 generic/054 generic/055 generic/056 generic/057 generic/059 generic/065 generic/066 generic/073 generic/090 generic/101 generic/104 generic/106 generic/107 generic/177 generic/311 generic/321 generic/322 generic/325 generic/335 generic/336 generic/341 generic/342 generic/343 generic/376 generic/388 generic/417 generic/455 generic/457 generic/475 generic/479 generic/480 generic/481 generic/483 generic/489 generic/498 generic/501 generic/502 generic/509 generic/510 generic/512 generic/520 generic/526 generic/527 generic/534 generic/535 generic/546 generic/547 generic/552 generic/557 generic/588 shared/002 xfs/011 xfs/029 xfs/051 xfs/057 xfs/079 xfs/095 xfs/119 xfs/121 xfs/141 xfs/181 xfs/216 xfs/217 xfs/439
> Not run: generic/455 generic/457 xfs/439
> Passed all 74 tests
> 
> These are the results of running ./check -g shutdown and ./check -g
> log, respectively, on 5.11.0-xfstests-patched-next-20210301+ kernel
> _with_ this patch applied on top:
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g shutdown 2>&1 | tee xfs-shutdown-patched.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.11.0-xfstests-patched-next-20210301+ #10 SMP Mon Mar 1 17:36:20 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/042 2s ...  3s
> generic/043 13s ...  12s
> generic/044 14s ...  15s
> generic/045 18s ...  18s
> generic/046 14s ...  15s
> generic/047 21s ...  21s
> generic/048 51s ...  51s
> generic/049 9s ...  8s
> generic/050 1s ...  2s
> generic/051 76s ...  77s
> generic/052 6s ...  2s
> generic/054 35s ...  48s
> generic/055 16s ...  17s
> generic/388 77s ...  73s
> generic/392 7s ...  5s
> generic/417 13s ...  11s
> generic/461 22s ...  21s
> generic/468 2s ...  3s
> generic/474 2s ...  1s
> generic/475 90s ...  96s
> generic/505 3s ...  3s
> generic/506 1s ...  2s
> generic/507     [not run] file system doesn't support chattr +AsSu
> generic/508 2s ...  10s
> generic/530 9s ...  13s
> generic/536 2s ...  1s
> generic/599 1s ...  1s
> generic/622 24s ...  25s
> xfs/051 18s ...  18s
> xfs/079 14s ...  13s
> xfs/121 6s ...  8s
> xfs/181 11s ...  14s
> xfs/212 2s ...  1s
> Ran: generic/042 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/054 generic/055 generic/388 generic/392 generic/417 generic/461 generic/468 generic/474 generic/475 generic/505 generic/506 generic/507 generic/508 generic/530 generic/536 generic/599 generic/622 xfs/051 xfs/079 xfs/121 xfs/181 xfs/212
> Not run: generic/507
> Passed all 33 tests
> 
> gustavo@beefy:~/git/xfstests$ time sudo ./check -g log 2>&1 | tee xfs-log-patched.out
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 beefy 5.11.0-xfstests-patched-next-20210301+ #10 SMP Mon Mar 1 17:36:20 CST 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> 
> generic/034 1s ...  1s
> generic/039 1s ...  1s
> generic/040 5s ...  5s
> generic/041 7s ...  7s
> generic/043 12s ...  13s
> generic/044 15s ...  15s
> generic/045 18s ...  18s
> generic/046 15s ...  14s
> generic/051 77s ...  76s
> generic/052 2s ...  1s
> generic/054 48s ...  29s
> generic/055 17s ...  16s
> generic/056 1s ...  1s
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
> generic/311 68s ...  68s
> generic/321 2s ...  2s
> generic/322 1s ...  1s
> generic/325 2s ...  1s
> generic/335 1s ...  1s
> generic/336 1s ...  1s
> generic/341 1s ...  1s
> generic/342 1s ...  1s
> generic/343 1s ...  1s
> generic/376 1s ...  1s
> generic/388 73s ...  83s
> generic/417 11s ...  11s
> generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> generic/475 96s ...  83s
> generic/479      2s
> generic/480 2s ...  1s
> generic/481 0s ...  1s
> generic/483 7s ...  7s
> generic/489 1s ...  1s
> generic/498 1s ...  1s
> generic/501 63s ...  61s
> generic/502 1s ...  1s
> generic/509 1s ...  1s
> generic/510 1s ...  1s
> generic/512 1s ...  1s
> generic/520 16s ...  16s
> generic/526 1s ...  1s
> generic/527 1s ...  1s
> generic/534 1s ...  1s
> generic/535 1s ...  1s
> generic/546 4s ...  4s
> generic/547 2s ...  2s
> generic/552 1s ...  1s
> generic/557 1s ...  1s
> generic/588 2s ...  1s
> shared/002 8s ...  9s
> xfs/011 18s ...  18s
> xfs/029 1s ...  1s
> xfs/051 18s ...  18s
> xfs/057 23s ...  24s
> xfs/079 13s ...  14s
> xfs/095 2s ...  1s
> xfs/119 3s ...  3s
> xfs/121 8s ...  6s
> xfs/141 18s ...  12s
> xfs/181 14s ...  12s
> xfs/216 3s ...  2s
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
> Build-tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/603e3177.WsvTXRpcLn5wdYW6%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h | 12 +++++------
>  fs/xfs/xfs_extfree_item.c      | 39 +++++++++++++++-------------------
>  fs/xfs/xfs_ondisk.h            |  8 +++----
>  3 files changed, 27 insertions(+), 32 deletions(-)
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
> index 93223ebb3372..5ed3ea93071c 100644
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
> +	size_t len = struct_size(src_efi_fmt, efi_extents,
> +				 src_efi_fmt->efi_nextents);
>  	uint len32 = sizeof(xfs_efi_log_format_32_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_32_t);  
> +		src_efi_fmt->efi_nextents * sizeof(xfs_extent_32_t);

Shouldn't these be converted to struct_size() too?

It seems to work all right for casted NULL pointers, and then we get all
the typechecking and multiplication overflow checking, e.g.:

	size_t len64 = struct_size((struct xfs_efi_log_format_32 *)NULL,
				efi_extents src_efi_fmt->efi_nextents);

--D

>  	uint len64 = sizeof(xfs_efi_log_format_64_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);  
> +		src_efi_fmt->efi_nextents * sizeof(xfs_extent_64_t);
>  
>  	if (buf->i_len == len) {
>  		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
> @@ -254,7 +251,7 @@ xfs_efd_item_sizeof(
>  	struct xfs_efd_log_item *efdp)
>  {
>  	return sizeof(xfs_efd_log_format_t) +
> -	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
> +	       efdp->efd_format.efd_nextents * sizeof(xfs_extent_t);
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
> +		efdp = kmem_zalloc(struct_size(efip, efi_format.efi_extents,
> +					nextents), 0);
> +	else
>  		efdp = kmem_cache_zalloc(xfs_efd_zone,
>  					GFP_KERNEL | __GFP_NOFAIL);
> -	}
>  
>  	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
>  			  &xfs_efd_item_ops);
> @@ -747,9 +742,9 @@ xlog_recover_efd_commit_pass2(
>  
>  	efd_formatp = item->ri_buf[0].i_addr;
>  	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
> +		(efd_formatp->efd_nextents * sizeof(xfs_extent_32_t)))) ||
>  	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
> +		(efd_formatp->efd_nextents * sizeof(xfs_extent_64_t)))));
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
