Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321D4ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 15:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiH3PFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiH3PFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 11:05:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A73AE85E;
        Tue, 30 Aug 2022 08:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24657B81C37;
        Tue, 30 Aug 2022 15:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F33C433C1;
        Tue, 30 Aug 2022 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661871946;
        bh=GQPJ5NSfdUFhBqVcqvImAuCjiXYFk2wcEhyajLqU0Ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ue9ek1XTRIqYYiBJlURQ5yzzP12UD+4wgfeP2lokTFXeEEcnXc6wkFndcyumf4vny
         5Pr4ALVheZKNyuCUnvMlbw6ulD4VkO9UJi9h9ReLB2KWagX/zBVCyxI2N06Rs2VXjj
         FfGLZukHIjnegzliW6PHWNxA8S41TlGQiGIYAOfCnpkbnaIbkK9xcbtMFqCrnv4mdd
         2Pwqt5fnG5/oYT8QNOt8JxV55URDch0JQTwwbxIB0wp7IBwl5cupmmIUn/pPdMxlIf
         +PfeJoWTYDs/COpEZSGOnxfaOIoZoZ/7w6ZTQ3qNsOZ+v/cvAHDcijDE8SibNnRtxh
         Vc5z4nN5BUB3A==
Date:   Tue, 30 Aug 2022 08:05:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] tests/xfs: remove single-AG options
Message-ID: <Yw4nSjAsFbCYveP+@magnolia>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-4-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830044433.1719246-4-jencce.kernel@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 12:44:32PM +0800, Murphy Zhou wrote:
> Since this xfsprogs commit:
> 	6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> Single-AG xfs is not allowed.
> 
> Remove agcount=1 from mkfs options and xfs/202 entirely.

It's not supported for /new/ filesystems, but the rest of the tools must
continue the same levels of support for existing filesystems, even if
they cannot be created today.

Second, there exist fstests that need to create a specific layout to
test some part of the code.  Single-AG filesystems sometimes make this
much easier.

Both of these reasons are why fstests (and LTP) get a special pass on
all the new checks in mkfs 5.19.

IOWs, we still need to check that xfs_repair works ok for existing
single AG filesystems.  We can perhaps drop these tests in a decade or
so, but now is premature.

--D

> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  tests/xfs/179     |  2 +-
>  tests/xfs/202     | 40 ----------------------------------------
>  tests/xfs/202.out | 29 -----------------------------
>  tests/xfs/520     |  2 +-
>  4 files changed, 2 insertions(+), 71 deletions(-)
>  delete mode 100755 tests/xfs/202
>  delete mode 100644 tests/xfs/202.out
> 
> diff --git a/tests/xfs/179 b/tests/xfs/179
> index ec0cb7e5..f0169717 100755
> --- a/tests/xfs/179
> +++ b/tests/xfs/179
> @@ -22,7 +22,7 @@ _require_cp_reflink
>  _require_test_program "punch-alternating"
>  
>  echo "Format and mount"
> -_scratch_mkfs -d agcount=1 > $seqres.full 2>&1
> +_scratch_mkfs > $seqres.full 2>&1
>  _scratch_mount >> $seqres.full 2>&1
>  
>  testdir=$SCRATCH_MNT/test-$seq
> diff --git a/tests/xfs/202 b/tests/xfs/202
> deleted file mode 100755
> index 5075d3a1..00000000
> --- a/tests/xfs/202
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2009 Christoph Hellwig.
> -#
> -# FS QA Test No. 202
> -#
> -# Test out the xfs_repair -o force_geometry option on single-AG filesystems.
> -#
> -. ./common/preamble
> -_begin_fstest repair auto quick
> -
> -# Import common functions.
> -. ./common/filter
> -. ./common/repair
> -
> -# real QA test starts here
> -_supported_fs xfs
> -
> -# single AG will cause default xfs_repair to fail. This test is actually
> -# testing the special corner case option needed to repair a single AG fs.
> -_require_scratch_nocheck
> -
> -#
> -# The AG size is limited to 1TB (or even less with historic xfsprogs),
> -# so chose a small enough filesystem to make sure we can actually create
> -# a single AG filesystem.
> -#
> -echo "== Creating single-AG filesystem =="
> -_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
> - || _fail "!!! failed to make filesystem with single AG"
> -
> -echo "== Trying to repair it (should fail) =="
> -_scratch_xfs_repair
> -
> -echo "== Trying to repair it with -o force_geometry =="
> -_scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
> -
> -# success, all done
> -echo "*** done"
> -status=0
> diff --git a/tests/xfs/202.out b/tests/xfs/202.out
> deleted file mode 100644
> index c2c5c881..00000000
> --- a/tests/xfs/202.out
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -QA output created by 202
> -== Creating single-AG filesystem ==
> -== Trying to repair it (should fail) ==
> -Phase 1 - find and verify superblock...
> -Only one AG detected - cannot validate filesystem geometry.
> -Use the -o force_geometry option to proceed.
> -== Trying to repair it with -o force_geometry ==
> -Phase 1 - find and verify superblock...
> -Phase 2 - using <TYPEOF> log
> -        - zero log...
> -        - scan filesystem freespace and inode maps...
> -        - found root inode chunk
> -Phase 3 - for each AG...
> -        - scan and clear agi unlinked lists...
> -        - process known inodes and perform inode discovery...
> -        - process newly discovered inodes...
> -Phase 4 - check for duplicate blocks...
> -        - setting up duplicate extent list...
> -        - check for inodes claiming duplicate blocks...
> -Phase 5 - rebuild AG headers and trees...
> -        - reset superblock...
> -Phase 6 - check inode connectivity...
> -        - resetting contents of realtime bitmap and summary inodes
> -        - traversing filesystem ...
> -        - traversal finished ...
> -        - moving disconnected inodes to lost+found ...
> -Phase 7 - verify and correct link counts...
> -done
> -*** done
> diff --git a/tests/xfs/520 b/tests/xfs/520
> index d9e252bd..de70db60 100755
> --- a/tests/xfs/520
> +++ b/tests/xfs/520
> @@ -60,7 +60,7 @@ force_crafted_metadata() {
>  }
>  
>  bigval=100000000
> -fsdsopt="-d agcount=1,size=512m"
> +fsdsopt="-d size=512m"
>  
>  force_crafted_metadata freeblks 0 "agf 0"
>  force_crafted_metadata longest $bigval "agf 0"
> -- 
> 2.31.1
> 
