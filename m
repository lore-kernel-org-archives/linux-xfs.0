Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F76C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 15:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9156A20770
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 15:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMr4LCii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391609AbgLAP1V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:27:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387678AbgLAP1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 10:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606836354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z8QTP/WEx1zBmWNBr5ADW1p8hLWJrdDVqOWqBfUCCjM=;
        b=iMr4LCiiATEARXFnLDL2iJRSGnvEMb+flE9DkFrh7aoZsYRZ2IS67Zs3BOmhJPtgAPZxh8
        Qi2b5DwWyeUPkV0o8X+hVplcKB7yV2v6dTpsfpgtB8GhxmEIJif9jPYJCwuL7d6djC+1ie
        gArgBT7pWaPWM3vMXiACaTSd9Hn6j4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-zw-YOqq7PtGqbzY8_h37nQ-1; Tue, 01 Dec 2020 10:25:51 -0500
X-MC-Unique: zw-YOqq7PtGqbzY8_h37nQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37054AFA88;
        Tue,  1 Dec 2020 15:25:50 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9F1060C6B;
        Tue,  1 Dec 2020 15:25:49 +0000 (UTC)
Date:   Tue, 1 Dec 2020 10:25:48 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
Message-ID: <20201201152548.GB1205666@bfoster>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
 <160679383664.447787.14224539520566294960.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679383664.447787.14224539520566294960.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a copy_file_range handler to XFS so that we can accelerate file
> copies with reflink when the source and destination ranges are not
> block-aligned.  We'll use the generic pagecache copy to handle the
> unaligned edges and attempt to reflink the middle.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_file.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b0f93f73837..9d1bb0dc30e2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1119,6 +1119,104 @@ xfs_file_remap_range(
>  	return remapped > 0 ? remapped : ret;
>  }
>  
...
> +STATIC ssize_t
> +xfs_file_copy_range(
> +	struct file		*src_file,
> +	loff_t			src_off,
> +	struct file		*dst_file,
> +	loff_t			dst_off,
> +	size_t			len,
> +	unsigned int		flags)
> +{
> +	struct inode		*inode_src = file_inode(src_file);
> +	struct xfs_inode	*src = XFS_I(inode_src);
> +	struct inode		*inode_dst = file_inode(dst_file);
> +	struct xfs_inode	*dst = XFS_I(inode_dst);
> +	struct xfs_mount	*mp = src->i_mount;
> +	loff_t			copy_ret;
> +	loff_t			next_block;
> +	size_t			copy_len;
> +	ssize_t			total_copied = 0;
> +
> +	/* Bypass all this if no copy acceleration is possible. */
> +	if (!xfs_want_reflink_copy_range(src, src_off, dst, dst_off, len))
> +		goto use_generic;
> +
> +	/* Use the regular copy until we're block aligned at the start. */
> +	next_block = round_up(src_off + 1, mp->m_sb.sb_blocksize);

Why the +1? AFAICT this means we manually copy the first block if
src_off does happen to be block aligned. Is this an assumption based on
the caller attempting ->remap_file_range() first?

BTW, if we do happen to be called in some (theoretical) corner case
where remap doesn't work unrelated to alignment, it seems this would
unconditionally break the manual copy into multiple parts (first block +
the rest). It's not immediately clear to me if that's significant from a
performance perspective, but I wonder if it would be nicer here to
filter that out more explicitly. For example, run the remap checks on
the block aligned offset/len first, or skip the remap if the caller has
provided a block aligned start (i.e. hinting that remap failed for other
reasons), or perhaps even implement this so it conditionally performs a
short manual copy so the next retry would fall into ->remap_file_range()
with aligned offsets, etc. Thoughts?

> +	copy_len = min_t(size_t, len, next_block - src_off);
> +	if (copy_len > 0) {
> +		copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
> +					dst_off, copy_len, flags);
> +		if (copy_ret < 0)
> +			return copy_ret;
> +
> +		src_off += copy_ret;
> +		dst_off += copy_ret;
> +		len -= copy_ret;
> +		total_copied += copy_ret;
> +		if (copy_ret < copy_len || len == 0)
> +			return total_copied;
> +	}
> +
> +	/*
> +	 * Now try to reflink as many full blocks as we can.  If the end of the
> +	 * copy request wasn't block-aligned or the reflink fails, we'll just
> +	 * fall into the generic copy to do the rest.
> +	 */
> +	copy_len = round_down(len, mp->m_sb.sb_blocksize);
> +	if (copy_len > 0) {
> +		copy_ret = xfs_file_remap_range(src_file, src_off, dst_file,
> +				dst_off, copy_len, REMAP_FILE_CAN_SHORTEN);
> +		if (copy_ret >= 0) {
> +			src_off += copy_ret;
> +			dst_off += copy_ret;
> +			len -= copy_ret;
> +			total_copied += copy_ret;
> +			if (copy_ret < copy_len || len == 0)
> +				return total_copied;

Any reason we return a potential short copy here, but fall into the
manual copy if the reflink outright fails?

> +		}
> +	}
> +
> +use_generic:
> +	/* Use the regular copy to deal with leftover bytes. */
> +	copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
> +			dst_off, len, flags);
> +	if (copy_ret < 0)
> +		return copy_ret;

Perhaps this should also check/return total_copied in the event we've
already done some work..?

Brian

> +	return total_copied + copy_ret;
> +}
> +
>  STATIC int
>  xfs_file_open(
>  	struct inode	*inode,
> @@ -1381,6 +1479,7 @@ const struct file_operations xfs_file_operations = {
>  	.get_unmapped_area = thp_get_unmapped_area,
>  	.fallocate	= xfs_file_fallocate,
>  	.fadvise	= xfs_file_fadvise,
> +	.copy_file_range = xfs_file_copy_range,
>  	.remap_file_range = xfs_file_remap_range,
>  };
>  
> 

