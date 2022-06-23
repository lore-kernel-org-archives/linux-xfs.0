Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB33C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 18:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiFWSgu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiFWSg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 14:36:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747292AD0
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 10:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC3A61FCF
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 17:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B680C3411B;
        Thu, 23 Jun 2022 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656005877;
        bh=wSC57hY8UIm33ytmXdCW3g95IBxIKm16pjs9NCpEtwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kiCitK7Weghf7aXC5zopUyIEY/7mM8ZO/4LmTpd9htYhIi7odO0rc4ZKJ6uo34vLY
         2U8b6Ft/tI/UhFaoyHfPLe7FWA0etGFZQMjQgC+bQRb8coJI8vFYqhuDiafLUHi4YQ
         /CKp9SVzwLLDfGex24Whyi2qUhQCJXGphbu2qplP4vsc6D/AZdOK/pOT+9I2C5TUQb
         pjzOMEaU7IbgjppdakpsZk2mEI9G9irkOo8vVUapGfMtObnDini9zFzUeuunsk1pA5
         QH/Zyzo/AULTpHsPdW0sde047xAASy9xzaN/dgyWr0Vw2PUuyGMwvkToZ8iuP3FrK6
         M7fT24t8+29vA==
Date:   Thu, 23 Jun 2022 10:37:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make src file readable during reflink
Message-ID: <YrSk9BzQx9zAITXS@magnolia>
References: <20220618011631.61826-1-wen.gang.wang@oracle.com>
 <44420D34-8DF7-428B-8881-0825A28232B2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44420D34-8DF7-428B-8881-0825A28232B2@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 04:12:36PM +0000, Wengang Wang wrote:
> Hi,
" Could anyone please review this patch?

This is the first time I've seen this show up on linux-xfs.

NOTE: I have a very strong suspicion that vger ate a bunch of emails
last week -- the V9 async buffered write series was sent on 16 June and
that never arrived here either.

> thanks,
> wengang
> 
> > On Jun 17, 2022, at 6:16 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > inode io lock and mmap lock are exclusively locked durning reflink copy,
> > read operations are blocked during that time. In case the reflink copy
> > needs a long time to finish, read operations could be blocked for that long
> > too.
> > 
> > The real case is that reflinks take serveral minutes or even longer with
> > huge source files. Those source files are hundreds of GB long and badly
> > fragmented, so the reflink copy needs to process more than one million
> > extents.

How about this as a replacement for the first two paragraphs:

"During a reflink operation, the IOLOCK and MMAPLOCK of the source file
are held in exclusive mode for the duration.  This prevents reads on the
source file, which could be a very long time if the source file has
millions of extents."

> > 
> > As the source of copy, besides some neccessary modification happens (say
> > dirty page flushing), it plays readonly role. Locking source file
> > exclusively through out the reflink copy is unnecessary.
> > 
> > This patch downgrade exclusive locks on source file to shared modes after
> > page cache flushing and before cloing the extents.

Hmm.  I'm not sure this is ok -- reflink uses IOLOCK_EXCL to prevent
concurrent directio writes to the source file.  Certain directio writes
can proceed having only ever taken IOLOCK_SHARED (e.g. aligned writes
below EOF on a file with no security xattrs), which means that someone
could be directio overwriting the file contents while we're reflinking.

A direct overwrite of a block that has already been shared would prompt
the usual COW operation, since we set the REFLINK flag on both files
before we start the operation.  However, this introduces the possibility
that a racing direct overwrite could write to a block that is about to
be shared.  xfs_reflink_remap_extent is careful to increase the refcount
before mapping the extent into the dest file, but how do people feel
about the possibility of source file writes slipping in after we've
started the reflink process?

It feels a little strange to me that we'd allow direct overwrites to
continue during a reflink, even though we don't allow that for buffered
and dax writes, and I feel a little queasy about this.  I suppose we
could add an inode flag to signal that direct writes /must/ take
IOLOCK_EXCL, but yuck.

