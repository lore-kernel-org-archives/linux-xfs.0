Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62268C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3992E20709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFXGdHnv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbgFYM0a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:26:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404343AbgFYM0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593087989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aYXtlBUY/pJPnqGvJ91dbHa8LabvsfdbqBnRqhm24CY=;
        b=XFXGdHnvwAIeY+z8+vxR5c1NeG29Js+aZTkOXwMHQddBaQc8dM69BsPpx57kkfBSS8ZnW3
        ie8jjCf0QJiBbsCc83q2TelvPy+JJxSTA7kDtqWfdxLXQIkESKDDdl1fPawDrn4uZ5ZqtQ
        HdmDMhQ9P9JmVVM7cF88VGlV3fZWrug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-RRQnviqjNgmj5KlCyuAvwg-1; Thu, 25 Jun 2020 08:26:26 -0400
X-MC-Unique: RRQnviqjNgmj5KlCyuAvwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B09618FE860;
        Thu, 25 Jun 2020 12:26:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3CDB8FF97;
        Thu, 25 Jun 2020 12:26:24 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:26:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200625122623.GB2863@bfoster>
References: <20200625011643.GJ7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625011643.GJ7625@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:16:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The data fork scrubber calls filemap_write_and_wait to flush dirty pages
> and delalloc reservations out to disk prior to checking the data fork's
> extent mappings.  Unfortunately, this means that scrub can consume the
> EIO/ENOSPC errors that would otherwise have stayed around in the address
> space until (we hope) the writer application calls fsync to persist data
> and collect errors.  The end result is that programs that wrote to a
> file might never see the error code and proceed as if nothing were
> wrong.
> 
> xfs_scrub is not in a position to notify file writers about the
> writeback failure, and it's only here to check metadata, not file
> contents.  Therefore, if writeback fails, we should stuff the error code
> back into the address space so that an fsync by the writer application
> can pick that up.
> 
> Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4: remove if block that only had a gigantic comment
> v3: don't play this game where we clear the mapping error only to re-set it
> v2: explain why it's ok to keep going even if writeback fails
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/bmap.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 7badd6dfe544..955302e7cdde 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -45,9 +45,27 @@ xchk_setup_inode_bmap(
>  	 */
>  	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
>  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> +		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
> +
>  		inode_dio_wait(VFS_I(sc->ip));
> -		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> -		if (error)
> +
> +		/*
> +		 * Try to flush all incore state to disk before we examine the
> +		 * space mappings for the data fork.  Leave accumulated errors
> +		 * in the mapping for the writer threads to consume.
> +		 *
> +		 * On ENOSPC or EIO writeback errors, we continue into the
> +		 * extent mapping checks because write failures do not
> +		 * necessarily imply anything about the correctness of the file
> +		 * metadata.  The metadata and the file data could be on
> +		 * completely separate devices; a media failure might only
> +		 * affect a subset of the disk, etc.  We can handle delalloc
> +		 * extents in the scrubber, so leaving them in memory is fine.
> +		 */
> +		error = filemap_fdatawrite(mapping);
> +		if (!error)
> +			error = filemap_fdatawait_keep_errors(mapping);
> +		if (error && (error != -ENOSPC && error != -EIO))
>  			goto out;
>  	}
>  
> 

