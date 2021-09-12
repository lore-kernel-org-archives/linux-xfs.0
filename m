Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CFAC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Sep 2021 08:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5A361209
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Sep 2021 08:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhILIOu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Sep 2021 04:14:50 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:36062 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhILIOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Sep 2021 04:14:49 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1204702|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0188155-0.000311573-0.980873;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=guan@eryu.me;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.LJ4N2A8_1631434413;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LJ4N2A8_1631434413)
          by smtp.aliyun-inc.com(10.147.41.120);
          Sun, 12 Sep 2021 16:13:34 +0800
Date:   Sun, 12 Sep 2021 16:13:33 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfstests: Move *_dump_log routines to common/xfs
Message-ID: <YT22rajMLkNyhKyr@desktop>
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
 <20210909174142.357719-4-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909174142.357719-4-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 09, 2021 at 05:41:42PM +0000, Catherine Hoang wrote:
> Move _scratch_remount_dump_log and _test_remount_dump_log from
> common/inject to common/xfs. These routines do not inject errors and
> should be placed with other xfs common functions.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/inject | 26 --------------------------
>  common/xfs    | 26 ++++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/common/inject b/common/inject
> index b5334d4a..6b590804 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -111,29 +111,3 @@ _scratch_inject_error()
>  		_fail "Cannot inject error ${type} value ${value}."
>  	fi
>  }
> -
> -# Unmount and remount the scratch device, dumping the log
> -_scratch_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_scratch_unmount
> -	_scratch_dump_log

This function is a common function that could handle multiple
filesystems, currently it supports xfs, ext4 and f2fs. So it's not a
xfs-specific function, and moving it to common/xfs doesn't seem correct.
Perhaps we should move it to common/log.

> -	_scratch_mount "$opts"
> -}
> -
> -# Unmount and remount the test device, dumping the log
> -_test_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_test_unmount
> -	_test_dump_log

Same here.

Thanks,
Eryu

> -	_test_mount "$opts"
> -}
> diff --git a/common/xfs b/common/xfs
> index bfb1bf1e..cda1f768 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1263,3 +1263,29 @@ _require_scratch_xfs_bigtime()
>  		_notrun "bigtime feature not advertised on mount?"
>  	_scratch_unmount
>  }
> +
> +# Unmount and remount the scratch device, dumping the log
> +_scratch_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_scratch_unmount
> +	_scratch_dump_log
> +	_scratch_mount "$opts"
> +}
> +
> +# Unmount and remount the test device, dumping the log
> +_test_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_test_unmount
> +	_test_dump_log
> +	_test_mount "$opts"
> +}
> -- 
> 2.25.1
