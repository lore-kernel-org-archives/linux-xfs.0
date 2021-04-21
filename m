Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346C4C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD10D6144B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhDUPzw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234894AbhDUPzt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 11:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B62646144A;
        Wed, 21 Apr 2021 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619020514;
        bh=PacKwmEx3fiGwm1ZzmvQiBEquM/NQDjD1STIB1i2thE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TWrE5WZ5JWNKE6WTM9qVN0KvlFWjIQMCtoYoDvqNlxQ+LFGGpWJQh9OxGuQ7QCjUH
         CmWW73VA3HACoL0lBaT+CzaaGXdmapE+9QWlCHtU9ixvuZw78rQYfoK38ehBCFTIyK
         xyP1JMyLJbKQ26C4/QV5vdhbuQPIFvqyXiU2s4Ig2sdZyoA0GK//6+IqyLAKhVbyEM
         Qp+tsmb0RE1BGHbikIgN/faut7tgfWDdjs5jUgceoTrOo4je3TYIKiRKKd22+alOYF
         s49v6z5ZsR2AQ/vY8APWty09iRRUs5u0cPLrrFmVc0/7rgsv/dZiKDpLvcPTSwAF3e
         2PBu7hUzZvQhQ==
Date:   Wed, 21 Apr 2021 08:55:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs: warn out the V4 format
Message-ID: <20210421155514.GS3122264@magnolia>
References: <20210421085716.3144357-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421085716.3144357-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 04:57:16PM +0800, Gao Xiang wrote:
> Kernel commit b96cb835e37c ("xfs: deprecate the V4 format") started
> the process of retiring the old format to close off attack surfaces
> and to encourage users to migrate onto V5.
> 
> This also prints warning to users when mkfs as well.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks fine to me; but does this cause any golden output failures in
fstests?

--D

> ---
>  mkfs/xfs_mkfs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0eac5336..ef09f8b3 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4022,6 +4022,10 @@ main(
>  	validate_extsize_hint(mp, &cli);
>  	validate_cowextsize_hint(mp, &cli);
>  
> +	if (!cli.sb_feat.crcs_enabled)
> +		fprintf(stderr,
> +_("Deprecated V4 format (-mcrc=0) will not be supported after September 2030.\n"));
> +
>  	/* Print the intended geometry of the fs. */
>  	if (!quiet || dry_run) {
>  		struct xfs_fsop_geom	geo;
> -- 
> 2.27.0
> 
