Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059ABC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 17:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67A661A13
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 17:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhCZRrp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhCZRrZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 13:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0468961A13;
        Fri, 26 Mar 2021 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616780845;
        bh=gNG0p5P140Hn2+YmQf1sgh4HmO+tVyC8LUYOTurhMcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rv1K1lp2EAA7wAOYVIZSQXWB5asiZeNifyiBMxFQfRAF+lL5+Ov+/OI756Ml7WvvX
         FnPVtjvMMpeZxuB/AaWawm/MnaHMtZLPI0xl0WniI4Aud1ypygIQlIlaiQvqQQH8VI
         FRkP1dNzKf8BeNl0F9oAq8Ph6Qpzy2oUGBNF4aV/WttJM/OJuW9453fKzaBtI9DvDS
         uv7jNlohc2I89uihkazn5wlhdx5RLAdrWwLrpGmwIwx56/Kpzg4JWCDlpXfsrDvijS
         5sjg0jdgnJB3L0Kpgs4inr/ZJ2eSjFIZTVWmEjOH7DAwBPJmfj3MlvEvrTkl1DjAa6
         6HG1V25+mKimw==
Date:   Fri, 26 Mar 2021 10:47:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: Remove incorrect check executed on block
 format directories
Message-ID: <20210326174724.GZ4090233@magnolia>
References: <20210326113312.983-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326113312.983-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 05:03:12PM +0530, Chandan Babu R wrote:
> A directory with one directory block which in turns consists of two or more fs
> blocks is incorrectly flagged as corrupt by scrub since it assumes that
> "Block" format directories have a data fork single extent spanning the file
> offset range of [0, Dir block size - 1].
> 
> This commit fixes the bug by removing the incorrect check.

It took me a minute to figure out that this isn't merely removing a
check that triggered somewhere; the check is incorrect /and/ redundant
because xfs_dir2_isblock sets is_block based on what it finds in the
iext tree, so it makes no sense to check that result against the iext
tree at all.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/scrub/dir.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 178b3455a170..3ec6290c78bb 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -694,15 +694,6 @@ xchk_directory_blocks(
>  	/* Iterate all the data extents in the directory... */
>  	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
>  	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
> -		/* Block directories only have a single block at offset 0. */
> -		if (is_block &&
> -		    (got.br_startoff > 0 ||
> -		     got.br_blockcount != args.geo->fsbcount)) {
> -			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
> -					got.br_startoff);
> -			break;
> -		}
> -
>  		/* No more data blocks... */
>  		if (got.br_startoff >= leaf_lblk)
>  			break;
> -- 
> 2.29.2
> 
