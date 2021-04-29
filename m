Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0732DC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 13:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBAD61450
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 13:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhD2NbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:31:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232867AbhD2NbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 09:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619703035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4/24EexAK+OHhVfKv5r/+MDcK1hPAxRgK3E6qEC7fzk=;
        b=bTmbQhaRIwz1X3hwabzbCIYmLNVE56nXTz2mVH6ROFNsuzrfMdXb9C6dl5VfzimwYlm/RA
        8bnTNDPy2qUYYEGpcPlDmc4yfZmie3MaTZLnLCmPduK/Ve34qXvpPmuWGiX80B8M9x6gvI
        q28Rpi6LeAqW9gCNRloBP5HdxBSo1bA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-3kAOWta4Oc6hkXypkRUYvw-1; Thu, 29 Apr 2021 09:30:33 -0400
X-MC-Unique: 3kAOWta4Oc6hkXypkRUYvw-1
Received: by mail-qv1-f70.google.com with SMTP id f7-20020a0562141d27b029019a6fd0a183so30603612qvd.23
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 06:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4/24EexAK+OHhVfKv5r/+MDcK1hPAxRgK3E6qEC7fzk=;
        b=GL2Nb9p2yICe94KxaRMwpDoig8TyT01eevdWolvUyWfZZNwKbWIdDcutYuDhXNymRv
         V1IURZ1fJY55MpayMa+D8aK/by+dcn93GOmvJPRxK9yK8PofFH4hOPdZSOBBjzCw1Ku/
         OMhwFp+jg3k+JmGpE8dcMcMxVdeY/hyy7xSnV4cXqqwi7OhjymzrURNl02iH7mtbRtRQ
         khMeYIbPUVrTzyZ0X8A1TeO1YvKplFzwfI6bYErXu2szRnNtctY/oQaHqSye1luP23pg
         rTOBXakvdNOYbvtPsxwpztBXY2NhsRkmNOtydy4oKJF8p1PoBZakkEVnEGYKeL65J/cc
         cvzQ==
X-Gm-Message-State: AOAM532eF1RtmP3tkBmXQ1BQQkypPTiCtdD9bH6qdljdVaJgisjpE9aM
        3eYlOLQYu67oDqWe4DoRIc68Z4xlIip+6wLJNUyCNJYCBPmqSOSX1y0u5zua3iO5Ly2zh0NiGOY
        sx1c8fELGw3ZNFOe+KmYA
X-Received: by 2002:ac8:5655:: with SMTP id 21mr32770753qtt.187.1619703032894;
        Thu, 29 Apr 2021 06:30:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEJCEMohk4OevIiLDOHRak6f0BMonNhH/011LaHSS2x6TpsDLzEfrVZTgv5/KuXiQu7bTdTQ==
X-Received: by 2002:ac8:5655:: with SMTP id 21mr32770731qtt.187.1619703032661;
        Thu, 29 Apr 2021 06:30:32 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id a20sm1399117qko.36.2021.04.29.06.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 06:30:32 -0700 (PDT)
Date:   Thu, 29 Apr 2021 09:30:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v1.2 5/5] xfs/49[12]: skip pre-lazysbcount filesystems
Message-ID: <YIq09i9DxCM19NEJ@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958296475.3452351.7075798777673076839.stgit@magnolia>
 <20210429013154.GL3122235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429013154.GL3122235@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 06:31:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to lazysbcount, the xfs mount code blindly trusted the value of
> the fdblocks counter in the primary super, which means that the kernel
> doesn't detect the fuzzed fdblocks value at all.  V4 is deprecated and
> pre-lazysbcount V4 hasn't been the default for ~14 years, so we'll just
> skip these two tests on those old filesystems.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.2: factor the feature checking into a separate helper
> ---

Looks good, thanks for the update:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs    |   12 ++++++++++++
>  tests/xfs/491 |    4 ++++
>  tests/xfs/492 |    4 ++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 8501b084..92383061 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1129,6 +1129,18 @@ _check_scratch_xfs_features()
>  	test "${found}" -eq "$#"
>  }
>  
> +# Skip a test if any of the given fs features aren't present on the scratch
> +# filesystem.  The scratch fs must have been formatted already.
> +_require_scratch_xfs_features()
> +{
> +	local features="$(_scratch_xfs_db -c 'version' 2>/dev/null)"
> +
> +	for feature in "$@"; do
> +		echo "${features}" | grep -q -w "${feature}" ||
> +			_notrun "Missing scratch feature: ${feature}"
> +	done
> +}
> +
>  # Decide if xfs_repair knows how to set (or clear) a filesystem feature.
>  _require_xfs_repair_upgrade()
>  {
> diff --git a/tests/xfs/491 b/tests/xfs/491
> index 6420202b..7d447ccf 100755
> --- a/tests/xfs/491
> +++ b/tests/xfs/491
> @@ -36,6 +36,10 @@ _require_scratch
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> +
> +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> +_require_scratch_xfs_features LAZYSBCOUNT
> +
>  _scratch_mount >> $seqres.full 2>&1
>  echo "test file" > $SCRATCH_MNT/testfile
>  
> diff --git a/tests/xfs/492 b/tests/xfs/492
> index 522def47..21c6872f 100755
> --- a/tests/xfs/492
> +++ b/tests/xfs/492
> @@ -36,6 +36,10 @@ _require_scratch
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> +
> +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> +_require_scratch_xfs_features LAZYSBCOUNT
> +
>  _scratch_mount >> $seqres.full 2>&1
>  echo "test file" > $SCRATCH_MNT/testfile
>  
> 

