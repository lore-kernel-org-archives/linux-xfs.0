Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DB3C38145
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Sep 2022 01:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiICBjf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 21:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiICBje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 21:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D86BF4A
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 18:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662169171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YotbAWSFrVo2S/ZjSvFr4qhiFHVheKgahzZxN2Tw9nc=;
        b=VvURoulGeed4TgJp7Usm9IYJHbNNETvy6ROjKpFl8JfjYod42cKJRhwNFwA8XcUfn41S8e
        d1L4Ir+z5h39FxjazV0axXi+kenSLbeW2aqUX1b0+KrbruTHEuhXD93KDVbtBml12RM/LZ
        DvnxkdpEpW1ZIGbTiMtJkBprVpTo72I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-kFgklmtuM-eNl9TLDdaxXg-1; Fri, 02 Sep 2022 21:39:30 -0400
X-MC-Unique: kFgklmtuM-eNl9TLDdaxXg-1
Received: by mail-qt1-f198.google.com with SMTP id h19-20020ac85493000000b00343408bd8e5so2811524qtq.4
        for <linux-xfs@vger.kernel.org>; Fri, 02 Sep 2022 18:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=YotbAWSFrVo2S/ZjSvFr4qhiFHVheKgahzZxN2Tw9nc=;
        b=aZMbB6fHzbLimtHrdzNCseF2QmJlbs1IOsV+tGh9f4OKB5TFaZU6xCKzti7kUMwiD7
         MDwhybNnqkJKsi7bBxSWwPM3vjCF3Q7pE721uxx6kf2nHc0M1SE0DJ1xjTrJwvwRmN8b
         2k332yVF8zraI9vdj5VU+XenMkZw04pR5ZIoqEFwIdR7V16nFo+icYO+2f3eqpmKi1nQ
         5/FrTFIxyE11YFuKh1yRLUs5EtyQuu6Sll01b0Jp6J37PLpFEpGyViFzbzZWEFX2O5T7
         HIGpjOZxWy/jvb5PkA8LDRS6vGkXavA9VWdOmQB5JKCaQSgObzmlpZHcdmKFtXZToLHM
         ovkw==
X-Gm-Message-State: ACgBeo1n/dAGmbKc0lr6s0WEdiBMP/EzIeTKDXjklBvep359/jqS4IBX
        NOA7OnMtl4QmDwXrCcUh2j0t5mcoZuKCngWa/luKclQz/oyKx03iv1Xy17KyT4/KgMv/eUy1ybM
        b9aPuW3Go/3+BoBqlz9Cy
X-Received: by 2002:a05:6214:1ccf:b0:495:cf4a:4041 with SMTP id g15-20020a0562141ccf00b00495cf4a4041mr32441513qvd.38.1662169169548;
        Fri, 02 Sep 2022 18:39:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7YF3qS56McFZ/T+PyGmE+Qb+tXK3oYmNkIYbOScrQrgfxw5kat5w+icUSqmBsAoOqk0s+gjQ==
X-Received: by 2002:a05:6214:1ccf:b0:495:cf4a:4041 with SMTP id g15-20020a0562141ccf00b00495cf4a4041mr32441497qvd.38.1662169169311;
        Fri, 02 Sep 2022 18:39:29 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bl4-20020a05620a1a8400b006b9526cfe6bsm2568862qkb.80.2022.09.02.18.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 18:39:28 -0700 (PDT)
Date:   Sat, 3 Sep 2022 09:39:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     fstests@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH fstests] xfs/554: xfs add illegal bestfree array size
 inject for leaf dir
Message-ID: <20220903013921.wbmwkf6rs2iknqn6@zlang-mailbox>
References: <20220902094046.3891252-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902094046.3891252-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 02, 2022 at 05:40:46PM +0800, Guo Xuenan wrote:
> Test leaf dir allocting new block when bestfree array size
> less than data blocks count, which may lead to UAF.
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  tests/xfs/554     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out |  6 ++++++
>  2 files changed, 54 insertions(+)
>  create mode 100755 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100755
> index 00000000..fcf45731
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,48 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> +#
> +# FS QA Test No. 554
> +#
> +# Test leaf dir bestfree array size match with dir disk size

Is it for a known bug? known commit id?

> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/populate
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch

Do you need V5 xfs? Or v4 is fine?
_require_scratch_xfs_crc ??

> +_require_check_dmesg
> +
> +echo "Format and mount"
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount  >> $seqres.full 2>&1
> +
> +echo "Create and check leaf dir"
> +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> +dblksz="$($XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"

Why do you need these two kinds of block size for xfs? And you sometimes
use the former, sometimes use the later? If you'd like to get the xfs data
block size, you can:

  _scratch_mkfs | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
  . $tmp.mkfs

Then "dbsize" is what you want.

> +leaf_lblk="$((32 * 1073741824 / blksz))"
> +node_lblk="$((64 * 1073741824 / blksz))"

I didn't see the "node_lblk" is used in this case, looks like you don't want to
get directory node blocks in this case.

> +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
> +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> +_scratch_unmount
> +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> +
> +echo "Inject bad bestfress array size"
> +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock 8388608" -c "write ltail.bestcount 0"

As you tried to detect xfs block size above, so it might not 4k block size, so
8388608 is not fixed.

According to the kernel definition:
  #define XFS_DIR2_DATA_ALIGN_LOG 3
  #define XFS_DIR2_SPACE_SIZE     (1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
  #define XFS_DIR2_LEAF_SPACE     1
  #define XFS_DIR2_LEAF_OFFSET    (XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)

The XFS_DIR2_LEAF_OFFSET = 1 * (1 << (32 + 3)) = 1<<35 = 34359738368 = 32GB, so
the fixed logical offset of leaf extent is 34359738368 bytes, then the offset
block number should be "34359738368 / dbsize". 8388608 is only for 4k block
size.

> +
> +echo "Test add entry to dir"
> +_scratch_mount
> +touch ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/{1..100}.txt > /dev/null 2>&1
> +_scratch_unmount 2>&1
> +_repair_scratch_fs >> $seqres.full 2>&1

Can you explain more about this testing steps? The xfs has been corrupted, then
we expect is can be mounted. And create 100 new files on that corrupted dir,
do you expect the 100 files can be created successfully? Or what ever, even
nothing be created?

What's the xfs_repair expect? Fix all curruption and left a clean xfs?

> +
> +# check demsg error
> +_check_dmesg

Which above step will trigger a dmesg you want to check? What kind of dmesg do
you want to check? I think xfstests checks dmesg at the end of each test case,
except you need to check some special one, or need a special filter?

Thanks,
Zorro

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..ea1f30cc
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,6 @@
> +QA output created by 554
> +Format and mount
> +Create and check leaf dir
> +Inject bad bestfress array size
> +ltail.bestcount = 0
> +Test add entry to dir
> -- 
> 2.25.1
> 

