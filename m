Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E178C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiAEBN6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiAEBN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:13:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8F5C061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 17:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88144614BB
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25C9C36AE0;
        Wed,  5 Jan 2022 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641345237;
        bh=n8fdZO73xh4/vPsZ/BL4dmgJfRDX+Hz6Pc5oShgUxU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I7h/a2EvBqS471jGWG9/5A+q0Q+shc5YkPz4iyTt/sIjsx6+7OQqcfaFfizaIlL9Z
         DvZFhP6wjIJuTqU60j26FOh5cvUwpdKPxqkW/KB7vEQnhfb8CpuD3WS4a+muNhVGK2
         J18TIA/0sBuUn5WwyU3UzRgZ9xMKGgg0mFzpxMdwcHqMFtwVf13t2yHqNMbvEvnAbD
         7+oflZCL3aL9xNVIBhgtEwD5b5833KpDZIoe3r8BW7jSke0BzZdrBsBdpSiNbunjbt
         0lQppLRXEY5L12KID7uCZlImTz2UQjJlWMVj2Y70oQjY6bpaTHtzrieLIfW5mC057o
         D0+kTUyRunF/A==
Date:   Tue, 4 Jan 2022 17:13:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 17/20] xfsprogs: xfs_info: Report NREXT64 feature
 status
Message-ID: <20220105011356.GD656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084811.764481-18-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:18:08PM +0530, Chandan Babu R wrote:
> This commit adds support to libfrog to obtain information about the
> availability of NREXT64 feature in the underlying filesystem.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  libfrog/fsgeom.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 4f1a1842..3e7f0797 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -30,6 +30,7 @@ xfs_report_geom(
>  	int			reflink_enabled;
>  	int			bigtime_enabled;
>  	int			inobtcount;
> +	int			nrext64;
>  
>  	isint = geo->logstart > 0;
>  	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
> @@ -47,12 +48,13 @@ xfs_report_geom(
>  	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
>  	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
>  	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
> +	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
>  
>  	printf(_(
>  "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
>  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
>  "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
> -"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
> +"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
>  "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  "         =%-22s sunit=%-6u swidth=%u blks\n"
>  "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
> @@ -62,7 +64,7 @@ xfs_report_geom(
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> -		"", reflink_enabled, bigtime_enabled, inobtcount,
> +		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
>  		"", geo->blocksize, (unsigned long long)geo->datablocks,
>  			geo->imaxpct,
>  		"", geo->sunit, geo->swidth,
> -- 
> 2.30.2
> 
