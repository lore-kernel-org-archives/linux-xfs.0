Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6E2C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 13:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DDD2074B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 13:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUIUjWZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgFINNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 09:13:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726937AbgFINNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 09:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591708386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ZiTy5KQdgsvGQfCllo/1fcJXpeMWWSGcy3rlkrWq/g=;
        b=IUIUjWZ97iQD5la0E81O4tGyzmwl9CWZRaLbXAhxVDfhrxvahxUX4LoK0HBL/GepK1A1e+
        jk8OzSWKROT48lQeb7Wp69fCfzNJLURsJRTmAaxNOxI2YhViSP7x9Z9KZNdXveiHK3DA5k
        7V3/KwshVMaikiSzujNNphD1haBLSro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-sjp_CtegML27OogVikw5hw-1; Tue, 09 Jun 2020 09:13:03 -0400
X-MC-Unique: sjp_CtegML27OogVikw5hw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1148C464;
        Tue,  9 Jun 2020 13:13:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD0325D9E4;
        Tue,  9 Jun 2020 13:13:00 +0000 (UTC)
Date:   Tue, 9 Jun 2020 09:12:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/30] xfs: remove xfs_inobp_check()
Message-ID: <20200609131258.GD40899@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-31-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-31-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This debug code is called on every xfs_iflush() call, which then
> checks every inode in the buffer for non-zero unlinked list field.
> Hence it checks every inode in the cluster buffer every time a
> single inode on that cluster it flushed. This is resulting in:
> 
> -   38.91%     5.33%  [kernel]  [k] xfs_iflush
>    - 17.70% xfs_iflush
>       - 9.93% xfs_inobp_check
>            4.36% xfs_buf_offset
> 
> 10% of the CPU time spent flushing inodes is repeatedly checking
> unlinked fields in the buffer. We don't need to do this.
> 
> The other place we call xfs_inobp_check() is
> xfs_iunlink_update_dinode(), and this is after we've done this
> assert for the agino we are about to write into that inode:
> 
> 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> 
> which means we've already checked that the agino we are about to
> write is not 0 on debug kernels. The inode buffer verifiers do
> everything else we need, so let's just remove this debug code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c | 24 ------------------------
>  fs/xfs/libxfs/xfs_inode_buf.h |  6 ------
>  fs/xfs/xfs_inode.c            |  2 --
>  3 files changed, 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 1af97235785c8..6b6f67595bf4e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -20,30 +20,6 @@
>  
>  #include <linux/iversion.h>
>  
> -/*
> - * Check that none of the inode's in the buffer have a next
> - * unlinked field of 0.
> - */
> -#if defined(DEBUG)
> -void
> -xfs_inobp_check(
> -	xfs_mount_t	*mp,
> -	xfs_buf_t	*bp)
> -{
> -	int		i;
> -	xfs_dinode_t	*dip;
> -
> -	for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
> -		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
> -		if (!dip->di_next_unlinked)  {
> -			xfs_alert(mp,
> -	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
> -				i, (long long)bp->b_bn);
> -		}
> -	}
> -}
> -#endif
> -
>  /*
>   * If we are doing readahead on an inode buffer, we might be in log recovery
>   * reading an inode allocation buffer that hasn't yet been replayed, and hence
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 865ac493c72a2..6b08b9d060c2e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -52,12 +52,6 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
>  			       struct xfs_dinode *to);
>  
> -#if defined(DEBUG)
> -void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
> -#else
> -#define	xfs_inobp_check(mp, bp)
> -#endif /* DEBUG */
> -
>  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
>  xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 931a483d5b316..9400c2e0b0c4a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2165,7 +2165,6 @@ xfs_iunlink_update_dinode(
>  	xfs_dinode_calc_crc(mp, dip);
>  	xfs_trans_inode_buf(tp, ibp);
>  	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -	xfs_inobp_check(mp, ibp);
>  }
>  
>  /* Set an in-core inode's unlinked pointer and return the old value. */
> @@ -3559,7 +3558,6 @@ xfs_iflush(
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
>  		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
> -	xfs_inobp_check(mp, bp);
>  
>  	/*
>  	 * We've recorded everything logged in the inode, so we'd like to clear
> -- 
> 2.26.2.761.g0e0b3e54be
> 

