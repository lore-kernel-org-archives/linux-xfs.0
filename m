Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E03C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EEE619B7
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhCWQN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233049AbhCWQNq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 12:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E10396157F;
        Tue, 23 Mar 2021 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616516026;
        bh=iiHwzHokTAsiR1T7OK3N9IRi4hpWdAxWWKILrdGWoXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+vx5KOAdRhPTbu1zQkNFdDnZT31ix3LA6H2d5sQTK1ZPnmB8dR4O1nPJEkkKOXOZ
         8oZf+WO/9RD++Nq96OWNPoS2Pz8pYG6gIp4W0CknWoNwcoME9lExjYf60/y89d0bhC
         Y4fa2UMsgx/2hm7EUGc0n7c3n69nup22ON+E1IiK/jm2YnEkcwi1QtUPlcSPUNbjpm
         d54bgaUy5CY+xItDtSSP9za7qR4s51D0d47LGf5NdcpHo8wa6fcE02X8ob4voip62P
         Snyy/x0h7LTf0tSuTrlzy2mbrDVMdSZyBL/mxQXyiOscsC8A9PC9hSbZHdvdhKIAom
         gUFlC1ZiqAF/g==
Date:   Tue, 23 Mar 2021 09:13:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zhen Zhao <zp_8483@163.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Message-ID: <20210323161345.GL22100@magnolia>
References: <20210323062456.67938-1-zp_8483@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323062456.67938-1-zp_8483@163.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 02:24:56AM -0400, Zhen Zhao wrote:
> In kernel 3.10, when there is no memory left in the
> system, fs_buf_associate_memory can fail, catch the
> error and return.

You're probably going to need to take this up with your kernel
distributor or the linux stable fixes list, since (AFAICT) none of this
exists in the upstream kernel.

--D

> Signed-off-by: Zhen Zhao <zp_8483@163.com>
> ---
>  fs/xfs/xfs_log.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2e5581bc..32a41bf5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1916,8 +1916,11 @@ xlog_sync(
>  	if (split) {
>  		bp = iclog->ic_log->l_xbuf;
>  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> -		xfs_buf_associate_memory(bp,
> +		error = xfs_buf_associate_memory(bp,
>  				(char *)&iclog->ic_header + count, split);
> +		if (error)
> +			return error;
> +
>  		bp->b_fspriv = iclog;
>  		bp->b_flags &= ~XBF_FLUSH;
>  		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
> -- 
> 2.27.0
> 
> 
