Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4656DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8232053B
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g3lOZl3S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502368AbfJYQrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:47:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390972AbfJYQrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+rhj++vNpZlKndbk2xFnJW7rza2o4t0D4++KlaQkv5w=; b=g3lOZl3S9EqbQo1Itv/9k1SXp
        elXlUbgNuUSsvuHdU6VtG+tjwJi5/bkdQTIpzmKn3gX4qyMcAJ58cCjlrwPzTYNgL6sbYjl9PwL0a
        2RrGdlA2t1X2feApzQdSJNGqrPEAX98wpLlTtJ27K+BJH1VgY1tlkubm/3AWb9VbIuSnzfQMYpbMp
        aoOdVJ+ekz+yvKpF5ZX3K2N0cXP9oOerum8s7xd5NNesQpQ5te9NRWsJYEGGdBTmvOjwaXmyBmvO9
        yKOQSTElG7W5PB4sYKd7eLRY5uPzY2txxgg/O7B9ILrD/55McT0ppjWMshQVHUw/DoqNmIm5Pl0eZ
        l7wGwqPlQ==;
Received: from [88.128.80.145] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO2jj-0001EW-RQ; Fri, 25 Oct 2019 16:46:59 +0000
Date:   Fri, 25 Oct 2019 18:45:59 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 09/17] xfs: add xfs_remount_rw() helper
Message-ID: <20191025164559.GA30200@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190348247.27074.12897905716268545882.stgit@fedora-28>
 <20191024153123.GS913374@magnolia>
 <90501efd6808a0816dbdf03b508130136bc8a94e.camel@themaw.net>
 <20191024231258.GZ913374@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024231258.GZ913374@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 04:12:58PM -0700, Darrick J. Wong wrote:
> > The fill super method needs quite a few more forward declarations
> > too.
> > 
> > I responded to Christoph's suggestion of grouping the mount code
> > together saying this would be needed, and that I thought the
> > improvement of grouping the code together was worth the forward
> > declarations, and asked if anyone had a different POV on it and
> > got no replies, ;)
> > 
> > The other thing is that the options definitions notionally belong
> > near the top of the mount/super block handling code so moving it
> > all down seemed like the wrong thing to do ...
> > 
> > So what do you think of the extra noise of forward declarations
> > in this case?
> 
> Eh, fine with me.  I was just curious, having speed-read over the
> previous iterations. :)

