Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KCMH5w091455 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:22:27 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC5AC3E54D1
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 05:22:44 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 0DQMYa3vXAfdRSKG for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 05:22:44 -0700 (PDT)
Date: Thu, 20 Aug 2009 14:22:43 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 14/17] xfs: Use new syncing helper
Message-ID: <20090820122243.GD16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-15-git-send-email-jack@suse.cz>
	<20090819163315.GA19969@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090819163315.GA19969@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed 19-08-09 12:33:15, Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 06:04:41PM +0200, Jan Kara wrote:
> > diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
> > index 7078974..aeb5a39 100644
> > --- a/fs/xfs/linux-2.6/xfs_lrw.c
> > +++ b/fs/xfs/linux-2.6/xfs_lrw.c
> > @@ -817,7 +817,7 @@ write_retry:
> >  		xfs_iunlock(xip, iolock);
> >  		if (need_i_mutex)
> >  			mutex_unlock(&inode->i_mutex);
> > -		error2 = sync_page_range(inode, mapping, pos, ret);
> > +		error2 = generic_write_sync(file, pos, ret);
> 
> I don't think this is very optimal for XFS.  This first starts an
> asynchronous writeout of the range in generic_write_sync,
> then calls into ->fsync which waits for all I/O on the file to finish,
> then forces the log inside xfs_fsync,  then waits for the range again in
> generic_write_sync, and after this code calls into
> xfs_write_sync_logforce which forces to log _again_.
> 
> We should be fine just doing your new filemap_fdatawrite_range helper
> here and let xfs_write_sync_logforce do the work.  Long term we should
> just get rid of this stupid submit writes before syncing the iode, then
> wait crap which is a pain for all modern filesystems.
  OK, I'll happily change this. I was just doing the straightforward
conversion and sync_page_range() essentially did what generic_write_sync()
does since it called fdatawrite(), write_inode_now(inode, 1) (here XFS was
forced to wait for pages and force the log), fdatawait().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
