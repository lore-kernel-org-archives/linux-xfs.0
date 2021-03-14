Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A6CC433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18D3964EC6
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCNSB0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 14:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhCNSA5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Mar 2021 14:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9449C64E76;
        Sun, 14 Mar 2021 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615744852;
        bh=O1xuOYaD26NbdcR7F6HaTvDksjRAXL+Ez3+GfhwQZ+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mvh2xVbqyPJuOca3BOjuG3isuMorTdzvH8X8cpfwyKl183BASa+J4fW0kpY1T/seM
         TKWTHcz4BMd5PfxlqnLubdOh6YDvOYDabXU4MtCYgm+oSOMONfcLVoiUpOCIZbmBJX
         Ip1TNRQ7ZbxF2wLojyNPEalfWmx4qKQahLwe4RXMKuyvSPKQsNoobIgopj+68O5cFZ
         l8f99TpeAyAmoGCMKhT7rU7lS4/KEFnhIlHpP47EzqXmty7ZkwRsRXxEoYbX7aVztN
         etHWXjoryaVAwJaTl4mU1XL++oHhcMGbGqekhK5INADH2ekUwbsbPtt17WvRmHapD6
         BKG/rXFJ54LnA==
Date:   Sun, 14 Mar 2021 11:00:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: also reject BULKSTAT_SINGLE in a mount user
 namespace
Message-ID: <20210314180052.GA22100@magnolia>
References: <20210312061941.1362951-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312061941.1362951-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 12, 2021 at 07:19:41AM +0100, Christoph Hellwig wrote:
> BULKSTAT_SINGLE exposed the ondisk uids/gids just like bulkstat, and can
> be called on any inode, including ones not visible in the current mount.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_itable.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ca310a125d1e14..3498b97fb06d31 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -168,6 +168,12 @@ xfs_bulkstat_one(
>  	};
>  	int			error;
>  
> +	if (breq->mnt_userns != &init_user_ns) {
> +		xfs_warn_ratelimited(breq->mp,
> +			"bulkstat not supported inside of idmapped mounts.");
> +		return -EINVAL;
> +	}
> +
>  	ASSERT(breq->icount == 1);
>  
>  	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
> -- 
> 2.30.1
> 
