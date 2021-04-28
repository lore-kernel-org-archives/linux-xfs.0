Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB41C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE9E61168
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbhD1Rso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242378AbhD1Rsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O6agX5tigvN+5FOe9w4Hj66VlzpPTJCuQDFa6uDYsO4=;
        b=Cg94DslEiIN/kr6qvFgbl1fBmX34ormhIt5dQrAAmEwDYPhjCmfJB6ivF/7JgAtEEmbURY
        Y8rcNdzSoyrAt5L98KVnzX3/lH1QR0Qi1X62tZlGmhAxtwpd1eqJRlw3G3yuaPkACcVFc6
        pfwQ1Ttc4EDZOqaQATstngB/tBQWdBo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-qVbSQbBzP0u7rV9iFwINlg-1; Wed, 28 Apr 2021 13:47:55 -0400
X-MC-Unique: qVbSQbBzP0u7rV9iFwINlg-1
Received: by mail-qk1-f198.google.com with SMTP id h22-20020a05620a13f6b02902e3e9aad4bdso21772921qkl.14
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O6agX5tigvN+5FOe9w4Hj66VlzpPTJCuQDFa6uDYsO4=;
        b=ThKpZPtFegl+iHRj4HjS25HP/1wgrz2//v34EVwTYpAOI108jTIf/NP8y0whqeOM2h
         wI4SC/To7csIvIhr5ewHwXB1CzueSNhI7Ms37q6pM+1T6VdJgfe7nh9O9D8nmSv9nkg0
         nfV7PfCGGqw8XIRPRvCKz9lSyDmMqfhNJ7t4F+Y2yUKSz/OlHhhCGCfUkIhEiU387wbh
         eqhdpte5rRn0au5mHH3yE+5CevHcS+dWiT06aaImD1kAF3G0DFc83VQO252FnM8XNB8i
         FPAHgwK1CBEUTzEa5C1VTqaqOHDOR8DTIdoag+eWKoAJphpmlmusHlOG3qoQUme/LfrM
         osiQ==
X-Gm-Message-State: AOAM531eMFvOOyKyvny5h0DibEiNUSWCWp/eHMDK3+P8gpLZSG3upB7E
        3QYc5ihSeaha/P9BLIXgVbbj91KXc+50OEvK4DxehuuLcvWs0a22/HalVnVaom3qOLjvXPJKXzK
        mrACEpr8EmmZgEpibdEKq
X-Received: by 2002:ac8:7fc5:: with SMTP id b5mr27806571qtk.41.1619632075454;
        Wed, 28 Apr 2021 10:47:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLj0pzM9rDJLLvl6ytN/zxkGHrebWz+iCUltfERJg7QOex6mg1uy6Itus5uN2sT+z+A/rWIw==
X-Received: by 2002:ac8:7fc5:: with SMTP id b5mr27806551qtk.41.1619632075193;
        Wed, 28 Apr 2021 10:47:55 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h8sm480883qtp.47.2021.04.28.10.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:47:54 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] xfs/49[12]: skip pre-lazysbcount filesystems
Message-ID: <YImfyecT3zngAioz@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958296475.3452351.7075798777673076839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958296475.3452351.7075798777673076839.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:24PM -0700, Darrick J. Wong wrote:
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
>  tests/xfs/491 |    5 +++++
>  tests/xfs/492 |    5 +++++
>  2 files changed, 10 insertions(+)
> 
> 
> diff --git a/tests/xfs/491 b/tests/xfs/491
> index 6420202b..9fd0ab56 100755
> --- a/tests/xfs/491
> +++ b/tests/xfs/491
> @@ -36,6 +36,11 @@ _require_scratch
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> +
> +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> +_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
> +	_notrun "filesystem requires lazysbcount"
> +

Perhaps we should turn this one into a '_require_scratch_xfs_feature
<FEATURE>' helper or some such? Probably not that important for
lazysbcount filtering, but it seems like that might be useful for newer
features going forward.

Brian

>  _scratch_mount >> $seqres.full 2>&1
>  echo "test file" > $SCRATCH_MNT/testfile
>  
> diff --git a/tests/xfs/492 b/tests/xfs/492
> index 522def47..c4b087b5 100755
> --- a/tests/xfs/492
> +++ b/tests/xfs/492
> @@ -36,6 +36,11 @@ _require_scratch
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> +
> +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> +_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
> +	_notrun "filesystem requires lazysbcount"
> +
>  _scratch_mount >> $seqres.full 2>&1
>  echo "test file" > $SCRATCH_MNT/testfile
>  
> 

