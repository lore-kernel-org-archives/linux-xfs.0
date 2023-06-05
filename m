Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F303C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 19:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjFETWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjFETWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 15:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53479E8
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 12:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0B0629C2
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 19:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38184C4339B;
        Mon,  5 Jun 2023 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685992956;
        bh=KaX0PpMlQOH5Q28ICnKedUNfuEHZK6du0dHm4CLGNwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bzr//exXfR00h8WB2Y5AdBui6GcoHQ9wJkLxLxhNG82H4Tq2O2LFdu+CIYo4yDMu4
         UQjkYdc/8pftdaVp/OoJcH09SBwqYwAPkTaN8A6NiIBuLf4zIHjRA2JHNnpGgS69wV
         6ZjlwBgbJyEgAFDX8Z3qn7pIof7xfzK+Pq/exmlZI16M3aaI/PXvNMAp33nRUUnT3C
         erKw+D6TMC7Oe2qmBky3hDuL8ba4cgVhiS8w9U1lGlF7CRcg/2qDUUxZQnLxu4oB7s
         jtnqbj5OxrD8ycd/v+zgu0eVVxtS0oGSGst8TEMkhiPbE1FImKi2zJ1px/f5KAQkX+
         ENjF1fPZQp2HQ==
Date:   Mon, 5 Jun 2023 12:22:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] set_cur: Add support to read from external log
 device
Message-ID: <20230605192235.GA1325469@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-6-chandan.babu@oracle.com>
 <20230523164807.GL11620@frogsfrogsfrogs>
 <87sfb6462k.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfb6462k.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 02:49:49PM +0530, Chandan Babu R wrote:
