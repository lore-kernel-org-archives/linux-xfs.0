Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A1AC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 12:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA7E24181
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 12:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJrlSpLT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750885AbgJ0MQE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 08:16:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750756AbgJ0MQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 08:16:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603800960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GYsdmr3JWS8fRJk/WfZTPZd+TGZ+dGKTMJPdjRxapnY=;
        b=KJrlSpLTXzgqRe4JoabYDBukMtFV6a+RxDaoueKXXWv11JFsh5ScNxreyku0YrkaJ/e1Cf
        FtVwsIv0HUe0iyIq/1InUL+HafM3CTeVM+cOndlp1QOVG018D+ZqmhZdCVCqG0EUbeQjAW
        7yyqIoGHnTLEejXXfeTfsJQ7Hsl0ACk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-xaDhiv9rOvaHFr9i-ardCw-1; Tue, 27 Oct 2020 08:15:56 -0400
X-MC-Unique: xaDhiv9rOvaHFr9i-ardCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7AD7188C128;
        Tue, 27 Oct 2020 12:15:55 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82CE25B4A5;
        Tue, 27 Oct 2020 12:15:55 +0000 (UTC)
Date:   Tue, 27 Oct 2020 08:15:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 01/10] xfs: Add helper xfs_attr_node_remove_step
Message-ID: <20201027121553.GA1560077@bfoster>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063435.7510-2-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:34:26PM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> This patch adds a new helper function xfs_attr_node_remove_step.  This
> will help simplify and modularize the calling function
> xfs_attr_node_remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e641..f4d39bf 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>  	if (retval && (state->path.active > 1)) {
>  		error = xfs_da3_join(state);
>  		if (error)
> -			goto out;
> +			return error;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out;
> +			return error;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
>  		error = xfs_trans_roll_inode(&args->trans, dp);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
> +	return error;
> +}
> +
> +/*
> + * Remove a name from a B-tree attribute list.
> + *
> + * This routine will find the blocks of the name to remove, remove them and
> + * shirnk the tree if needed.
> + */
> +STATIC int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state;

It urks me a little bit that we have to dig down into a couple functions
to grok that state allocation is the first step or otherwise occurs
before we potentially use the error path. Since we already check for
state in the out path, can we just initialize this as *state = NULL
here so the logic is clear? Otherwise the patch LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	int			error;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_attr_node_remove_step(args, state);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -- 
> 2.7.4
> 

