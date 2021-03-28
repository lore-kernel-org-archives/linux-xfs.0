Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4C9C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 16:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9123961920
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 16:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC1QSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 12:18:32 -0400
Received: from out20-14.mail.aliyun.com ([115.124.20.14]:45314 "EHLO
        out20-14.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhC1QSa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 12:18:30 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1381721|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00701211-0.000471667-0.992516;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.JraA3sc_1616948305;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JraA3sc_1616948305)
          by smtp.aliyun-inc.com(10.147.40.44);
          Mon, 29 Mar 2021 00:18:26 +0800
Date:   Mon, 29 Mar 2021 00:18:25 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [RFC PATCH v3 1/3] common/xfs: add a _require_xfs_shrink helper
Message-ID: <YGCsUXMF+uupaHNV@desktop>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
 <20210315111926.837170-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315111926.837170-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 07:19:24PM +0800, Gao Xiang wrote:
> In order to detect whether the current kernel supports XFS shrinking.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  common/xfs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2156749d..ea3b6cab 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -432,6 +432,17 @@ _supports_xfs_scrub()
>  	return 0
>  }
>  
> +_require_xfs_shrink()
> +{
> +	_require_scratch

_require_command "$XFS_GROWFS_PROG" xfs_growfs

> +
> +	_scratch_mkfs_xfs > /dev/null
> +	_scratch_mount
> +	$XFS_GROWFS_PROG -D1 "$SCRATCH_MNT" 2>&1 | grep -q 'Invalid argument' || \
> +		_notrun "kernel does not support shrinking"

Better to describe the behavior here to explain why EINVAL means kernel
supports shrink.

Thanks,
Eryu

> +	_scratch_unmount
> +}
> +
>  # run xfs_check and friends on a FS.
>  _check_xfs_filesystem()
>  {
> -- 
> 2.27.0
