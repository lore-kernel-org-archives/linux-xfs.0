Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41AFC43461
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9313C61183
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhEPPcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 May 2021 11:32:24 -0400
Received: from out20-27.mail.aliyun.com ([115.124.20.27]:49776 "EHLO
        out20-27.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbhEPPcX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 May 2021 11:32:23 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08107959|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0300717-0.00211437-0.967814;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KEEUBY-_1621179065;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEEUBY-_1621179065)
          by smtp.aliyun-inc.com(10.147.42.197);
          Sun, 16 May 2021 23:31:06 +0800
Date:   Sun, 16 May 2021 23:31:05 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v6 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Message-ID: <YKE6uYPIzzWry3ZN@desktop>
References: <20210511233228.1018269-1-hsiangkao@redhat.com>
 <20210511233228.1018269-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511233228.1018269-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 07:32:26AM +0800, Gao Xiang wrote:
> In order to detect whether the current kernel supports XFS shrinking.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  common/xfs | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 69f76d6e..a0a4032a 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -766,6 +766,26 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +_require_xfs_scratch_shrink()

I renamed this to _require_scratch_xfs_shrink(), as most of other
helpers are in this format as _require_scratch_xfs_bigtime(), the only
exception is _require_xfs_scratch_rmapbt(), I think we should change
that too in another patch.

> +{
> +	_require_scratch
> +	_require_command "$XFS_GROWFS_PROG" xfs_growfs
> +
> +	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +	. $tmp.mkfs
> +	_scratch_mount
> +	# here just to check if kernel supports, no need do more extra work
> +	errmsg=$($XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" 2>&1)

Also make it as local.

Thanks,
Eryu

> +	if [ "$?" -ne 0 ]; then
> +		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' > /dev/null && \
> +			_notrun "kernel does not support shrinking"
> +		echo "$errmsg" | grep 'data size .* too small, old size is ' > /dev/null && \
> +			_notrun "xfsprogs does not support shrinking"
> +		_fail "$XFS_GROWFS_PROG failed unexpectedly: $errmsg"
> +	fi
> +	_scratch_unmount
> +}
> +
>  # XFS ability to change UUIDs on V5/CRC filesystems
>  #
>  _require_meta_uuid()
> -- 
> 2.27.0
