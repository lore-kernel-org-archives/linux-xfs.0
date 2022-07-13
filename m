Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5DFCCA479
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 14:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiGMO0n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiGMO0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 10:26:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 473613337F
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657722389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z23StcQQqJl1hCYT3b6PtfoFXbnirnscAks8X3j+z64=;
        b=Lk1jxw/MnR3D9V8c5TShwCzI0C/HOjrN4ZNeF78h2I/FG3kbqPQdlU+n0144iKhDFVCDk8
        7rhyd48MrPOisFcMjkZWWo1RWyvG8m9OqKIdwtBkVz+IdmZOA4IWof9wywuEvBkGLPkFuH
        9CPb1NWIy3GCkM1LZQSUfKdl4Eq1hik=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-VNVRguz7MOCr7aJYJSLcOg-1; Wed, 13 Jul 2022 10:26:28 -0400
X-MC-Unique: VNVRguz7MOCr7aJYJSLcOg-1
Received: by mail-ot1-f72.google.com with SMTP id bh7-20020a056830380700b00618fa36228fso4527209otb.7
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z23StcQQqJl1hCYT3b6PtfoFXbnirnscAks8X3j+z64=;
        b=l0Bhmlt7CjG6wtLoEWu/iBvwmc+qDtnUjtIVQ58i5BF/7bJJ8j6kpRtZOcmLvTl92O
         4q95vPNCfAc5peA/GYsfxSE44LiLTfguC+AD/O+ff1FEqNFmX2dH2I0j0nCqYfKkH+48
         uQTJTExahGNs4aP4SWFjRfPQDfTgcH3dzW3ETnr8YBaHJk4XxjiCF7KQsDWE7pAFpEbl
         HMelNWOBq77ioekGmsELRTw8vF2Nm6HFO3KPDo9jDD7KgGS815BBrgccVLlgV5fl7Zqe
         f4JU4Zc3YJ+rwJOSnFI9VoogUdpVnQY3Eptb7bMjVfFL2+goFCdpanzvYABZj/veWTVU
         gTeQ==
X-Gm-Message-State: AJIora9tIB+bKFcp5/mUsNMqvB+rQtkPOntVLtDnV67rs5mzYq5nHC+L
        yZTyHh7dlQPHXdZR7Iz0F7UiTWU0WZvgaPGd00e4PCGo3KLQ85eCo+Dtq7cAkM0Tlg5hyaScs5c
        4AO8ZIGlzJyl+LCRA8y/Z
X-Received: by 2002:a05:6808:ecf:b0:33a:3356:72f0 with SMTP id q15-20020a0568080ecf00b0033a335672f0mr960889oiv.271.1657722387092;
        Wed, 13 Jul 2022 07:26:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sCc6NfH9HpuiG3ac0tmFZCtMAN/0Cn4S7eYvQm+ojW7234pEKIh4lzELPNXYqI1OVmISTlJQ==
X-Received: by 2002:a05:6808:ecf:b0:33a:3356:72f0 with SMTP id q15-20020a0568080ecf00b0033a335672f0mr960869oiv.271.1657722386828;
        Wed, 13 Jul 2022 07:26:26 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n12-20020a4abd0c000000b00425806a20f5sm4811731oop.3.2022.07.13.07.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:26:26 -0700 (PDT)
Date:   Wed, 13 Jul 2022 22:26:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 1/8] misc: use _get_file_block_size for block (re)mapping
 tests
Message-ID: <20220713142620.gkr2lrjevx24lg4h@zlang-mailbox>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767379972.869123.2310819795149500736.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165767379972.869123.2310819795149500736.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 05:56:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Tests that exercise block remapping functionality such as reflink,
> hole punching, fcollapse, and finsert all require the input parameters
> to be aligned to allocation unit size for regular files.  This could be
> different from the fundamental filesystem block size (think ext4
> bigalloc or xfs realtime), so use the appropriate function here.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks like _get_file_block_size is more recommended than _get_block_size
generally :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc         |    2 +-
>  tests/generic/017 |    2 +-
>  tests/generic/064 |    2 +-
>  tests/generic/158 |    2 +-
>  tests/xfs/537     |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index d5e6764c..5bac0355 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2626,7 +2626,7 @@ _require_xfs_io_command()
>  		param_checked="$param"
>  		;;
>  	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
> -		local blocksize=$(_get_block_size $TEST_DIR)
> +		local blocksize=$(_get_file_block_size $TEST_DIR)
>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 $((5 * $blocksize))" \
>  			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
>  			$testfile 2>&1`
> diff --git a/tests/generic/017 b/tests/generic/017
> index 4b6acace..12c486d1 100755
> --- a/tests/generic/017
> +++ b/tests/generic/017
> @@ -29,7 +29,7 @@ _scratch_mount
>  testfile=$SCRATCH_MNT/$seq.$$
>  BLOCKS=10240
>  
> -BSIZE=`_get_block_size $SCRATCH_MNT`
> +BSIZE=`_get_file_block_size $SCRATCH_MNT`
>  
>  length=$(($BLOCKS * $BSIZE))
>  
> diff --git a/tests/generic/064 b/tests/generic/064
> index b7d7fa4b..3b32fa1b 100755
> --- a/tests/generic/064
> +++ b/tests/generic/064
> @@ -29,7 +29,7 @@ _scratch_mount
>  src=$SCRATCH_MNT/testfile
>  dest=$SCRATCH_MNT/testfile.dest
>  BLOCKS=100
> -BSIZE=`_get_block_size $SCRATCH_MNT`
> +BSIZE=`_get_file_block_size $SCRATCH_MNT`
>  length=$(($BLOCKS * $BSIZE))
>  
>  # Write file
> diff --git a/tests/generic/158 b/tests/generic/158
> index 649c75db..b9955265 100755
> --- a/tests/generic/158
> +++ b/tests/generic/158
> @@ -38,7 +38,7 @@ testdir2=$SCRATCH_MNT/test-$seq
>  mkdir $testdir2
>  
>  echo "Create the original files"
> -blksz="$(_get_block_size $testdir1)"
> +blksz="$(_get_file_block_size $testdir1)"
>  blks=1000
>  margin='7%'
>  sz=$((blksz * blks))
> diff --git a/tests/xfs/537 b/tests/xfs/537
> index 7d7776f7..a31652cd 100755
> --- a/tests/xfs/537
> +++ b/tests/xfs/537
> @@ -29,7 +29,7 @@ echo "Format and mount fs"
>  _scratch_mkfs >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
> -bsize=$(_get_block_size $SCRATCH_MNT)
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
>  
>  srcfile=${SCRATCH_MNT}/srcfile
>  donorfile=${SCRATCH_MNT}/donorfile
> 

