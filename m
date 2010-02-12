Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHjqiD010136 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:45:52 -0600
Date: Fri, 12 Feb 2010 12:47:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100212174706.GB22633@infradead.org>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220505.26466.99037.stgit@case>
	<1265986006.3201.112.camel@doink1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265986006.3201.112.camel@doink1>
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
To: Alex Elder <aelder@sgi.com>
Cc: bfields@fieldses.org, Ben Myers <bpm@sgi.com>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 08:46:46AM -0600, Alex Elder wrote:
> On Thu, 2010-02-11 at 16:05 -0600, Ben Myers wrote:
> > This is the commit_metadata export operation for XFS, including the changes
> > suggested by hch and dgc:
> > 
> > - Takes two two inodes instead of dentries and can assume the parent is
> > always set.
> 
> I alluded to this in my review of the first patch.
> This could be changed considered in a more generic
> sense, "sync one or two inodes' metadata" rather
> than presupposing the two inodes have a parent/child
> relationship.

Or just implement my later suggestion to only pass one inode to the
method and cal in on both inodes.   For the non-create case where
we have only one transaction to deal with fhr first call will take
care of it and unpin the second inode by forcing the log buffer out.
For the create case we need to make sure to call it on the child first
so that we force out the setattr transaction which also forced out the
earlier one.   This keeps the calling convention quite a bit simpler,
and also means we don't have to bother with locking two inodes or lsn
comparisms.

> > - Uses xfs_lock_two_inodes for the ilock.
> > 
> > - Forces the log up to the larger lsn of parent and child.
> > 
> > - Uses XFS_LSN_CMP for lsn comparison.
> > 
> > - Doesn't force the log if nobody had a pincount.
> 
> So if the log doesn't get forced, what causes the
> desired metadata sync expected as a result of this
> call?  (Maybe this is a dumb question.)

Inodes get pinned on transaction commit, and unpinned when the log I/O
for that transaction completes.  If the inode is not pinned this implies
it has already been written to disk, e.g. because we're filling the log
so fast that we need to write out more log buffers in that tiny window
between the metada operation and the commit_metadata call.

> > +		force_lsn = ip->i_itemp->ili_last_lsn;
> > +	}
> > +
> > +	if (force_lsn != NULLCOMMITLSN) {
> > +		error = _xfs_log_force(mp, force_lsn,
> > +				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
> 
> You want this here:
>  error = xfs_log_force_lsn(mp, force_lsn, XFS_LOG_FORCE | XFS_LOG_SYNC);

In the XFS tree we do want either

	xfs_log_force_lsn(mp, force_lsn, XFS_LOG_SYNC);

or
	error = _xfs_log_force_lsn(mp, force_lsn, XFS_LOG_SYNC, NULL);

if we care enough about the returned error.  But Ben is working against
the NFS tree which doesn't have that change yet.

We can deal with that by either commiting the old variant to the nfs
tree and then leaving sending Stephen a patch to fix it up in -next,
or just not apply the xfs commit_metadata implementation yet, and wait
for it until both the xfs and nfs trees have hit mainline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
