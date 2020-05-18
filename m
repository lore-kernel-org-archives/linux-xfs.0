Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0888AC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 12:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C925520878
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 12:35:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoGu7L5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgERMfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 08:35:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33835 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727839AbgERMfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 08:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589805302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4QgMLi/nyoG53Ykfy4+b1zeOCkIVUCEZqzERr8ml+58=;
        b=GoGu7L5B+ElSK/D4bAXFI+1e36B8mzasmKG9R8/MiUiT769vZjM3YXTwHC7Az3ta2g7i0r
        BYz/eyhxZw5a0jBg5mtjm4Lr/M32AVpGxzHEl3ZzInZ/CqXAsS+eAJThrjRBZvgwf/Of8z
        jUpCxos68O/9fdJkE4bFQu/30LRXCTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-lpHd8ZhsP0OwLorTBYuEIg-1; Mon, 18 May 2020 08:35:01 -0400
X-MC-Unique: lpHd8ZhsP0OwLorTBYuEIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55CBE800D24
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 12:35:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC6031001925;
        Mon, 18 May 2020 12:34:56 +0000 (UTC)
Date:   Mon, 18 May 2020 08:34:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFCRAP] xfs: handle ENOSPC quota return in
 xfs_file_buffered_aio_write
Message-ID: <20200518123454.GB10938@bfoster>
References: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 04:43:36PM -0500, Eric Sandeen wrote:
> Since project quota returns ENOSPC rather than EDQUOT, the distinction
> between those two error conditions in xfs_file_buffered_aio_write() is
> incomplete.  If project quota is on, and we get ENOSPC, it seems that
> we have no good way to know if it was due to quota, or due to actual
> out of space conditions, and we may need to run both remediation options...
> 
> This is completely untested and not even built, because I'm really not sure
> what the best way to go here is.  True ENOSPC is hopefully rare, pquota
> ENOSPC is probably less so, so I'm not sure how far we should go digging
> to figure out what the root cause of the ENOSPC condition is, when pquota
> is on (on this inode).
> 
> If project quota is on on this inode and pquota enforced, should we look
> to the super to make a determination about low free blocks in the fs?
> 
> Should we crack open the dquot and see if it's over limit?
> 
> Should we just run both conditions and hope for the best?
> 
> Is this all best effort anyway, so we just simply care if we take the
> improper action for pquota+ENOSPC?
> 
> Probably-shouldn't-merge-this-sez: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4b8bdecc3863..8cec826046ce 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -647,27 +647,31 @@ xfs_file_buffered_aio_write(
>  	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
>  	 * also behaves as a filter to prevent too many eofblocks scans from
>  	 * running at the same time.
> +	 *
> +	 * Fun fact: Project quota returns -ENOSPC, so... complexity here.
>  	 */
> -	if (ret == -EDQUOT && !enospc) {
> -		xfs_iunlock(ip, iolock);
> -		enospc = xfs_inode_free_quota_eofblocks(ip);
> -		if (enospc)
> -			goto write_retry;
> -		enospc = xfs_inode_free_quota_cowblocks(ip);
> +	if (!enospc) {
> +		if (ret == -ENOSPC) {
> +			struct xfs_eofblocks eofb = {0};
> +	
> +			enospc = 1;
> +			xfs_flush_inodes(ip->i_mount);
> +	
> +			xfs_iunlock(ip, iolock);
> +			eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> +			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> +			xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> +		}
> +		if (ret == -EDQUOT ||
> +		    (ret == -ENOSPC && ip->i_pdquot &&
> +		     XFS_IS_PQUOTA_ENFORCED(mp) && ip->i_pdquot)) {
> +			xfs_iunlock(ip, iolock);
> +			enospc |= xfs_inode_free_quota_eofblocks(ip);
> +			enospc |= xfs_inode_free_quota_cowblocks(ip);
> +			iolock = 0;
> +		}

Christoph's comment aside, note that the quota helpers here are filtered
scans based on the dquots attached to the inode. It's basically an
optimized scan when we know the failure was due to quota, so I don't
think there should ever be a need to run a quota scan after running the
-ENOSPC handling above. For project quota, it might make more sense to
check if a pdquot is attached, check xfs_dquot_lowsp() and conditionally
update the eofb to do a filtered pquota scan if appropriate (since
calling the quota helper above would also affect other dquots attached
to the inode, which I don't think we want to do). Then we can fall back
to the global scan if the pquota optimization is not relevant or still
returns -ENOSPC on the subsequent retry.

Brian

>  		if (enospc)
>  			goto write_retry;
> -		iolock = 0;
> -	} else if (ret == -ENOSPC && !enospc) {
> -		struct xfs_eofblocks eofb = {0};
> -
> -		enospc = 1;
> -		xfs_flush_inodes(ip->i_mount);
> -
> -		xfs_iunlock(ip, iolock);
> -		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> -		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> -		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> -		goto write_retry;
>  	}
>  
>  	current->backing_dev_info = NULL;
> 

