Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C180C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EB122268
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KDzPvHR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbgJILdE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 07:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729986AbgJILdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 07:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602243183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oYCfnMy0gY4jD5XfIWHb0yho0pRsBbDCi2R4cRI+uDY=;
        b=KDzPvHR6zUN6czP5/O5qVsaI3XQpRgGIRWuiAKxJPe1DFn1xpBxdezOW9Ytaq9X5xSn+jN
        bJxCnrsVNLpOWEldPe05bC96nBj9Xnx5oriXjc8SxLo2rLqE6tGpB2ZDD/S/VDdMVmK4Xh
        whEIst+lBS/zYCea4ufro/OzjWhOm18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-RLZUD1k2NRuHomZXsW1a6w-1; Fri, 09 Oct 2020 07:33:01 -0400
X-MC-Unique: RLZUD1k2NRuHomZXsW1a6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C87618A822E;
        Fri,  9 Oct 2020 11:33:00 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F0AB6EF57;
        Fri,  9 Oct 2020 11:32:59 +0000 (UTC)
Date:   Fri, 9 Oct 2020 07:32:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v4 3/3] xfs: directly return if the delta equal to zero
Message-ID: <20201009113257.GE769470@bfoster>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
 <1602130749-23093-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602130749-23093-4-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 12:19:09PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if it is
> NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}].
> Nowadays seems none of the callers want to join the dquots to the
> transaction and push them to device when the delta is zero. Actually,
> most of time the caller would check the delta and go on only when the
> delta value is not zero, so we should bail out when it is zero.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 0ebfd7930382..3e37501791bf 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -194,6 +194,9 @@ xfs_trans_mod_dquot(
>  	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
>  	qtrx = NULL;
>  
> +	if (!delta)
> +		return;
> +

Note that the calls in xfs_trans_dqresv() also check for delta != 0, so
that could be removed with this patch. That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (tp->t_dqinfo == NULL)
>  		xfs_trans_alloc_dqinfo(tp);
>  	/*
> @@ -205,10 +208,8 @@ xfs_trans_mod_dquot(
>  	if (qtrx->qt_dquot == NULL)
>  		qtrx->qt_dquot = dqp;
>  
> -	if (delta) {
> -		trace_xfs_trans_mod_dquot_before(qtrx);
> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> -	}
> +	trace_xfs_trans_mod_dquot_before(qtrx);
> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>  
>  	switch (field) {
>  	/* regular disk blk reservation */
> @@ -261,8 +262,7 @@ xfs_trans_mod_dquot(
>  		ASSERT(0);
>  	}
>  
> -	if (delta)
> -		trace_xfs_trans_mod_dquot_after(qtrx);
> +	trace_xfs_trans_mod_dquot_after(qtrx);
>  }
>  
>  
> -- 
> 2.20.0
> 

