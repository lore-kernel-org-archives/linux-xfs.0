Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B4CECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 07:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiH3Htv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 03:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH3Htu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 03:49:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB48FF2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 00:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661845784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SBwkg2d90U//c38QsxRGKMCraHKC2z+i+jRzmfhcsFE=;
        b=gM5lWylMJYclGJfzY2ORnPaOr5FUublSeZpq8V8sT5Uj/eZzyQe5PJeCHRcjR2Wuo3IVV/
        3Kxyj4kyG9uuh3GDzeOQmO/XPbWBIDdbKmtbdaImz2FpYako/JPsUgEqMUIWN0/LjzVgTg
        4U9Ryq9ybTqJU8qjn/u4aVGaNit7Y5o=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-n68UVI2_Pi6SJZD4MoG1RA-1; Tue, 30 Aug 2022 03:49:43 -0400
X-MC-Unique: n68UVI2_Pi6SJZD4MoG1RA-1
Received: by mail-qk1-f200.google.com with SMTP id br15-20020a05620a460f00b006bc58c26501so8482559qkb.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 00:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SBwkg2d90U//c38QsxRGKMCraHKC2z+i+jRzmfhcsFE=;
        b=BtzTpHt6RYe5Yq0nPn2LuHpFZ0zQYNQmW9zBTTuIDr/hJahpKMGiPDIIumsi4lEfPs
         zLWOBo9HosJiRRPRuTFvS7ksmqyjH5EpOmEMX7yJCORnTCTqOSikyJ/cstTTcFvjratl
         OCroWX9j+hH5hJZ8EDTqfXUMIz6x2ZZ0EQJ6G1VkSjWoBnnHkk6JmPqdd6sNAxg8nCNf
         /w6dV0Z1yzOiXGTVv/uWo5zv5r9/ybMQxZjzBZzMG3kk3GiydSLr1JRhkkyj5R/jBtoD
         NvSi3nUZHBcPbtkN8AC1Tb6KZxj1c1LZ4HyXpwsiclNJ6dMQm2h8c3e+af2txy6rjh9d
         XPEQ==
X-Gm-Message-State: ACgBeo2D4cv7bhkf3PJy56low17QXyHFFKhMjm7clxev0pOwA0XY3IfG
        L7o8+nP/quZuRpAbatWL8qtQXQpMKdgu8JwmicLIK4Hp1pAiH52hio0sLUVaxHPt19zVFF92Jzj
        bkhEpsvOQ0lrRqj/jJVnc
X-Received: by 2002:a05:6214:f6c:b0:476:6e82:7af4 with SMTP id iy12-20020a0562140f6c00b004766e827af4mr13665131qvb.129.1661845782353;
        Tue, 30 Aug 2022 00:49:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6jV2XlYWmD/OhqYULkya2PtYbwbc5QKRdd3w44vl6+yppn7R/d3Ljn2+p96plnKK8VaBoWGQ==
X-Received: by 2002:a05:6214:f6c:b0:476:6e82:7af4 with SMTP id iy12-20020a0562140f6c00b004766e827af4mr13665121qvb.129.1661845782102;
        Tue, 30 Aug 2022 00:49:42 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5-20020a05622a170500b0034490214788sm6851304qtk.49.2022.08.30.00.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:49:41 -0700 (PDT)
Date:   Tue, 30 Aug 2022 15:49:36 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs/144: remove testing root dir inode in AG 1
Message-ID: <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-5-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830044433.1719246-5-jencce.kernel@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 12:44:33PM +0800, Murphy Zhou wrote:
> Since this xfsprogs commit
>   1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
> this operation is not allowed.
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  tests/xfs/144 | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/tests/xfs/144 b/tests/xfs/144
> index 706aff61..3f80d0ee 100755
> --- a/tests/xfs/144
> +++ b/tests/xfs/144
> @@ -17,9 +17,6 @@ _begin_fstest auto mkfs
>  _supported_fs xfs
>  _require_test
>  
> -# The last testcase creates a (sparse) fs image with a 2GB log, so we need
> -# 3GB to avoid failing the mkfs due to ENOSPC.
> -_require_fs_space $TEST_DIR $((3 * 1048576))
>  echo Silence is golden
>  
>  testfile=$TEST_DIR/a
> @@ -36,7 +33,7 @@ test_format() {
>  }
>  
>  # First we try various small filesystems and stripe sizes.
> -for M in `seq 298 302` `seq 490 520`; do
> +for M in `seq 1024 1030` ; do

Can `seq 1024 1030` replace `seq 298 302` `seq 490 520`? I don't know how
Darrick choose these numbers, better to ask the original authoer of this
case. Others looks reasonable for me.

Thanks,
Zorro

>  	for S in `seq 32 4 64`; do
>  		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
>  	done
> @@ -45,11 +42,6 @@ done
>  # log end rounded beyond EOAG due to stripe unit
>  test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
>  
> -# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> -# because this check only occurs after the root directory has been allocated,
> -# which mkfs -N doesn't do.
> -test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> -
>  # success, all done
>  status=0
>  exit
> -- 
> 2.31.1
> 