So looking at the result I'm not sure my suggestion was productive.  It
turns out there is a fair chunk of mount code at the end of the file as
well, and there is literally nothing left of the the code towards the
top of the file except for the Opt_* definitions.  So while I think
using this rewrite as a chance to group the code is still a good
idea, I suspect the better (and actually more natural) place is toward
the bottom of the file.
> 
> --D
> 
> > Ian
> > 
> > > 
> > > --D
> > > 
> > > > +
> > > >  /*
> > > >   * Table driven mount option parser.
> > > >   */
> > > > @@ -455,6 +457,68 @@ xfs_mount_free(
> > > >  	kmem_free(mp);
> > > >  }
> > > >  
> > > > +static int
> > > > +xfs_remount_rw(
> > > > +	struct xfs_mount	*mp)
> > > > +{
> > > > +	struct xfs_sb		*sbp = &mp->m_sb;
> > > > +	int			error;
> > > > +
> > > > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > > > +		xfs_warn(mp,
> > > > +			"ro->rw transition prohibited on norecovery
> > > > mount");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > > > +	    xfs_sb_has_ro_compat_feature(sbp,
> > > > XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > > > +		xfs_warn(mp,
> > > > +	"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > > > filesystem",
> > > > +			(sbp->sb_features_ro_compat &
> > > > +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > > +
> > > > +	/*
> > > > +	 * If this is the first remount to writeable state we might
> > > > have some
> > > > +	 * superblock changes to update.
> > > > +	 */
> > > > +	if (mp->m_update_sb) {
> > > > +		error = xfs_sync_sb(mp, false);
> > > > +		if (error) {
> > > > +			xfs_warn(mp, "failed to write sb changes");
> > > > +			return error;
> > > > +		}
> > > > +		mp->m_update_sb = false;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * Fill out the reserve pool if it is empty. Use the stashed
> > > > value if
> > > > +	 * it is non-zero, otherwise go with the default.
> > > > +	 */
> > > > +	xfs_restore_resvblks(mp);
> > > > +	xfs_log_work_queue(mp);
> > > > +
> > > > +	/* Recover any CoW blocks that never got remapped. */
> > > > +	error = xfs_reflink_recover_cow(mp);
> > > > +	if (error) {
> > > > +		xfs_err(mp,
> > > > +			"Error %d recovering leftover CoW
> > > > allocations.", error);
> > > > +			xfs_force_shutdown(mp,
> > > > SHUTDOWN_CORRUPT_INCORE);
> > > > +		return error;
> > > > +	}
> > > > +	xfs_start_block_reaping(mp);
> > > > +
> > > > +	/* Create the per-AG metadata reservation pool .*/
> > > > +	error = xfs_fs_reserve_ag_blocks(mp);
> > > > +	if (error && error != -ENOSPC)
> > > > +		return error;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  struct proc_xfs_info {
> > > >  	uint64_t	flag;
> > > >  	char		*str;
> > > > @@ -1169,7 +1233,7 @@ xfs_save_resvblks(struct xfs_mount *mp)
> > > >  	xfs_reserve_blocks(mp, &resblks, NULL);
> > > >  }
> > > >  
> > > > -STATIC void
> > > > +static void
> > > >  xfs_restore_resvblks(struct xfs_mount *mp)
> > > >  {
> > > >  	uint64_t resblks;
> > > > @@ -1307,57 +1371,8 @@ xfs_fs_remount(
> > > >  
> > > >  	/* ro -> rw */
> > > >  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY))
> > > > {
> > > > -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > > > -			xfs_warn(mp,
> > > > -		"ro->rw transition prohibited on norecovery mount");
> > > > -			return -EINVAL;
> > > > -		}
> > > > -
> > > > -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > > > -		    xfs_sb_has_ro_compat_feature(sbp,
> > > > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > > > {
> > > > -			xfs_warn(mp,
> > > > -"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > > > filesystem",
> > > > -				(sbp->sb_features_ro_compat &
> > > > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > > > ;
> > > > -			return -EINVAL;
> > > > -		}
> > > > -
> > > > -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > > -
> > > > -		/*
> > > > -		 * If this is the first remount to writeable state we
> > > > -		 * might have some superblock changes to update.
> > > > -		 */
> > > > -		if (mp->m_update_sb) {
> > > > -			error = xfs_sync_sb(mp, false);
> > > > -			if (error) {
> > > > -				xfs_warn(mp, "failed to write sb
> > > > changes");
> > > > -				return error;
> > > > -			}
> > > > -			mp->m_update_sb = false;
> > > > -		}
> > > > -
> > > > -		/*
> > > > -		 * Fill out the reserve pool if it is empty. Use the
> > > > stashed
> > > > -		 * value if it is non-zero, otherwise go with the
> > > > default.
> > > > -		 */
> > > > -		xfs_restore_resvblks(mp);
> > > > -		xfs_log_work_queue(mp);
> > > > -
> > > > -		/* Recover any CoW blocks that never got remapped. */
> > > > -		error = xfs_reflink_recover_cow(mp);
> > > > -		if (error) {
> > > > -			xfs_err(mp,
> > > > -	"Error %d recovering leftover CoW allocations.", error);
> > > > -			xfs_force_shutdown(mp,
> > > > SHUTDOWN_CORRUPT_INCORE);
> > > > -			return error;
> > > > -		}
> > > > -		xfs_start_block_reaping(mp);
> > > > -
> > > > -		/* Create the per-AG metadata reservation pool .*/
> > > > -		error = xfs_fs_reserve_ag_blocks(mp);
> > > > -		if (error && error != -ENOSPC)
> > > > +		error = xfs_remount_rw(mp);
> > > > +		if (error)
> > > >  			return error;
> > > >  	}
> > > >  
> > > > 
> > 
---end quoted text---
