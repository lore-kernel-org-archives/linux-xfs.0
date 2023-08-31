Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAE8C83F2F
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 20:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345453AbjHaUT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244103AbjHaUT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 16:19:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718CE5C
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 13:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693513151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F9p7Q46cK6HRGLbVDIzI3vhF5a2YY/ys8vYcG1u965g=;
        b=IbVlE/4Wi6m0qFuPqhml354HlwUGvZoUjvuU29yLxkNlSZwHQBv7MYHKbtidtWUsLOnr0V
        53/qqwB1e86J81O65o3q391xnMwBdgUMU1n1rrdbWrKq2zQlehuCPIGQRkE0zilh9RgJXS
        d20GYm/794caQ0W8P0y3W4BJvFVXiVE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-pxFQ-gkxPI6nZ0F3mWBTBw-1; Thu, 31 Aug 2023 16:19:07 -0400
X-MC-Unique: pxFQ-gkxPI6nZ0F3mWBTBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 360D9101A52E;
        Thu, 31 Aug 2023 20:18:52 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF7AD2166B25;
        Thu, 31 Aug 2023 20:18:51 +0000 (UTC)
Date:   Thu, 31 Aug 2023 15:18:50 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     Bill O'Donnell <bodonnel@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2] xfs: load uncached unlinked inodes into memory on
 demand
Message-ID: <ZPD1qsrKB8P64iRM@redhat.com>
References: <20230830152659.GJ28186@frogsfrogsfrogs>
 <ZPDXqUJ94w8ZgOqy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPDXqUJ94w8ZgOqy@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I jumped the gun and only reviewed the userspace patches. Sorry,
I'll actually look at the kernel patch now. ;)
-Bill

On Thu, Aug 31, 2023 at 01:10:49PM -0500, Bill O'Donnell wrote:
> On Wed, Aug 30, 2023 at 08:26:59AM -0700, Darrick J. Wong wrote:
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
> > Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> > Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> This LGTM. Thanks!
> Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> 
> > ---
> > v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
> >     and actually return ENOLINK
> > ---
> >  fs/xfs/xfs_inode.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_trace.h |   25 +++++++++++++++++
> >  2 files changed, 96 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6ee266be45d4..2942002560b5 100644
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
> > @@ -1858,7 +1863,8 @@ xfs_iunlink_update_backref(
> >  
> >  	ip = xfs_iunlink_lookup(pag, next_agino);
> >  	if (!ip)
> > -		return -EFSCORRUPTED;
> > +		return -ENOLINK;
> > +
> >  	ip->i_prev_unlinked = prev_agino;
> >  	return 0;
> >  }
> > @@ -1902,6 +1908,62 @@ xfs_iunlink_update_bucket(
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
> > +	xfs_info_ratelimited(mp,
> > + "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
> > +			next_agino, pag->pag_agno);
> > +
> > +	/*
> > +	 * Use an untrusted lookup to be cautious in case the AGI has been
> > +	 * corrupted and now points at a free inode.  That shouldn't happen,
> > +	 * but we'd rather shut down now since we're already running in a weird
> > +	 * situation.
> > +	 */
> > +	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
> > +	if (error)
> > +		return error;
> > +
> > +	/* If this is not an unlinked inode, something is very wrong. */
> > +	if (VFS_I(next_ip)->i_nlink != 0) {
> > +		error = -EFSCORRUPTED;
> > +		goto rele;
> > +	}
> > +
> > +	next_ip->i_prev_unlinked = prev_agino;
> > +	trace_xfs_iunlink_reload_next(next_ip);
> > +rele:
> > +	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
> > +	xfs_irele(next_ip);
> > +	return error;
> > +}
> > +
> >  static int
> >  xfs_iunlink_insert_inode(
> >  	struct xfs_trans	*tp,
> > @@ -1933,6 +1995,8 @@ xfs_iunlink_insert_inode(
> >  	 * inode.
> >  	 */
> >  	error = xfs_iunlink_update_backref(pag, agino, next_agino);
> > +	if (error == -ENOLINK)
> > +		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
> >  	if (error)
> >  		return error;
> >  
> > @@ -2027,6 +2091,9 @@ xfs_iunlink_remove_inode(
> >  	 */
> >  	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
> >  			ip->i_next_unlinked);
> > +	if (error == -ENOLINK)
> > +		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
> > +				ip->i_next_unlinked);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 36bd42ed9ec8..f4e46bac9b91 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3832,6 +3832,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
> >  		  __entry->new_ptr)
> >  );
> >  
> > +TRACE_EVENT(xfs_iunlink_reload_next,
> > +	TP_PROTO(struct xfs_inode *ip),
> > +	TP_ARGS(ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, agino)
> > +		__field(xfs_agino_t, prev_agino)
> > +		__field(xfs_agino_t, next_agino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = ip->i_mount->m_super->s_dev;
> > +		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> > +		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> > +		__entry->prev_agino = ip->i_prev_unlinked;
> > +		__entry->next_agino = ip->i_next_unlinked;
> > +	),
> > +	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->agno,
> > +		  __entry->agino,
> > +		  __entry->prev_agino,
> > +		  __entry->next_agino)
> > +);
> > +
> >  DECLARE_EVENT_CLASS(xfs_ag_inode_class,
> >  	TP_PROTO(struct xfs_inode *ip),
> >  	TP_ARGS(ip),
> > 
> 

