Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBABC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Apr 2022 13:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiDPNiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Apr 2022 09:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiDPNiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Apr 2022 09:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F7E43CFED
        for <linux-xfs@vger.kernel.org>; Sat, 16 Apr 2022 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650116126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jH3MPUHJAECXXZSY9edmQYka6fuZCzm0XaNcA8qkX9g=;
        b=EGyPvf0xfkGT5gNlzoo+trVGgFNsoJPy+3ToNvHpvTvDCaEoD1LHCU1KRQcnnjl1Uu1U4r
        Zn2bB8H19vdMhcpTLTMcCmuVFz7GfqZm74EKenyXyPc3N8U4f6GZkgmpxeZoDHl6rGrkJ/
        L5gCY0LA17WtbINXkFeVFe4xme2BvCQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-_oeNDkoEMhuyUohqE_A1Cw-1; Sat, 16 Apr 2022 09:35:25 -0400
X-MC-Unique: _oeNDkoEMhuyUohqE_A1Cw-1
Received: by mail-qv1-f70.google.com with SMTP id 30-20020a0c80a1000000b00446218e1bcbso6214083qvb.23
        for <linux-xfs@vger.kernel.org>; Sat, 16 Apr 2022 06:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=jH3MPUHJAECXXZSY9edmQYka6fuZCzm0XaNcA8qkX9g=;
        b=VGz/Jw2+2DGoSzYAhdYPvvHETnWPI9xRsEPDaI8nwoAozzYtvuqdHYCHyUR4Jr6lnH
         EZeChOcBVXh+5nMxJHb+X7jsGdxiRpngzl63hvUftM2kQiISkee9JFKJO0QYBQdgtIO/
         +A2elkT5gJwlp3PZWezaS+InYpdSjgOWt62xQidrghb1RXFrirY69fQkZ5h0oFtaPzg6
         cfpLozhv6HqQW205Rff9sGGJRbJbcpmALu1L/NnzvMR3qQarh9LvmP0LXAG298lDJrOS
         pJe0ivnqMdyn37shkalk4/y51YuVi0JAVOG4kwgQdAJjuC4IrcaXeJvAzg2+LjQuxcfC
         5icQ==
X-Gm-Message-State: AOAM530V1/MRwh4P3E3i9MKKr7dPoxCJ/J9URdHRXAk0WqMF4spyuGXy
        +CZm7X2F2eNSI3UWdR/cBEWLvSr/7r/FHaTUzHGZ4Lvl0SeI+fPHSyEFcIe3bUhBM8/QemyFkg9
        RXJy3IY4GdKEtxYPik2eg
X-Received: by 2002:a05:620a:2946:b0:69e:7d37:2229 with SMTP id n6-20020a05620a294600b0069e7d372229mr762613qkp.604.1650116125098;
        Sat, 16 Apr 2022 06:35:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws5RbNvmNzSoc/ulOPm6TdZSOpo8NCY/E8VfWCA9+8BQc08jY17/lbJ9+zLUT0Hh3cdNJSfg==
X-Received: by 2002:a05:620a:2946:b0:69e:7d37:2229 with SMTP id n6-20020a05620a294600b0069e7d372229mr762607qkp.604.1650116124829;
        Sat, 16 Apr 2022 06:35:24 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5-20020a05622a198500b002f1f02b7465sm2169705qtc.17.2022.04.16.06.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 06:35:24 -0700 (PDT)
Date:   Sat, 16 Apr 2022 21:35:18 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v1.1 3/3] xfs/216: handle larger log sizes
Message-ID: <20220416133518.sxow73joph3f7h7v@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220415150458.GB17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415150458.GB17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 08:04:58AM -0700, Darrick J. Wong wrote:
> mkfs will soon refuse to format a log smaller than 64MB, so update this
> test to reflect the new log sizing calculations.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/216             |   19 +++++++++++++++++++
>  tests/xfs/216.out.64mblog |   10 ++++++++++
>  tests/xfs/216.out.classic |    0 
>  3 files changed, 29 insertions(+)
>  create mode 100644 tests/xfs/216.out.64mblog
>  rename tests/xfs/{216.out => 216.out.classic} (100%)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index c3697db7..ebae8979 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -29,6 +29,23 @@ $MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
>  $MKFS_XFS_PROG 2>&1 | grep -q reflink && \
>  	loop_mkfs_opts="$loop_mkfs_opts -m reflink=0"
>  
> +# Decide which golden output file we're using.  Starting with mkfs.xfs 5.15,
> +# the default minimum log size was raised to 64MB for all cases, so we detect
> +# that by test-formatting with a 512M filesystem.  This is a little handwavy,
> +# but it's the best we can do.
> +choose_golden_output() {
> +	local seqfull=$1
> +	local file=$2
> +
> +	if $MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> +			-d name=$file,size=512m $loop_mkfs_opts | \
> +			grep -q 'log.*blocks=16384'; then
> +		ln -f -s $seqfull.out.64mblog $seqfull.out
> +	else
> +		ln -f -s $seqfull.out.classic $seqfull.out
> +	fi

Actually there's a old common function in common/rc named _link_out_file(),
xfstests generally use it to deal with multiple .out files. It would be
better to keep in step with common helpers, but your "ln" command
isn't wrong :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +}
> +
>  _do_mkfs()
>  {
>  	for i in $*; do
> @@ -43,6 +60,8 @@ _do_mkfs()
>  # make large holey file
>  $XFS_IO_PROG -f -c "truncate 256g" $LOOP_DEV
>  
> +choose_golden_output $0 $LOOP_DEV
> +
>  #make loopback mount dir
>  mkdir $LOOP_MNT
>  
> diff --git a/tests/xfs/216.out.64mblog b/tests/xfs/216.out.64mblog
> new file mode 100644
> index 00000000..3c12085f
> --- /dev/null
> +++ b/tests/xfs/216.out.64mblog
> @@ -0,0 +1,10 @@
> +QA output created by 216
> +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> diff --git a/tests/xfs/216.out b/tests/xfs/216.out.classic
> similarity index 100%
> rename from tests/xfs/216.out
> rename to tests/xfs/216.out.classic
> 

