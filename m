Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D44C11D2F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 13:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB61B20732
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 13:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cXSTCejK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgBXNIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:08:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44398 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727673AbgBXNIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 08:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RlAnB/gN8foEpgZA2X6Z5kpKM9Ds0Eg0qt4O24BSpdc=;
        b=cXSTCejK2VoenANNIQJDwu/dmLTUUhb8hFRvMVF87jYwnRop4761XzRTfxC9ctHmhtWUdI
        nIlzUWQcdS8iYjwl9nBmIju7u8I1Na0nW4RYeIHQmvt47NUTL7ILBg4yUzdROScaivFoSk
        gfbFQXSli5y2nAYd3RDJmZklARWIMFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-OoaiLCsTOGiexYv4SOgG9w-1; Mon, 24 Feb 2020 08:08:15 -0500
X-MC-Unique: OoaiLCsTOGiexYv4SOgG9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A7CD107ACCD;
        Mon, 24 Feb 2020 13:08:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2DBC8B759;
        Mon, 24 Feb 2020 13:08:13 +0000 (UTC)
Date:   Mon, 24 Feb 2020 08:08:11 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 04/19] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20200224130811.GC15761@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-5-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:05:56PM -0700, Allison Collins wrote:
> Delayed operations cannot return error codes.  So we must check for these conditions
> first before starting set or remove operations
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2255060..a2f812f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -437,6 +437,14 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> +
> +	error = xfs_has_attr(&args);
> +	if (error == -EEXIST && (name->type & ATTR_CREATE))
> +		goto out_trans_cancel;
> +
> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +		goto out_trans_cancel;
> +

So xfs_has_attr() calls the format-specific variant for the attr fork.
If it's node format, xfs_attr_node_hasname() allocs a state and only
frees it if the lookup happens to fail. That looks like a potential
memory leak... Perhaps that helper should free the state in any case the
caller doesn't ask for a pointer?

Brian

>  	error = xfs_attr_set_args(&args);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -525,6 +533,10 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> +	error = xfs_has_attr(&args);
> +	if (error != -EEXIST)
> +		goto out;
> +
>  	error = xfs_attr_remove_args(&args);
>  	if (error)
>  		goto out;
> -- 
> 2.7.4
> 

