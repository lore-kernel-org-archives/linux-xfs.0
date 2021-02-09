Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44440C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41E564EA6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhBIRXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:23:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231845AbhBIRXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7HqNct6GOkXnAAPChwUOyWEpZusngdeF3EtMPcxGajI=;
        b=hACZWj+Xl0vewuY2rKINtY1F7yNDbukaSuQG92M/R3oINpSeTGnsb1tBNbzydaXjaHSpNn
        wqIwk/tiQk/gI3Ha9ZIsWfk/r/Ayg0OhropcHCVtTeS3Hg+M02d+D82cqOgflDjP88UR0Y
        PyVYR1NqZyUZZx5o8bNtSlWDD7zxSSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24--EUa9IuHMZeF9tiBAUxCHw-1; Tue, 09 Feb 2021 12:21:24 -0500
X-MC-Unique: -EUa9IuHMZeF9tiBAUxCHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CB9281425C;
        Tue,  9 Feb 2021 17:21:23 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D655D9D0;
        Tue,  9 Feb 2021 17:21:23 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:21:21 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210209172121.GF14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284384955.3057868.8076509276356847362.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> program start and (presumably) clear it by the end of the run.  This
> code isn't terribly useful to users; it's mainly here so that fstests
> can exercise the functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/globals.c    |    2 ++
>  repair/globals.h    |    2 ++
>  repair/phase1.c     |   23 +++++++++++++++++++++++
>  repair/xfs_repair.c |    9 +++++++++
>  4 files changed, 36 insertions(+)
> 
> 
...
> diff --git a/repair/phase1.c b/repair/phase1.c
> index 00b98584..b26d25f8 100644
> --- a/repair/phase1.c
> +++ b/repair/phase1.c
> @@ -30,6 +30,26 @@ alloc_ag_buf(int size)
>  	return(bp);
>  }
>  
> +static void
> +set_needsrepair(
> +	struct xfs_sb	*sb)
> +{
> +	if (!xfs_sb_version_hascrc(sb)) {
> +		printf(
> +	_("needsrepair flag only supported on V5 filesystems.\n"));
> +		exit(0);
> +	}
> +
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		printf(_("Filesystem already marked as needing repair.\n"));
> +		return;
> +	}

Any reason this doesn't exit the repair like the lazy counter logic
does? Otherwise seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	printf(_("Marking filesystem in need of repair.\n"));
> +	primary_sb_modified = 1;
> +	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +}
> +
>  /*
>   * this has got to be big enough to hold 4 sectors
>   */
> @@ -126,6 +146,9 @@ _("Cannot disable lazy-counters on V5 fs\n"));
>  		}
>  	}
>  
> +	if (add_needsrepair)
> +		set_needsrepair(sb);
> +
>  	/* shared_vn should be zero */
>  	if (sb->sb_shared_vn) {
>  		do_warn(_("resetting shared_vn to zero\n"));
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9dc73854..ee377e8a 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -65,11 +65,13 @@ static char *o_opts[] = {
>   */
>  enum c_opt_nums {
>  	CONVERT_LAZY_COUNT = 0,
> +	CONVERT_NEEDSREPAIR,
>  	C_MAX_OPTS,
>  };
>  
>  static char *c_opts[] = {
>  	[CONVERT_LAZY_COUNT]	= "lazycount",
> +	[CONVERT_NEEDSREPAIR]	= "needsrepair",
>  	[C_MAX_OPTS]		= NULL,
>  };
>  
> @@ -302,6 +304,13 @@ process_args(int argc, char **argv)
>  					lazy_count = (int)strtol(val, NULL, 0);
>  					convert_lazy_count = 1;
>  					break;
> +				case CONVERT_NEEDSREPAIR:
> +					if (!val)
> +						do_abort(
> +		_("-c needsrepair requires a parameter\n"));
> +					if (strtol(val, NULL, 0) == 1)
> +						add_needsrepair = true;
> +					break;
>  				default:
>  					unknown('c', val);
>  					break;
> 

