Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBF9C4360D
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 14:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52AD217F5
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 14:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KElkgtWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393554AbfIUOez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Sep 2019 10:34:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38860 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393543AbfIUOez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Sep 2019 10:34:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so5468796pgi.5;
        Sat, 21 Sep 2019 07:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gPlCifjIXnbGkx0llELOpANjDaaR2HIKwHNBSDE8XJg=;
        b=KElkgtWavpVGj8mhprb3IoAZq0cs9MXIqAsCoI0VJihu1/JUHtgkkqurvwHBV2/j4f
         FOJ8HDWP7FE3sWNDDFVqGYPIPXUIRxObfuk3CUN9EuJ687uv45+88qGhMkJEb0mK4QYU
         acVJV6iOHp01Sbma5FwzcRMNnV9Vbaw5trlpThomgSg7WDc90DSSLivQ6jaac4sqBPGv
         l2vtbJeHwWEKeyEF5Hs1Oui+b9Yf3RVXNI3iCof43FS8clinHr3dHIijYYSw9vVtfdsW
         ev2LVmseD1kHwtLI5dmwvk80yvBLYXvkqkzFHveg0X3bD3lf2F2yStyBX9OdmXHq66PY
         nsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gPlCifjIXnbGkx0llELOpANjDaaR2HIKwHNBSDE8XJg=;
        b=iUPe7+gmKsftsb6jlxBja+iVic5FLu/0jREbb4vl1ak6DQoOYsQwz1PmBb93m3b2Cd
         Hg8KO3RYXs+JRYJg6XwJSWaTRrjP3347E4NJcC79sEZTo77a5ulplul40rF0Gv/nd4FN
         OFtn686vVkP1bYULCxYKhXxlhpXWuPxxXYR24QaoM5FhjTgWifNEkEXp80/RyFDBCLeL
         b52zWHtQjK1SwbELL97lbTSGmrIRKgyAnPpUzuPPUvA3sCVPVSn8hvuSsAynfM8rl7nZ
         dkJrRTr18hlMLUH2tJC++vZtF8Ay3YJzXYKHx35an4Jt8MTAsTmuWsTEzTGG6SPm/dvT
         Svng==
X-Gm-Message-State: APjAAAUreofagCiQxxhXOJrbPd1cJrNGXTqvwX8RQdE5ytzUH9644Y6v
        8ukWyAb6uqiWhJz+b8bw1DM=
X-Google-Smtp-Source: APXvYqxLu+/UMhh03OSK2K5mlYq0wUkuFWEAnxZfH4hf62F3XOXD8LP+m/ZES67oLnxNGViq47tPnQ==
X-Received: by 2002:a17:90a:8e84:: with SMTP id f4mr10634224pjo.122.1569076493834;
        Sat, 21 Sep 2019 07:34:53 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id 71sm7011169pfw.147.2019.09.21.07.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 07:34:52 -0700 (PDT)
Date:   Sat, 21 Sep 2019 22:34:47 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3 1/2] common: check if a given rename flag is supported
 in _requires_renameat2
Message-ID: <20190921143443.GO2622@desktop>
References: <7d4b6a1d-98a1-1fcb-5ccf-991e537df77c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d4b6a1d-98a1-1fcb-5ccf-991e537df77c@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 07:47:47PM +0800, kaixuxia wrote:
> Some testcases may require a special rename flag, such as RENAME_WHITEOUT,
> so add support check for if a given rename flag is supported in
> _requires_renameat2.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>

Nice improvement, thanks for the patch!

> ---
>  common/renameat2  | 30 +++++++++++++++++++++++++++++-
>  tests/generic/024 | 13 +++----------
>  tests/generic/025 | 13 +++----------
>  tests/generic/078 | 13 +++----------
>  4 files changed, 38 insertions(+), 31 deletions(-)
> 
> diff --git a/common/renameat2 b/common/renameat2
> index f8d6d4f..9625d8c 100644
> --- a/common/renameat2
> +++ b/common/renameat2
> @@ -103,10 +103,38 @@ _rename_tests()
>  #
>  _requires_renameat2()

I renamed the function to _require_renameat2 while we're at it, since
no other _require rules are named as "_requires".

>  {
> +	local flags=$1
> +	local rename_dir=$TEST_DIR/$$
> +	local cmd=""
> +
>  	if test ! -x src/renameat2; then
>  		_notrun "renameat2 binary not found"
>  	fi
> -	if ! src/renameat2 -t; then
> +
> +	mkdir $rename_dir
> +	touch $rename_dir/foo
> +	case $flags in
> +	"noreplace")
> +		cmd="-n $rename_dir/foo $rename_dir/bar"
> +		;;
> +	"exchange")
> +		touch $rename_dir/bar
> +		cmd="-x $rename_dir/foo $rename_dir/bar"
> +		;;
> +	"whiteout")
> +		touch $rename_dir/bar
> +		cmd="-w $rename_dir/foo $rename_dir/bar"
> +		;;
> +	"")

I added 'cmd=""' here as Brian suggested.

> +		;;
> +	*)
> +		rm -rf $rename_dir
> +		_notrun "only support noreplace,exchange,whiteout rename flags, please check."

I changed this to a _fail, as that indicates a test bug in helper usage.

> +		;;
> +	esac
> +	if ! src/renameat2 -t $cmd; then
> +		rm -rf $rename_dir
>  		_notrun "kernel doesn't support renameat2 syscall"
>  	fi
> +	rm -rf $rename_dir
>  }
> diff --git a/tests/generic/024 b/tests/generic/024
> index 2888c66..9c1161a 100755
> --- a/tests/generic/024
> +++ b/tests/generic/024

I also changed generic/398 and generic/419 to check for 'exchange' as
they use RENAME_EXCHANGE.

Thanks,
Eryu

> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 noreplace
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo
> -if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_NOREPLACE"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -n
>  rmdir $rename_dir
>  
> diff --git a/tests/generic/025 b/tests/generic/025
> index 0310efa..1ee9ad6 100755
> --- a/tests/generic/025
> +++ b/tests/generic/025
> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 exchange
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo $rename_dir/bar
> -if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_EXCHANGE"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -x
>  rmdir $rename_dir
>  
> diff --git a/tests/generic/078 b/tests/generic/078
> index 9608574..37f3201 100755
> --- a/tests/generic/078
> +++ b/tests/generic/078
> @@ -29,20 +29,13 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_test
> -_requires_renameat2
> +_requires_renameat2 whiteout
>  _require_test_symlinks
>  
> -rename_dir=$TEST_DIR/$$
> -mkdir $rename_dir
> -touch $rename_dir/foo $rename_dir/bar
> -if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
> -    _notrun "fs doesn't support RENAME_WHITEOUT"
> -fi
> -rm -f $rename_dir/foo $rename_dir/bar
> -
>  # real QA test starts here
>  
> +rename_dir=$TEST_DIR/$$
> +mkdir $rename_dir
>  _rename_tests $rename_dir -w
>  rmdir $rename_dir
>  
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
