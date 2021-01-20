Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DADC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873BA233EB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbhATSqZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:46:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388965AbhATRj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 12:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611164313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L4k6mYOUBvekOQSxfNUv8CxiBqTioNGNisyLbIZ0ifA=;
        b=T7BBVvPoY2AL79ztbTvENcxf2WFLGX4QPuT/jERCJn7GXFEUxJJLfCEDfOXp1OQsCN9ahz
        M/RvETs2Ur/CInx8Xy5NXQL42fDCdQWNGypHhLCDntfqMIxwBToIBm8AKj80OFwrsHu9ks
        7/t0J4g4WqgIlu27M4fw5swkKmrt4sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-DfxDD0MwP4eY3YvvVJT2JQ-1; Wed, 20 Jan 2021 12:38:31 -0500
X-MC-Unique: DfxDD0MwP4eY3YvvVJT2JQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04A4A1800D42;
        Wed, 20 Jan 2021 17:38:30 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F6B35D6AD;
        Wed, 20 Jan 2021 17:38:28 +0000 (UTC)
Date:   Wed, 20 Jan 2021 12:38:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2.1 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210120173820.GA1722880@bfoster>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
 <20210120043128.GX3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120043128.GX3134581@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 08:31:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2.1: only remove needsrepair at the end of the xfs_repair run
> ---
>  include/xfs_mount.h |    1 +
>  libxfs/init.c       |    2 +-
>  repair/agheader.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/agheader.h   |    2 ++
>  repair/xfs_repair.c |    4 +++-
>  5 files changed, 62 insertions(+), 2 deletions(-)
> 
...
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 8bb99489..56a7f45c 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -220,6 +220,40 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
>  	return(XR_OK);
>  }
>  
> +/* Clear needsrepair after a successful repair run. */
> +int
> +clear_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (!xfs_sb_version_needsrepair(&mp->m_sb) || no_modify)
> +		return 0;
> +
> +	/* We must succeed at flushing all dirty buffers to disk. */
> +	error = -libxfs_flush_mount(mp);
> +	if (error)
> +		return error;
> +

Do we really need a new helper and buf get/relse cycle just to
incorporate the above flush? ISTM we could either lift the
libxfs_bcache_flush() call above the superblock update in the caller,
insert the libxfs_flush_mount() right after that, and just do:

	dsb->sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;

... in the hunk that also updates the quota flags.

Though perhaps cleaner would be to keep the helper, but genericize it a
bit to something like final_sb_update() and fold in the qflags update
and whatever flush/ordering is required for the feature bit.

> +	/* Clear needsrepair from the superblock. */
> +	bp = libxfs_getsb(mp);
> +	if (!bp)
> +		return ENOMEM;
> +	if (bp->b_error) {
> +		error = bp->b_error;
> +		libxfs_buf_relse(bp);
> +		return -error;
> +	}
> +
> +	mp->m_sb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +
> +	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +	libxfs_buf_mark_dirty(bp);
> +	libxfs_buf_relse(bp);
> +	return 0;
> +}
> +
>  /*
>   * Possible fields that may have been set at mkfs time,
>   * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
> @@ -452,6 +486,27 @@ secondary_sb_whack(
>  			rval |= XR_AG_SB_SEC;
>  	}
>  
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (!no_modify)
> +			sb->sb_features_incompat &=
> +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;

I suspect this should be folded into the check below so we don't modify
the primary sb by accident (should some other check dirty it).

Brian

> +		if (i == 0) {
> +			if (!no_modify)
> +				do_warn(
> +	_("clearing needsrepair flag and regenerating metadata\n"));
> +			else
> +				do_warn(
> +	_("would clear needsrepair flag and regenerate metadata\n"));
> +		} else {
> +			/*
> +			 * Quietly clear needsrepair on the secondary supers as
> +			 * part of ensuring them.  If needsrepair is set on the
> +			 * primary, it will be done at the very end of repair.
> +			 */
> +			rval |= XR_AG_SB_SEC;
> +		}
> +	}
> +
>  	return(rval);
>  }
>  
> diff --git a/repair/agheader.h b/repair/agheader.h
> index a63827c8..552c1f70 100644
> --- a/repair/agheader.h
> +++ b/repair/agheader.h
> @@ -82,3 +82,5 @@ typedef struct fs_geo_list  {
>  #define XR_AG_AGF	0x2
>  #define XR_AG_AGI	0x4
>  #define XR_AG_SB_SEC	0x8
> +
> +int clear_needsrepair(struct xfs_mount *mp);
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9409f0d8..d36c5a21 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1133,7 +1133,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	format_log_max_lsn(mp);
>  
>  	/* Report failure if anything failed to get written to our fs. */
> -	error = -libxfs_umount(mp);
> +	error = clear_needsrepair(mp);
> +	if (!error)
> +		error = -libxfs_umount(mp);
>  	if (error)
>  		do_error(
>  	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
> 

