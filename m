Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA55DC2D0D7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B18624735
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKBpTZqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfLMOPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 09:15:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727444AbfLMOPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 09:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576246552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCEU+zwX5VlC3GyfdZ4i2nDn45VNIP1ecgnTZMW9RZ4=;
        b=QKBpTZqrdr/6597X3hfaU+mhyvZrEgMyB51cEQ+PnQNQ5sQijZV57j4jycHYvhdZkILjG4
        zJqrYQCxKF4geRxVXWioSdtwdCfTucOL9GC7cJJEeNG8HBuyrVTgras3A+aTIO8EaKKwB8
        4uCe8pQybHkjCU0xJE9pesJkCt3bqwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-E3uB32YLOdWX8sIuk4V1pw-1; Fri, 13 Dec 2019 09:15:51 -0500
X-MC-Unique: E3uB32YLOdWX8sIuk4V1pw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 408A6DB22;
        Fri, 13 Dec 2019 14:15:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE52960C63;
        Fri, 13 Dec 2019 14:15:49 +0000 (UTC)
Date:   Fri, 13 Dec 2019 09:15:49 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 08/14] xfs: Factor up xfs_attr_try_sf_addname
Message-ID: <20191213141549.GE43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-9-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:07PM -0700, Allison Collins wrote:
> New delayed attribute routines cannot handle transactions. We
> can factor up the commit, but there is little left in this
> function other than some error handling and an ichgtime. So
> hoist all of xfs_attr_try_sf_addname up at this time.  We will
> remove all the commits in this set.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++----------------------------
>  1 file changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 36f6a43..9c78e0d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -258,7 +230,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error;
> +	int			error, error2 = 0;;

Extra semicolon on the above line.

>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -277,9 +249,27 @@ xfs_attr_set_args(
>  		/*
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC)
> -			return error;
> +
> +		error = xfs_attr_shortform_addname(args);
> +
> +		/* Should only be 0, -EEXIST or ENOSPC */
> +		if (error != -ENOSPC) {
> +			/*
> +			 * Commit the shortform mods, and we're done.
> +			 * NOTE: this is also the error path (EEXIST, etc).
> +			 */
> +			if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
> +				xfs_trans_ichgtime(args->trans, dp,
> +						   XFS_ICHGTIME_CHG);
> +
> +			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
> +				xfs_trans_set_sync(args->trans);
> +
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
> +

And extra whitespace here. With those nits fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
> -- 
> 2.7.4
> 

