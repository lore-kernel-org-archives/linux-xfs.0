Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07092C4743D
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E918960FF4
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhFKHv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhFKHv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 03:51:58 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA913C061574;
        Fri, 11 Jun 2021 00:50:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t17so1796259pga.5;
        Fri, 11 Jun 2021 00:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=XDQ7Y2LsbskU8VR11lnF8kU3uLMWTVdaleXRQTdHo0g=;
        b=TZyAnpOMS67yK6El2csuZrnZ03w6lT+WIloObno/4TKyKzvOl1t95meioJrb7y70iW
         42jdLtRpaMP71DGRDMMERDZL1BN0EOPLMCrV34gjqsZJlSvVCAJXsQrwOL/d6fYP28WQ
         GMmK2dVo0W1rBPxabSMlll4vMr1LHD9y+pN4rNO67E+osLRDdxAB3nqFZGv3lZsXkzih
         tlxEU9O/+O0s1W9WpZx0VbKC48q9i7K7vn9tpVrn1XOK4cCvPTB4HqKmJoJoXJ0Z0DMC
         3WsEuwrf91agqdG5+0n2sLxgSpVMRY3ecZX4zhy04PkivaLAoRWl2vPvkt9gqjT0y3nl
         BNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=XDQ7Y2LsbskU8VR11lnF8kU3uLMWTVdaleXRQTdHo0g=;
        b=FO8C3j/5pXBmmp7o/w/gnlKl7fpIC4yM6dHvtANzp/D47M48lAbW8VoHdUJ4qTmctC
         LcKjH1w5xKMp0wYrxYT+7iN4cUc4qa6hS9rpbTP1QhkjvCgPskWwXJF8y9kbReGkynnU
         vVFwGUtjxAfin6azjzhv3xgdztnhdaLhODH6TPv2aSysBoqqcuvFEoIKReSBUjHhzVDh
         LXvd3zTK2/9COWI8EIHip9jUohWiDCsi3zAXZbzvrlMhDmCqaJDZypo540F9prYkvym9
         Zz2tkHKKBca3T4/2Fu7oP1a7P/08/lmIJGg4NFqEg2Ov9vVJXN94o1q6CNrBixAAFhgv
         qzxQ==
X-Gm-Message-State: AOAM532z8xBniwLM40YnFIUcoTxJPMtShPzeG7OB7H0oy9m5R9kPDu2g
        WfDJ74siAPgwGoRQnHJh3AA=
X-Google-Smtp-Source: ABdhPJztyVgEQFfuhCBpxxPh/N//fWVEhzQDX2UutPGLd993ngNVqmI7nDXONbD8m6ri9rwwKZrflw==
X-Received: by 2002:a63:be45:: with SMTP id g5mr2330356pgo.311.1623397800149;
        Fri, 11 Jun 2021 00:50:00 -0700 (PDT)
Received: from garuda ([171.61.74.194])
        by smtp.gmail.com with ESMTPSA id h21sm4130479pfv.190.2021.06.11.00.49.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jun 2021 00:49:59 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317281679.653489.1178774292862746443.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 10/13] check: use generated group files
In-reply-to: <162317281679.653489.1178774292862746443.stgit@locust>
Date:   Fri, 11 Jun 2021 13:19:56 +0530
Message-ID: <87sg1o3knv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Convert the ./check script to use the automatically generated group list
> membership files, as the transition is now complete.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/check b/check
> index ba192042..3dab7630 100755
> --- a/check
> +++ b/check
> @@ -124,9 +124,9 @@ get_sub_group_list()
>  	local d=$1
>  	local grp=$2
>  
> -	test -s "$SRC_DIR/$d/group" || return 1
> +	test -s "$SRC_DIR/$d/group.list" || return 1
>  
> -	local grpl=$(sed -n < $SRC_DIR/$d/group \
> +	local grpl=$(sed -n < $SRC_DIR/$d/group.list \
>  		-e 's/#.*//' \
>  		-e 's/$/ /' \
>  		-e "s;^\($VALID_TEST_NAME\).* $grp .*;$SRC_DIR/$d/\1;p")
> @@ -384,7 +384,7 @@ if $have_test_arg; then
>  				test_dir=`dirname $t`
>  				test_dir=${test_dir#$SRC_DIR/*}
>  				test_name=`basename $t`
> -				group_file=$SRC_DIR/$test_dir/group
> +				group_file=$SRC_DIR/$test_dir/group.list
>  
>  				if egrep -q "^$test_name" $group_file; then
>  					# in group file ... OK


-- 
chandan
