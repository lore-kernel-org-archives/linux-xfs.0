Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F831C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 13:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiGGN3r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiGGN3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 09:29:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B8CE313A7
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657200584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GxbH1buS7CtTd7+uOf8ed3PdpyMBy4zeogZpKS59Mlw=;
        b=GTY219BLh/A+84qxmm1qL97qSGUdChSIuixtuN3FywvlBxv3t0SoSCrAvul0ChEYwfA9bR
        3FY+iXKCnwQKH3YrqMh3sJpnu4Tdl8xSsptLd2ldZ+IMiEUMp5TvZlsSSID49nLMSixm1a
        gngHwEtlnsbg4cQkP1n8s/e8iUo7gkM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-0nqaaFQMOX2IOfVfHuPGbA-1; Thu, 07 Jul 2022 09:29:43 -0400
X-MC-Unique: 0nqaaFQMOX2IOfVfHuPGbA-1
Received: by mail-qt1-f200.google.com with SMTP id fx12-20020a05622a4acc00b0031e98cb703cso1991637qtb.18
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 06:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxbH1buS7CtTd7+uOf8ed3PdpyMBy4zeogZpKS59Mlw=;
        b=KIAmqMo8Uaowf8DHJu5fChGtlz0ERDcvhVGOMFMoqfD4YlGcO3ab9mvdtPcf+lrEfu
         YO06+cizWYtAy1YUBK62ESuVmLtMcm5twNEpn0mUfvzcknEWtqm78hS7MEdrH4YWudND
         mylZWLrj24lmdWqU1tun7tjhrUSIx7Nl34zesD2D9fKl19UTAzJ6t2GNZ7UZLEkExbAy
         XWktKQ2A3EO8WYJiyQ+sBoyAED+cIm5hZHAncQMkayFOAGpSmUcdUYPQr3xyGBGLip4X
         CNKzETPXj/lbiRu7EsTv4Y+b/zKa3i3HT0a3vPGY7vmnJqtFrIVcCUlzTCO00TLBomQU
         wxOw==
X-Gm-Message-State: AJIora+vHqlTR5hxBB6ijecA28Y8Evfo1bRdOEhbwaTJ9FoKDAcvSNsD
        j+4YMpKguZVlpv3mYHBJQcOmtNdasNkLwA8TUbsVPEZOHguaxRmO+1nS4nsDNN8HoygqjN6B6yK
        HTVx+fOPC4f4Ke5mPzwrj
X-Received: by 2002:ac8:5d49:0:b0:31e:9b43:9366 with SMTP id g9-20020ac85d49000000b0031e9b439366mr1939814qtx.69.1657200582752;
        Thu, 07 Jul 2022 06:29:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9/am4kYHZmAjYHZzVQgHcbBFjNVE4Np6XurjgIVf6zZgm9s/fmgt0i1/tSP4XpqBrwrGDDQ==
X-Received: by 2002:ac8:5d49:0:b0:31e:9b43:9366 with SMTP id g9-20020ac85d49000000b0031e9b439366mr1939685qtx.69.1657200581125;
        Thu, 07 Jul 2022 06:29:41 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q11-20020a05620a0d8b00b006a32bf19502sm31269109qkl.60.2022.07.07.06.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 06:29:40 -0700 (PDT)
Date:   Thu, 7 Jul 2022 21:29:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix test mkfs.xfs sizing of internal logs that
 overflow the AG
Message-ID: <20220707132934.dcq4d2yq4nacfnkx@zlang-mailbox>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
 <165705852849.2820493.14066599391475531621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705852849.2820493.14066599391475531621.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 03:02:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a few problems with this test -- one of the things we test require
> mkfs to run in -N mode, so we need to have a certain amount of free
> space, and fix that test not to use -N mode.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This case has been merged, so it's fine to use "xfs/144: ..." as the subject
of this patch. Others looks good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/144 |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/tests/xfs/144 b/tests/xfs/144
> index 2910eec9..706aff61 100755
> --- a/tests/xfs/144
> +++ b/tests/xfs/144
> @@ -16,6 +16,10 @@ _begin_fstest auto mkfs
>  # Modify as appropriate.
>  _supported_fs xfs
>  _require_test
> +
> +# The last testcase creates a (sparse) fs image with a 2GB log, so we need
> +# 3GB to avoid failing the mkfs due to ENOSPC.
> +_require_fs_space $TEST_DIR $((3 * 1048576))
>  echo Silence is golden
>  
>  testfile=$TEST_DIR/a
> @@ -26,7 +30,7 @@ test_format() {
>  	shift
>  
>  	echo "$tag" >> $seqres.full
> -	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
> +	$MKFS_XFS_PROG -f $@ -d file,name=$testfile &>> $seqres.full
>  	local res=$?
>  	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
>  }
> @@ -38,13 +42,13 @@ for M in `seq 298 302` `seq 490 520`; do
>  	done
>  done
>  
> +# log end rounded beyond EOAG due to stripe unit
> +test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
> +
>  # Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
>  # because this check only occurs after the root directory has been allocated,
>  # which mkfs -N doesn't do.
> -test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
> -
> -# log end rounded beyond EOAG due to stripe unit
> -test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
> +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
>  
>  # success, all done
>  status=0
> 

