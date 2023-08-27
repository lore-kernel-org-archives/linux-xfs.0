Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555E6C83F10
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Aug 2023 13:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjH0NHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 09:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjH0NHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 09:07:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB8E13D
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 06:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693141610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=STC5a0adxidzCn6eTupSaZiKkCcldLdNmhDF9jB7Qeo=;
        b=ZSTH2JRgmeaYz/vouLNJpxSTrkPO/038dWtVGwNewA+QbjWs+LkF8S/XYZWAETio6nQftd
        TpFPY3/355FDd1xmJ8tKUiqA4cT8Az3ANKV+WAUS2oJFSrHi3kIn03kl//fvlGqa/iGTs1
        OLOfGrUcKt61EB94iG2Veq19G5D+T7I=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-d5r3NGfAMbqlomexptBjDA-1; Sun, 27 Aug 2023 09:06:49 -0400
X-MC-Unique: d5r3NGfAMbqlomexptBjDA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1bde8160fbdso21580845ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 06:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693141608; x=1693746408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STC5a0adxidzCn6eTupSaZiKkCcldLdNmhDF9jB7Qeo=;
        b=lIzkz5JYanIjnklBt8+pLdDX+OMMWTiWIiLrJTqFv1wh6MdM30BSuJzFrS2y1dKz0y
         R+JDqdHJP6PxeK87Bpbk+RHmKlBRWIGN0RgO+1Fmo5ViH5pQxpqGedQ8yQapZ4Nw2fZe
         i4nTmPO9blw+hHU9SAAUNca/ab0plRmSGhVjST7AiEMMLteQTBWW36Wz/urFV4WVhEiv
         3V6ikjFP0qertiuGZIUHprL0ZfuXahBqak+lvm7yB0GOleWHpb+975bGRJ/379oc/0Jr
         hR97U5HHFbVrAn9axmdEP5i1tciEy04iSoo28EDwiIONTeLEcATRPyJV8dJdXWvsz1Qd
         oKTQ==
X-Gm-Message-State: AOJu0YxIQMhJg3mt/WdJV9ti9jVP9nc8enwTouIjPjScMXrK4ryGgCeZ
        YdxAdg7pA2dFu268BSiSe3V1TcwTQPYaXItM9MB/WlY3+oUcKDGBxqspBPUa6mIK+my3xIvTp4W
        GgiCJ+yxhkby6SnQDfj74
X-Received: by 2002:a17:903:2304:b0:1c0:d17a:bff2 with SMTP id d4-20020a170903230400b001c0d17abff2mr6190408plh.20.1693141608092;
        Sun, 27 Aug 2023 06:06:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvt0ZHIXBl9R6bsLyW34zYMDWYUHCeRZvZ0dWnQqjVg5niFN9VRwHGgNf3gcMbFfFnkJpBxg==
X-Received: by 2002:a17:903:2304:b0:1c0:d17a:bff2 with SMTP id d4-20020a170903230400b001c0d17abff2mr6190391plh.20.1693141607743;
        Sun, 27 Aug 2023 06:06:47 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jf6-20020a170903268600b001b869410ed2sm5228331plb.72.2023.08.27.06.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 06:06:47 -0700 (PDT)
Date:   Sun, 27 Aug 2023 21:06:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <20230827130644.nhdi6ihobn5qne3a@zlang-mailbox>
References: <20230823010046.GD11286@frogsfrogsfrogs>
 <20230823010239.GE11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823010239.GE11263@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 22, 2023 at 06:02:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> exact power of two.  I traced this to an agbno integer overflow when the
> current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> the last record returned was non-shareable space at the end of an AG.
> 
> This is the regression test for that bug.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/935.out |    2 ++
>  2 files changed, 57 insertions(+)
>  create mode 100755 tests/xfs/935
>  create mode 100644 tests/xfs/935.out
> 
> diff --git a/tests/xfs/935 b/tests/xfs/935
> new file mode 100755
> index 0000000000..a06f2fc8dc
> --- /dev/null
> +++ b/tests/xfs/935
> @@ -0,0 +1,55 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 935
> +#
> +# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
> +# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
> +# a continuation of a previous call by setting the "low" key to the last record
> +# returned by the previous call.
> +#
> +# If the last record returned by GETFSMAP is a non-shareable extent at the end
> +# of an AG and the AG size is exactly a power of two, the startblock in the low
> +# key of the rmapbt query can be set to a value larger than EOAG.  When this
> +# happens, GETFSMAP will return EINVAL instead of returning records for the
> +# next AG.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick fsmap
> +
> +. ./common/filter
> +
> +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> +	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_xfs_io_command fsmap
> +_require_xfs_scratch_rmapbt
> +
> +_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> +source $tmp.mkfs
> +
> +# Find the next power of two agsize smaller than whatever the default is.
> +for ((p = 31; p > 0; p--)); do
> +	desired_agsize=$((2 ** p))
> +	test "$desired_agsize" -lt "$agsize" && break
> +done
> +
> +echo "desired asize=$desired_agsize" >> $seqres.full
> +_scratch_mkfs -d "agsize=${desired_agsize}b" | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> +source $tmp.mkfs
> +
> +test "$desired_agsize" -eq "$agsize" || _notrun "wanted agsize=$desired_agsize, got $agsize"
> +
> +_scratch_mount
> +$XFS_IO_PROG -c 'fsmap -n 1024 -v' $SCRATCH_MNT >> $tmp.big
> +$XFS_IO_PROG -c 'fsmap -n 1 -v' $SCRATCH_MNT >> $tmp.small

This line reports:

  xfs_io: xfsctl(XFS_IOC_GETFSMAP) iflags=0x0 ["/mnt/xfstests/scratch"]: Invalid argument

when the test case fails. Is that normal?

> +
> +diff -Naurpw $tmp.big $tmp.small
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/935.out b/tests/xfs/935.out
> new file mode 100644
> index 0000000000..1b5422d1e3
> --- /dev/null
> +++ b/tests/xfs/935.out
> @@ -0,0 +1,2 @@
> +QA output created by 935
> +Silence is golden
> 

