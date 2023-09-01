Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00510CA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 16:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbjIAQdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjIAQc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 12:32:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC910EC
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 09:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693585935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=seGBgEQUi0lvTCuBGw9D7INs1kk4a1W/2PWVZkl0aVA=;
        b=cSygODJ0t/DPMT8hip/g+f6b0PPcGOpB8hXnL15oIhWBIVornKqZgbnNtXUHEmFLH2zdJu
        Y+WiouMtSJPiARvj4OylCTWPMthYhBxRO3G4eLlTmn9qYcp2rTvy89tD2hWyg0LYhzX9js
        eVUe8PUAm7TcbulG9AFNkXFcH4j9vm4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-zMllLHanPrmXGw4Wf3ZduQ-1; Fri, 01 Sep 2023 12:32:14 -0400
X-MC-Unique: zMllLHanPrmXGw4Wf3ZduQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-56c306471ccso2113676a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2023 09:32:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693585932; x=1694190732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seGBgEQUi0lvTCuBGw9D7INs1kk4a1W/2PWVZkl0aVA=;
        b=Pa1QPrsY189jBJf8oHrbPSZiMVgQFzaoMZydXJnWl2Nw3BQclE6SJLMK2Cg1ijPpFA
         uC8OPxteiqStIkSio376IopE3lRSHafqa+4rdl3Myj2wxw8C6p9NfgwjZ4TGB5hjfTOS
         zTXX+WhFJDM4TckrW2a0uAjv5MxhSWNbKHJuPupzNpiwqwU0qsv7rzu3B6iyNO2UqyOm
         QsSRssth2mgroiFP4BTF8y2GRw8UetPsd31MHWeSCmXV5kcJ1SyLukFvHSAiXAybvBcd
         HZ+T/PU5oemVcAhifQxDoLQvAivCag+wXv+X0++2DlsGzkLrj+P6FK4ZmeFS4MQD2asR
         LCTw==
X-Gm-Message-State: AOJu0YyozWN0QcoV5tWM5Nf5cp9ZFfyX1qgmEu/gsouXWRWGq/StDoTw
        v0VNpqaUufFPL/kUmykcRWLb2yWe67lPmo+L1f8UnS3e01zKMfB604CmQ46RbNjpAF+YRxgniM6
        Cc/yacNRcPETrGeHbAXILuWVHrliglP1qYw==
X-Received: by 2002:a05:6a20:54a8:b0:148:4c5:9714 with SMTP id i40-20020a056a2054a800b0014804c59714mr3984183pzk.13.1693585932678;
        Fri, 01 Sep 2023 09:32:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMVaHqhGQOfFSNG3IuJWBGwg9ttsB0dWI2Js4E7jlvzxokNYYk2xKxzs90aqv+CBv1gBUdvA==
X-Received: by 2002:a05:6a20:54a8:b0:148:4c5:9714 with SMTP id i40-20020a056a2054a800b0014804c59714mr3984156pzk.13.1693585932415;
        Fri, 01 Sep 2023 09:32:12 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x3-20020aa784c3000000b00687fcb2ba7csm3139717pfn.103.2023.09.01.09.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 09:32:11 -0700 (PDT)
Date:   Sat, 2 Sep 2023 00:32:07 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] common: split _get_hugepagesize into detection and
 actual query
Message-ID: <20230901163207.xzii6pqogzfa3jxw@zlang-mailbox>
References: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
 <169335021789.3517899.15257872086965624714.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335021789.3517899.15257872086965624714.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:03:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This helper has two parts -- querying the value, and _notrun'ing the
> test if huge pages aren't turned on.  Break these into the usual
> _require_hugepages and _get_hugepagesize predicates so that we can adapt
> xfs/559 to large folios being used for writes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc         |   13 ++++++++-----
>  tests/generic/413 |    1 +
>  tests/generic/605 |    1 +
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 68d2ad041e..b5bf3c3bcb 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -108,14 +108,17 @@ _get_filesize()
>      stat -c %s "$1"
>  }
>  
> +# Does this kernel support huge pages?
> +_require_hugepages()
> +{
> +	awk '/Hugepagesize/ {print $2}' /proc/meminfo | grep -E -q ^[0-9]+$ || \
> +		_notrun "Kernel does not report huge page size"
> +}
> +
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> -	local hugepgsz=$(awk '/Hugepagesize/ {print $2}' /proc/meminfo)
> -	# Call _notrun if $hugepgsz is not a number
> -	echo "$hugepgsz" | grep -E -q ^[0-9]+$ || \
> -		_notrun "Cannot get the value of Hugepagesize"
> -	echo $((hugepgsz * 1024))
> +	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
>  }
>  
>  _mount()
> diff --git a/tests/generic/413 b/tests/generic/413
> index 155f397d1d..bd1b04a624 100755
> --- a/tests/generic/413
> +++ b/tests/generic/413
> @@ -13,6 +13,7 @@ _begin_fstest auto quick dax prealloc
>  . ./common/filter
>  
>  _supported_fs generic
> +_require_hugepages
>  _require_test
>  _require_scratch_dax_mountopt "dax"
>  _require_test_program "feature"
> diff --git a/tests/generic/605 b/tests/generic/605
> index 77671f39d3..7e814d5ba1 100755
> --- a/tests/generic/605
> +++ b/tests/generic/605
> @@ -13,6 +13,7 @@ _begin_fstest auto attr quick dax prealloc
>  . ./common/filter
>  
>  _supported_fs generic
> +_require_hugepages
>  _require_scratch_dax_mountopt "dax=always"
>  _require_test_program "feature"
>  _require_test_program "t_mmap_dio"
> 

