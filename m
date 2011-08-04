Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74C7RhI067847 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 07:07:27 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E5F6532049
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 05:07:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id nB4GfkV93oIZvqhG for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 05:07:26 -0700 (PDT)
Date: Thu, 4 Aug 2011 14:07:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Improve writeout pattern from xfs_flush_pages()
Message-ID: <20110804120724.GA20800@quack.suse.cz>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
	<20110803214206.GA20477@infradead.org>
	<20110804103616.GF17196@quack.suse.cz>
	<20110804104210.GA30823@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110804104210.GA30823@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 04-08-11 06:42:10, Christoph Hellwig wrote:
> On Thu, Aug 04, 2011 at 12:36:16PM +0200, Jan Kara wrote:
> > > The first one actually is a synchronous writeout, just implemented in
> > > a rather odd way by doing the xfs_ioend_wait right after it, so your
> > > change is actively harmful for it.
> >   Oh, right. BTW cannot be truncate livelocked on a busy file because of
> > that xfs_ioend_wait()?
> 
> Not really.  We requite the iolock for new writes to start, and truncate
> holds it exclusively.  But I'm working on a series for 3.2 to remove
> xfs_ioend_wait and just rely on inode_dio_wait for direct I/O, so it
> will be gone soon.  At this point I'll also have to switch to
> filemap_write_and_wait_range for this caller.
> 
> > > The third one is opportunistic writeout if a file got truncated down on
> > > final release.  filemap_flush probably is fine here, but there's no need
> > > for a range version.  If you replace it with filemap_flush please also
> > > kill the useless wrapper while you're at it.
> >   Do you mean xfs_flush_pages()? OK, I can do that.
> 
> Yes, xfs_flush_pages should go - at least he async version and its
> abuse of the buffer flags.
  Hmm, BTW, shouldn't the call to xfs_flush_pages() in
xfs_file_buffered_aio_write() be converted to an asynchronous one? I don't
quite see a point in waiting for io completion... Generally, flushing of
the inode there seems of limited usefulness to me since that inode could be
just a tiny victim not holding much delayallocated blocks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
