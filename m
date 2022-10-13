Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479D2C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 15:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJMPr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiJMPr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 11:47:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8D9DCADC
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665676044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLoHnPjXUryLdfE9TfX6Mn5fEYYm8RoqK0vdQ04ngFE=;
        b=NNEY6oGcCBaptx7PgXFfmc072pJV5hljPrlrVUkfmv3bZ25PejjpopuWJ4VAEwA6OgE2OJ
        5HiQNzmwu0HTLU1pFnYcuFXhuK56l8psZljHDuKJPjVVGzibvIC/eN5nslshNU57/jSw1n
        7/8fzJFM3iBMrrGVr68jd8xkC26euK0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-600-6JOjBbhiM3O0N9z3FAKZUQ-1; Thu, 13 Oct 2022 11:47:22 -0400
X-MC-Unique: 6JOjBbhiM3O0N9z3FAKZUQ-1
Received: by mail-qt1-f199.google.com with SMTP id br5-20020a05622a1e0500b00394c40fee51so1600549qtb.17
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLoHnPjXUryLdfE9TfX6Mn5fEYYm8RoqK0vdQ04ngFE=;
        b=GGMumj6K3oM8jdEXXFs826YgaqqxlsoDKOuQDuM36mvCwe0yiMnq4IwwkKvUtqiYu1
         q2rxt4+zvtn3s/nWrYqjiLQRq50vJ9sOcZJ0PVfGv9bogwaMaSShQifH6y7JWxV7ovMx
         LmVWkv+zpuQwy+n7aEDGDLeV/Pk2V/3tu1sKs7PTnjTuFsPMilx539X1IZFhDuhGwPLu
         0/vrY91PyiqmWOT757AVmIWTmxrQQiTLUQUq4/5nxiumnE0NlyEwTiUM6zx/6t3sHayF
         AmNHSlAzoDQV1UuVFdn8bwtwEwhyEz40EOf8NYeMO4tyxFCPkl5vmdWXYabOPxtNoT3h
         DHSg==
X-Gm-Message-State: ACrzQf2taTPooDLsXxCOmI2b3iXo48mJ82/v3lXzb6v3tOOFfSTveZQz
        6zmvTpSPNbtWV6aivrr382EUUeFmJvuU1fJAt0jRPw+FGXMFypaVyLAMNBgjR6+tVUpYk3dT0+E
        DSnmZXFmG7UESqqtJtfry
X-Received: by 2002:a05:622a:64c:b0:39c:ba62:ef05 with SMTP id a12-20020a05622a064c00b0039cba62ef05mr348557qtb.351.1665676042341;
        Thu, 13 Oct 2022 08:47:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4sHoPrEhG+rV3gcFdD8tDINaSX5BlMm0z5PokDHtnldtNff9/EAlF8NGAel5dUqzdXeqSCqg==
X-Received: by 2002:a05:622a:64c:b0:39c:ba62:ef05 with SMTP id a12-20020a05622a064c00b0039cba62ef05mr348548qtb.351.1665676042101;
        Thu, 13 Oct 2022 08:47:22 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w27-20020a05620a0e9b00b006ce76811a07sm20423qkm.75.2022.10.13.08.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:47:21 -0700 (PDT)
Date:   Thu, 13 Oct 2022 23:47:17 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] populate: reformat external ext[34] journal devices
 when restoring a cached image
Message-ID: <20221013154717.tmg4i2ebkmyzew2r@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553913911.422450.17214876114235793554.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553913911.422450.17214876114235793554.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:45:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The fs population code has the ability to save cached metadumps of
> filesystems to save time when running fstests.  The cached images should
> be unmounted cleanly, so we never save the contents of external journal
> devices.
> 
> Unfortunately, the cache restore code fails to reset the external
> journal when restoring a clean image, so we ignore cached images because
> the journal doesn't match the filesystem.  This makes test runtimes
> longer than they need to be.
> 
> Solve this by reformatting the external journal to match the filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 0bd78e0a0a..66c55b682f 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -16,6 +16,9 @@ _require_populate_commands() {
>  		_require_command "$XFS_DB_PROG" "xfs_db"
>  		_require_command "$WIPEFS_PROG" "wipefs"
>  		;;
> +	ext*)
> +		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
> +		;;
>  	esac
>  }
>  
> @@ -871,9 +874,20 @@ _scratch_populate_restore_cached() {
>  		return $res
>  		;;
>  	"ext2"|"ext3"|"ext4")
> -		# ext4 cannot e2image external logs, so we cannot restore
> -		test -n "${SCRATCH_LOGDEV}" && return 1
> -		e2image -r "${metadump}" "${SCRATCH_DEV}" && return 0
> +		e2image -r "${metadump}" "${SCRATCH_DEV}"
> +		ret=$?
> +		test $ret -ne 0 && return $ret
> +
> +		# ext4 cannot e2image external logs, so we have to reformat
> +		# the scratch device to match the restored fs
> +		if [ -n "${SCRATCH_LOGDEV}" ]; then
> +			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
> +					grep 'Journal UUID:' | \
> +					sed -e 's/Journal UUID:[[:space:]]*//g')"

This patch looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

Just ask, how about combine that grep and sed lines to:

  sed -n '/Journal UUID:/s/Journal UUID:[[:space:]]*//p'

That's not a big deal, both are OK to me.

Thanks,
Zorro

> +			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
> +					-F -U "${fsuuid}"
> +		fi
> +		return 0
>  		;;
>  	esac
>  	return 1
> 

