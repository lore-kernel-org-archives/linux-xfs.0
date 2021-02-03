Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DDFC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AECE64F91
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhBCOna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:43:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232322AbhBCOn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 09:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612363323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8i2w2q1nUk7x+ydlpBkpZYERE8cbcmIMT+4KP4ZHs0=;
        b=akfZ3RpOg6J9/6/RIy/Eg8HyEbdVqNsIuKeQhnVhR9nHYu2OwQpDLy+67ooCnnQtxLQVr/
        k3i42NKiVYXH9Ydgx0LNdC59dYr2NcJc+ZkInFDn20GsbNs9LtsFzyq/Vn6aIMg109dN8G
        KMC1Pz5lsFPnTy0sEpC2W9Qi05igOBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-y0LL8L5-OQ2fTvpKUWANLg-1; Wed, 03 Feb 2021 09:41:59 -0500
X-MC-Unique: y0LL8L5-OQ2fTvpKUWANLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E84F1014E72;
        Wed,  3 Feb 2021 14:41:58 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1CD18B42;
        Wed,  3 Feb 2021 14:41:57 +0000 (UTC)
Date:   Wed, 3 Feb 2021 09:41:55 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, chandanrlinux@gmail.com
Subject: Re: [PATCH] xfs: fix incorrect root dquot corruption error when
 switching group/project quota types
Message-ID: <20210203144155.GD3647012@bfoster>
References: <20210202193945.GP7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202193945.GP7193@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 11:39:45AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While writing up a regression test for broken behavior when a chprojid
> request fails, I noticed that we were logging corruption notices about
> the root dquot of the group/project quota file at mount time when
> testing V4 filesystems.
> 
> In commit afeda6000b0c, I was trying to improve ondisk dquot validation
> by making sure that when we load an ondisk dquot into memory on behalf
> of an incore dquot, the dquot id and type matches.  Unfortunately, I
> forgot that V4 filesystems only have two quota files, and can switch
> that file between group and project quota types at mount time.  When we
> perform that switch, we'll try to load the default quota limits from the
> root dquot prior to running quotacheck and log a corruption error when
> the types don't match.
> 
> This is inconsequential because quotacheck will reset the second quota
> file as part of doing the switch, but we shouldn't leave scary messages
> in the kernel log.
> 
> Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.c |   39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 175f544f7c45..bd8379b98374 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -506,6 +506,42 @@ xfs_dquot_alloc(
>  	return dqp;
>  }
>  
> +/* Check the ondisk dquot's id and type match what the incore dquot expects. */
> +static bool
> +xfs_dquot_check_type(
> +	struct xfs_dquot	*dqp,
> +	struct xfs_disk_dquot	*ddqp)
> +{
> +	uint8_t			ddqp_type;
> +	uint8_t			dqp_type;
> +
> +	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
> +	dqp_type = xfs_dquot_type(dqp);
> +
> +	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
> +		return false;
> +
> +	/*
> +	 * V5 filesystems always expect an exact type match.  V4 filesystems
> +	 * expect an exact match for user dquots and for non-root group and
> +	 * project dquots.
> +	 */
> +	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
> +	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
> +		return ddqp_type == dqp_type;
> +
> +	/*
> +	 * V4 filesystems support either group or project quotas, but not both
> +	 * at the same time.  The non-user quota file can be switched between
> +	 * group and project quota uses depending on the mount options, which
> +	 * means that we can encounter the other type when we try to load quota
> +	 * defaults.  Quotacheck will soon reset the the entire quota file
> +	 * (including the root dquot) anyway, but don't log scary corruption
> +	 * reports to dmesg.
> +	 */
> +	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
> +}
> +
>  /* Copy the in-core quota fields in from the on-disk buffer. */
>  STATIC int
>  xfs_dquot_from_disk(
> @@ -518,8 +554,7 @@ xfs_dquot_from_disk(
>  	 * Ensure that we got the type and ID we were looking for.
>  	 * Everything else was checked by the dquot buffer verifier.
>  	 */
> -	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
> -	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
> +	if (!xfs_dquot_check_type(dqp, ddqp)) {
>  		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
>  			  "Metadata corruption detected at %pS, quota %u",
>  			  __this_address, dqp->q_id);
> 

