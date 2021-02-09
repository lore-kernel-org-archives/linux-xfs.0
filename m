Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADB7C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26DC164E15
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBIRjL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:39:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233295AbhBIRhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:37:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612892139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2q43GRgwR7HZKQMWir7ZbVctQLznNQzzmZQMlUsFRE=;
        b=JYDGPrOhRFIiKtthSv5385pqEbMZWiioT8+jmQ7YuLgXvweWD9qrrfVYEon+6rQ543iK7k
        OWF268NIeP4lo0A4tq8N4hQwv9oRy2aCDUDmh9DiDs5z7DF/gx//0aNwu8aSdRatBDQxzE
        vcJto1vtKdTJyyEYDElYD2yuO50NlVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-l8wiIFmZMT-mtoWlm5seCQ-1; Tue, 09 Feb 2021 12:35:36 -0500
X-MC-Unique: l8wiIFmZMT-mtoWlm5seCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32901195D565;
        Tue,  9 Feb 2021 17:35:35 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFCD660C4D;
        Tue,  9 Feb 2021 17:35:34 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:35:32 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs_repair: enable bigtime upgrade via repair
Message-ID: <20210209173532.GJ14273@bfoster>
References: <161284386265.3058138.14199712814454514885.stgit@magnolia>
 <161284387398.3058138.5317754248430984165.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284387398.3058138.5317754248430984165.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upgrade existing V5 filesystems to support large timestamps up to 2486.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  man/man8/xfs_admin.8 |    6 ++++++
>  repair/globals.c     |    1 +
>  repair/globals.h     |    1 +
>  repair/phase1.c      |   23 +++++++++++++++++++++++
>  repair/xfs_repair.c  |   11 +++++++++++
>  5 files changed, 42 insertions(+)
> 
> 
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index da05171d..13d71643 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -135,6 +135,12 @@ This reduces mount time by speeding up metadata space reservation calculations.
>  The filesystem cannot be downgraded after this feature is enabled.
>  Once enabled, the filesystem will not be writable by older kernels.
>  This feature was added to Linux 5.10.
> +.TP 0.4i
> +.B bigtime
> +Upgrade a filesystem to support larger timestamps up to the year 2486.
> +The filesystem cannot be downgraded after this feature is enabled.
> +Once enabled, the filesystem will not be mountable by older kernels.
> +This feature was added to Linux 5.10.
>  .RE
>  .TP
>  .BI \-U " uuid"
> diff --git a/repair/globals.c b/repair/globals.c
> index 89063b10..28f0b6a0 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -52,6 +52,7 @@ int	lazy_count;		/* What to set if to if converting */
>  
>  bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
>  bool	add_inobtcount;		/* add inode btree counts to AGI */
> +bool	add_bigtime;		/* add support for timestamps up to 2486 */
>  
>  /* misc status variables */
>  
> diff --git a/repair/globals.h b/repair/globals.h
> index a0051794..be784cf6 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -94,6 +94,7 @@ extern int	lazy_count;		/* What to set if to if converting */
>  
>  extern bool	add_needsrepair;
>  extern bool	add_inobtcount;
> +extern bool	add_bigtime;
>  
>  /* misc status variables */
>  
> diff --git a/repair/phase1.c b/repair/phase1.c
> index 96661c6b..89056215 100644
> --- a/repair/phase1.c
> +++ b/repair/phase1.c
> @@ -77,6 +77,27 @@ set_inobtcount(
>  	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
>  }
>  
> +static void
> +set_bigtime(
> +	struct xfs_sb	*sb)
> +{
> +	if (!xfs_sb_version_hascrc(sb)) {
> +		printf(
> +	_("Large timestamp feature only supported on V5 filesystems.\n"));
> +		exit(0);
> +	}
> +
> +	if (xfs_sb_version_hasbigtime(sb)) {
> +		printf(_("Filesystem already supports large timestamps.\n"));
> +		return;
> +	}
> +
> +	printf(_("Adding large timestamp support to filesystem.\n"));
> +	primary_sb_modified = 1;
> +	sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
> +				     XFS_SB_FEAT_INCOMPAT_BIGTIME);
> +}
> +
>  /*
>   * this has got to be big enough to hold 4 sectors
>   */
> @@ -177,6 +198,8 @@ _("Cannot disable lazy-counters on V5 fs\n"));
>  		set_needsrepair(sb);
>  	if (add_inobtcount)
>  		set_inobtcount(sb);
> +	if (add_bigtime)
> +		set_bigtime(sb);
>  
>  	/* shared_vn should be zero */
>  	if (sb->sb_shared_vn) {
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 0ff2e2bc..60f97e8c 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -69,6 +69,7 @@ enum c_opt_nums {
>  	CONVERT_LAZY_COUNT = 0,
>  	CONVERT_NEEDSREPAIR,
>  	CONVERT_INOBTCOUNT,
> +	CONVERT_BIGTIME,
>  	C_MAX_OPTS,
>  };
>  
> @@ -76,6 +77,7 @@ static char *c_opts[] = {
>  	[CONVERT_LAZY_COUNT]	= "lazycount",
>  	[CONVERT_NEEDSREPAIR]	= "needsrepair",
>  	[CONVERT_INOBTCOUNT]	= "inobtcount",
> +	[CONVERT_BIGTIME]	= "bigtime",
>  	[C_MAX_OPTS]		= NULL,
>  };
>  
> @@ -327,6 +329,15 @@ process_args(int argc, char **argv)
>  		_("-c inobtcount only supports upgrades\n"));
>  					add_inobtcount = true;
>  					break;
> +				case CONVERT_BIGTIME:
> +					if (!val)
> +						do_abort(
> +		_("-c bigtime requires a parameter\n"));
> +					if (strtol(val, NULL, 0) != 1)
> +						do_abort(
> +		_("-c bigtime only supports upgrades\n"));
> +					add_bigtime = true;
> +					break;
>  				default:
>  					unknown('c', val);
>  					break;
> 

