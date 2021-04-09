Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7059C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA3B61042
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhDIO2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:28:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232855AbhDIO2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617978518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2WeIsmkBPBWNxXOoVqWwCuAdvoknN3d8B+ES3b+K120=;
        b=If3EVw61V37C+bSdB4gRB5XrYnDvQdeRTzRd/8FzFDqN3bvr24y9cwUp1KItMotJ/oMCMF
        vz13eM0J9UUwIE+AXnWH2DzCR0r69G4Fza+at2RCtIzZ6IJHolfzf6rQt+V+DBcBI6lhzs
        5N+Shf+XCSQJi6Dbj2tA+XsPN+Mnt48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-7qX4dOamNAW1DdDOjY-5tg-1; Fri, 09 Apr 2021 10:28:34 -0400
X-MC-Unique: 7qX4dOamNAW1DdDOjY-5tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38A1E106BB23;
        Fri,  9 Apr 2021 14:28:33 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 672B46F965;
        Fri,  9 Apr 2021 14:28:32 +0000 (UTC)
Date:   Fri, 9 Apr 2021 10:28:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix return of uninitialized value in variable error
Message-ID: <YHBkjihVv4+7D62Q@bfoster>
References: <20210409141834.667163-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409141834.667163-1-colin.king@canonical.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 09, 2021 at 03:18:34PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A previous commit removed a call to xfs_attr3_leaf_read that
> assigned an error return code to variable error. We now have
> a few early error return paths to label 'out' that return
> error if error is set; however error now is uninitialized
> so potentially garbage is being returned.  Fix this by setting
> error to zero to restore the original behaviour where error
> was zero at the label 'restart'.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 472b3039eabb..902e5f7e6642 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -928,6 +928,7 @@ xfs_attr_node_addname(
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> +	error = 0;
>  	retval = xfs_attr_node_hasname(args, &state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
>  		goto out;

I think it would be nicer to initialize at the top of the function as
opposed to try and "preserve" historical behavior, but that nit aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -- 
> 2.30.2
> 

