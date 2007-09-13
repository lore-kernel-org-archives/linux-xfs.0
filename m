Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 04:41:59 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DBfq4p006238
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 04:41:56 -0700
Date: Thu, 13 Sep 2007 12:20:46 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 968767 - Ensure file size updates have been completed before writing inode to disk.
Message-ID: <20070913112046.GA25515@infradead.org>
References: <200709130330.l8D3UGu9004196@redback.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709130330.l8D3UGu9004196@redback.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

This has never been out for review, has it?

On Thu, Sep 13, 2007 at 01:30:16PM +1000, Lachlan McIlroy wrote:
> fs/xfs/xfs_vnodeops.c - 1.720 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/> xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
> 	- Ensure file size updates have been completed before writing inode to disk.

I think you want to at least add a comment above the filemap_fdatawait
call why we have it that early compared to where the generic code calls
it (again).  But hopefully I'll push changes to the core code soon
to move the filemap_datawrite/wait into fs domain completely.

I also don't like idioms like vn_to_inode(XFS_ITOV(ip)) at all.  Just
doing a direct ip->i_vnode deference sounds perfectly fine.


Why is removing the ipincount check in xfs_inode_flush okay?  Trying
to flush pinned inodes doesn't seem that much of a good idea.
