Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C72DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C16C20789
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fOm1i2Af"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388942AbgFXMiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:38:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388132AbgFXMiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 08:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593002334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3U3SehrK03YyXcik5Te1+Z3rgouXp8AfJ8p1EZTQgic=;
        b=fOm1i2AfDoY/c8NXaqxYm38EZXOQ97dV3z/PgRfIS/xyM71M6KKnCHuffdjBTtIBZSonG9
        RsxCeVEqgREZgApK91b+f0zKDfGzcdQ28UxucFdTjBUcCw3VvGKso0LLhe2PhODCclARxN
        ErhmaZ0xFLOv8fcAao28beZG406rhg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-O_jKDcE4N0ytlE8Bi_C1GQ-1; Wed, 24 Jun 2020 08:38:52 -0400
X-MC-Unique: O_jKDcE4N0ytlE8Bi_C1GQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7C278015F5;
        Wed, 24 Jun 2020 12:38:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5961B60C80;
        Wed, 24 Jun 2020 12:38:51 +0000 (UTC)
Date:   Wed, 24 Jun 2020 08:38:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 2/3] xfs: fix xfs_reflink_remap_prep calling conventions
Message-ID: <20200624123849.GB9914@bfoster>
References: <159288488965.150128.10967331397379450406.stgit@magnolia>
 <159288490208.150128.2169762955647750917.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159288490208.150128.2169762955647750917.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 09:01:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the return value of xfs_reflink_remap_prep so that its return value
> conventions match the rest of xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c    |    2 +-
>  fs/xfs/xfs_reflink.c |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 00db81eac80d..b375fae811f2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1035,7 +1035,7 @@ xfs_file_remap_range(
>  	/* Prepare and then clone file data. */
>  	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
>  			&len, remap_flags);
> -	if (ret < 0 || len == 0)
> +	if (ret || len == 0)
>  		return ret;
>  
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f50a8c2f21a5..dd9ed7d5694d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1341,7 +1341,7 @@ xfs_reflink_remap_prep(
>  	struct inode		*inode_out = file_inode(file_out);
>  	struct xfs_inode	*dest = XFS_I(inode_out);
>  	bool			same_inode = (inode_in == inode_out);
> -	ssize_t			ret;
> +	int			ret;
>  
>  	/* Lock both files against IO */
>  	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
> @@ -1365,7 +1365,7 @@ xfs_reflink_remap_prep(
>  
>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
>  			len, remap_flags);
> -	if (ret < 0 || *len == 0)
> +	if (ret || *len == 0)
>  		goto out_unlock;
>  
>  	/* Attach dquots to dest inode before changing block map */
> @@ -1400,7 +1400,7 @@ xfs_reflink_remap_prep(
>  	if (ret)
>  		goto out_unlock;
>  
> -	return 1;
> +	return 0;
>  out_unlock:
>  	xfs_reflink_remap_unlock(file_in, file_out);
>  	return ret;
> 

