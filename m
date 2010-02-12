Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CJste1019824 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 13:54:55 -0600
Date: Fri, 12 Feb 2010 13:56:47 -0600
From: bpm@sgi.com
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100212195647.GQ23654@sgi.com>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220505.26466.99037.stgit@case>
	<1265986006.3201.112.camel@doink1>
	<20100212174706.GB22633@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100212174706.GB22633@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Feb 12, 2010 at 12:47:07PM -0500, Christoph Hellwig wrote:
> On Fri, Feb 12, 2010 at 08:46:46AM -0600, Alex Elder wrote:
> > On Thu, 2010-02-11 at 16:05 -0600, Ben Myers wrote:
> > > This is the commit_metadata export operation for XFS, including the changes
> > > suggested by hch and dgc:
> > > 
> > > - Takes two two inodes instead of dentries and can assume the parent is
> > > always set.
> > 
> > I alluded to this in my review of the first patch.
> > This could be changed considered in a more generic
> > sense, "sync one or two inodes' metadata" rather
> > than presupposing the two inodes have a parent/child
> > relationship.
> 
> Or just implement my later suggestion to only pass one inode to the
> method and cal in on both inodes.   For the non-create case where
> we have only one transaction to deal with fhr first call will take
> care of it and unpin the second inode by forcing the log buffer out.
> For the create case we need to make sure to call it on the child first
> so that we force out the setattr transaction which also forced out the
> earlier one.

I chose not implement that suggestion because I prefer not to rely upon
the coincidence that the child be modified last and synced first in
knfsd.  It is better that the intent of the patch be clear, and that
filesystems other than xfs also have enough information to sort out how
to sync more efficiently.  knfsd shouldn't be forced to sync in a
specific order just because that's what works best for xfs.  Or, mebbe
it should and I'm being thick.  ;)

Alex's suggestion that ->commit_metadata be more generic about the
relationship of the two inodes seems reasonable, not sure what that
means for vfs.c:commit_metadata.  This will help with the rename case.

> This keeps the calling convention quite a bit simpler,
> and also means we don't have to bother with locking two inodes or lsn
> comparisms.

Don't need the ilock to check pincount?

> > > +		error = _xfs_log_force(mp, force_lsn,
> > > +				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
> > 
> > You want this here:
> >  error = xfs_log_force_lsn(mp, force_lsn, XFS_LOG_FORCE | XFS_LOG_SYNC);
> 
> In the XFS tree we do want either
> 
> 	xfs_log_force_lsn(mp, force_lsn, XFS_LOG_SYNC);
> 
> or
> 	error = _xfs_log_force_lsn(mp, force_lsn, XFS_LOG_SYNC, NULL);
> 
> if we care enough about the returned error.  But Ben is working against
> the NFS tree which doesn't have that change yet.
> 
> We can deal with that by either commiting the old variant to the nfs
> tree and then leaving sending Stephen a patch to fix it up in -next,
> or just not apply the xfs commit_metadata implementation yet, and wait
> for it until both the xfs and nfs trees have hit mainline.

Yeah.  I don't know who Stephen is.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
