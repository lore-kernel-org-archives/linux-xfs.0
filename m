Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DAAEB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjHAXuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjHAXuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:50:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568461B1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E009F6163C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B4C433C7;
        Tue,  1 Aug 2023 23:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690933800;
        bh=1mcOxtwdG/Zw/3H1e9qbl9FBRvQJ3pIFroy7bmNqdOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0e5cml7ttXSsKC1ruCkgbtvGConi/waepbpe+a5RfVhHLubNSORuZMjr9rwL+t0u
         5shhRoChe4SraRKOfbZ9BxGAUIKvJCyhmU5Y1P7cItD0LIGtlaEeg6gK4/cjL8Lr31
         /4p/yxRCBHIrCvhjclATGMXE/F8d9icc+ewz+7alcDcFfRvSTeB77t0b75H6lNukSY
         PKulfFdzbdPY8ZltJypsW7T+F5GYmS10qlSvuSGdiuy3QtstxQiK/KKJxCSmzj/55M
         FIkkgfBlyPUhPNyKWp0eyUllkRxLZkGjKxdNrtT8oyDp8Iu3SNvsLSbKMw30w4L1B8
         ROnIg0hy17n9Q==
Date:   Tue, 1 Aug 2023 16:49:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 12/23] xfs_db: Add support to read from external log
 device
Message-ID: <20230801234959.GT11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-13-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:16AM +0530, Chandan Babu R wrote:
> This commit introduces a new function set_log_cur() allowing xfs_db to read
> from an external log device. This is required by a future commit which will
> add the ability to dump metadata from external log devices.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/io.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
>  db/io.h |  2 ++
>  2 files changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 3d257236..5ccfe3b5 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -508,18 +508,19 @@ write_cur(void)
>  
>  }
>  
> -void
> -set_cur(
> -	const typ_t	*type,
> -	xfs_daddr_t	blknum,
> -	int		len,
> -	int		ring_flag,
> -	bbmap_t		*bbmap)
> +static void
> +__set_cur(
> +	struct xfs_buftarg	*btargp,
> +	const typ_t		*type,
> +	xfs_daddr_t		 blknum,
> +	int			 len,
> +	int			 ring_flag,
> +	bbmap_t			*bbmap)
>  {
> -	struct xfs_buf	*bp;
> -	xfs_ino_t	dirino;
> -	xfs_ino_t	ino;
> -	uint16_t	mode;
> +	struct xfs_buf		*bp;
> +	xfs_ino_t		dirino;
> +	xfs_ino_t		ino;
> +	uint16_t		mode;
>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>  	int		error;
>  
> @@ -548,11 +549,11 @@ set_cur(
>  		if (!iocur_top->bbmap)
>  			return;
>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> +		error = -libxfs_buf_read_map(btargp, bbmap->b,
>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>  				ops);
>  	} else {
> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
> +		error = -libxfs_buf_read(btargp, blknum, len,
>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
>  		iocur_top->bbmap = NULL;
>  	}
> @@ -589,6 +590,35 @@ set_cur(
>  		ring_add();
>  }
>  
> +void
> +set_cur(
> +	const typ_t	*type,
> +	xfs_daddr_t	blknum,
> +	int		len,
> +	int		ring_flag,
> +	bbmap_t		*bbmap)
> +{
> +	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
> +}
> +
> +void
> +set_log_cur(
> +	const typ_t	*type,
> +	xfs_daddr_t	blknum,
> +	int		len,
> +	int		ring_flag,
> +	bbmap_t		*bbmap)
> +{
> +	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
> +		fprintf(stderr, "no external log specified\n");
> +		exitcode = 1;
> +		return;
> +	}
> +
> +	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
> +}
> +
> +
>  void
>  set_iocur_type(
>  	const typ_t	*type)
> diff --git a/db/io.h b/db/io.h
> index c29a7488..bd86c31f 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
>  extern void	write_cur(void);
>  extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
>  			int len, int ring_add, bbmap_t *bbmap);
> +extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
> +			int len, int ring_add, bbmap_t *bbmap);
>  extern void     ring_add(void);
>  extern void	set_iocur_type(const struct typ *type);
>  extern void	xfs_dummy_verify(struct xfs_buf *bp);
> -- 
> 2.39.1
> 
