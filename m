Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKYing024757 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:34:45 -0600
Date: Fri, 12 Feb 2010 15:35:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100212203559.GA28731@infradead.org>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220505.26466.99037.stgit@case>
	<1265986006.3201.112.camel@doink1>
	<20100212174706.GB22633@infradead.org>
	<20100212195647.GQ23654@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100212195647.GQ23654@sgi.com>
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
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Feb 12, 2010 at 01:56:47PM -0600, bpm@sgi.com wrote:
> I chose not implement that suggestion because I prefer not to rely upon
> the coincidence that the child be modified last and synced first in
> knfsd.

It does ot rely on that coincidence for correctness, just for a small
performance optimization.

> It is better that the intent of the patch be clear, and that
> filesystems other than xfs also have enough information to sort out how
> to sync more efficiently.  knfsd shouldn't be forced to sync in a
> specific order just because that's what works best for xfs.  Or, mebbe
> it should and I'm being thick.  ;)

The order of parent and child only happens in the create case where
NFS does a separate ->setattr call.  For all the operations handled
by the filesystem parent and child are in the same transaction for
every transactional filesystem.

> > This keeps the calling convention quite a bit simpler,
> > and also means we don't have to bother with locking two inodes or lsn
> > comparisms.
> 
> Don't need the ilock to check pincount?

Ah sorry, that should have read not bothering with locking two inodes
at the same time, which always is a bit troublesome.  We do need to lock
the inode for looking at the pincount.

> > We can deal with that by either commiting the old variant to the nfs
> > tree and then leaving sending Stephen a patch to fix it up in -next,
> > or just not apply the xfs commit_metadata implementation yet, and wait
> > for it until both the xfs and nfs trees have hit mainline.
> 
> Yeah.  I don't know who Stephen is.

Stephen Rothwell is the maintainer of the linux-next tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
