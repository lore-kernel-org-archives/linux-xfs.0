Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DECBEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjGLRfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjGLRfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:35:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5070B1BD
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D78E561898
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E47C433CA;
        Wed, 12 Jul 2023 17:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689183330;
        bh=9VnsnS8xpIk62a8wUbKfhwdH9RKQNghSdCoIY3blrw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLsUQjGK89H61puUDq7/71rc8SStbyN7wI5NF/20lam7iGXhhee3gvl/LFFOIOTU5
         4VE0fYNvTVpfzkOZIRxmnLCw9UQ1gGl5P9gU8lT5/CKQkJef1EK/REy+7ZLbQorPsm
         I2eiz9iaU2U7FI5CkpOGrJ5/x2S6iWokk+VXesP8EWEz8Im3Yj+s9+4Px1lXoRlxtW
         najNkSar2kjvDHCMNlnPYccluKwac4DpS2GbrH8IdMHZsVgtsyhu0w804d0CQYYMOM
         V9c2hXUW7QOWa0sdp1F+Ssmw8d8pazzzo8bLX0SGo1AhOqYTf5ETACrBHOSlNbAW0t
         mdv731z7M9UPg==
Date:   Wed, 12 Jul 2023 10:35:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 12/23] xfs_db: Add support to read from external log
 device
Message-ID: <20230712173529.GK108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-13-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:55PM +0530, Chandan Babu R wrote:
> This commit introduces a new function set_log_cur() allowing xfs_db to read
> from an external log device. This is required by a future commit which will
> add the ability to dump metadata from external log devices.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/io.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 3d257236..a6feaba3 100644
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
> @@ -589,6 +590,36 @@ set_cur(
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
> +	struct xfs_buftarg	*btargp = mp->m_ddev_targp;
> +
> +	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
> +		ASSERT(mp->m_sb.sb_logstart == 0);
> +		btargp = mp->m_logdev_targp;
> +	}

I think this should print an error message if there isn't an external
log device and then leave iocur_top unchanged:

	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
		fprintf(stderr, "no external log specified\n");
		exitcode = 1;
		return;
	}

	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);

because metadump shouldn't crash if there's an external log device but
sb_logstart is zero.  The superblock fields /could/ be corrupt, or other
weird shenanigans are going on.

(Also it's a layering violation for the io cursors to know anything at
all about the filesystem stored above them.)

--D

> +
> +	__set_cur(btargp, type, blknum, len, ring_flag, bbmap);
> +}
> +
> +
>  void
>  set_iocur_type(
>  	const typ_t	*type)
> -- 
> 2.39.1
> 
