Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3AEC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FE52075B
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClvkAunT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgEDNa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 09:30:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbgEDNa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 09:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588599027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Th0/XxMgoyf798jPzQmoNByPw1ZSy60ZdfSfw+/Ccyw=;
        b=ClvkAunTx/OWBbvQVJtCeynbMZQJezs3ay6G0jthdID1EwzdJ3fXSr8BMDu9DSwOUiDUFE
        b+Ziq45zLqHEwN2130Ffx54hFjVB+gKpgOMZC1VewhDi0lHeKwsitxe7pPjt2htKEnRr+4
        rN9VPnQIcHiI0p+BhGzIGeJMwisSir4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-TQKcZNYPNNuY9jF9dGD52w-1; Mon, 04 May 2020 09:30:25 -0400
X-MC-Unique: TQKcZNYPNNuY9jF9dGD52w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDD56835B40;
        Mon,  4 May 2020 13:30:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FE5460C80;
        Mon,  4 May 2020 13:30:24 +0000 (UTC)
Date:   Mon, 4 May 2020 09:30:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 13/24] xfs: Remove unneeded xfs_trans_roll_inode calls
Message-ID: <20200504133022.GD54625@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-14-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:05PM -0700, Allison Collins wrote:
> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
> needed. If they are the last operations executed in these functions, and
> no further changes are made, then higher level routines will roll or
> commit the tranactions. The xfs_trans_roll in _removename is also not
> needed because invalidating blocks is an incore-only change.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 40 ----------------------------------------
>  1 file changed, 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d83443c..af47566 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -784,9 +770,6 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  	}
>  	return 0;

Looks like this could be simplified to return error at the end of the
function. Some of the others might have similar simplifications
available.

>  }
> @@ -1074,13 +1057,6 @@ xfs_attr_node_addname(
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

There's an xfs_defer_finish() before this roll. Is that not also
extraneous? It looks like we return straight up to xfs_attr_set() (trans
commit) from here..

>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
...
> @@ -1194,10 +1158,6 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> -

I'm still a bit on the fence about this one. At first glance it looks
like it's not necessary, but technically we're changing behavior by
combining setting the inactive flag and the first remote block unmap,
right? If so, that seems fairly reasonable, but it's hard to say for
sure with the state of the xattr transaction reservations...

Looking around some more, I suppose this could be analogous to the
!remote remove case where an entry is removed and a potential dabtree
join occurs under the same transaction. If that's the best argument we
have, however, I might suggest to split this one out into an independent
patch and let the commit log describe what's going on in more detail.
That way it's more obvious to reviewers and if it's wrong it's easier to
revert.

Brian

>  		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
> -- 
> 2.7.4
> 

