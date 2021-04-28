Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450BFC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E43613DC
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhD1RsF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242667AbhD1RsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=83nCVKgrGf4sedjQS2BrTng2JSzKHnjwsCGqg6tJ03I=;
        b=QfrSsj18yjhduiaD3Zh3gX2awoeUv5FIWbxNNB/M0B5M8XkCPJVFcRGixM5xJAtie2ZAlU
        3z/D+/9RKs5nzcoxJ96kOh1SaFtBmPUFbcdbBN8saTvBetjWBN8GQxCojTZ9xuLeYq0Gc4
        m1zsiEkxHp8UHwJdvAdGDbEt3kdWRik=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-bn_Zcg-5PUqhyXvWZXNXiw-1; Wed, 28 Apr 2021 13:47:16 -0400
X-MC-Unique: bn_Zcg-5PUqhyXvWZXNXiw-1
Received: by mail-qv1-f69.google.com with SMTP id r18-20020a0ccc120000b02901a21aadacfcso26660565qvk.5
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=83nCVKgrGf4sedjQS2BrTng2JSzKHnjwsCGqg6tJ03I=;
        b=md2TUqQVC1E2S/J44UV0uwrh+SxyFjx+LMVUiayqfwMpXLlRsr0L6owJ5eE+NbnP6Y
         dUtEvgTNLCwvxqkVWO4x7Kcj7KRvBEEbpV2pZl0DPIqqVVZlwONWSAmmb1hMrmCAsMoC
         v0S7CFQvL4FVsfa5CYcWOqYzxDSCWa9SG30AA8m8tp79O+NMm8RCKquhWTT8bvdGVjiD
         eJtxmAuG5I2Xh7+ucVIweYmJCtiypulC6wJW1Vw6HGjPyG3JHhBiusNUkM+vubrew4Ut
         flqRY3Gstd+wxoMgQBkvufLLrjJJTpG5dasbclLPeXwJWAZZESJ7hXC3qA8W5Rw5yzub
         /wCA==
X-Gm-Message-State: AOAM533tq+ly+dihNkUSnI2wDA/ievQffAWeebvgk2IOuujH56QPeKwR
        XjA5E6rEtw2F4mKF/KUZfvTJW0SRq1bcZrPHOfbaDs+j8cg3cITCIJSjBO9fmgPsCOhr1Y5/GUV
        MVgcZZBv4q3e4Fk7carPM
X-Received: by 2002:a0c:d80a:: with SMTP id h10mr30086076qvj.25.1619632036069;
        Wed, 28 Apr 2021 10:47:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjsnW5rm8VV1T/HnIZrNt6A3Cez2ZkYoQ4tCK6tG8KPN59h5aVorg14EnKbHOK4vtTslgr+g==
X-Received: by 2002:a0c:d80a:: with SMTP id h10mr30086064qvj.25.1619632035901;
        Wed, 28 Apr 2021 10:47:15 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k18sm295558qkg.53.2021.04.28.10.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:47:15 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/5] xfs/276: remove unnecessary mkfs golden output
Message-ID: <YImfodtIxRrG4XAF@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958294062.3452351.18374824154438201788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958294062.3452351.18374824154438201788.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A previous update to this test dropped the clause where the mkfs
> standard output gets sent to /dev/null.  The filtered mkfs output isn't
> needed here and it breaks the test, so fix that.
> 
> Fixes: e97f96e5 ("xfs/27[26]: force realtime on or off as needed")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/276 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/276 b/tests/xfs/276
> index 6e2b2fb4..afea48ad 100755
> --- a/tests/xfs/276
> +++ b/tests/xfs/276
> @@ -35,7 +35,7 @@ _require_test_program "punch-alternating"
>  rm -f "$seqres.full"
>  
>  echo "Format and mount"
> -_scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs"
> +_scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs" >/dev/null
>  . $tmp.mkfs
>  cat "$tmp.mkfs" > $seqres.full
>  _scratch_mount
> 

