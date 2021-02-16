Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055A4C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B176964DFF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhBPMUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:20:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhBPMUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 07:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613477918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1cYBqxEwx0gGvjHzjEIrWbz6gpvjrR5EXpW2/t7tflU=;
        b=Jz/rsE9zOrOxm0/O7SfWvk9N2Yd3WvnMm7mCaMmxy2Xm6er5mxFNJ7kWXUx0BZoR4GeluM
        INd1COr2t/aLDBYFhMXgOQUb5s+uTD0HKsAdlPbd0jYROjFz6NJ4Nalgu5fg1OzfUTNPoT
        AqZgzWu0Qto/4Rdh5/k5/vGZyEPQBUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-JPk0idx7PuqsFg5bdsw3CA-1; Tue, 16 Feb 2021 07:18:34 -0500
X-MC-Unique: JPk0idx7PuqsFg5bdsw3CA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 089911934100;
        Tue, 16 Feb 2021 12:18:33 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6905E60C15;
        Tue, 16 Feb 2021 12:18:32 +0000 (UTC)
Date:   Tue, 16 Feb 2021 07:18:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: enable inobtcount upgrade via repair
Message-ID: <20210216121830.GF534175@bfoster>
References: <161319522350.423010.5768275226481994478.stgit@magnolia>
 <161319524563.423010.7140989505952004894.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319524563.423010.7140989505952004894.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:47:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use xfs_repair to add the inode btree counter feature to a filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  man/man8/xfs_admin.8 |   11 ++++++++++-
>  repair/globals.c     |    1 +
>  repair/globals.h     |    1 +
>  repair/phase2.c      |   30 ++++++++++++++++++++++++++++++
>  repair/xfs_repair.c  |   11 +++++++++++
>  5 files changed, 53 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index ae661648..4ba718d8 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -136,7 +136,16 @@ without the
>  .BR -n )
>  must be followed to clean the filesystem.
>  .IP
> -There are no feature options currently.
> +Supported features are as follows:
> +.RS 0.7i
> +.TP 0.4i
> +.B inobtcount
> +Keep a count the number of blocks in each inode btree in the AGI.
> +This reduces mount time by speeding up metadata space reservation calculations.
> +The filesystem cannot be downgraded after this feature is enabled.
> +Once enabled, the filesystem will not be writable by older kernels.
> +This feature was added to Linux 5.10.
> +.RE
>  .TP
>  .BI \-U " uuid"
>  Set the UUID of the filesystem to
> diff --git a/repair/globals.c b/repair/globals.c
> index 537d068b..47d90bd3 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -48,6 +48,7 @@ char	*rt_name;		/* Name of realtime device */
>  int	rt_spec;		/* Realtime dev specified as option */
>  int	convert_lazy_count;	/* Convert lazy-count mode on/off */
>  int	lazy_count;		/* What to set if to if converting */
> +bool	add_inobtcount;		/* add inode btree counts to AGI */
>  
>  /* misc status variables */
>  
> diff --git a/repair/globals.h b/repair/globals.h
> index a9287320..5b6fe4d4 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -89,6 +89,7 @@ extern char	*rt_name;		/* Name of realtime device */
>  extern int	rt_spec;		/* Realtime dev specified as option */
>  extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
>  extern int	lazy_count;		/* What to set if to if converting */
> +extern bool	add_inobtcount;		/* add inode btree counts to AGI */
>  
>  /* misc status variables */
>  
> diff --git a/repair/phase2.c b/repair/phase2.c
> index f654edcc..96074a1d 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -131,6 +131,33 @@ zero_log(
>  		libxfs_max_lsn = log->l_last_sync_lsn;
>  }
>  
> +static bool
> +set_inobtcount(
> +	struct xfs_mount	*mp)
> +{
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		printf(
> +	_("Inode btree count feature only supported on V5 filesystems.\n"));
> +		exit(0);
> +	}
> +
> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		printf(
> +	_("Inode btree count feature requires free inode btree.\n"));
> +		exit(0);
> +	}
> +
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		printf(_("Filesystem already has inode btree counts.\n"));
> +		exit(0);
> +	}
> +
> +	printf(_("Adding inode btree counts to filesystem.\n"));
> +	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> +	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +	return true;
> +}
> +
>  /* Perform the user's requested upgrades on filesystem. */
>  static void
>  upgrade_filesystem(
> @@ -140,6 +167,9 @@ upgrade_filesystem(
>  	bool			dirty = false;
>  	int			error;
>  
> +	if (add_inobtcount)
> +		dirty |= set_inobtcount(mp);
> +
>          if (no_modify || !dirty)
>                  return;
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 6b60b8f4..2d9dca6b 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -65,11 +65,13 @@ static char *o_opts[] = {
>   */
>  enum c_opt_nums {
>  	CONVERT_LAZY_COUNT = 0,
> +	CONVERT_INOBTCOUNT,
>  	C_MAX_OPTS,
>  };
>  
>  static char *c_opts[] = {
>  	[CONVERT_LAZY_COUNT]	= "lazycount",
> +	[CONVERT_INOBTCOUNT]	= "inobtcount",
>  	[C_MAX_OPTS]		= NULL,
>  };
>  
> @@ -302,6 +304,15 @@ process_args(int argc, char **argv)
>  					lazy_count = (int)strtol(val, NULL, 0);
>  					convert_lazy_count = 1;
>  					break;
> +				case CONVERT_INOBTCOUNT:
> +					if (!val)
> +						do_abort(
> +		_("-c inobtcount requires a parameter\n"));
> +					if (strtol(val, NULL, 0) != 1)
> +						do_abort(
> +		_("-c inobtcount only supports upgrades\n"));
> +					add_inobtcount = true;
> +					break;
>  				default:
>  					unknown('c', val);
>  					break;
> 

