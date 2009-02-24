Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OJEx9s161171 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 13:14:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60BD814C595
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 11:14:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X64Jjb3YusxEQO37 for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 11:14:29 -0800 (PST)
Date: Tue, 24 Feb 2009 14:14:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
Message-ID: <20090224191429.GA10627@infradead.org>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090220122242.b36a778f.akpm@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 20, 2009 at 12:22:42PM -0800, Andrew Morton wrote:
> But to fix this bug, xfs needs to stop calling inode_init_always()
> under read_lock().  Because inode_alloc_security() also can sleep (see
> new_inode_smack()).

The normal inode initialization path is fine as it's not in atomic
context, but if we relcaim a partially torn down inode in
xfs_iget_cache_hit we call inode_init_always under pag_ici_lock.

I wonder if we should just give up on trying to "recover" such
inodes.  Instead call finish_reclaim on them and restart the inode
cache lookup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
