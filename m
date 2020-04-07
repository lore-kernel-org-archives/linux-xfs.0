Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503B2C2BA2B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248CE207FF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3lTRIej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgDGORb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:17:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728596AbgDGORb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 10:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586269050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N9N6As8qBPNVIXXTedsy5lvMW5f13cE7FJ8yyHqB91o=;
        b=T3lTRIej8obYFuQMHVoBApADz7JvmyB8IpKvO/ZZlza0epwX/ACCa1RfrOkkkfkwZuvzl4
        31TZMlQ1KRlgYnu1PJRS6u8KohQay5cjpS0JwCe3TwFQfLn7rAC5VQMtUUUtY59gdYtrN5
        rDRhFsj0N4JG2t538l2el6h6mZ44IR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-BDbw0vVfNeOnk0U7j6RjsQ-1; Tue, 07 Apr 2020 10:17:26 -0400
X-MC-Unique: BDbw0vVfNeOnk0U7j6RjsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5923B8010CA;
        Tue,  7 Apr 2020 14:17:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F13918C08D;
        Tue,  7 Apr 2020 14:17:24 +0000 (UTC)
Date:   Tue, 7 Apr 2020 10:17:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 12/20] xfs: Removed unneeded xfs_trans_roll_inode calls
Message-ID: <20200407141723.GC28936@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-13-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:21PM -0700, Allison Collins wrote:
> Some calls to xfs_trans_roll_inode in the *_addname routines are not
> needed. If they are the last operations executed in these functions, and
> no further changes are made, then higher level routines will roll or
> commit the tranactions. The xfs_trans_roll in _removename is also not
> needed because invalidating blocks is not an incore change.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 27a9bb5..4225a94 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -700,11 +700,6 @@ xfs_attr_leaf_addname(
>  				return error;
>  		}
>  
> -		/*
> -		 * Commit the remove and start the next trans in series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -

Ok, so it looks like the only caller immediately rolls again.

>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -712,12 +707,6 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			return error;
> -
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}

Same logic applies here. Makes sense.

>  	return error;
>  }
> @@ -1069,13 +1058,6 @@ xfs_attr_node_addname(
>  				goto out;
>  		}
>  
> -		/*
> -		 * Commit and start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> -

From here, we log the inode and commit, so that seems safe.

BTW, doesn't that mean the defer_finish() just above (after the
da3_join()) is unnecessary as well?

>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -1083,14 +1065,6 @@ xfs_attr_node_addname(
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
> @@ -1189,10 +1163,6 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> -

Hmm, not sure I follow this one. Don't we want to commit the incomplete
flag before proceeding? Or are we just saying it can be combined with
the first bunmap since that's going to roll anyways..?

BTW, the commit log refers to the invalidation as "not incore," which I
think is opposite. :P xfs_attr_rmtval_invalidate() is incore-only in the
sense that it doesn't seem to use the transaction. Is that what you
mean?

Brian

>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> -- 
> 2.7.4
> 

