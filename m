Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45639ECAAD4
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 13:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiH3NtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiH3Nsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 09:48:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E188FB3B18
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 06:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661867175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r+PZxqc8b4Nzewql8RGLC0Tbbp5lXeZy1S77g/wCvNQ=;
        b=Upf7zExPyy2jsi68Cw05u9qLjTdPR0J3YR/uh3ImMKiOtzU3U3kcvZA+lSvv2A82wtk108
        YnG2VnXiuDIx1LJZNlhTDoH3k/gqZseV1/fwjaaKGYFRBbbCyrfES8pX0WTauwOI9Z3a3F
        CT5nje3bseutUO5M8kEvaWajisHbcrU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-386-jHu22RtkMRSSQZt-WLQ6ZA-1; Tue, 30 Aug 2022 09:43:04 -0400
X-MC-Unique: jHu22RtkMRSSQZt-WLQ6ZA-1
Received: by mail-qk1-f200.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso9289166qkp.21
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 06:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=r+PZxqc8b4Nzewql8RGLC0Tbbp5lXeZy1S77g/wCvNQ=;
        b=5R3Al46BCNDClKZtD4mwh88zkk+3hE5VaLhXftOv1N8dqpz/FK9cJ/u4X4YBnTmcyr
         bXwmM/e7l5pxhpNYbcCyubDC+lPk64fXtMxBjswXbyA7zIr83HX2mn9f+fMxryZCgKgM
         FVp550JYnScbRxIw15ji0lJlMxj9UyOooI+80kTtatajNDtCswGArhGjGqrWqyAMSa2w
         VJyWnLIgTBRwppcIrCpN51aLnjfn5+oIAWaiTNQm1iosm06oY5kfdL+n6Ks0hmv7Bg2y
         Ju4zlnD6H1LwhC8buByawi8lsu7MaEyNrjBFxBjKZQEsy3mTxeMhUN7Gbac1sMQgHobV
         X4GQ==
X-Gm-Message-State: ACgBeo2C4OUEGMOTGoKJ8lPBJdZKYLxxsZpAyfkhhnG32v8ihIGuXsY1
        S0Er1Zt5hFfv64kZw3Ppr4iZoCf92twUfpf2O5xn2Y6nXlaMAjgPLmN4bRoUVPo2ThjLzmaYFIz
        o+W1K4D9C9vIg5Gds1a46
X-Received: by 2002:a05:620a:1513:b0:6ba:e66b:726d with SMTP id i19-20020a05620a151300b006bae66b726dmr11787665qkk.692.1661866983730;
        Tue, 30 Aug 2022 06:43:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4g+P6Qk90P7S7GYF9/tDs/ReY3pzyvJiOAPbU87ng04wSQwN3nLw3hg/uG22h8P1rT003Pyg==
X-Received: by 2002:a05:620a:1513:b0:6ba:e66b:726d with SMTP id i19-20020a05620a151300b006bae66b726dmr11787652qkk.692.1661866983417;
        Tue, 30 Aug 2022 06:43:03 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k17-20020a05620a143100b006bb83e2e65fsm7634501qkj.42.2022.08.30.06.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 06:43:03 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:42:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] tests/xfs: remove single-AG options
Message-ID: <20220830134257.2sve6rwvyvz66lsg@zlang-mailbox>
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
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---

Looks like all single AG xfs tests are invalid now. As this patch would like to
remove xfs specific cases or change its original format, better to let xfs list
review, to make sure they are informed at least.

BTW I remember xfs/041 uses "agcount=1" too, don't we need to change it with
this patch together?

Thanks,
Zorro

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

