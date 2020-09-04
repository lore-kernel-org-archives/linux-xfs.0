Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D32C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4954B208B3
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgIDLaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:30:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52348 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730161AbgIDLY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 07:24:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-1Esvy05qM0q-zl9dT7eM0A-1; Fri, 04 Sep 2020 07:24:55 -0400
X-MC-Unique: 1Esvy05qM0q-zl9dT7eM0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2812B18A227B;
        Fri,  4 Sep 2020 11:24:54 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F115C1DA;
        Fri,  4 Sep 2020 11:24:53 +0000 (UTC)
Date:   Fri, 4 Sep 2020 07:24:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: force the log after remapping a synchronous-writes
 file
Message-ID: <20200904112451.GA529978@bfoster>
References: <20200904031100.GZ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904031100.GZ6096@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 08:11:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Commit 5833112df7e9 tried to make it so that a remap operation would
> force the log out to disk if the filesystem is mounted with mandatory
> synchronous writes.  Unfortunately, that commit failed to handle the
> case where the inode or the file descriptor require mandatory
> synchronous writes.
> 
> Refactor the check into into a helper that will look for all three
> conditions, and now we can treat reflink just like any other synchronous
> write.
> 
> Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")

More of a process thought than an issue with this particular patch, but
I feel like the Fixes tag thing gets more watered down as we attempt to
apply it to more patches. Is it really necessary here? If so, what's the
reasoning? I thought it was more of a "this previous patch has a bug,"
but that link seems a bit tenuous here given the original patch refers
specifically to wsync. Sure, a stable kernel probably wants both
patches, but is that really the primary purpose of "Fixes?"

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c31cd3be9fb2..ee43f137830c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1008,6 +1008,21 @@ xfs_file_fadvise(
>  	return ret;
>  }
>  
> +/* Does this file, inode, or mount want synchronous writes? */
> +static inline bool xfs_file_sync_writes(struct file *filp)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> +
> +	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
> +		return true;
> +	if (filp->f_flags & (__O_SYNC | O_DSYNC))
> +		return true;
> +	if (IS_SYNC(file_inode(filp)))
> +		return true;
> +
> +	return false;
> +}
> +
>  STATIC loff_t
>  xfs_file_remap_range(
>  	struct file		*file_in,
> @@ -1065,7 +1080,7 @@ xfs_file_remap_range(
>  	if (ret)
>  		goto out_unlock;
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
>  		xfs_log_force_inode(dest);
>  out_unlock:
>  	xfs_iunlock2_io_mmap(src, dest);
> 

