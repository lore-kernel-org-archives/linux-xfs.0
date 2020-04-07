Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E9C2BA2B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D282078A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNtBjJcd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgDGORN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:17:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28758 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728975AbgDGORN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 10:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586269032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvlhdLcS/t0Wb8Vpr8KJYpLpZ+op1J5oWuCoLkEqyGQ=;
        b=YNtBjJcd/Dnz9auWQKZrcmf0wG/LRKKN/gNCUjWwqkhNwEjH4HTDypzMfFideLaCdLpFaf
        bw1i8Qz8UhPDvsFlPp6kYYQ69zfOSc7L4RnGw42aY58MSYOyfQi+RErVMHMLj36G9xvkcF
        0wNxVcPpO4j9mKsYynuyM+AjjnCQ3yQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-stR0NoJmMeC8joIBLKa4KQ-1; Tue, 07 Apr 2020 10:17:09 -0400
X-MC-Unique: stR0NoJmMeC8joIBLKa4KQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87C10107B267;
        Tue,  7 Apr 2020 14:17:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E4105DA60;
        Tue,  7 Apr 2020 14:17:08 +0000 (UTC)
Date:   Tue, 7 Apr 2020 10:17:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 11/20] xfs: Add helper function xfs_attr_node_shrink
Message-ID: <20200407141706.GB28936@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-12-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:20PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_shrink used to
> shrink an attr name into an inode if it is small enough.  This helps to
> modularize the greater calling function xfs_attr_node_removename.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index db5a99c..27a9bb5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -1197,31 +1235,10 @@ xfs_attr_node_removename(
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		/*
> -		 * Have to get rid of the copy of this dabuf in the state.
> -		 */
> -		ASSERT(state->path.active == 1);
> -		ASSERT(state->path.blk[0].bp);
> -		state->path.blk[0].bp = NULL;
> -
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -		if (error)
> -			goto out;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error = xfs_attr_node_shrink(args, state);
>  
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		} else
> -			xfs_trans_brelse(args->trans, bp);
> -	}
>  	error = 0;

Looks like the error handling is busted here..? We used to goto out, now
we always reset error to 0.

Brian

> -
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> -- 
> 2.7.4
> 

