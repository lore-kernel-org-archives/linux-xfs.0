Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DE0C1B08C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB6D6128B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhGNVrx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235751AbhGNVrx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:47:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A43260C3D;
        Wed, 14 Jul 2021 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626299101;
        bh=/7sciX+KRzzyn5xnIMQH2nNNjrnMyPZ0GK2sTTOT7WE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGwQosyWWs7wQNgPjZKCgXmXYR9jK0zOl/DgbK+lGqRq44/E1ewD2NWp8NalLPLqP
         oKlrAl7wIOfKgJ8WAxI5Qdelo/iaAulgjQvXsi/aCJcXHtzQzRTao+2ueBGjfj3xyu
         7LM/b09flwhmQSXMUhev0kGiS3PNOHcXKVOhUFeXWUI4X95uVSOhUtkBmbRikSsA7U
         /qB31Dv6LZGxKlZ8uYQhp4P8JG3xQoC69cM0a8yjNtEen5ST37jyz4cw+Ektrd6+x5
         n69W/sfLZESKMS8iNfIowrBv0it8cwyHAgQXC6bya9JYoV4JE51SRg/OH3vtuzfd1u
         +aoIzASOvYcvA==
Date:   Wed, 14 Jul 2021 14:45:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove the flags argument to xfs_qm_dquot_walk
Message-ID: <20210714214501.GM22402@magnolia>
References: <20210712111426.83004-1-hch@lst.de>
 <20210712111426.83004-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111426.83004-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:14:25PM +0200, Christoph Hellwig wrote:
> We always purge all dquots now, so drop the argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 580b9dba21122b..2b34273d0405e7 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -187,15 +187,11 @@ xfs_qm_dqpurge(
>   */
>  static void
>  xfs_qm_dqpurge_all(
> -	struct xfs_mount	*mp,
> -	uint			flags)
> +	struct xfs_mount	*mp)
>  {
> -	if (flags & XFS_QMOPT_UQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
> -	if (flags & XFS_QMOPT_GQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
> -	if (flags & XFS_QMOPT_PQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
>  }
>  
>  /*
> @@ -206,7 +202,7 @@ xfs_qm_unmount(
>  	struct xfs_mount	*mp)
>  {
>  	if (mp->m_quotainfo) {
> -		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
> +		xfs_qm_dqpurge_all(mp);
>  		xfs_qm_destroy_quotainfo(mp);
>  	}
>  }
> @@ -1359,7 +1355,7 @@ xfs_qm_quotacheck(
>  	 * at this point (because we intentionally didn't in dqget_noattach).
>  	 */
>  	if (error) {
> -		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
> +		xfs_qm_dqpurge_all(mp);
>  		goto error_return;
>  	}
>  
> -- 
> 2.30.2
> 
