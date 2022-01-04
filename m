Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3731C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiADXuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiADXuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:50:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2CDC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 15:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668B6615ED
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C172FC36AEB;
        Tue,  4 Jan 2022 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641340214;
        bh=tO1XTSL4cEU/+RAJsDiBilt0UcT+MsF9xZ1II7fWHNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cRZPPPRwDVZHZeF2bRhO/VwUvRZAN0oi2XG3w1GJ4aA5jJO9CsGQBpQHRPMJiES1t
         7HxwVlcY1exeYOcPmLJH+9cPHsxUSbeKmJuc89zsGm2uvojj8Yrnga3Z+w1FMmAkQN
         NPrjiyc3y6mFIZ5JL9nPyKCauAFkt5mTFBhguTBirH9zcU9wsJsW43ALcVkMNeYXEs
         YJTD9h7N7WBo6haqMBVgu3sxVj8fbDZNZjQ7CqIBfTYR+wUCuz8Wi7Nr5kYIAygA4E
         syKZI9opX3YHneAT7mNBXVda3S9PP+ymjYgO7I+UJd+tP0eJ0y8jt0SIJ4yxVZbS1t
         XJ6Xy/NRDNZSg==
Date:   Tue, 4 Jan 2022 15:50:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 05/16] xfs: Use basic types to define xfs_log_dinode's
 di_nextents and di_anextents
Message-ID: <20220104235014.GL31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-6-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-6-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:08PM +0530, Chandan Babu R wrote:
> A future commit will increase the width of xfs_extnum_t in order to facilitate
> larger per-inode extent counters. Hence this patch now uses basic types to
> define xfs_log_dinode->[di_nextents|dianextents].
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

I wonder how this didn't trip the xfs_ondisk.h checks in the last
revision of the patches, but ... who cares, let's see what I think of
how /this/ version handles the field enlargements.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b322db523d65..fd66e70248f7 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -396,8 +396,8 @@ struct xfs_log_dinode {
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> +	uint32_t	di_nextents;	/* number of extents in data fork */
> +	uint16_t	di_anextents;	/* number of extents in attribute fork*/
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> -- 
> 2.30.2
> 
