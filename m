Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45D2C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CD822261
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcwr7ZgY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbgJILcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 07:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729986AbgJILct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 07:32:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602243168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CErGe8cf4ilyJwignoEYLTogPHl7eWBx/WEMuBY7JFc=;
        b=fcwr7ZgY8KTq47dFAAL1GoDUyz243K3T2yLpwAeKN6TwxO5+HmbIos4LsuWH6ciaAkZNi5
        vNpsxQqVkzYMAm7kMMFgz6qy2P2hDo+ZNkfxaRs/rlNd4erU3uuUBdv8qYIhu3nUlCJ83F
        hL684u2O7pSJ+WQDHY478VgLhHkkFdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-JShxQVLUOb2D_yC4JFCYAQ-1; Fri, 09 Oct 2020 07:32:44 -0400
X-MC-Unique: JShxQVLUOb2D_yC4JFCYAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8254518A8234;
        Fri,  9 Oct 2020 11:32:43 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B32A21002C08;
        Fri,  9 Oct 2020 11:32:42 +0000 (UTC)
Date:   Fri, 9 Oct 2020 07:32:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v4 1/3] xfs: delete duplicated tp->t_dqinfo null check
 and allocation
Message-ID: <20201009113240.GC769470@bfoster>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
 <1602130749-23093-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602130749-23093-2-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 12:19:07PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()
> to account for quotas, and also there is the function call chain
> xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv -> xfs_trans_mod_dquot,
> both of them do the duplicated null check and allocation. Thus
> we can delete the duplicated operation from them.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---

Seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans_dquot.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index fe45b0c3970c..67f1e275b34d 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>  		return;
>  
> -	if (tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);
> -
>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
> @@ -698,7 +695,6 @@ xfs_trans_dqresv(
>  	 * because we don't have the luxury of a transaction envelope then.
>  	 */
>  	if (tp) {
> -		ASSERT(tp->t_dqinfo);
>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  		if (nblks != 0)
>  			xfs_trans_mod_dquot(tp, dqp,
> @@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
> -	if (tp && tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);
> -
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
>  	if (udqp) {
> -- 
> 2.20.0
> 

