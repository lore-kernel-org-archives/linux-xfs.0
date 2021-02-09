Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB329C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796A964E85
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhBIRXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:23:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232909AbhBIRXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:23:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BCvNm54ZDx0oti/4WMwpwl/6F0TEkSlDf/GYk4XD7lg=;
        b=jPwqjMcoweKj86VL6eCK/g9jADFl+Svqi2s7aMExptbzVwtX0gDzoNFiK/QmXYEWu+I1+g
        AZ06aeNIPtTotrVolxLe0mLyod7OTdUiY9P+tnx0CWZqQYbXcQnNK6wnQ1QESthfx87Er+
        JHaY1OpfU4O4iodU+XDqIrlxxfvuphc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-Ne4IxzICPCaIopxXSuQxww-1; Tue, 09 Feb 2021 12:21:34 -0500
X-MC-Unique: Ne4IxzICPCaIopxXSuQxww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 688BBBBEE3;
        Tue,  9 Feb 2021 17:21:33 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBC5E179B3;
        Tue,  9 Feb 2021 17:21:32 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:21:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <20210209172131.GG14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284385516.3057868.355176047687079022.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Simulate a crash when anyone calls force_needsrepair.  This is a debug
> knob so that we can test that the kernel won't mount after setting
> needsrepair and that a re-run of xfs_repair will clear the flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Can't we just use db to manually set the bit on the superblock?

Brian

>  repair/globals.c    |    1 +
>  repair/globals.h    |    2 ++
>  repair/phase1.c     |    5 +++++
>  repair/xfs_repair.c |    7 +++++++
>  4 files changed, 15 insertions(+)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index 699a96ee..b0e23864 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -40,6 +40,7 @@ int	dangerously;		/* live dangerously ... fix ro mount */
>  int	isa_file;
>  int	zap_log;
>  int	dumpcore;		/* abort, not exit on fatal errs */
> +bool	abort_after_force_needsrepair;
>  int	force_geo;		/* can set geo on low confidence info */
>  int	assume_xfs;		/* assume we have an xfs fs */
>  char	*log_name;		/* Name of log device */
> diff --git a/repair/globals.h b/repair/globals.h
> index 043b3e8e..9fa73b2c 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -82,6 +82,8 @@ extern int	isa_file;
>  extern int	zap_log;
>  extern int	dumpcore;		/* abort, not exit on fatal errs */
>  extern int	force_geo;		/* can set geo on low confidence info */
> +/* Abort after forcing NEEDSREPAIR to test its functionality */
> +extern bool	abort_after_force_needsrepair;
>  extern int	assume_xfs;		/* assume we have an xfs fs */
>  extern char	*log_name;		/* Name of log device */
>  extern int	log_spec;		/* Log dev specified as option */
> diff --git a/repair/phase1.c b/repair/phase1.c
> index b26d25f8..57f72cd0 100644
> --- a/repair/phase1.c
> +++ b/repair/phase1.c
> @@ -170,5 +170,10 @@ _("Cannot disable lazy-counters on V5 fs\n"));
>  	 */
>  	sb_ifree = sb_icount = sb_fdblocks = sb_frextents = 0;
>  
> +	/* Simulate a crash after setting needsrepair. */
> +	if (primary_sb_modified && add_needsrepair &&
> +	    abort_after_force_needsrepair)
> +		exit(55);
> +
>  	free(sb);
>  }
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ee377e8a..ae7106a6 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -44,6 +44,7 @@ enum o_opt_nums {
>  	BLOAD_LEAF_SLACK,
>  	BLOAD_NODE_SLACK,
>  	NOQUOTA,
> +	FORCE_NEEDSREPAIR_ABORT,
>  	O_MAX_OPTS,
>  };
>  
> @@ -57,6 +58,7 @@ static char *o_opts[] = {
>  	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
>  	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
>  	[NOQUOTA]		= "noquota",
> +	[FORCE_NEEDSREPAIR_ABORT] = "debug_force_needsrepair_abort",
>  	[O_MAX_OPTS]		= NULL,
>  };
>  
> @@ -282,6 +284,9 @@ process_args(int argc, char **argv)
>  		_("-o debug_bload_node_slack requires a parameter\n"));
>  					bload_node_slack = (int)strtol(val, NULL, 0);
>  					break;
> +				case FORCE_NEEDSREPAIR_ABORT:
> +					abort_after_force_needsrepair = true;
> +					break;
>  				case NOQUOTA:
>  					quotacheck_skip();
>  					break;
> @@ -795,6 +800,8 @@ force_needsrepair(
>  		error = -libxfs_bwrite(bp);
>  		if (error)
>  			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> +		if (abort_after_force_needsrepair)
> +			exit(55);
>  	}
>  	if (bp)
>  		libxfs_buf_relse(bp);
> 

