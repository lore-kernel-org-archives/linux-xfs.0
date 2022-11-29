Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BB8C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 02:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiK2Chc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 21:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiK2ChX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 21:37:23 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07094876C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 18:37:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VVyJFeA_1669689438;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VVyJFeA_1669689438)
          by smtp.aliyun-inc.com;
          Tue, 29 Nov 2022 10:37:20 +0800
Date:   Tue, 29 Nov 2022 10:37:18 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use memcpy, not strncpy, to format the attr
 prefix during listxattr
Message-ID: <Y4VwXufkzBMPUuyA@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930916972.2061853.5449429916617568478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <166930916972.2061853.5449429916617568478.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:29AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When -Wstringop-truncation is enabled, the compiler complains about
> truncation of the null byte at the end of the xattr name prefix.  This
> is intentional, since we're concatenating the two strings together and
> do _not_ want a null byte in the middle of the name.
> 
> We've already ensured that the name buffer is long enough to handle
> prefix and name, and the prefix_len is supposed to be the length of the
> prefix string without the null byte, so use memcpy here instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

> ---
>  fs/xfs/xfs_xattr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index c325a28b89a8..10aa1fd39d2b 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -210,7 +210,7 @@ __xfs_xattr_put_listent(
>  		return;
>  	}
>  	offset = context->buffer + context->count;
> -	strncpy(offset, prefix, prefix_len);
> +	memcpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
>  	strncpy(offset, (char *)name, namelen);			/* real name */
>  	offset += namelen;
