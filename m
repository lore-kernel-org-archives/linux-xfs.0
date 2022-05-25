Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA872C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 04:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiEYECg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 00:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiEYECg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 00:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3274152E52
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 21:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653451352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jlz6GA/gb+OMr7HKwKUKGB1wdQxe8ZxkG9RRRkr4MiE=;
        b=UmkMxaXIb/a6rbIqCnf/Rehqhlc+OJqi4CuMapKPbgNI6tcrgBqqToRiqugIosaVkBQi2J
        EsbC5GQL/FCH81R7+8Zzpz1lC9PPGO7kMKFnEfQr+mU8S5xXo78uEKxxo02t4A/ILKQzYQ
        g1erP9aAWcLaNCibwZo6CJIzHBOfu/M=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-R7U-VAVvNf27d3E8o2IL0w-1; Wed, 25 May 2022 00:02:30 -0400
X-MC-Unique: R7U-VAVvNf27d3E8o2IL0w-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-f2bfdd5480so429514fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 21:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jlz6GA/gb+OMr7HKwKUKGB1wdQxe8ZxkG9RRRkr4MiE=;
        b=gRKw/qY+wxqZSvvntlFigO5ixQONBwXo5mfhq9riq8nZaGnhBSl/b22dzMwXDElhqF
         nLOWeODZMeDVwW9TSLxf+955hoL53rVY9wsSucO8o00m+F6ZsvSh14BKhqIrmlTXLvKZ
         Qrd9NiVUaGdrapxJdNXR4xKdymdYXUQGj3Jv2tJV2hZ+zcaeupsNRMXSo5P34QnrUgs5
         xrIntX4Rbru+Lh11OdwQmSmqfr8qcJILZPVztOEbyR9Eio6RzXrFcMC/10TTgvY1TnH+
         BqDnZB9RZDdnFbFw1WxtdkhGDLK6kAEBZ9Lqj7L/h5fg+PcYRTf1qAZCSuzzYxcVecP8
         zcXA==
X-Gm-Message-State: AOAM530AfVXGU5CuKayCOpGdbT4uuLuQyWF09GAJS7UDqIRn5duznY3E
        G01MUv3N1REeWEQnGZuHbEDM/6NVaCNebaldNvy7u50JVP6DDPncdZH+O09moJOIkwY35TV/oZq
        g0Vp7F7THTf7/ciOpxM7v
X-Received: by 2002:a9d:76cd:0:b0:60b:400:8533 with SMTP id p13-20020a9d76cd000000b0060b04008533mr6920811otl.69.1653451349488;
        Tue, 24 May 2022 21:02:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWNcrCe1lHU4Hjl00DCZu5FgOMTyw0LKYuXiCxGJLvd7Rk4NiThAFE6vmleJUtdr3mH1P//A==
X-Received: by 2002:a9d:76cd:0:b0:60b:400:8533 with SMTP id p13-20020a9d76cd000000b0060b04008533mr6920808otl.69.1653451349228;
        Tue, 24 May 2022 21:02:29 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b18-20020a4ae212000000b0035eb4e5a6bfsm5978304oot.21.2022.05.24.21.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 21:02:28 -0700 (PDT)
Date:   Wed, 25 May 2022 12:02:22 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
Message-ID: <20220525040222.7nepzhckyptuavl6@zlang-mailbox>
References: <Yo027/k+vAYsUt4U@magnolia>
 <Yo036Y+er/WaT2IH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo036Y+er/WaT2IH@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:54:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for an xfs_copy fix that ensures that it
> doesn't perform a cached read of an XFS filesystem prior to initializing
> libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
> yet.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/844     |   37 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/844.out |    3 +++
>  3 files changed, 40 insertions(+), 1 deletion(-)
>  create mode 100755 tests/xfs/844
>  create mode 100644 tests/xfs/844.out
> 
> diff --git a/tests/xfs/844 b/tests/xfs/844
> new file mode 100755
> index 00000000..720f45bb
> --- /dev/null
> +++ b/tests/xfs/844
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 844
> +#
> +# Regression test for xfsprogs commit:
> +#
> +# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")

     ^^^ I'd like to merge a test after it's fixed offically at first, anyway that
     doesn't prevent us from reviewing it at first :)

> +#
> +. ./common/preamble
> +_begin_fstest auto copy
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $TEST_DIR/$seq.*
> +}
> +
> +# Import common functions.
> +# . ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.

"Modify as appropriate." can be removed.

> +_supported_fs generic
> +_require_xfs_copy
> +_require_test
> +
> +truncate -s 100m $TEST_DIR/$seq.a
> +truncate -s 100m $TEST_DIR/$seq.b

fstests recommends using "truncate" of XFS_IO_PROG, although use 'truncate'
isn't wrong at here.

As TEST_DIR might have existed files, do we need to do
        rm -rf $TEST_DIR/$seq.a $TEST_DIR/$seq.b
at first?

Thanks,
Zorro

> +
> +$XFS_COPY_PROG $TEST_DIR/$seq.a $TEST_DIR/$seq.b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/844.out b/tests/xfs/844.out
> new file mode 100644
> index 00000000..dbefde1c
> --- /dev/null
> +++ b/tests/xfs/844.out
> @@ -0,0 +1,3 @@
> +QA output created by 844
> +bad magic number
> +xfs_copy: couldn't read superblock, error=22
> 

