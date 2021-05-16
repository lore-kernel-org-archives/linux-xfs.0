Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C390DC433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA87661185
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhEPP4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 May 2021 11:56:03 -0400
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:48624 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhEPPzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 May 2021 11:55:47 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09229667|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00608744-0.000464144-0.993448;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KEFBNP2_1621180470;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEFBNP2_1621180470)
          by smtp.aliyun-inc.com(10.147.41.231);
          Sun, 16 May 2021 23:54:31 +0800
Date:   Sun, 16 May 2021 23:54:30 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs/178: fix mkfs success test
Message-ID: <YKFANr4Yki6+cBmk@desktop>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
 <162078494495.3302755.13327851823592717788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162078494495.3302755.13327851823592717788.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 07:02:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the obviously incorrect code here that wants to fail the test if
> mkfs doesn't succeed.  The return value ("$?") is always the status of
> the /last/ command in the pipe.  Change the checker to _notrun so that
> we don't leave the scratch check files around.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/178 |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/178 b/tests/xfs/178
> index a24ef50c..bf72e640 100755
> --- a/tests/xfs/178
> +++ b/tests/xfs/178
> @@ -57,8 +57,8 @@ _supported_fs xfs
>  #             fix filesystem, new mkfs.xfs will be fine.
>  
>  _require_scratch
> -_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs \
> -        || _fail "mkfs failed!"
> +_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> +test "${PIPESTATUS[0]}" -eq 0 || _notrun "mkfs failed!"

I still don't understand why changing this to _notrun, shouldn't creating a
default filesystem should always pass? and fail the test if mkfs failed?

Thanks,
Eryu

>  
>  # By executing the followint tmp file, will get on the mkfs options stored in
>  # variables
> 
