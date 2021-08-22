Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3239C4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 12:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F5D6128A
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhHVMUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 08:20:01 -0400
Received: from out20-74.mail.aliyun.com ([115.124.20.74]:48610 "EHLO
        out20-74.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhHVMUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Aug 2021 08:20:01 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08467039|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00598008-0.00460133-0.989419;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.L60tP5C_1629634758;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.L60tP5C_1629634758)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 22 Aug 2021 20:19:18 +0800
Date:   Sun, 22 Aug 2021 20:19:18 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi_debug: fix module removal loop
Message-ID: <YSJAxsay/y/1Bk5u@desktop>
References: <162924437987.779373.1973564511078951065.stgit@magnolia>
 <162924439095.779373.7171773658755331729.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924439095.779373.7171773658755331729.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:53:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Luis' recent patch changing the "sleep 1" to a "udevadm settle"
> invocation exposed some race conditions in _put_scsi_debug_dev that
> caused regressions in generic/108 on my machine.  Looking at tracing
> data, it looks like the udisks daemon will try to open the device at
> some point after the filesystem unmounts; if this coincides with the
> final 'rmmod scsi_debug', the test fails.
> 
> Examining the function, it is odd to me that the loop condition is
> predicated only on whether or not modprobe /thinks/ it can remove the
> module.  Why not actually try (twice) actually to remove the module,
> and then complain if a third attempt fails?
> 
> Also switch the final removal attempt to modprobe -r, since it returns
> zero if the module isn't loaded.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/scsi_debug |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index e7988469..abaf6798 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -49,9 +49,9 @@ _put_scsi_debug_dev()
>  	# use redirection not -q option of modprobe here, because -q of old
>  	# modprobe is only quiet when the module is not found, not when the
>  	# module is in use.
> -	while [ $n -ge 0 ] && ! modprobe -nr scsi_debug >/dev/null 2>&1; do
> +	while [ $n -ge 0 ] && ! modprobe -r scsi_debug >/dev/null 2>&1; do
>  		$UDEV_SETTLE_PROG
>  		n=$((n-1))

Luis' new patch removed this while loop completely, and

>  	done
> -	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
> +	modprobe -r scsi_debug || _fail "Could not remove scsi_debug module"

Replaced this rmmod with _patient_rmmod helper, which uses modprobe -r
to remove mod internally.

So I'd drop this patch. Thanks for the fix anyway!

Eryu
