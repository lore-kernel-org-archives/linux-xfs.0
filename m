Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OMZVeL169921 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:35:32 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E398199A7FF
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:34:59 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id ENHCxG14TjXjF0fl
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:34:59 -0800 (PST)
Date: Wed, 25 Feb 2009 09:34:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
Message-ID: <20090224223451.GE26138@disturbed>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
	<20090224191429.GA10627@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090224191429.GA10627@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2009 at 02:14:29PM -0500, Christoph Hellwig wrote:
> On Fri, Feb 20, 2009 at 12:22:42PM -0800, Andrew Morton wrote:
> > But to fix this bug, xfs needs to stop calling inode_init_always()
> > under read_lock().  Because inode_alloc_security() also can sleep (see
> > new_inode_smack()).
> 
> The normal inode initialization path is fine as it's not in atomic
> context, but if we relcaim a partially torn down inode in
> xfs_iget_cache_hit we call inode_init_always under pag_ici_lock.
> 
> I wonder if we should just give up on trying to "recover" such
> inodes.  Instead call finish_reclaim on them and restart the inode
> cache lookup.

The reason for this code is that journalling allows us to reuse the
inode without flushing it to disk. If we reclaim it, then we force
it to be flushed to disk before it can be reused. That will greatly
slow down workloads that create and delete temporary files
repeatedly.

I had a brief look at the code, and I think it can be reworked to
avoid re-initialisation under the pag_ici_lock. I should have some
time this weekend to test a fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
