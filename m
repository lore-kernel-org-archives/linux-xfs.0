Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAFFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 07:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiCVHRh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 03:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiCVHRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 03:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6224310FB
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 00:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647933367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c/FBRcy+huZE69c5xi3jUZeE1RQ+k0XlKCnqgEAjnHQ=;
        b=V8rPumBBl5Q0TPDsNv9XA22HxviRA/fI0hntfwYuJ/h+g+8VyslElpsbxJDBdcfjNFVEcV
        duAw7UtV1ewdNN0UMds3cMqiL7A+z61750wc/jYin3wfU0sN+zmU4HhJo8WnAkQDLjk1+N
        7qemMWLzYG2YX86hbrTNm03CXiQHGCM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-0RkL5fy2Nm-DzOAomlgSLQ-1; Tue, 22 Mar 2022 03:16:05 -0400
X-MC-Unique: 0RkL5fy2Nm-DzOAomlgSLQ-1
Received: by mail-qv1-f69.google.com with SMTP id h18-20020a05621402f200b00440cedaa9a2so13129665qvu.17
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 00:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=c/FBRcy+huZE69c5xi3jUZeE1RQ+k0XlKCnqgEAjnHQ=;
        b=2p3pkX/I6rvPwlqVMFkJFZxSM8iYOpLBPiXFBnCv9mjM1pxiqMMyDDxYGYE4RpoWAf
         thcgzov5lA43GdrxPkDzj0ldi1LN3O2uj5qBF7QLLobv/fMZ/LyyVzm+mJtvnp/Ku21p
         KnIBIIRR9pd9fF6k+SIr0KaARNDmf019WMifgbaHMBhq5+Vsz8UpX/E+i58wYayx0GAQ
         HwBJmDG5A4ny8HxKara02h4IBrbqgOD38vpSrorXJXxckiLhOwYoXpK14l4V/aFZ21v0
         ih27Dtd4O9ITNFMaPhM3XjGfKAWJTL/ilrPPptfHSLkvT7dOZrqZK/xMOELr1kAvJVfw
         ju0g==
X-Gm-Message-State: AOAM532/UvRqmdIeiYoMoqlrRheNmsueKayIpZevaV2n4nWnMLoCGm5T
        d9ZaidIdkltMFILBk/VLp+Rx+6HA1T/W4FSNEblqq7BJ5wVUHZNtVl6HwYTn0B9gA0olUXW2MQL
        0fRtVc13Ea3dvmp5N4Cp9
X-Received: by 2002:a37:b983:0:b0:67e:c0d2:c3ca with SMTP id j125-20020a37b983000000b0067ec0d2c3camr278714qkf.749.1647933365340;
        Tue, 22 Mar 2022 00:16:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRxjtfelMddTXjRRLqZmUuEMnBFZ5mAmlvL9fae1Ph1bC9jLzIywe/oKgswQWRkJhvne3c1Q==
X-Received: by 2002:a37:b983:0:b0:67e:c0d2:c3ca with SMTP id j125-20020a37b983000000b0067ec0d2c3camr278704qkf.749.1647933364857;
        Tue, 22 Mar 2022 00:16:04 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w3-20020a05622a190300b002e1f084d84bsm11502557qtc.50.2022.03.22.00.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 00:16:04 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:15:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/4] xfs/17[035]: fix intermittent failures when
 filesystem metadata gets large
Message-ID: <20220322071556.6iajo57ilyalwfdi@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
 <20220316221326.GF8200@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316221326.GF8200@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 03:13:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These tests check that the filestreams allocator never shares an AG
> across multiple streams when there's plenty of space in the filesystem.
> Recent increases in metadata overhead for newer features (e.g. bigger
> logs due to reflink) can throw this off, so add another AG to the
> formatted filesystem to encourage it to avoid the AG with the log.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---



>  common/filestreams |    2 +-
>  tests/xfs/170      |   16 +++++++++++-----
>  tests/xfs/170.out  |    8 ++++----
>  tests/xfs/171      |   16 ++++++++++++----
>  tests/xfs/171.out  |    8 ++++----
>  tests/xfs/173      |   16 ++++++++++++----
>  tests/xfs/173.out  |    8 ++++----

Looks good to me, and test passed after merging this patch. Just one
tiny question, the subject is "xfs/17[035]: ...", if "17[035]" mean
170, 173 and 175, but the files you changed are 170, 171 and 173 as
above :)

Reviewed-by: Zorro Lang <zlang@redhat.com>



