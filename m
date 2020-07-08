Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1FAC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9767920720
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDxKuOeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgGHMlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:41:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30599 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728918AbgGHMln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+T07YLO7QFC9C8XMYQfvDXUy08mhD1RRkN9N3Zsa0o=;
        b=bDxKuOeA0Qw8mVXDYeDQXyH7P6nVp45b5ArCMZdrnUf1GEH0m9Fqe39XASyB/C3VtHIoXT
        O2yOKGPKA6GFLOPA8brVjYHIxijXKB1vuTQx5TeP7NuI3aUfIH1ensvySzfBoUTshIJ58Q
        9lsqRxJR2jDz6qXU4j1a3vqWLApKjlw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-QS63ZiPfP9-aLfhNx_f78A-1; Wed, 08 Jul 2020 08:41:40 -0400
X-MC-Unique: QS63ZiPfP9-aLfhNx_f78A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42D2C101084C;
        Wed,  8 Jul 2020 12:41:39 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB2885C1B2;
        Wed,  8 Jul 2020 12:41:38 +0000 (UTC)
Date:   Wed, 8 Jul 2020 08:41:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v10 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
Message-ID: <20200708124137.GA53550@bfoster>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
 <20200625233018.14585-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625233018.14585-14-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 04:30:06PM -0700, Allison Collins wrote:
> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
> needed. If they are the last operations executed in these functions, and
> no further changes are made, then higher level routines will roll or
> commit the tranactions.

	     transactions

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

This one LGTM now:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 61 ++++++------------------------------------------
>  1 file changed, 7 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4eff875..1a78023 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -693,34 +693,15 @@ xfs_attr_leaf_addname(
>  		/*
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				return error;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * Commit the remove and start the next trans in series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -
>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -780,15 +761,11 @@ xfs_attr_leaf_removename(
>  	/*
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
> -	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -	}
> +
>  	return 0;
>  }
>  
> @@ -1070,18 +1047,8 @@ xfs_attr_node_addname(
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  		}
>  
> -		/*
> -		 * Commit and start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> -
>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -1089,14 +1056,6 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> -
> -		 /*
> -		  * Commit the flag value change and start the next trans in
> -		  * series.
> -		  */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
>  	}
>  	retval = error = 0;
>  
> @@ -1135,16 +1094,10 @@ xfs_attr_node_shrink(
>  	if (forkoff) {
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
> -		if (error)
> -			return error;
> -
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  	} else
>  		xfs_trans_brelse(args->trans, bp);
>  
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 

