Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6993FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381071AbiDTR1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 13:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381065AbiDTR1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 13:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FB1DE9D;
        Wed, 20 Apr 2022 10:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8E4CB82122;
        Wed, 20 Apr 2022 17:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE29C385A1;
        Wed, 20 Apr 2022 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650475502;
        bh=nMmzOhxotCajNarK8awDNazXFZSTk/ACo0M6tq43FZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QQa34rruxXiAFXHJk3qqrOfyI5kmyPOK3mf493IK/V3XrQTC/4U6X1pSiI1xuBAtP
         STMlkkCuhSEqfAyMsmfjt5B2E1gh04yndgLNkcTvj2y6FnYDKEOILIANpjAb+sPzeB
         tQtza/q76f8zY5BGytldBTFWQpQt4nvr+2kEyC/hhGhOSo9AGN0i9iyo/bDV3W06HS
         xTCdPXyHk6oQMOjQID/AlkMUTXeh7KA/C8Bk+9+03E9rfsoER6GIcMu1hqDZT16iIM
         rhEgxUmJjUWEPae57GkywVLhO8LCGoP+BXl6LH6+XQ+v5OoYgqT2UzT0CIBZSCKJxA
         oKFpnkVi5boEw==
Date:   Wed, 20 Apr 2022 10:25:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] generic: test data corruption when blocksize <
 pagesize for mmaped data
Message-ID: <20220420172501.GQ17025@magnolia>
References: <20220420083653.1031631-1-zlang@redhat.com>
 <20220420083653.1031631-4-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420083653.1031631-4-zlang@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:36:52PM +0800, Zorro Lang wrote:
> page_mkwrite() is used by filesystems to allocate blocks under a page
> which is becoming writeably mmapped in some process' address space.
> This allows a filesystem to return a page fault if there is not enough
> space available, user exceeds quota or similar problem happens, rather
> than silently discarding data later when writepage is called. However
> VFS fails to call ->page_mkwrite() in all the cases where filesystems
> need it when blocksize < pagesize.
> 
> At the moment page_mkwrite() is called, filesystem can allocate only
> one block for the page if i_size < page size. Otherwise it would
> create blocks beyond i_size which is generally undesirable. But later
> at writepage() time, we also need to store data at offset 4095 but we
> don't have block allocated for it.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/generic/999     | 75 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  5 +++
>  2 files changed, 80 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..f1b65982
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Regression test for linux commit 90a80202 ("data corruption when
> +# blocksize < pagesize for mmaped data")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_block_device $SCRATCH_DEV
> +_require_xfs_io_command mmap "-s <size>"
> +_require_xfs_io_command mremap
> +_require_xfs_io_command truncate
> +_require_xfs_io_command mwrite
> +
> +sector_size=`_min_dio_alignment $SCRATCH_DEV`
> +page_size=$(get_page_size)
> +block_size=$((page_size/2))
> +if [ $sector_size -gt $block_size ];then
> +	_notrun "need sector size < page size"
> +fi
> +
> +unset MKFS_OPTIONS
> +# For save time, 512MiB is enough to reproduce bug
> +_scratch_mkfs_sized 536870912 $block_size >$seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +# take one block size space
> +$XFS_IO_PROG -f -t -c "pwrite 0 $block_size" $SCRATCH_MNT/testfile >>$seqres.full 2>&1
> +
> +# Fill all free space, dd can keep writing until no space. Note: if the fs
> +# isn't be full, this test will fail.
> +for ((i=0; i<2; i++));do
> +	dd if=/dev/zero of=$SCRATCH_MNT/full bs=$block_size >>$seqres.full 2>&1
> +	_scratch_cycle_mount
> +done

_fill_fs ?

Also, this test ought to check that we actually consumed all the
freespace and note that in the golden output so that a test runner can
tell the difference between "test preconditions not satisfied" vs.
"kernel needs patching".

--D

> +
> +# truncate 0
> +# pwrite -S 0x61 0 $block_size
> +# mmap -rw -s $((page_size * 2)) 0 $block_size
> +# mwrite -S 0x61 0 1  --> page_mkwrite() for index 0 is called
> +# truncate $((page_size * 2))
> +# mremap $((page_size * 2))
> +# mwrite -S 0x61 $((page_size - 1)) 1  --> [bug] no page_mkwrite() called
> +#
> +# If there's a bug, the last step will be killed by SIGBUS, and it won't
> +# write a "0x61" on the disk.
> +#
> +# Note: mremap maybe failed when memory load is heavy.
> +$XFS_IO_PROG -f \
> +             -c "truncate 0" \
> +             -c "pwrite -S 0x61 0 $block_size" \
> +             -c "mmap -rw -s $((page_size * 2)) 0 $block_size" \
> +             -c "mwrite -S 0x61 0 1" \
> +             -c "truncate $((page_size * 2))" \
> +             -c "mremap $((page_size * 2))" \
> +             -c "mwrite -S 0x61 $((page_size - 1)) 1" \
> +             $SCRATCH_MNT/testfile | _filter_xfs_io
> +
> +# we will see 0x61 written by "mwrite -S 0x61 0 1", but we shouldn't see one
> +# more 0x61 by the last mwrite (except this fs isn't be full, or a bug)
> +od -An -c $SCRATCH_MNT/testfile
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..f1c59e83
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,5 @@
> +QA output created by 999
> +   a   a   a   a   a   a   a   a   a   a   a   a   a   a   a   a
> +*
> +  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
> +*
> -- 
> 2.31.1
> 
