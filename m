Return-Path: <SRS0=RLxe=2J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB41C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 13:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCD2227BF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 13:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4Vo590s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSNS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:18:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726695AbfLSNS0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Dec 2019 08:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576761505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GCs/ZixBqhEqE/cxmONckRLBC0bS/nUhC5CluHEakmM=;
        b=A4Vo590sUv3PBZJBbcSgvZ5KmL756d4p/4fv8Wdw6mRmoxyZIBx3bzlecpFRMuJR99n0aD
        aeCzLAAnUhwxkGWMB0zhMSeEGLP9o15DoRuvAssZuphRmpvBYqzQSjEldTWueARradwcRV
        wsN5uLrW2qa1cfMxautKgR057ZhR0JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-BQji-Fl6MfiNQd8v7skeow-1; Thu, 19 Dec 2019 08:18:22 -0500
X-MC-Unique: BQji-Fl6MfiNQd8v7skeow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0D4F107BE0D;
        Thu, 19 Dec 2019 13:18:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C0F5D9E2;
        Thu, 19 Dec 2019 13:18:20 +0000 (UTC)
Date:   Thu, 19 Dec 2019 08:18:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, alex@zadara.com
Subject: Re: [PATCH 2/3] xfs: split the sunit parameter update into two parts
Message-ID: <20191219131818.GD6995@bfoster>
References: <157669784202.117895.9984764081860081830.stgit@magnolia>
 <157669785528.117895.4622861432203934489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157669785528.117895.4622861432203934489.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 11:37:35AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the administrator provided a sunit= mount option, we need to validate
> the raw parameter, convert the mount option units (512b blocks) into the
> internal unit (fs blocks), and then validate that the (now cooked)
> parameter doesn't screw anything up on disk.  The incore inode geometry
> computation can depend on the new sunit option, but a subsequent patch
> will make validating the cooked value depends on the computed inode
> geometry, so break the sunit update into two steps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_mount.c |  126 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 75 insertions(+), 51 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..3750f0074c74 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -360,66 +360,79 @@ xfs_readsb(
>  }
>  
>  /*
> - * Update alignment values based on mount options and sb values
> + * If we were provided with new sunit/swidth values as mount options, make sure
> + * that they pass basic alignment and superblock feature checks, and convert
> + * them into the same units (FSB) that everything else expects.  This step
> + * /must/ be done before computing the inode geometry.
>   */
>  STATIC int
> -xfs_update_alignment(xfs_mount_t *mp)
> +xfs_validate_new_dalign(
> +	struct xfs_mount	*mp)
>  {
...
> +		} else if (mp->m_dalign) {
> +			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
>  		} else {
>  			xfs_warn(mp,
> -	"cannot change alignment: superblock does not support data alignment");
> +		"alignment check failed: sunit(%d) less than bsize(%d)",
> +				 mp->m_dalign, mp->m_sb.sb_blocksize);
>  			return -EINVAL;
>  		}
> +	}
> +
> +	/* Update superblock with new values and log changes. */

We can probably drop the above comment since this hunk no longer does
either. ;) With that fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
> +		xfs_warn(mp,
> +"cannot change alignment: superblock does not support data alignment");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Update alignment values based on mount options and sb values
> + */
> +STATIC int
> +xfs_update_alignment(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
> +	if (mp->m_dalign) {
> +		if (sbp->sb_unit == mp->m_dalign &&
> +		    sbp->sb_width == mp->m_swidth)
> +			return 0;
> +
> +		sbp->sb_unit = mp->m_dalign;
> +		sbp->sb_width = mp->m_swidth;
> +		mp->m_update_sb = true;
>  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
>  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> -			mp->m_dalign = sbp->sb_unit;
> -			mp->m_swidth = sbp->sb_width;
> +		mp->m_dalign = sbp->sb_unit;
> +		mp->m_swidth = sbp->sb_width;
>  	}
>  
>  	return 0;
> @@ -648,12 +661,12 @@ xfs_mountfs(
>  	}
>  
>  	/*
> -	 * Check if sb_agblocks is aligned at stripe boundary
> -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> -	 * allocator alignment is within an ag, therefore ag has
> -	 * to be aligned at stripe boundary.
> +	 * If we were given new sunit/swidth options, do some basic validation
> +	 * checks and convert the incore dalign and swidth values to the
> +	 * same units (FSB) that everything else uses.  This /must/ happen
> +	 * before computing the inode geometry.
>  	 */
> -	error = xfs_update_alignment(mp);
> +	error = xfs_validate_new_dalign(mp);
>  	if (error)
>  		goto out;
>  
> @@ -664,6 +677,17 @@ xfs_mountfs(
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
> 

