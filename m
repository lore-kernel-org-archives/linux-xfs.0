Return-Path: <SRS0=CJP2=CW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB37C2D0A7
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Sep 2020 15:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D79242078D
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Sep 2020 15:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgIMPe7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Sep 2020 11:34:59 -0400
Received: from out20-38.mail.aliyun.com ([115.124.20.38]:42520 "EHLO
        out20-38.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgIMPe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Sep 2020 11:34:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=0.09806292|-1;BR=01201311R371ee;CH=green;DM=|CONTINUE|false|;DS=SPAM|spam_ad|0.930493-0.00369937-0.0658081;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03306;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.IWZdkuY_1600011291;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IWZdkuY_1600011291)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 13 Sep 2020 23:34:51 +0800
Date:   Sun, 13 Sep 2020 23:34:51 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     fstests@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com, ira.weiny@intel.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/rc: Check 'tPnE' flags on a directory instead
 of a regilar file
Message-ID: <20200913153451.GI3853@desktop>
References: <20200908131523.20899-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908131523.20899-1-yangx.jy@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 09:15:22PM +0800, Xiao Yang wrote:
> 'tPnE' flags are only valid for a directory so check them on a directory.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  common/rc | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index aa5a7409..cf31eebc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2168,8 +2168,14 @@ _require_xfs_io_command()
>  		fi
>  		# Test xfs_io chattr support AND
>  		# filesystem FS_IOC_FSSETXATTR support
> -		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
> -		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
> +		# 'tPnE' flags are only valid for a directory so check them on a directory.
> +		if echo "$param" | egrep -q 't|P|n|E'; then
> +			testio=`$XFS_IO_PROG -F -c "chattr +$param" $TEST_DIR 2>&1`
> +			$XFS_IO_PROG -F -r -c "chattr -$param" $TEST_DIR 2>&1

I don't think it's a good idea to try chattr on $TEST_DIR, it may change
the behavior of all sub-dirs and files in it and cause unexpected
failures. (I know we do "chattr -$param" right away, but it still looks
dangerous to me.) It's better to create a new $testdir like $testfile to
try on, and remove it after test.

Thanks,
Eryu

> +		else
> +			testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
> +			$XFS_IO_PROG -F -r -c "chattr -$param" $testfile 2>&1
> +		fi
>  		param_checked="+$param"
>  		;;
>  	"chproj")
> -- 
> 2.21.0
> 
> 
