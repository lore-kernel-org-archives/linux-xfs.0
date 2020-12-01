Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3026AC64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B618322247
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bu8e2+xV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391812AbgLAQTp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:19:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390841AbgLAQTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606839498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DY6Usj3XRI2SgIkG2OSPdNbNPI1rpvVRC+OD/44zEk8=;
        b=Bu8e2+xVRI/kzp0BpphuwYnlQb8oK8VPLfK+Du22fg4N3wUjE3ScjlhlAg/AsHBbGPq2TC
        93r8ie2O9KrTekg6T+Q3QdccnVy8jdZsZV1qp9lma/OMo/u208wq3XGTtd+CT4Dj3an79/
        Y8dVyshgQbnmuXtd43se5pJNmgtnn1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-NNB2Q5qkNGOW-g6MHxQ4xA-1; Tue, 01 Dec 2020 11:18:16 -0500
X-MC-Unique: NNB2Q5qkNGOW-g6MHxQ4xA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2D4110074CE;
        Tue,  1 Dec 2020 16:18:14 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8507F60BD8;
        Tue,  1 Dec 2020 16:18:14 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:18:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201201161812.GD1205666@bfoster>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385127.447856.3129099457617444604.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679385127.447856.3129099457617444604.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define an incompat feature flag to indicate that the filesystem needs to
> be repaired.  While libxfs will recognize this feature, the kernel will
> refuse to mount if the feature flag is set, and only xfs_repair will be
> able to clear the flag.  The goal here is to force the admin to run
> xfs_repair to completion after upgrading the filesystem, or if we
> otherwise detect anomalies.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

IIUC, we're using an incompat bit to intentionally ensure the filesystem
cannot mount, even on kernels that predate this particular "needs
repair" feature. The only difference is that an older kernel would
complain about an unknown feature and return a different error code.
Right?

That seems reasonable, but out of curiousity is there a need/reason for
using an incompat bit over an ro_compat bit?

Brian

>  fs/xfs/libxfs/xfs_format.h |    7 +++++++
>  fs/xfs/xfs_mount.c         |    6 ++++++
>  2 files changed, 13 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd764da08f6f..5d8ba609ac0b 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -468,6 +468,7 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
> +#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> @@ -584,6 +585,12 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
>  }
>  
> +static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7bc7901d648d..2853ad49b27d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -266,6 +266,12 @@ xfs_sb_validate_mount(
>  	struct xfs_buf		*bp,
>  	struct xfs_sb		*sbp)
>  {
> +	/* Filesystem claims it needs repair, so refuse the mount. */
> +	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * Don't touch the filesystem if a user tool thinks it owns the primary
>  	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> 

