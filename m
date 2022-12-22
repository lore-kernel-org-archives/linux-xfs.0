Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BCBC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Dec 2022 07:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLVHT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Dec 2022 02:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLVHT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2022 02:19:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728022B01
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 23:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671693547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U03EJ97qjDi03/Cgd8Neqw7yDGPypOWrxu6FNB3WBI4=;
        b=eVVPj3hef17uNAoAoaE9/kLxfY8qB1Dc9WUfOeHIbyAwo7ZNYc/+UmLRjiozn7thA/MH+s
        Fn5+wI/gYanQbZHgJxWnxMhjN8qa40CSHy4RU8QEQvjSdE3ug1BReusDbxj6Q5bIYjw6cZ
        2Lm8QdLou+orJYbfmqOpmNNbwici7XU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-XyG737KmPgS9tIZHBz0T1w-1; Thu, 22 Dec 2022 02:19:06 -0500
X-MC-Unique: XyG737KmPgS9tIZHBz0T1w-1
Received: by mail-pf1-f200.google.com with SMTP id k22-20020aa79736000000b0057f3577fdbaso642543pfg.8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 23:19:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U03EJ97qjDi03/Cgd8Neqw7yDGPypOWrxu6FNB3WBI4=;
        b=mWXiZGETrDm38pkCgnPn1kByoksrwpQ/E3zzQW2aunxD9w8NU/Do7IzbtZWXN1kyqb
         Jaqu5Z4va9CppLXTQr5Rl84Nbexkhk9ZkD3OveTLsQo3yM0vShvGu/9jacjGE31yR5lC
         jfzNEMiaTbyk14PUv+sV/RYr0xwsAFHiNyVJ8BeJ0LuQWIDcbgBIMnl/52rTfVnP9L8H
         vQIzqgwq/pQKuRs5ujRlZ9EE6hmW1mtsU3sZWx3idfVKBI9P2uz6ervXi29l+rjSpTDs
         KVc5uUYKlGaGCbCJoacxUkFODSRYoO24YebJH7Pqx8fUnQZ6RY3PLCh/3hxI5zDjYE7l
         FwPA==
X-Gm-Message-State: AFqh2kpoy+CdvIWRhHVKi6vdr5oP3sGpuC4ijypyoy3Ywua1HReaSK6Z
        zRf9GKJvCvRuF80H/Zhpq2lNSH5DebGlky06hgS/x1tpLGreEP7/MSQeA7agif/GJY4gFofL3LS
        OJ4YSsy+C8wBH/O3W+i9Y
X-Received: by 2002:a17:903:3255:b0:191:f83:636b with SMTP id ji21-20020a170903325500b001910f83636bmr5274145plb.25.1671693545501;
        Wed, 21 Dec 2022 23:19:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvCLzpcWgGtBV96Kz5Y59MkrD0rPFuMpKJvtAu5nILUd50raV4lECr3KIh8rsPq7aUMulHAVQ==
X-Received: by 2002:a17:903:3255:b0:191:f83:636b with SMTP id ji21-20020a170903325500b001910f83636bmr5274134plb.25.1671693545121;
        Wed, 21 Dec 2022 23:19:05 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f10-20020a63510a000000b004351358f056sm55996pgb.85.2022.12.21.23.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 23:19:04 -0800 (PST)
Date:   Thu, 22 Dec 2022 15:19:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <20221222071900.dngksnsq374c5cdj@zlang-mailbox>
References: <167158209640.235360.13061162358544554094.stgit@magnolia>
 <167158210207.235360.12388823078640206103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167158210207.235360.12388823078640206103.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 04:21:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust this test since made EFI/EFD log item format structs proper flex
> arrays instead of array[1].
> 
> This adjustment was made to the kernel source tree as part of a project
> to make the use of flex arrays more consistent throughout the kernel.
> Converting array[1] and array[0] to array[] also avoids bugs in various
> compiler ports that mishandle the array size computation.  Prior to the
> introduction of xfs_ondisk.h, these miscomputations resulted in kernels
> that would silently write out filesystem structures that would then not
> be recognized by more mainstream systems (e.g.  x86).
> 
> OFC nearly all those reports about buggy compilers are for tiny
> architectures that XFS doesn't work well on anyways, so in practice it
> hasn't created any user problems (AFAIK).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This version looks good to me, thanks for all these detailed information!

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc         |   15 +++++++++++++++
>  tests/xfs/122     |    5 +++++
>  tests/xfs/122.out |    8 ++++----
>  3 files changed, 24 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 8060c03b7d..67bd74dc89 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1502,6 +1502,21 @@ _fixed_by_kernel_commit()
>  	_fixed_by_git_commit kernel $*
>  }
>  

I'd like to give some comments to the new _wants_* helpers when I merge
it (don't need send a new version again: ), to help others know the
different usage of _wants_* and _fixed_by_*. How about below comment:

# Compare with _fixed_by_* helpers, this helper is used for un-regression
# test case, e.g. xfs/122. Or a case would like to mention a git commit
# which is not a bug fix (maybe a default behavior/format change). Then
# use this helpers.

> +_wants_git_commit()
> +{
> +	local pkg=$1
> +	shift
> +
> +	echo "This test wants $pkg fix:" >> $seqres.hints
> +	echo "      $*" >> $seqres.hints
> +	echo >> $seqres.hints
> +}
> +

# Refer to _wants_git_commit

Feel free to make it better :)

Thanks,
Zorro

> +_wants_kernel_commit()
> +{
> +	_wants_git_commit kernel $*
> +}
> +
>  _check_if_dev_already_mounted()
>  {
>  	local dev=$1
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 91083d6036..e616f1987d 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -17,6 +17,11 @@ _begin_fstest other auto quick clone realtime
>  _supported_fs xfs
>  _require_command "$INDENT_PROG" indent
>  
> +# Starting in Linux 6.1, the EFI log formats were adjusted away from using
> +# single-element arrays as flex arrays.
> +_wants_kernel_commit 03a7485cd701 \
> +	"xfs: fix memcpy fortify errors in EFI log format copying"
> +
>  # filter out known changes to xfs type sizes
>  _type_size_filter()
>  {
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index a56cbee84f..95e53c5081 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
>  sizeof(xfs_dq_logformat_t) = 24
>  sizeof(xfs_dqblk_t) = 136
>  sizeof(xfs_dsb_t) = 264
> -sizeof(xfs_efd_log_format_32_t) = 28
> -sizeof(xfs_efd_log_format_64_t) = 32
> -sizeof(xfs_efi_log_format_32_t) = 28
> -sizeof(xfs_efi_log_format_64_t) = 32
> +sizeof(xfs_efd_log_format_32_t) = 16
> +sizeof(xfs_efd_log_format_64_t) = 16
> +sizeof(xfs_efi_log_format_32_t) = 16
> +sizeof(xfs_efi_log_format_64_t) = 16
>  sizeof(xfs_error_injection_t) = 8
>  sizeof(xfs_exntfmt_t) = 4
>  sizeof(xfs_exntst_t) = 4
> 

