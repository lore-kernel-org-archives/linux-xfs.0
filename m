Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510DEC2BA19
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 14:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12D7A23D6B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 14:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnQiFQE2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgDFOcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:32:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728406AbgDFOcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 10:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586183529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1U9bxhLgJmjynt6lX0r4TQQXffCwufgmOfreUo6vCD4=;
        b=UnQiFQE2JMqmfhjNYNHgMdkNWtL0wjaxCz62JSxxDkppnuGDewr9lB14g1gswNSxmg2Sno
        q03EH9rTVwR7rONxHbIwbVHbktCc/IwopoY1JZ7/ovdluhJcArUHIwkk31OB1Uf+htGkY2
        1xuTx2Eh2aSztCdPETqhM/D0kyIFF1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-7qQgEQfFN16i4aJB03mSSQ-1; Mon, 06 Apr 2020 10:32:05 -0400
X-MC-Unique: 7qQgEQfFN16i4aJB03mSSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AC37800D5C;
        Mon,  6 Apr 2020 14:31:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D690E19C4F;
        Mon,  6 Apr 2020 14:31:56 +0000 (UTC)
Date:   Mon, 6 Apr 2020 10:31:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 02/20] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20200406143155.GD20708@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-3-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:11PM -0700, Allison Collins wrote:
> Delayed operations cannot return error codes.  So we must check for
> these conditions first before starting set or remove operations
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2a0d3d3..f7e289e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -404,6 +404,17 @@ xfs_attr_set(
>  				args->total, 0, quota_flags);
>  		if (error)
>  			goto out_trans_cancel;
> +
> +		error = xfs_has_attr(args);
> +		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
> +			goto out_trans_cancel;
> +
> +		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> +			goto out_trans_cancel;
> +
> +		if (error != -ENOATTR && error != -EEXIST)
> +			goto out_trans_cancel;

I'd kill off the whitespace between the above error checks. Otherwise
looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
>  		error = xfs_attr_set_args(args);
>  		if (error)
>  			goto out_trans_cancel;
> @@ -411,6 +422,10 @@ xfs_attr_set(
>  		if (!args->trans)
>  			goto out_unlock;
>  	} else {
> +		error = xfs_has_attr(args);
> +		if (error != -EEXIST)
> +			goto out_trans_cancel;
> +
>  		error = xfs_attr_remove_args(args);
>  		if (error)
>  			goto out_trans_cancel;
> -- 
> 2.7.4
> 

