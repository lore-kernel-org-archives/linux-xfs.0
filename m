Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DEFC6FA8F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 02:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjH3CEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 22:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241706AbjH3CEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 22:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDAC1A6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 19:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987B863495
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 02:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA401C433C7;
        Wed, 30 Aug 2023 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693361071;
        bh=G22AhGwxrFKyzxlFyo4gfj4CmonWiKhZbeFY3166wtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0QKQTNd71Em2SmIm8wPXa4T01oHr2MC+mpDoWKlBOzZJbWHsQgdlAlqc+ORT+wbJ
         taEsZU/9pSCw+CmeKn0DBr/bU5+wSDgrO9TD/GG30BMsfKPEtmyKLFJnDKem7BnBvr
         xU1y9vmtxPsxixvoSQ80vkartvwLKvSAzgkQ2Ir8SZThIEdsoqL9Vjk/NJpZkjOW2+
         y/ok6tij79wKxV9QekgGUJfVMJDJC5HKG5XEgE7ZJnjfSaTVItDVegY1lWvtITEkx1
         HbUgUROWGfgs8SDKTf8A+C/UTOsthWzesvybYiYGeQUicPu9GOmoX6ZwKxlJG7q5b+
         cRGgFbjHJ4iyQ==
Date:   Tue, 29 Aug 2023 19:04:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [RFC PATCH] xfs: load uncached unlinked inodes into memory on
 demand
Message-ID: <20230830020430.GH28186@frogsfrogsfrogs>
References: <20230829232043.GE28186@frogsfrogsfrogs>
 <ZO6JqOBOOUCcS4ac@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO6JqOBOOUCcS4ac@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2023 at 10:13:28AM +1000, Dave Chinner wrote:
> On Tue, Aug 29, 2023 at 04:20:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > shrikanth hegde reports that filesystems fail shortly after mount with
> > the following failure:
> > 
> > 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> > 
> > This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
> > 
> > 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> > 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
> > 
> > From diagnostic data collected by the bug reporters, it would appear
> > that we cleanly mounted a filesystem that contained unlinked inodes.
> > Unlinked inodes are only processed as a final step of log recovery,
> > which means that clean mounts do not process the unlinked list at all.
> > 
> > Prior to the introduction of the incore unlinked lists, this wasn't a
> > problem because the unlink code would (very expensively) traverse the
> > entire ondisk metadata iunlink chain to keep things up to date.
> > However, the incore unlinked list code complains when it realizes that
> > it is out of sync with the ondisk metadata and shuts down the fs, which
> > is bad.
> > 
> > Ritesh proposed to solve this problem by unconditionally parsing the
> > unlinked lists at mount time, but this imposes a mount time cost for
> > every filesystem to catch something that should be very infrequent.
> > Instead, let's target the places where we can encounter a next_unlinked
> > pointer that refers to an inode that is not in cache, and load it into
> > cache.
> > 
> > Note: This patch does not address the problem of iget loading an inode
> > from the middle of the iunlink list and needing to set i_prev_unlinked
> > correctly.
> > 
> > Link: https://lore.kernel.org/linux-xfs/e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com/
> > Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> > Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_trace.h |   25 +++++++++++++++++++
> >  2 files changed, 92 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6ee266be45d4..3ab140ec09bb 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
> >  
> >  	rcu_read_lock();
> >  	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> > +	if (!ip) {
> > +		/* Caller can handle inode not being in memory. */
> > +		rcu_read_unlock();
> > +		return NULL;
> > +	}
> >  
> >  	/*
> > -	 * Inode not in memory or in RCU freeing limbo should not happen.
> > -	 * Warn about this and let the caller handle the failure.
> > +	 * Inode in RCU freeing limbo should not happen.  Warn about this and
> > +	 * let the caller handle the failure.
> >  	 */
> > -	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
> > +	if (WARN_ON_ONCE(!ip->i_ino)) {
> >  		rcu_read_unlock();
> >  		return NULL;
> >  	}
> 
> I think we should still log a message about this situation, as it implies
> that we had an unrecovered unlinked list on the filesystem and that
> should "never happen" in normal conditions.
> 
> i.e. something like:
> 
> XFS(dev): Found unrecovered unlinked inodes in AG X. Runtime recovery initiated.
> 
> which uses a perag state flag to only issue the message once per AG
> per mount. At least this way, if we get weird stuff happening
> because of loading an inode in the middle of an unlinked list (the
> unhandled prev_agino case) we know why weird stuff might be
> happening...

<nod> Ok, I'll make that explicit.

