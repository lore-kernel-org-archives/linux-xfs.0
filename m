Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CB0CA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3A121897
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="O5/ENDkK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dsah/vNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfKBEsJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 00:48:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44585 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfKBEsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 00:48:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A36C521340;
        Sat,  2 Nov 2019 00:48:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 02 Nov 2019 00:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        7NEjKRPiOJrRFGzo9ycoOkknsQgogmYgEPtbEEIDXYE=; b=O5/ENDkK2jg57kRi
        TYVWecoGSvqrjzu/hOqINzzncrDrVMBO6dz8QZVh+TaQm23Qd0lxA6wcH4hvRc77
        luHkAJW92xbTH9c47vJBL1hpC58WLeUpnW0DX0tF2zxv41rs7+hDcazo18xub3ys
        WNLjec4a/x74cm5l7lMPcgai/HVeZKtyKlINE94hA/hTGVkn92s8aYVx/80RTXRc
        8i6kYrY2qN4DuqKl3JqVTSBD1jZcDM2fJg74HzZZBXHji0VxaILSFaaI2Y0GyGet
        pFHMapoxiWPSkEuOjpdOWNSWyHqjgLCjfBaTNpNW9N7w8xdo9eqJf8AV8Ux2GICB
        JIjVjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=7NEjKRPiOJrRFGzo9ycoOkknsQgogmYgEPtbEEIDX
        YE=; b=dsah/vNeYuXhGWzsgJNjCZJN03FxquVpsQwczyyGOcQYKqfjWy746M16D
        vh0qGZk9K2l2puyTaaci5t18qW+YOQHbl3AEBeB9NmYJi1ceGGP++5w99Knt7Xfs
        0abmzxWjaGOhum+DN2zteQGbO66n/rcdccMWvTI0Kvsy24vQSyXpjN2DFVMwtcdD
        XaqVdf3XJYGoD4Drtpr4gBPeZqqcoScqqXGm5zfgXlyZ01onk3OBNH5QHpSBcTgr
        lXx80k+x/vlsFSuuVLfmq4KAgjIyevKVjeptP2JNoI4ppw/gh8hvOorYvK4JQxVr
        Tg0na+iS/3+NL5an2j+T+JyNXqoFQ==
X-ME-Sender: <xms:hgq9XZZLdcKe_4eKNFSURXsBvAoDKJZnmgwBKEWCQ3lwX8ihY3Y_OA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtkedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekledrudeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:hgq9XZ0oY53JpSCo8FvgxTfmme-6GSF_KX_JgpZiCyPII5o4DmAByA>
    <xmx:hgq9XbimB_-_z49NC6ht6X_94Rblj80l1OnyvL23Fj3fX1toCGVW7Q>
    <xmx:hgq9XdZflj9eiE5oUMaqerGl4CuI7TVJBN0ngNPCepInSi_ZAuidUg>
    <xmx:hwq9XfPVhJIFL_zUqOestMOHEOIIdrisCDD-AVhHR8Yj4nocg2r4mA>
