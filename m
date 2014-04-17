Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7CA87F5D
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 23:41:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 327D6AC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:41:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	prWQPpFldQYZROMq for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 21:41:55 -0700 (PDT)
Date: Thu, 17 Apr 2014 14:41:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/19] Make effect of PF_FSTRANS to disable __GFP_FS
	universal.
Message-ID: <20140417044152.GW15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.58240.stgit@notabene.brown>
	<20140416053756.GC15995@dastard>
	<20140416161726.51b506e2@notabene.brown>
	<20140417110350.0470feba@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140417110350.0470feba@notabene.brown>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, xfs@oss.sgi.com

On Thu, Apr 17, 2014 at 11:03:50AM +1000, NeilBrown wrote:
> On Wed, 16 Apr 2014 16:17:26 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > On Wed, 16 Apr 2014 15:37:56 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> 
> > > > -	/*
> > > > -	 * Given that we do not allow direct reclaim to call us, we should
> > > > -	 * never be called while in a filesystem transaction.
> > > > -	 */
> > > > -	if (WARN_ON(current->flags & PF_FSTRANS))
> > > > -		goto redirty;
> > > 
> > > We still need to ensure this rule isn't broken. If it is, the
> > > filesystem will silently deadlock in delayed allocation rather than
> > > gracefully handle the problem with a warning....
> > 
> > Hmm... that might be tricky.  The 'new' PF_FSTRANS can definitely be set when
> > xfs_vm_writepage is called and we really want the write to happen.
> > I don't suppose there is any other way to detect if a transaction is
> > happening?
> 
> I've been thinking about this some more....
> 
> That code is in xfs_vm_writepage which is only called as ->writepage.
> xfs never calls that directly so it could only possibly be called during
> reclaim?

    __filemap_fdatawrite_range or __writeback_single_inode
      do_writepages
	->writepages
	  xfs_vm_writepages
	    write_cache_pages
	      ->writepage
	        xfs_vm_writepage

So explicit data flushes or background writeback still end up in
xfs_vm_writepage.

> We know that doesn't happen, but if it does then PF_MEMALLOC would be set,
> but PF_KSWAPD would not... and you already have a test for that.
> 
> How about every time we set PF_FSTRANS, we store the corresponding
> xfs_trans_t in current->journal_info, and clear that field when PF_FSTRANS is
> cleared.  Then xfs_vm_writepage can test for current->journal_info being
> clear.
> That is the field that several other filesystems use to keep track of the
> 'current' transaction.

The difference is that we have an explicit transaction handle in XFS
which defines the transaction context. i.e. we don't hide
transactions in thread contexts - the transaction defines the atomic
context of the modification being made.....

> I don't know what xfs_trans_t we would use in
> xfs_bmapi_allocate_worker, but I suspect you do :-)

The same one we use now.

But that's exactly my point.  i.e. the transaction handle belongs to
the operation being executed, not the thread that is currently
executing it.  We also hand transaction contexts to IO completion,
do interesting things with log space reservations for operations
that require multiple commits to complete and so pass state when
handles are duplicated prior to commit, etc. We still need direct
manipulation and control of the transaction structure, regardless of
where it is stored.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