> On Tue, May 23, 2023 at 09:48:07 AM -0700, Darrick J. Wong wrote:
> > On Tue, May 23, 2023 at 02:30:31PM +0530, Chandan Babu R wrote:
> >> This commit changes set_cur() to be able to read from external log
> >> devices. This is required by a future commit which will add the ability to
> >> dump metadata from external log devices.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  db/io.c   | 22 +++++++++++++++-------
> >>  db/type.c |  2 ++
> >>  db/type.h |  2 +-
> >>  3 files changed, 18 insertions(+), 8 deletions(-)
> >> 
> >> diff --git a/db/io.c b/db/io.c
> >> index 3d2572364..e8c8f57e2 100644
> >> --- a/db/io.c
> >> +++ b/db/io.c
> >> @@ -516,12 +516,13 @@ set_cur(
> >>  	int		ring_flag,
> >>  	bbmap_t		*bbmap)
> >>  {
> >> -	struct xfs_buf	*bp;
> >> -	xfs_ino_t	dirino;
> >> -	xfs_ino_t	ino;
> >> -	uint16_t	mode;
> >> +	struct xfs_buftarg	*btargp;
> >> +	struct xfs_buf		*bp;
> >> +	xfs_ino_t		dirino;
> >> +	xfs_ino_t		ino;
> >> +	uint16_t		mode;
> >>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
> >> -	int		error;
> >> +	int			error;
> >>  
> >>  	if (iocur_sp < 0) {
> >>  		dbprintf(_("set_cur no stack element to set\n"));
> >> @@ -534,7 +535,14 @@ set_cur(
> >>  	pop_cur();
> >>  	push_cur();
> >>  
> >> +	btargp = mp->m_ddev_targp;
> >> +	if (type->typnm == TYP_ELOG) {
> >
> > This feels like a layering violation, see below...
> >
> >> +		ASSERT(mp->m_ddev_targp != mp->m_logdev_targp);
> >> +		btargp = mp->m_logdev_targp;
> >> +	}
> >> +
> >>  	if (bbmap) {
> >> +		ASSERT(btargp == mp->m_ddev_targp);
> >>  #ifdef DEBUG_BBMAP
> >>  		int i;
> >>  		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
> >> @@ -548,11 +556,11 @@ set_cur(
> >>  		if (!iocur_top->bbmap)
> >>  			return;
> >>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> >> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> >> +		error = -libxfs_buf_read_map(btargp, bbmap->b,
> >>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
> >>  				ops);
> >>  	} else {
> >> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
> >> +		error = -libxfs_buf_read(btargp, blknum, len,
> >>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
> >>  		iocur_top->bbmap = NULL;
> >>  	}
> >> diff --git a/db/type.c b/db/type.c
> >> index efe704456..cc406ae4c 100644
> >> --- a/db/type.c
> >> +++ b/db/type.c
> >> @@ -100,6 +100,7 @@ static const typ_t	__typtab_crc[] = {
> >>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
> >>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
> >>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> >> +	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> >
> > It strikes me as a little odd to create a new /metadata type/ to
> > reference the external log.  If we someday want to add a bunch of new
> > types to xfs_db to allow us to decode/fuzz the log contents, wouldn't we
> > have to add them twice -- once for decoding an internal log, and again
> > to decode the external log?  And the only difference between the two
> > would be the buftarg, right?  The set_cur caller needs to know the
> > daddr already, so I don't think it's unreasonable for the caller to have
> > to know which buftarg too.
> >
> > IOWs, I think set_cur ought to take the buftarg, the typ_t, and a daddr
> > as explicit arguments.  But maybe others have opinions?
> >
> > e.g. rename set_cur to __set_cur and make it take a buftarg, and then:
> >
> > int
> > set_log_cur(
> > 	const typ_t	*type,
> > 	xfs_daddr_t	blknum,
> > 	int		len,
> > 	int		ring_flag,
> > 	bbmap_t		*bbmap)
> > {
> > 	if (!mp->m_logdev_targp->bt_bdev ||
> > 	    mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
> > 		printf(_("external log device not loaded, use -l.\n"));
> > 		return ENODEV;
> > 	}
> >
> > 	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
> > 	return 0;
> > }
> >
> > and then metadump can do something like ....
> >
> > 	error = set_log_cur(&typtab[TYP_LOG], 0,
> > 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
> >
> 
> Darrick, How about implementing the following instead,
> 
> static void
> __set_cur(
> 	struct xfs_buftarg	*btargp,
> 	const typ_t		*type,
> 	xfs_daddr_t		 blknum,
> 	int			 len,
> 	int			 ring_flag,
> 	bbmap_t			*bbmap)
> {
> 	struct xfs_buf		*bp;
> 	xfs_ino_t		dirino;
> 	xfs_ino_t		ino;
> 	uint16_t		mode;
> 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
> 	int		error;
> 
> 	if (iocur_sp < 0) {
> 		dbprintf(_("set_cur no stack element to set\n"));
> 		return;
> 	}
> 
> 	ino = iocur_top->ino;
> 	dirino = iocur_top->dirino;
> 	mode = iocur_top->mode;
> 	pop_cur();
> 	push_cur();
> 
> 	if (bbmap) {
> #ifdef DEBUG_BBMAP
> 		int i;
> 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
> 		printf(_("\tblock map"));
> 		for (i = 0; i < bbmap->nmaps; i++)
> 			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
> 					   bbmap->b[i].bm_len);
> 		printf("\n");
> #endif
> 		iocur_top->bbmap = malloc(sizeof(struct bbmap));
> 		if (!iocur_top->bbmap)
> 			return;
> 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> 		error = -libxfs_buf_read_map(btargp, bbmap->b,
> 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
> 				ops);
> 	} else {
> 		error = -libxfs_buf_read(btargp, blknum, len,
> 				LIBXFS_READBUF_SALVAGE, &bp, ops);
> 		iocur_top->bbmap = NULL;
> 	}
> 
> 	/*
> 	 * Salvage mode means that we still get a buffer even if the verifier
> 	 * says the metadata is corrupt.  Therefore, the only errors we should
> 	 * get are for IO errors or runtime errors.
> 	 */
> 	if (error)
> 		return;
> 	iocur_top->buf = bp->b_addr;
> 	iocur_top->bp = bp;
> 	if (!ops) {
> 		bp->b_ops = NULL;
> 		bp->b_flags |= LIBXFS_B_UNCHECKED;
> 	}
> 
> 	iocur_top->bb = blknum;
> 	iocur_top->blen = len;
> 	iocur_top->boff = 0;
> 	iocur_top->data = iocur_top->buf;
> 	iocur_top->len = BBTOB(len);
> 	iocur_top->off = blknum << BBSHIFT;
> 	iocur_top->typ = cur_typ = type;
> 	iocur_top->ino = ino;
> 	iocur_top->dirino = dirino;
> 	iocur_top->mode = mode;
> 	iocur_top->ino_buf = 0;
> 	iocur_top->dquot_buf = 0;
> 
> 	/* store location in ring */
> 	if (ring_flag)
> 		ring_add();
> }
> 
> void
> set_cur(
> 	const typ_t	*type,
> 	xfs_daddr_t	blknum,
> 	int		len,
> 	int		ring_flag,
> 	bbmap_t		*bbmap)
> {
> 	struct xfs_buftarg	*btargp = mp->m_ddev_targp;
> 
> 	if (type->typnm == TYP_LOG &&
> 		mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
> 		ASSERT(mp->m_sb.sb_logstart == 0);
> 		btargp = mp->m_logdev_targp;
> 	}
> 
> 	__set_cur(btargp, type, blknum, len, ring_flag, bbmap);
> }
> 
> i.e. We continue to have just one type for the log and set_cur() will
> internally decide which buftarg to pass to __set_cur(). Please let me know
> your opinion on this approach.

If I'm understanding this correctly, you're proposing to push the
buftarg decision down into set_cur instead of encoding it in the typ_t
information?

I still don't like this, because that decision should be made by the
callers of set_*cur, not down in the io cursor handling code.

Take a look at the users of set_log_cur and set_rt_cur in the 'dblock'
command as of djwong-wtf:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tree/db/block.c?h=djwong-wtf_2023-06-05#n217

Notice this bit here:

static inline bool
is_rtfile(
	struct xfs_dinode	*dip)
{
	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
}

static int
dblock_f(...)
{
	...

	if (is_rtfile(iocur_top->data))
		set_rt_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
				nb * blkbb, DB_RING_ADD,
				nex > 1 ? &bbmap : NULL);
	else
		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
				nb * blkbb, DB_RING_ADD,
				nex > 1 ? &bbmap : NULL);

xfs_db can now access the data blocks of realtime files, because we have
the high level logic to decide which buftarg based on the di_flags set
in the inode core.  TYP_DATA doesn't know anything at all about inodes
or data blocks or whatever -- down at the level of "data block" we don't
actually have the context we need to select a device.

--D

> -- 
> chandan
