Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAD8C4320A
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 11:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7316103C
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 11:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhHVLTd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 07:19:33 -0400
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:38173 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbhHVLTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Aug 2021 07:19:33 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1204478|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0310233-0.00253036-0.966446;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.L6.2AJ3_1629631129;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.L6.2AJ3_1629631129)
          by smtp.aliyun-inc.com(10.147.42.22);
          Sun, 22 Aug 2021 19:18:50 +0800
Date:   Sun, 22 Aug 2021 19:18:49 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic: test shutdowns of a nested filesystem
Message-ID: <YSIymUFbWA9xNcIK@desktop>
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924440518.779465.6907507760500586987.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924440518.779465.6907507760500586987.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:53:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/475, but we're running fsstress on a disk image inside the
> scratch filesystem
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc             |   20 +++++++
>  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/725.out |    2 +
>  3 files changed, 158 insertions(+)
>  create mode 100755 tests/generic/725
>  create mode 100644 tests/generic/725.out
> 
> 
> diff --git a/common/rc b/common/rc
> index 84757fc1..473bfb0a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -631,6 +631,26 @@ _ext4_metadump()
>  		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
>  }
>  
> +# Capture the metadata of a filesystem in a dump file for offline analysis
> +_metadump_dev() {
> +	local device="$1"
> +	local dumpfile="$2"
> +	local compressopt="$3"
> +
> +	case "$FSTYP" in
> +	ext*)
> +		_ext4_metadump $device $dumpfile $compressopt
> +		;;
> +	xfs)
> +		_xfs_metadump $dumpfile $device none $compressopt
> +		;;
> +	*)
> +		echo "Don't know how to metadump $FSTYP"

This breaks tests on filesystems other than ext* and xfs. I think it's
OK if we only want to use it in failure path, but it's better to
describe the use case in comments.

And Im' wondering if should honor DUMP_CORRUPT_FS, and only do the dump
when it's set.

Thanks,
Eryu