>  7 files changed, 48 insertions(+), 26 deletions(-)
> 
> diff --git a/common/filestreams b/common/filestreams
> index 8165effe..62acb47c 100644
> --- a/common/filestreams
> +++ b/common/filestreams
> @@ -80,7 +80,7 @@ _check_for_dupes()
>  
>  _test_streams() {
>  
> -	echo "# testing $* ...."
> +	echo "# testing $* ...." | tee -a $seqres.full
>  	local agcount="$1"
>  	local agsize="$2" # in MB
>  	local stream_count="$3"
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index 5e622d24..b9ead341 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -25,11 +25,17 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # test small stream, multiple I/O per file, 30s timeout
>  _set_stream_timeout_centisecs 3000
>  
> -# test streams does a mkfs and mount
> -_test_streams 8 22 4 8 3 0 0
> -_test_streams 8 22 4 8 3 1 0
> -_test_streams 8 22 4 8 3 0 1
> -_test_streams 8 22 4 8 3 1 1
> +# This test checks that the filestreams allocator never allocates space in any
> +# given AG into more than one stream when there's plenty of space on the
> +# filesystem.  Newer feature sets (e.g. reflink) have increased the size of
> +# the log for small filesystems, so we make sure there's one more AG than
> +# filestreams to encourage the allocator to skip whichever AG owns the log.
> +#
> +# Exercise 9x 22MB AGs, 4 filestreams, 8 files per stream, and 3MB per file.
> +_test_streams 9 22 4 8 3 0 0
> +_test_streams 9 22 4 8 3 1 0
> +_test_streams 9 22 4 8 3 0 1
> +_test_streams 9 22 4 8 3 1 1
>  
>  status=0
>  exit
> diff --git a/tests/xfs/170.out b/tests/xfs/170.out
> index e71515e9..16dcb795 100644
> --- a/tests/xfs/170.out
> +++ b/tests/xfs/170.out
> @@ -1,20 +1,20 @@
>  QA output created by 170
> -# testing 8 22 4 8 3 0 0 ....
> +# testing 9 22 4 8 3 0 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 8 22 4 8 3 1 0 ....
> +# testing 9 22 4 8 3 1 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 8 22 4 8 3 0 1 ....
> +# testing 9 22 4 8 3 0 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 8 22 4 8 3 1 1 ....
> +# testing 9 22 4 8 3 1 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
> diff --git a/tests/xfs/171 b/tests/xfs/171
> index 4412fe2f..f93b6011 100755
> --- a/tests/xfs/171
> +++ b/tests/xfs/171
> @@ -29,10 +29,18 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # 100 = 78.1% full, should reliably succeed
>  _set_stream_timeout_centisecs 12000
>  
> -_test_streams 64 16 8 100 1 1 0
> -_test_streams 64 16 8 100 1 1 1
> -_test_streams 64 16 8 100 1 0 0
> -_test_streams 64 16 8 100 1 0 1
> +# This test tries to get close to the exact point at which the filestreams
> +# allocator will start to allocate space from some AG into more than one
> +# stream.  Newer feature sets (e.g. reflink) have increased the size of the log
> +# for small filesystems, so we make sure there's one more AG than filestreams
> +# to encourage the allocator to skip whichever AG owns the log.
> +#
> +# This test exercises 64x 16MB AGs, 8 filestreams, 100 files per stream, and
> +# 1MB per file.
> +_test_streams 65 16 8 100 1 1 0
> +_test_streams 65 16 8 100 1 1 1
> +_test_streams 65 16 8 100 1 0 0
> +_test_streams 65 16 8 100 1 0 1
>  
>  status=0
>  exit
> diff --git a/tests/xfs/171.out b/tests/xfs/171.out
> index 89407cb2..73f73c90 100644
> --- a/tests/xfs/171.out
> +++ b/tests/xfs/171.out
> @@ -1,20 +1,20 @@
>  QA output created by 171
> -# testing 64 16 8 100 1 1 0 ....
> +# testing 65 16 8 100 1 1 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 64 16 8 100 1 1 1 ....
> +# testing 65 16 8 100 1 1 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 64 16 8 100 1 0 0 ....
> +# testing 65 16 8 100 1 0 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 64 16 8 100 1 0 1 ....
> +# testing 65 16 8 100 1 0 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
> diff --git a/tests/xfs/173 b/tests/xfs/173
> index bce6ac51..6b18d919 100755
> --- a/tests/xfs/173
> +++ b/tests/xfs/173
> @@ -26,10 +26,18 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # be less than or equal to half the AG count so we don't run out of AGs.
>  _set_stream_timeout_centisecs 12000
>  
> -_test_streams 64 16 33 8 2 1 1 fail
> -_test_streams 64 16 32 8 2 0 1
> -_test_streams 64 16 33 8 2 0 0 fail
> -_test_streams 64 16 32 8 2 1 0
> +# This test checks the exact point at which the filestreams allocator will
> +# start to allocate space from some AG into more than one stream.  Newer
> +# feature sets (e.g. reflink) have increased the size of the log for small
> +# filesystems, so we make sure there's one more AG than filestreams to
> +# encourage the allocator to skip whichever AG owns the log.
> +#
> +# Exercise 65x 16MB AGs, 32/33 filestreams, 8 files per stream, and 2MB per
> +# file.
> +_test_streams 65 16 34 8 2 1 1 fail
> +_test_streams 65 16 32 8 2 0 1
> +_test_streams 65 16 34 8 2 0 0 fail
> +_test_streams 65 16 32 8 2 1 0
>  
>  status=0
>  exit
> diff --git a/tests/xfs/173.out b/tests/xfs/173.out
> index 21493057..705c352a 100644
> --- a/tests/xfs/173.out
> +++ b/tests/xfs/173.out
> @@ -1,20 +1,20 @@
>  QA output created by 173
> -# testing 64 16 33 8 2 1 1 fail ....
> +# testing 65 16 34 8 2 1 1 fail ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + expected failure, matching AGs
> -# testing 64 16 32 8 2 0 1 ....
> +# testing 65 16 32 8 2 0 1 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + passed, streams are in seperate AGs
> -# testing 64 16 33 8 2 0 0 fail ....
> +# testing 65 16 34 8 2 0 0 fail ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
>  + expected failure, matching AGs
> -# testing 64 16 32 8 2 1 0 ....
> +# testing 65 16 32 8 2 1 0 ....
>  # streaming
>  # sync AGs...
>  # checking stream AGs...
> 

