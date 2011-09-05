Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p85DMMlM015245 for <xfs@oss.sgi.com>; Mon, 5 Sep 2011 08:22:22 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A272413532F
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2011 06:22:21 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id UIwotpvPvDcdoxGW for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2011 06:22:21 -0700 (PDT)
Date: Mon, 5 Sep 2011 21:22:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH, RFC] writeback: avoid redirtying when ->write_inode
	failed to clear I_DIRTY
Message-ID: <20110905132216.GB1349@localhost>
References: <20110827061409.GA6854@infradead.org>
	<20110827135825.GA22575@localhost>
	<20110903011315.GJ12182@quack.suse.cz>
	<20110903213527.GB10529@localhost>
	<20110905111153.GD5466@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110905111153.GD5466@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 05, 2011 at 07:11:53PM +0800, Jan Kara wrote:
> On Sun 04-09-11 05:35:27, Wu Fengguang wrote:
> > On Sat, Sep 03, 2011 at 09:13:15AM +0800, Jan Kara wrote:
> > > On Sat 27-08-11 21:58:25, Wu Fengguang wrote:
> > > > Christoph,
> > > > 
> > > > On Sat, Aug 27, 2011 at 02:14:09PM +0800, Christoph Hellwig wrote:
> > > > > Right now ->write_inode has no way to safely return a EAGAIN without explicitly
> > > > > redirtying the inode, as we would lose the dirty state otherwise.  Most
> > > > > filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
> > > > > the flusher thread when ->write_inode hits contentended inode locks.  A
> > > > > contended ilock is something XFS can hit very easibly when extending files, as
> > > > > the data I/O completion handler takes the lock to update the size, and the
> > > > > ->write_inode call can race with it fairly easily if writing enough data
> > > > > in one go so that the completion for the first write come in just before
> > > > > we call ->write_inode.
> > > > > 
> > > > > Change the handling of this case to use requeue_io for a quick retry instead
> > > > > of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
> > > > > delaying the writeout more and more with every failed attempt to get the lock.
> > > > 
> > > > Yeah redirty_tail() does have the problem of possibly delay inodes for
> > > > too long time. However, you know requeue_io() always has the danger of
> > > > triggering busy wb_writeback() loops in corner cases.
> > > > 
> > > > For example, nfs_write_inode()/nfs_commit_unstable_pages() often
> > > > redirty the inode without doing anything (hence no any progress, a
> > > > prerequisite for busy loops) depending on the in flight writes, which
> > > > unfortunately further depends on _external_ network/server states..
> > > > That means some stalled network/sever state could lead to busy loops
> > > > in NFS clients.
> > > > 
> > > > The alternative solution may be to firstly apply the attached patch,
> > > > and change this one to:
> > > > 
> > > >   -			redirty_tail(inode, wb);
> > > >   +			requeue_io_wait(inode, wb);
> > >   But your patch doesn't solve the busyloop when the problematic inodes are
> > > the only ones under writeback, does it? Then b_more_io and b_more_io_wait
> > > are effectively the same if I understand it right.
> > 
> > The difference lies in the
> > 
> >                 /*
> >                  * No more inodes for IO, bail
> >                  */
> >                 if (list_empty(&wb->b_more_io))
> >                         break;
> > 
> > check in wb_writeback(). So when what's left are all b_more_io_wait
> > inodes, the above check will take effect and break the loop. This is
> > the tricky point of the patch: it relies on the code not touched by
> > the patch to work. I've updated the changelog to explain this.
>   Argh, that's really subtle! Two points here.

Yes, it is..

> 1) We will immediately retry inodes in b_more_io_wait list because of
> 	if (progress)
> 		continue;
> check.

That's right. I'm aware of this and think it's reasonable to not
sleep as long as there are b_more_io inodes to write. The typical
situation will be, the time take to write b_more_io inodes naturally
serve as necessary delay to retry the b_more_io_wait inodes.

> 2) The time writeout will be delayed is only <=dirty_expire_centisecs but
> can be arbitrarily small if someone submits more work.

Exactly.

> Also if wb_writeback() was called from wb_do_writeback(), we will
> retry b_more_io_wait inodes twice immediately because of
> wb_check_old_data_flush() and wb_check_background_flush() calls.

Right. However given that wb_check_old_data_flush() is ratelimited by
dirty_writeback_interval=5s and wb_check_background_flush() is limited
by over_bground_thresh(), it's hardly a real problem.

> > > I think that busylooping in cases like these could be fixed improving the
> > > busyloop prevention at the end of the loop in wb_writeback(). Maybe we
> > > could just take a short nap before continuting with writeback instead of /
> > > in addition to waiting for inode writeback. What do you think?
> > 
> > That's a reasonable robust option, however at the cost of keeping the
> > writeback code in some ambiguous state ;)
>   What do you exactly mean by ambiguous state?

I mean in Christoph's case, it will be calling requeue_io() and at the
same time rely on your suggested unconditional sleep at the end of
wb_writeback() loop to avoid busy loop. Or in other words, b_more_io
will be holding both inodes that should be busy retried and the inodes
to be opportunistically retried.  However I admit it's not a big
problem if we take b_more_io as general "to be retried ASAP".

> I don't see anything ambiguous in waiting for a jiffie or so. Not
> that I'd be completely happy about "just wait for a while and see if
> things are better" but your solution does not seem ideal either... 

There are no big differences (that matter) in terms of "how much exact
time to wait" in this XFS case.  What make me prefer b_more_io_wait is
that it looks a more general solution to replace the majority
redirty_tail() calls to avoid modifying dirtied_when.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
