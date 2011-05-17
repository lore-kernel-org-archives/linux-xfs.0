Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HFn9jt190613 for <xfs@oss.sgi.com>; Tue, 17 May 2011 10:49:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B30171EC9AD6
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 08:49:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0VJqlHUZXwxlyFu3 for
	<xfs@oss.sgi.com>; Tue, 17 May 2011 08:49:08 -0700 (PDT)
Date: Tue, 17 May 2011 11:49:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock during reclaim in _xfs_trans_alloc?
Message-ID: <20110517154907.GA17735@infradead.org>
References: <BANLkTinyaam3pFub7QD4Xi=tn8WvFfmqJw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinyaam3pFub7QD4Xi=tn8WvFfmqJw@mail.gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, May 17, 2011 at 10:37:59AM -0400, Peter Watkins wrote:
> Greetings,
> 
> I think I've hit another case when reclaim recurses into xfs and deadlocks.
> 
> The system was under memory pressure and an fsync() call sent xfs into
> reclaim which blocked on the prune_icache mutex while holding an xfs
> inode buffer lock. Another thread, also in reclaim, held the
> prune_icache mutex but needed that xfs inode buffer lock to make
> progress.
> 
> Perhaps _xfs_trans_alloc should not recurse into the filesystem if its
> allocation goes into reclaim? Should it say:
> 
>        tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP|KM_NOFS);
> 
> I'll send a proposed patch in a second. (I'm on 2.6.27, but the patch
> will be against latest)

My patch "prune back iprune_sem" which landed in Linux 2.6.39 as commit
bab1d9444d9a147f1dc3478dd06c16f490227f3e should fix that at the VFS
level.  I'm not sure how 2.6.27 looks in that area, but a lot of things
have changed so a backport might not be trivial.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
