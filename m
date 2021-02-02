Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9ECC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C6B64F64
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhBBPoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235646AbhBBPkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 10:40:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612280360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MMXYTdY8iIuKkMG0Vj6wxoJk0ZXFlBA+vZDUH9RfddM=;
        b=RtC8uAgu56HhucfRoLauC0/jGBaAdOaTcitTxopSElBPFS3V2i7SXqi5hJnXhMh7yk/PpV
        xOvrns5wwHXNDM2CVvhqT4YUij+PBIIIJBKvlp3iORQMgPdQ2G2NLAEaqxKYZvhtv9w7xY
        C4GVdSszxao8mLprK1i+y/3UHCcLr+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-Nb3RrnOrOMS4TdEw-SR8YQ-1; Tue, 02 Feb 2021 10:39:19 -0500
X-MC-Unique: Nb3RrnOrOMS4TdEw-SR8YQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 049B71936B66;
        Tue,  2 Feb 2021 15:39:18 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 756925C1CF;
        Tue,  2 Feb 2021 15:39:17 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:39:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 09/12] xfs: flush eof/cowblocks if we can't reserve quota
 for chown
Message-ID: <20210202153915.GI3336100@bfoster>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517714.140945.1957722027452288290.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214517714.140945.1957722027452288290.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a file user, group, or project change is unable to reserve enough
> quota to handle the modification, try clearing whatever space the
> filesystem might have been hanging onto in the hopes of speeding up the
> filesystem.  The flushing behavior will become particularly important
> when we add deferred inode inactivation because that will increase the
> amount of space that isn't actively tied to user data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ee3cb916c5c9..3203841ab19b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1149,8 +1149,10 @@ xfs_trans_alloc_ichange(
>  	struct xfs_dquot	*new_udqp;
>  	struct xfs_dquot	*new_gdqp;
>  	struct xfs_dquot	*new_pdqp;
> +	bool			retried = false;
>  	int			error;
>  
> +retry:
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
> @@ -1175,6 +1177,13 @@ xfs_trans_alloc_ichange(
>  	if (new_udqp || new_gdqp || new_pdqp) {
>  		error = xfs_trans_reserve_quota_chown(tp, ip, new_udqp,
>  				new_gdqp, new_pdqp, force);
> +		if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> +			xfs_trans_cancel(tp);
> +			xfs_blockgc_free_dquots(new_udqp, new_gdqp, new_pdqp,
> +					0);
> +			retried = true;
> +			goto retry;
> +		}
>  		if (error)
>  			goto out_cancel;
>  	}
> 