Received: from mickey.themaw.net (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40F003060057;
        Sat,  2 Nov 2019 00:48:02 -0400 (EDT)
Message-ID: <dcc36cb56b2b8a27fe6a9cecf6dc91fee6750c25.camel@themaw.net>
Subject: Re: [PATCH v8 14/16] xfs: move xfs_fc_reconfigure() above
 xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sat, 02 Nov 2019 12:48:00 +0800
In-Reply-To: <20191101201635.GH15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
         <157259467671.28278.14729127257650613602.stgit@fedora-28>
         <20191101201635.GH15222@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-11-01 at 13:16 -0700, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 03:51:16PM +0800, Ian Kent wrote:
> > Grouping the options parsing and mount handling functions above the
> > struct fs_context_operations but below the struct super_operations
> > should improve (some) the grouping of the super operations while
> > also
> > improving the grouping of the options parsing and mount handling
> > code.
> > 
> > Start by moving xfs_fc_reconfigure() and friends.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> 
> No functional changes, right?  I didn't see any...

Yeah, it seemed sensible to do this after all the changes were
done since that way there's better visibility of what's actually
changing and these three patches just move code to a gain better
locality.

Locating this code here does seem to result in quite good locality
and removes quite a bit of noise from the remaining code for a
readability improvement there too.

Overall it appears to be a good choice.

> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_super.c |  324 ++++++++++++++++++++++++++------------
> > --------------
> >  1 file changed, 162 insertions(+), 162 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index bed914bc087b..9c5ea74dbfd5 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1139,168 +1139,6 @@ xfs_quiesce_attr(
> >  	xfs_log_quiesce(mp);
> >  }
> >  
> > -static int
> > -xfs_remount_rw(
> > -	struct xfs_mount	*mp)
> > -{
> > -	struct xfs_sb		*sbp = &mp->m_sb;
> > -	int error;
> > -
> > -	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > -		xfs_warn(mp,
> > -			"ro->rw transition prohibited on norecovery
> > mount");
> > -		return -EINVAL;
> > -	}
> > -
> > -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > -	    xfs_sb_has_ro_compat_feature(sbp,
> > XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > -		xfs_warn(mp,
> > -	"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > filesystem",
> > -			(sbp->sb_features_ro_compat &
> > -				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > -		return -EINVAL;
> > -	}
> > -
> > -	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > -
> > -	/*
> > -	 * If this is the first remount to writeable state we might
> > have some
> > -	 * superblock changes to update.
> > -	 */
> > -	if (mp->m_update_sb) {
> > -		error = xfs_sync_sb(mp, false);
> > -		if (error) {
> > -			xfs_warn(mp, "failed to write sb changes");
> > -			return error;
> > -		}
> > -		mp->m_update_sb = false;
> > -	}
> > -
> > -	/*
> > -	 * Fill out the reserve pool if it is empty. Use the stashed
> > value if
> > -	 * it is non-zero, otherwise go with the default.
> > -	 */
> > -	xfs_restore_resvblks(mp);
> > -	xfs_log_work_queue(mp);
> > -
> > -	/* Recover any CoW blocks that never got remapped. */
> > -	error = xfs_reflink_recover_cow(mp);
> > -	if (error) {
> > -		xfs_err(mp,
> > -			"Error %d recovering leftover CoW
> > allocations.", error);
> > -			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > -		return error;
> > -	}
> > -	xfs_start_block_reaping(mp);
> > -
> > -	/* Create the per-AG metadata reservation pool .*/
> > -	error = xfs_fs_reserve_ag_blocks(mp);
> > -	if (error && error != -ENOSPC)
> > -		return error;
> > -
> > -	return 0;
> > -}
> > -
> > -static int
> > -xfs_remount_ro(
> > -	struct xfs_mount	*mp)
> > -{
> > -	int error;
> > -
> > -	/*
> > -	 * Cancel background eofb scanning so it cannot race with the
> > final
> > -	 * log force+buftarg wait and deadlock the remount.
> > -	 */
> > -	xfs_stop_block_reaping(mp);
> > -
> > -	/* Get rid of any leftover CoW reservations... */
> > -	error = xfs_icache_free_cowblocks(mp, NULL);
> > -	if (error) {
> > -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -		return error;
> > -	}
> > -
> > -	/* Free the per-AG metadata reservation pool. */
> > -	error = xfs_fs_unreserve_ag_blocks(mp);
> > -	if (error) {
> > -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -		return error;
> > -	}
> > -
> > -	/*
> > -	 * Before we sync the metadata, we need to free up the reserve
> > block
> > -	 * pool so that the used block count in the superblock on disk
> > is
> > -	 * correct at the end of the remount. Stash the current*
> > reserve pool
> > -	 * size so that if we get remounted rw, we can return it to the
> > same
> > -	 * size.
> > -	 */
> > -	xfs_save_resvblks(mp);
> > -
> > -	xfs_quiesce_attr(mp);
> > -	mp->m_flags |= XFS_MOUNT_RDONLY;
> > -
> > -	return 0;
> > -}
> > -
> > -/*
> > - * Logically we would return an error here to prevent users from
> > believing
> > - * they might have changed mount options using remount which can't
> > be changed.
> > - *
> > - * But unfortunately mount(8) adds all options from mtab and fstab
> > to the mount
> > - * arguments in some cases so we can't blindly reject options, but
> > have to
> > - * check for each specified option if it actually differs from the
> > currently
> > - * set option and only reject it if that's the case.
> > - *
> > - * Until that is implemented we return success for every remount
> > request, and
> > - * silently ignore all options that we can't actually change.
> > - */
> > -static int
> > -xfs_fc_reconfigure(
> > -	struct fs_context *fc)
> > -{
> > -	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > -	struct xfs_mount        *new_mp = fc->s_fs_info;
> > -	xfs_sb_t		*sbp = &mp->m_sb;
> > -	int			flags = fc->sb_flags;
> > -	int			error;
> > -
> > -	sync_filesystem(mp->m_super);
> > -
> > -	error = xfs_fc_validate_params(new_mp);
> > -	if (error)
> > -		return error;
> > -
> > -	/* inode32 -> inode64 */
> > -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > -	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > -		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > -		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > -	}
> > -
> > -	/* inode64 -> inode32 */
> > -	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > -	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > -		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > -		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > -	}
> > -
> > -	/* ro -> rw */
> > -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> > -		error = xfs_remount_rw(mp);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> > -	/* rw -> ro */
> > -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> > -		error = xfs_remount_ro(mp);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> > -	return 0;
> > -}
> > -
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> >   * need to take care of the metadata. Once that's done sync the
> > superblock
> > @@ -1735,6 +1573,168 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static int
> > +xfs_remount_rw(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	int error;
> > +
> > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > +		xfs_warn(mp,
> > +			"ro->rw transition prohibited on norecovery
> > mount");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +	    xfs_sb_has_ro_compat_feature(sbp,
> > XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > +		xfs_warn(mp,
> > +	"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > filesystem",
> > +			(sbp->sb_features_ro_compat &
> > +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > +		return -EINVAL;
> > +	}
> > +
> > +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > +
> > +	/*
> > +	 * If this is the first remount to writeable state we might
> > have some
> > +	 * superblock changes to update.
> > +	 */
> > +	if (mp->m_update_sb) {
> > +		error = xfs_sync_sb(mp, false);
> > +		if (error) {
> > +			xfs_warn(mp, "failed to write sb changes");
> > +			return error;
> > +		}
> > +		mp->m_update_sb = false;
> > +	}
> > +
> > +	/*
> > +	 * Fill out the reserve pool if it is empty. Use the stashed
> > value if
> > +	 * it is non-zero, otherwise go with the default.
> > +	 */
> > +	xfs_restore_resvblks(mp);
> > +	xfs_log_work_queue(mp);
> > +
> > +	/* Recover any CoW blocks that never got remapped. */
> > +	error = xfs_reflink_recover_cow(mp);
> > +	if (error) {
> > +		xfs_err(mp,
> > +			"Error %d recovering leftover CoW
> > allocations.", error);
> > +			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +	xfs_start_block_reaping(mp);
> > +
> > +	/* Create the per-AG metadata reservation pool .*/
> > +	error = xfs_fs_reserve_ag_blocks(mp);
> > +	if (error && error != -ENOSPC)
> > +		return error;
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +xfs_remount_ro(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int error;
> > +
> > +	/*
> > +	 * Cancel background eofb scanning so it cannot race with the
> > final
> > +	 * log force+buftarg wait and deadlock the remount.
> > +	 */
> > +	xfs_stop_block_reaping(mp);
> > +
> > +	/* Get rid of any leftover CoW reservations... */
> > +	error = xfs_icache_free_cowblocks(mp, NULL);
> > +	if (error) {
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +
> > +	/* Free the per-AG metadata reservation pool. */
> > +	error = xfs_fs_unreserve_ag_blocks(mp);
> > +	if (error) {
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +
> > +	/*
> > +	 * Before we sync the metadata, we need to free up the reserve
> > block
> > +	 * pool so that the used block count in the superblock on disk
> > is
> > +	 * correct at the end of the remount. Stash the current*
> > reserve pool
> > +	 * size so that if we get remounted rw, we can return it to the
> > same
> > +	 * size.
> > +	 */
> > +	xfs_save_resvblks(mp);
> > +
> > +	xfs_quiesce_attr(mp);
> > +	mp->m_flags |= XFS_MOUNT_RDONLY;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Logically we would return an error here to prevent users from
> > believing
> > + * they might have changed mount options using remount which can't
> > be changed.
> > + *
> > + * But unfortunately mount(8) adds all options from mtab and fstab
> > to the mount
> > + * arguments in some cases so we can't blindly reject options, but
> > have to
> > + * check for each specified option if it actually differs from the
> > currently
> > + * set option and only reject it if that's the case.
> > + *
> > + * Until that is implemented we return success for every remount
> > request, and
> > + * silently ignore all options that we can't actually change.
> > + */
> > +static int
> > +xfs_fc_reconfigure(
> > +	struct fs_context *fc)
> > +{
> > +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > +	struct xfs_mount        *new_mp = fc->s_fs_info;
> > +	xfs_sb_t		*sbp = &mp->m_sb;
> > +	int			flags = fc->sb_flags;
> > +	int			error;
> > +
> > +	sync_filesystem(mp->m_super);
> > +
> > +	error = xfs_fc_validate_params(new_mp);
> > +	if (error)
> > +		return error;
> > +
> > +	/* inode32 -> inode64 */
> > +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > +	}
> > +
> > +	/* inode64 -> inode32 */
> > +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > +	}
> > +
> > +	/* ro -> rw */
> > +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> > +		error = xfs_remount_rw(mp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	/* rw -> ro */
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> > +		error = xfs_remount_ro(mp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static void xfs_fc_free(struct fs_context *fc)
> >  {
> >  	struct xfs_mount	*mp = fc->s_fs_info;
> > 

