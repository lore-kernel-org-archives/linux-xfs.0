Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246A4C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 20:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjEZUCb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 16:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZUC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 16:02:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F97F3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 13:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685131303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RtxFHX4zO2PyGGnkQ/d6tRFa7ESWSoq+efdP4qaVHnE=;
        b=S4txcC5QeIaBof3mI3xm0jCTEj8vQvqsMpJ6DVetze6cjQ4SRssarkTFY4b6YCx6VZOtFR
        uUlm7VhSCwlBCmJCaaeVqrGBVDuvdLBmfEHRrxBwZSyaWF9W+sEz92RXOdBroDslMuLY/E
        6Lln9cSy4umuRIlpDn68XHfXOWyYWsY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-s7G_dDupPjGwVmV3HFIyyA-1; Fri, 26 May 2023 16:01:41 -0400
X-MC-Unique: s7G_dDupPjGwVmV3HFIyyA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2536e522b5cso850013a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 13:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685131300; x=1687723300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtxFHX4zO2PyGGnkQ/d6tRFa7ESWSoq+efdP4qaVHnE=;
        b=Ud/xRypkSabyZrO+gvIkPSyzl1Ll86GWAZHwJz1m5l5E1bW4PXvfTiq2S4HGbHw0oc
         tFFBr8/rDlZH+g6oDAwGOUp/hojxji4B4B7l0N2+brVJxJ2IvdXlOhvTEayMHvKgns2o
         z7DR080eCNRy41tPf6pGSoQvb5dY7wIhoDKyGlmXhS7E9LSnbtypI9Re/vTbxjMt3j94
         ZQveJaNvFZGsd8Mn+gUbX+M/Qi3doBJIRtnAJuVinT9ymfg7rExSoWUOLM+sL7mMVf3O
         HEARYEduWoZRN/pIOWvQU+LWjAV0WiV0n7zCWqscx0Qz0B5is4SlTQRZRPqoPEFPsM8D
         koSQ==
X-Gm-Message-State: AC+VfDx0+rKFoe0ENTing0f6sIHYnGXYSAgAO9Khld3Lr+OuGGHnY3sk
        YQX2XAeYNG7PBreZiCdEuBqxDgoMOYbzd42+iYPl4C77LxnGZNv6S3nKio6ppu5r5Pi3qMIkmMM
        YbgLg17gHURlEAJeztWNO
X-Received: by 2002:a17:903:32ca:b0:1ae:35b8:d59b with SMTP id i10-20020a17090332ca00b001ae35b8d59bmr4363185plr.41.1685131300597;
        Fri, 26 May 2023 13:01:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7mGHc+7Tbz/jrCFqua5oxiIYO43fr4qpedeGsD21KS75Cr1duJEXQpZxmXeCMm6k4o2c5Zrg==
X-Received: by 2002:a17:903:32ca:b0:1ae:35b8:d59b with SMTP id i10-20020a17090332ca00b001ae35b8d59bmr4363145plr.41.1685131300097;
        Fri, 26 May 2023 13:01:40 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d70500b001acad024c8asm3621776ply.40.2023.05.26.13.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 13:01:38 -0700 (PDT)
Date:   Sat, 27 May 2023 04:01:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs/018: disable parent pointers for this test
Message-ID: <20230526200134.cnhlqop277ntyyah@zlang-mailbox>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
 <168506060929.3732476.6482579916222371853.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506060929.3732476.6482579916222371853.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 07:03:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test depends heavily on the xattr formats created for new files.
> Parent pointers break those assumptions, so force parent pointers off.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/018 |    7 ++++++-
>  tests/xfs/191 |    7 ++++++-
>  tests/xfs/288 |    7 ++++++-
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 1ef51a2e61..34b6e91579 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -100,7 +100,12 @@ attr32l="X$attr32k"
>  attr64k="$attr32k$attr32k"
>  
>  echo "*** mkfs"
> -_scratch_mkfs >/dev/null
> +
> +# Parent pointers change the xattr formats sufficiently to break this test.
> +# Disable parent pointers if mkfs supports it.
> +mkfs_args=()
> +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)

Maybe we need a _require_no_xfs_parent() ?

Thanks,
Zorro

> +_scratch_mkfs "${mkfs_args[@]}" >/dev/null
>  
>  blk_sz=$(_scratch_xfs_get_sb_field blocksize)
>  err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
> diff --git a/tests/xfs/191 b/tests/xfs/191
> index 7a02f1be21..0a6c20dad7 100755
> --- a/tests/xfs/191
> +++ b/tests/xfs/191
> @@ -33,7 +33,12 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
>  _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
>  _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
>  
> -_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> +# Parent pointers change the xattr formats sufficiently to break this test.
> +# Disable parent pointers if mkfs supports it.
> +mkfs_args=()
> +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> +
> +_scratch_mkfs_xfs "${mkfs_args[@]}" | _filter_mkfs >$seqres.full 2>$tmp.mkfs
>  cat $tmp.mkfs >> $seqres.full
>  source $tmp.mkfs
>  _scratch_mount
> diff --git a/tests/xfs/288 b/tests/xfs/288
> index aa664a266e..6bfc9ac0c8 100755
> --- a/tests/xfs/288
> +++ b/tests/xfs/288
> @@ -19,8 +19,13 @@ _supported_fs xfs
>  _require_scratch
>  _require_attrs
>  
> +# Parent pointers change the xattr formats sufficiently to break this test.
> +# Disable parent pointers if mkfs supports it.
> +mkfs_args=()
> +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> +
>  # get block size ($dbsize) from the mkfs output
> -_scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +_scratch_mkfs_xfs "${mkfs_args[@]}" 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  . $tmp.mkfs
>  
>  _scratch_mount
> 

