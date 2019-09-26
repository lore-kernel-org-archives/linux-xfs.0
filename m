Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A35EC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 17:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DFD6222C3
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 17:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfIZRhT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 13:37:19 -0400
Received: from sandeen.net ([63.231.237.45]:53844 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZRhS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 13:37:18 -0400
Received: from Liberator-6.hsd1.mn.comcast.net (c-174-53-190-166.hsd1.mn.comcast.net [174.53.190.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2C2E6544;
        Thu, 26 Sep 2019 12:37:07 -0500 (CDT)
Subject: Re: [PATCH 4/5] xfs_scrub: separate internal metadata scrub functions
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156944706528.296129.7604742756772046951.stgit@magnolia>
 <156944708984.296129.4265304780428958376.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <e44fb1e9-6d3f-4001-42f9-6bc75c0d428c@sandeen.net>
Date:   Thu, 26 Sep 2019 12:37:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <156944708984.296129.4265304780428958376.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/25/19 4:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_scrub_metadata into two functions -- one to make a single
> call xfs_check_metadata, and the second retains the loop logic.  The
> name is a little easy to confuse with other functions, so rename it to
> reflect what it actually does: scrub all internal metadata of a given
> class (AG header, AG metadata, FS metadata).  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/scrub.c |  101 +++++++++++++++++++++++++++++----------------------------
>  1 file changed, 52 insertions(+), 49 deletions(-)
> 

(V2: addressed Dave's minor nits about function names, updated comments)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index 083ed9a1..2557da2a 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -276,47 +276,68 @@ xfs_scrub_save_repair(
>  	return true;
>  }
>  
> -/* Scrub metadata, saving corruption reports for later. */
> +/* Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later. */
> +static int
> +xfs_scrub_meta_type(
> +	struct scrub_ctx		*ctx,
> +	unsigned int			type,
> +	xfs_agnumber_t			agno,
> +	struct xfs_action_list		*alist)
> +{
> +	struct xfs_scrub_metadata	meta = {
> +		.sm_type		= type,
> +		.sm_agno		= agno,
> +	};
> +	enum check_outcome		fix;
> +
> +	background_sleep();
> +
> +	/* Check the item. */
> +	fix = xfs_check_metadata(ctx, &meta, false);
> +	progress_add(1);
> +
> +	switch (fix) {
> +	case CHECK_ABORT:
> +		return ECANCELED;
> +	case CHECK_REPAIR:
> +		if (!xfs_scrub_save_repair(ctx, alist, &meta))
> +			return ENOMEM;
> +		/* fall through */
> +	case CHECK_DONE:
> +		return 0;
> +	default:
> +		/* CHECK_RETRY should never happen. */
> +		abort();
> +	}
> +}
> +
> +/*
> + * Scrub all metadata types that are assigned to the given XFROG_SCRUB_TYPE_*,
> + * saving corruption reports for later.  This should not be used for
> + * XFROG_SCRUB_TYPE_INODE or for checking summary metadata.
> + */
>  static bool
> -xfs_scrub_metadata(
> +xfs_scrub_all_types(
>  	struct scrub_ctx		*ctx,
>  	enum xfrog_scrub_type		scrub_type,
>  	xfs_agnumber_t			agno,
>  	struct xfs_action_list		*alist)
>  {
> -	struct xfs_scrub_metadata	meta = {0};
>  	const struct xfrog_scrub_descr	*sc;
> -	enum check_outcome		fix;
> -	int				type;
> +	unsigned int			type;
>  
>  	sc = xfrog_scrubbers;
>  	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
> +		int			ret;
> +
>  		if (sc->type != scrub_type)
>  			continue;
>  		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
>  			continue;
>  
> -		meta.sm_type = type;
> -		meta.sm_flags = 0;
> -		meta.sm_agno = agno;
> -		background_sleep();
> -
> -		/* Check the item. */
> -		fix = xfs_check_metadata(ctx, &meta, false);
> -		progress_add(1);
> -		switch (fix) {
> -		case CHECK_ABORT:
> +		ret = xfs_scrub_meta_type(ctx, type, agno, alist);
> +		if (ret)
>  			return false;
> -		case CHECK_REPAIR:
> -			if (!xfs_scrub_save_repair(ctx, alist, &meta))
> -				return false;
> -			/* fall through */
> -		case CHECK_DONE:
> -			continue;
> -		case CHECK_RETRY:
> -			abort();
> -			break;
> -		}
>  	}
>  
>  	return true;
> @@ -332,28 +353,10 @@ xfs_scrub_primary_super(
>  	struct scrub_ctx		*ctx,
>  	struct xfs_action_list		*alist)
>  {
> -	struct xfs_scrub_metadata	meta = {
> -		.sm_type = XFS_SCRUB_TYPE_SB,
> -	};
> -	enum check_outcome		fix;
> +	int				ret;
>  
> -	/* Check the item. */
> -	fix = xfs_check_metadata(ctx, &meta, false);
> -	switch (fix) {
> -	case CHECK_ABORT:
> -		return false;
> -	case CHECK_REPAIR:
> -		if (!xfs_scrub_save_repair(ctx, alist, &meta))
> -			return false;
> -		/* fall through */
> -	case CHECK_DONE:
> -		return true;
> -	case CHECK_RETRY:
> -		abort();
> -		break;
> -	}
> -
> -	return true;
> +	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
> +	return ret == 0;
>  }
>  
>  /* Scrub each AG's header blocks. */
> @@ -363,7 +366,7 @@ xfs_scrub_ag_headers(
>  	xfs_agnumber_t			agno,
>  	struct xfs_action_list		*alist)
>  {
> -	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
> +	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
>  }
>  
>  /* Scrub each AG's metadata btrees. */
> @@ -373,7 +376,7 @@ xfs_scrub_ag_metadata(
>  	xfs_agnumber_t			agno,
>  	struct xfs_action_list		*alist)
>  {
> -	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
> +	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
>  }
>  
>  /* Scrub whole-FS metadata btrees. */
> @@ -382,7 +385,7 @@ xfs_scrub_fs_metadata(
>  	struct scrub_ctx		*ctx,
>  	struct xfs_action_list		*alist)
>  {
> -	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
> +	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
>  }
>  
>  /* How many items do we have to check? */
> 
