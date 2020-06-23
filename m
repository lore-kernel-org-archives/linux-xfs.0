Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E15C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 12:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A137420707
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 12:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHjzMe+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbgFWMKj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:10:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732713AbgFWMKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 08:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592914237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ps+uU4QO1xLq+CXBByK3xY2sdeGxwyitBVjJb0Z2AZM=;
        b=gHjzMe+gr4b2jkxuheS5MoxLBdjyrXkOx4B3s1kEFesE78UbUkIzt6V96bjNptK3gbwc6Y
        yaeIkXqp7KkTpLAItdK3xLEOg/THzG7RnaYV8ZsMhu2D+YfSM1ySIn0utdUUBSYsN7D5PL
        LGVgNDAwxpvVy274cgveQcOGmis4hRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-m0v8Qq-DN5KvmVZOmvXs_A-1; Tue, 23 Jun 2020 08:10:34 -0400
X-MC-Unique: m0v8Qq-DN5KvmVZOmvXs_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB03184D142;
        Tue, 23 Jun 2020 12:10:33 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 789CF5C1D4;
        Tue, 23 Jun 2020 12:10:33 +0000 (UTC)
Date:   Tue, 23 Jun 2020 08:10:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200623121031.GB55038@bfoster>
References: <20200623035010.GF7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623035010.GF7606@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 08:50:10PM -0700, Darrick J. Wong wrote:
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
> v2: explain why it's ok to keep going even if writeback fails
> ---
>  fs/xfs/scrub/bmap.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 7badd6dfe544..0d7062b7068b 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -47,7 +47,24 @@ xchk_setup_inode_bmap(
>  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
>  		inode_dio_wait(VFS_I(sc->ip));
>  		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> -		if (error)
> +		if (error == -ENOSPC || error == -EIO) {
> +			/*
> +			 * If writeback hits EIO or ENOSPC, reflect it back
> +			 * into the address space mapping so that a writer
> +			 * program calling fsync to look for errors will still
> +			 * capture the error.
> +			 *
> +			 * However, we continue into the extent mapping checks
> +			 * because write failures do not necessarily imply
> +			 * anything about the correctness of the file metadata.
> +			 * The metadata and the file data could be on
> +			 * completely separate devices; a media failure might
> +			 * only affect a subset of the disk, etc.  We properly
> +			 * account for delalloc extents, so leaving them in
> +			 * memory is fine.
> +			 */
> +			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);

I think the more appropriate thing to do is open code the data write and
wait and use the variants of the latter that don't consume address space
errors in the first place (i.e. filemap_fdatawait_keep_errors()). Then
we wouldn't need the special error handling branch or perhaps the first
part of the comment. Hm?

Brian

> +		} else if (error)
>  			goto out;
>  	}
>  
> 