Anyway, moving along...

> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> > fs/xfs/xfs_file.c  |  8 +++++++-
> > fs/xfs/xfs_inode.c | 36 ++++++++++++++++++++++++++++++++++++
> > fs/xfs/xfs_inode.h |  4 ++++
> > 3 files changed, 47 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5a171c0b244b..99bbb188deb4 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1125,6 +1125,12 @@ xfs_file_remap_range(
> > 	if (ret || len == 0)
> > 		return ret;
> > 
> > +	/*
> > +	 * From now on, we read only from src, so downgrade locks on src
> > +	 * to allow read operations in parallel.
> > +	 */
> > +	xfs_ilock_io_mmap_downgrade_src(src, dest);
> > +
> > 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> > 
> > 	ret = xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
> > @@ -1152,7 +1158,7 @@ xfs_file_remap_range(
> > 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
> > 		xfs_log_force_inode(dest);
> > out_unlock:
> > -	xfs_iunlock2_io_mmap(src, dest);
> > +	xfs_iunlock2_io_mmap_src_shared(src, dest);
> > 	if (ret)
> > 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> > 	return remapped > 0 ? remapped : ret;
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 52d6f2c7d58b..721abefbb1fa 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3786,6 +3786,22 @@ xfs_ilock2_io_mmap(
> > 	return 0;
> > }
> > 
> > +/*
> > + * Downgrade the locks on src file if src and dest are not the same one.
> > + */
> > +void
> > +xfs_ilock_io_mmap_downgrade_src(
> > +	struct xfs_inode	*src,
> > +	struct xfs_inode	*dest)
> > +{
> > +	if (src != dest) {
> > +		struct inode *inode = VFS_I(src);
> > +
> > +		downgrade_write(&inode->i_mapping->invalidate_lock);
> > +		downgrade_write(&inode->i_rwsem);

xfs_ilock_demote?

	if (src == dest)
		return;

	xfs_ilock_demote(src, XFS_MMAPLOCK_EXCL);
	xfs_ilock_demote(src, XFS_IOLOCK_EXCL);

That way we still get the xfs_ilock_demote tracepoint.

> > +	}
> > +}
> > +
> > /* Unlock both inodes to allow IO and mmap activity. */
> > void
> > xfs_iunlock2_io_mmap(
> > @@ -3798,3 +3814,23 @@ xfs_iunlock2_io_mmap(
> > 	if (ip1 != ip2)
> > 		inode_unlock(VFS_I(ip1));
> > }
> > +
> > +/* Unlock the exclusive locks on dest file.

Multiline comments should start on a separate line.

> > + * Also unlock the shared locks on src if src and dest are not the same one
> > + */
> > +void
> > +xfs_iunlock2_io_mmap_src_shared(
> > +	struct xfs_inode	*src,
> > +	struct xfs_inode	*dest)
> > +{
> > +	struct inode	*src_inode = VFS_I(src);
> > +	struct inode	*dest_inode = VFS_I(dest);
> > +
> > +	inode_unlock(dest_inode);
> > +	up_write(&dest_inode->i_mapping->invalidate_lock);

filemap_invalidate_unlock

> > +	if (src == dest)
> > +		return;
> > +
> > +	inode_unlock_shared(src_inode);
> > +	up_read(&src_inode->i_mapping->invalidate_lock);

filemap_invalidate_unlock_shared

--D

> > +}
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 7be6f8e705ab..02b44e1a7e4e 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -512,5 +512,9 @@ void xfs_end_io(struct work_struct *work);
> > 
> > int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> > void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> > +void xfs_ilock_io_mmap_downgrade_src(struct xfs_inode *src,
> > +					struct xfs_inode *dest);
> > +void xfs_iunlock2_io_mmap_src_shared(struct xfs_inode *src,
> > +					struct xfs_inode *dest);
> > 
> > #endif	/* __XFS_INODE_H__ */
> > -- 
> > 2.21.0 (Apple Git-122.2)
> > 
> 
