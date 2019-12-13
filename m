Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EEDC7CFDC
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B8EA247E5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2eYy5YP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfLMRpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 12:45:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58266 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728012AbfLMRpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:45:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576259133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YlnU8fYcIUYj/+C3C8/AIKtjj0JFSB5QA7qT3Q7CYrA=;
        b=B2eYy5YP9N29A83MzRc8lMlizVRBkMQxQSlvPs+rrllxx5/elT+qAIOLfWe/jLWZuvRIWq
        mleeRauH77b0gNgNuZWVD9WXWPecw9nTI28Gs4uxsNHw0LJdSZ7YubY3ShSTFex8h60UN2
        MgpX/oc0D2lzgUoP9FKVwJvOi6n6ofA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-BmBa7jtsMsCfmnJgQV305A-1; Fri, 13 Dec 2019 12:45:29 -0500
X-MC-Unique: BmBa7jtsMsCfmnJgQV305A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8EB1911E8;
        Fri, 13 Dec 2019 17:45:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 643F019C4F;
        Fri, 13 Dec 2019 17:45:27 +0000 (UTC)
Date:   Fri, 13 Dec 2019 12:45:26 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191213174526.GH43376@bfoster>
References: <20191213161349.GH99875@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213161349.GH99875@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 08:13:49AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> and swidth values could cause xfs_repair to fail loudly.  The problem
> here is that repair calculates the where mkfs should have allocated the
> root inode, based on the superblock geometry.  The allocation decisions
> depend on sunit, which means that we really can't go updating sunit if
> it would lead to a subsequent repair failure on an otherwise correct
> filesystem.
> 
> Port from xfs_repair some code that computes the location of the root
> inode and teach mount to skip the ondisk update if it would cause
> problems for repair.  Along the way we'll update the documentation,
> provide a function for computing the minimum AGFL size instead of
> open-coding it, and cut down some indenting in the mount code.
> 
> Note that we allow the mount to proceed (and new allocations will
> reflect this new geometry) because we've never screened this kind of
> thing before.  We'll have to wait for a new future incompat feature to
> enforce correct behavior, alas.
> 
> Note that the geometry reporting always uses the superblock values, not
> the incore ones, so that is what xfs_info and xfs_growfs will report.
> 
> [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> 
> Reported-by: Alex Lyakas <alex@zadara.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
> behavior, fix a bunch of the comments and make it clearer how we compute
> the rootino location
> ---
>  fs/xfs/libxfs/xfs_alloc.c  |   18 ++++++---
>  fs/xfs/libxfs/xfs_ialloc.c |   70 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    1 
>  fs/xfs/xfs_mount.c         |   90 ++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_trace.h         |   21 ++++++++++
>  5 files changed, 166 insertions(+), 34 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 323592d563d5..72b3468b97b1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
...
> @@ -398,28 +431,26 @@ xfs_update_alignment(xfs_mount_t *mp)
>  			}
>  		}
>  
> -		/*
> -		 * Update superblock with new values
> -		 * and log changes
> -		 */
> -		if (xfs_sb_version_hasdalign(sbp)) {
> -			if (sbp->sb_unit != mp->m_dalign) {
> -				sbp->sb_unit = mp->m_dalign;
> -				mp->m_update_sb = true;
> -			}
> -			if (sbp->sb_width != mp->m_swidth) {
> -				sbp->sb_width = mp->m_swidth;
> -				mp->m_update_sb = true;
> -			}
> -		} else {
> +		/* Update superblock with new values and log changes. */
> +		if (!xfs_sb_version_hasdalign(sbp)) {
>  			xfs_warn(mp,
>  	"cannot change alignment: superblock does not support data alignment");
>  			return -EINVAL;
>  		}
> +
> +		if (sbp->sb_unit == mp->m_dalign &&
> +		    sbp->sb_width == mp->m_swidth)
> +			return 0;
> +
> +		xfs_check_new_dalign(mp, mp->m_dalign);
> +
> +		sbp->sb_unit = mp->m_dalign;
> +		sbp->sb_width = mp->m_swidth;
> +		mp->m_update_sb = true;

Isn't this supposed to conditionally update the superblock based on the
rootino calculation?

Brian

>  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
>  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> -			mp->m_dalign = sbp->sb_unit;
> -			mp->m_swidth = sbp->sb_width;
> +		mp->m_dalign = sbp->sb_unit;
> +		mp->m_swidth = sbp->sb_width;
>  	}
>  
>  	return 0;
> @@ -647,16 +678,6 @@ xfs_mountfs(
>  		mp->m_update_sb = true;
>  	}
>  
> -	/*
> -	 * Check if sb_agblocks is aligned at stripe boundary
> -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> -	 * allocator alignment is within an ag, therefore ag has
> -	 * to be aligned at stripe boundary.
> -	 */
> -	error = xfs_update_alignment(mp);
> -	if (error)
> -		goto out;
> -
>  	xfs_alloc_compute_maxlevels(mp);
>  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> @@ -664,6 +685,17 @@ xfs_mountfs(
>  	xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
> +	/*
> +	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> +	 * is NOT aligned turn off m_dalign since allocator alignment is within
> +	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
> +	 * we must compute the free space and rmap btree geometry before doing
> +	 * this.
> +	 */
> +	error = xfs_update_alignment(mp);
> +	if (error)
> +		goto out;
> +
>  	/* enable fail_at_unmount as default */
>  	mp->m_fail_unmount = true;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c13bb3655e48..a86be7f807ee 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
>  DEFINE_KMEM_EVENT(kmem_zone_alloc);
>  
> +TRACE_EVENT(xfs_check_new_dalign,
> +	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> +	TP_ARGS(mp, new_dalign, calc_rootino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, new_dalign)
> +		__field(xfs_ino_t, sb_rootino)
> +		__field(xfs_ino_t, calc_rootino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->new_dalign = new_dalign;
> +		__entry->sb_rootino = mp->m_sb.sb_rootino;
> +		__entry->calc_rootino = calc_rootino;
> +	),
> +	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->new_dalign, __entry->sb_rootino,
> +		  __entry->calc_rootino)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

