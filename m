Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73912C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 15:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiHPPYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 11:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiHPPYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 11:24:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B46B8D9
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 08:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0139D610A5
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EEBC433D7;
        Tue, 16 Aug 2022 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660663422;
        bh=DW3UrteIq29GLPDPydMzTJ1+Pb5KkDr7GwVdcVwVcp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ketd5Y9OGSy0tDKYVmHRcyRuA/Uhx/LqqsBLu3NNEpBJJApPeeSeyLAhzDJkwdb0F
         iILdmyVaJq+7D9K/zhbGok6ka6XHpN90R6CeT1SwJSs3KRVzdZ12/80Whb3C75hgF/
         G8daa0osunuwlAxiTiQeWyf/R3UqpKELC392odfSldkfaobkXShP0erwPcjXdprUuO
         8sW+aN1HK4Q4iIk/m/H9Fxt465Cyjqj9P/e0akLnD8yWGTvDqJDd9DllebuGRDe6Sw
         tagz8SxEiApBSLPRS4mvZraTTTp+4DqyBxI9+q6Sew89V0O3ZzEM2gfk7M9wRF87wF
         gQQSOgo6WAOlg==
Date:   Tue, 16 Aug 2022 08:23:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: [PATCH v2] libxfs: fix inode reservation space for removing
 transaction
Message-ID: <Yvu2fcKnPkhlxq5v@magnolia>
References: <20220815025458.137-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815025458.137-1-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 15, 2022 at 10:54:58AM +0800, Xiaole He wrote:
> From: hexiaole <hexiaole@kylinos.cn>
> 
> In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
> directory entry mentions that there has 2 inode size of space to be
> reserverd, but the actual code only count for 1 inode size:

Already merged, see 6.0-rc1.

--D

> 
> /* libxfs/xfs_trans_resv.c begin */
> /*
>  * For removing a directory entry we can modify:
>  *    the parent directory inode: inode size
>  *    the removed inode: inode size
> ...
> xfs_calc_remove_reservation(
>         struct xfs_mount        *mp)
> {
>         return XFS_DQUOT_LOGRES(mp) +
>                 xfs_calc_iunlink_add_reservation(mp) +
>                 max((xfs_calc_inode_res(mp, 1) +
> ...
> /* libxfs/xfs_trans_resv.c end */
> 
> Here only count for 1 inode size to be reserved in
> 'xfs_calc_inode_res(mp, 1)', rather than 2.
> 
> Signed-off-by: hexiaole <hexiaole@kylinos.cn>
> ---
> V1 -> V2: djwong: remove redundant code citations
> 
>  libxfs/xfs_trans_resv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index d4a9f69e..797176d7 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -514,7 +514,7 @@ xfs_calc_remove_reservation(
>  {
>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_iunlink_add_reservation(mp) +
> -		max((xfs_calc_inode_res(mp, 1) +
> +		max((xfs_calc_inode_res(mp, 2) +
>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
>  		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> -- 
> 2.27.0
> 
