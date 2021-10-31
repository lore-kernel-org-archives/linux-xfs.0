Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10A2C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 15:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C50B960F02
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 15:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJaPRl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Oct 2021 11:17:41 -0400
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:49716 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhJaPRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Oct 2021 11:17:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1125223|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00536418-0.000593094-0.994043;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Ll2aNHF_1635693304;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ll2aNHF_1635693304)
          by smtp.aliyun-inc.com(10.147.42.16);
          Sun, 31 Oct 2021 23:15:04 +0800
Date:   Sun, 31 Oct 2021 23:15:04 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     djwong@kernel.org, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/126: Add a getxattr opeartion
Message-ID: <YX6y+Bt6+euS8CP6@desktop>
References: <1635497424-8095-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635497424-8095-1-git-send-email-xuyang2018.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 29, 2021 at 04:50:24PM +0800, Yang Xu wrote:
> It is design to reproduce a deadlock on upstream kernel. It is introduced
> by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>

As this will trigger deadlock, I'd just wait for the fix to land first,
the we also could reference the commit that fixed the issue in commit
log.

Thanks,
Eryu

> ---
>  tests/xfs/126 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/126 b/tests/xfs/126
> index c3a74b1c..9a77a60e 100755
> --- a/tests/xfs/126
> +++ b/tests/xfs/126
> @@ -69,7 +69,7 @@ done
>  
>  echo "+ mount image && modify xattr"
>  if _try_scratch_mount >> $seqres.full 2>&1; then
> -
> +	getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" 2> /dev/null || _fail "modified corrupt xattr"
>  	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
>  	umount "${SCRATCH_MNT}"
>  fi
> -- 
> 2.23.0
