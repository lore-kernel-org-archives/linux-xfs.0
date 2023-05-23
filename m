Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD105C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbjEWQsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbjEWQsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D841132
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 09:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16096343F
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 16:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E3AC433D2;
        Tue, 23 May 2023 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684860488;
        bh=nzq1GvP1N515+0uImlS5+R9d9tzc7Rr2yNk+AMCpSHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4M6aH6FO5u3ZM6bdSYz34+86ThIJqsrfM8lW5ONeix6lbQ6h60XsPYDjREP4tXW+
         ox1SsgWnJbQY1Qab2OrjXn+lHN5p7S1vAA0xFMvVLONghNh2G24FK4nvDIr61Cbpvr
         mBsRDbQLlKb4C64gtO7HWtfg6wCKDT/uYbR762LWTSswMMPlyp8IxS/zKGMe4BW/3F
         La5vo049aWbOVNGXrf/iksUjkA/zymLXWFdfth0ABmJglaxGShlw/N/MoaRwzx+U1C
         iDqfO8S05EDVFc5Le9sDfcFrZQS/VQSiHQ0izPelmGsrgxRWCQj5TclEfunVqQv0jx
         4TPSNSHYV1A5w==
Date:   Tue, 23 May 2023 09:48:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] set_cur: Add support to read from external log
 device
Message-ID: <20230523164807.GL11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-6-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-6-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:31PM +0530, Chandan Babu R wrote:
> This commit changes set_cur() to be able to read from external log
> devices. This is required by a future commit which will add the ability to
> dump metadata from external log devices.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/io.c   | 22 +++++++++++++++-------
>  db/type.c |  2 ++
>  db/type.h |  2 +-
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 3d2572364..e8c8f57e2 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -516,12 +516,13 @@ set_cur(
>  	int		ring_flag,
>  	bbmap_t		*bbmap)
>  {
> -	struct xfs_buf	*bp;
> -	xfs_ino_t	dirino;
> -	xfs_ino_t	ino;
> -	uint16_t	mode;
> +	struct xfs_buftarg	*btargp;
> +	struct xfs_buf		*bp;
> +	xfs_ino_t		dirino;
> +	xfs_ino_t		ino;
> +	uint16_t		mode;
>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
> -	int		error;
> +	int			error;
>  
>  	if (iocur_sp < 0) {
>  		dbprintf(_("set_cur no stack element to set\n"));
> @@ -534,7 +535,14 @@ set_cur(
>  	pop_cur();
>  	push_cur();
>  
> +	btargp = mp->m_ddev_targp;
> +	if (type->typnm == TYP_ELOG) {

This feels like a layering violation, see below...

> +		ASSERT(mp->m_ddev_targp != mp->m_logdev_targp);
> +		btargp = mp->m_logdev_targp;
> +	}
> +
>  	if (bbmap) {
> +		ASSERT(btargp == mp->m_ddev_targp);
>  #ifdef DEBUG_BBMAP
>  		int i;
>  		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
> @@ -548,11 +556,11 @@ set_cur(
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
> diff --git a/db/type.c b/db/type.c
> index efe704456..cc406ae4c 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -100,6 +100,7 @@ static const typ_t	__typtab_crc[] = {
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },

It strikes me as a little odd to create a new /metadata type/ to
reference the external log.  If we someday want to add a bunch of new
types to xfs_db to allow us to decode/fuzz the log contents, wouldn't we
have to add them twice -- once for decoding an internal log, and again
to decode the external log?  And the only difference between the two
would be the buftarg, right?  The set_cur caller needs to know the
daddr already, so I don't think it's unreasonable for the caller to have
to know which buftarg too.

IOWs, I think set_cur ought to take the buftarg, the typ_t, and a daddr
as explicit arguments.  But maybe others have opinions?

e.g. rename set_cur to __set_cur and make it take a buftarg, and then:

int
set_log_cur(
	const typ_t	*type,
	xfs_daddr_t	blknum,
	int		len,
	int		ring_flag,
	bbmap_t		*bbmap)
{
	if (!mp->m_logdev_targp->bt_bdev ||
	    mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
		printf(_("external log device not loaded, use -l.\n"));
		return ENODEV;
	}

	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
	return 0;
}

and then metadump can do something like ....

	error = set_log_cur(&typtab[TYP_LOG], 0,
			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);

--D

>  	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
> @@ -144,6 +145,7 @@ static const typ_t	__typtab_spcrc[] = {
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
> diff --git a/db/type.h b/db/type.h
> index 411bfe90d..feb5c8219 100644
> --- a/db/type.h
> +++ b/db/type.h
> @@ -14,7 +14,7 @@ typedef enum typnm
>  	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
>  	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
>  	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
> -	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
> +	TYP_LOG, TYP_ELOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
>  	TYP_TEXT, TYP_FINOBT, TYP_NONE
>  } typnm_t;
>  
> -- 
> 2.39.1
> 