> 
> > @@ -1902,6 +1907,60 @@ xfs_iunlink_update_bucket(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Load the inode @next_agino into the cache and set its prev_unlinked pointer
> > + * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
> > + * to the unlinked list.
> > + */
> > +STATIC int
> > +xfs_iunlink_reload_next(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agibp,
> > +	xfs_agino_t		prev_agino,
> > +	xfs_agino_t		next_agino)
> > +{
> > +	struct xfs_perag	*pag = agibp->b_pag;
> > +	struct xfs_mount	*mp = pag->pag_mount;
> > +	struct xfs_inode	*next_ip = NULL;
> > +	xfs_ino_t		ino;
> > +	int			error;
> > +
> > +	ASSERT(next_agino != NULLAGINO);
> > +
> > +#ifdef DEBUG
> > +	rcu_read_lock();
> > +	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
> > +	ASSERT(next_ip == NULL);
> > +	rcu_read_unlock();
> > +#endif
> > +
> > +	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
> > +	if (error)
> > +		return error;
> 
> WHy are we using XFS_IGET_UNTRUSTED here? A comment explaining why
> we don't trust the agino on th eunlinked list we are about to try to
> recover (i.e. trust!) would be good.

	/*
	 * Use an untrusted lookup just to be cautious in case the AGI
	 * has been corrupted and now points at a free inode.  That
	 * shouldn't happen, but we'd rather shut down now since we're
	 * already running in a weird situation.
	 */


> > +	/* If this is not an unlinked inode, something is very wrong. */
> > +	if (VFS_I(next_ip)->i_nlink != 0) {
> > +		error = -EFSCORRUPTED;
> > +		goto rele;
> > +	}
> 
> *nod*
> 
> > +
> > +	next_ip->i_prev_unlinked = prev_agino;
> > +	trace_xfs_iunlink_reload_next(next_ip);
> > +rele:
> > +	/*
> > +	 * We're running in transaction context, so we cannot run any inode
> > +	 * release code.  Clear DONTCACHE on this inode to prevent the VFS from
> > +	 * initiating writeback and to force the irele to push this inode to
> > +	 * the LRU instead of dropping it immediately.
> > +	 */
> > +	spin_lock(&VFS_I(next_ip)->i_lock);
> > +	VFS_I(next_ip)->i_state &= ~I_DONTCACHE;
> > +	spin_unlock(&VFS_I(next_ip)->i_lock);
> > +	xfs_irele(next_ip);
> 
> Huh. We just loaded the next_ip into memory - how is it dirty,
> and what writeback will happen? Also, how would I_DONTCACHE get set
> in the first place here?

Ah, that's a historical accident -- originally when I thought the
possibility of unrecovered unlinked inodes was vanishingly small, I
wrote a whole bunch of code into online repair to deal with reloading
the incore list, etc.

When I first started prototyping it, xchk_irele didn't exist yet, so any
time I had to release an inode within a scrub transaction, I had to
manually clear I_DONTCACHE.  That got copied around everywhere in the
scrub code, and then it got copied over when I started working on the
runtime version.  That's been lurking beyond the depths of djwong-wtf
for quite a long time now, and I never got back to it until the heat
started going up after 6.1.

I think here it's not necessary since (as you point out) nobody can
actually dirty the inode, nor can they set DONTCACHE.

> 
> > +	return error;
> > +}
> > +
> >  static int
> >  xfs_iunlink_insert_inode(
> >  	struct xfs_trans	*tp,
> > @@ -1933,6 +1992,8 @@ xfs_iunlink_insert_inode(
> >  	 * inode.
> >  	 */
> >  	error = xfs_iunlink_update_backref(pag, agino, next_agino);
> > +	if (error == -ENOLINK)
> > +		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
> >  	if (error)
> >  		return error;
> 
> Where does this -ENOLINK error come from?
> xfs_iunlink_update_backref() returns either -EFSCORRUPTED or 0. Is
> the patch missing hunks or is it dependent on some other patch that
> does this?

<sigh> I forgot to copy that when I backported this patch from my dev
tree to TOT.  Welllllp thanks for catching that, now I can go restart
the test fleet.

/* Update the prev pointer of the next agino. */
static int
xfs_iunlink_update_backref(
	struct xfs_perag	*pag,
	xfs_agino_t		prev_agino,
	xfs_agino_t		next_agino)
{
	struct xfs_inode	*ip;

	/* No update necessary if we are at the end of the list. */
	if (next_agino == NULLAGINO)
		return 0;

	ip = xfs_iunlink_lookup(pag, next_agino);
	if (!ip)
		return -ENOLINK;

	ip->i_prev_unlinked = prev_agino;
	return 0;
}


--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
