Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5785AC19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 20:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245288AbiHIUoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 16:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245700AbiHIUoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 16:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA42183F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 13:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18A8360DFA
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791AAC433D6;
        Tue,  9 Aug 2022 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660077853;
        bh=363zRKWhV4lC13wDoPBPKSBOOU0pGBmXgs3+L3snMQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ClmBDXlJPagSV4uTLRFfi/tq0KbFlQ7jrwNuGvWc1+4CMdoKzqCAyhP9OGnU0pBCx
         804boZCLm1ECACE10+bXHcYEDiQt4z1hmxvuE3sgxibEucSSGCMNudCWguesRp5PgJ
         bwTkXVPh6mCzTCI4Z/s7qM72M0PXFZO0t8z+oGHP+6i+Vaz7uIlv08htcLC19tVx6S
         3Z0LY5+aGOVhovXH13Q4xOxJuBRJuvaPkXKvqPrAwZ4gdvzkG1WlZ9ZkJI/H0Vsm5n
         /1rkrjenxYKmLWuNN+/TtxEG+oocFPpzET6Cxj5iQ2D1/duF/eur5yW10ZmpoxdvmI
         WCXkyelmsq6kA==
Date:   Tue, 9 Aug 2022 13:44:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] libxfs: fix inode reservation space for removing
 transaction
Message-ID: <YvLHHESN9UDqCJ/a@magnolia>
References: <20220802031806.236-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802031806.236-1-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 11:18:06AM +0800, Xiaole He wrote:
> From: hexiaole <hexiaole@kylinos.cn>
> 
> In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
> directory entry writes:
> 
> /* libxfs/xfs_trans_resv.c begin */
> /*
>  * For removing a directory entry we can modify:
>  *    the parent directory inode: inode size
>  *    the removed inode: inode size
> ...
> /* libxfs/xfs_trans_resv.c end */
> 
> There has 2 inode size of space to be reserverd, but the actual code
> for inode reservation space writes:
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
> There only count for 1 inode size to be reserved in
> 'xfs_calc_inode_res(mp, 1)', rather than 2.

The logic looks correct.  Why is this patch against xfsprogs, though?

--D

> Signed-off-by: hexiaole <hexiaole@kylinos.cn>
> ---
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
