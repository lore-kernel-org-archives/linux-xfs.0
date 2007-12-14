Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 12:30:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEKU9x4000576
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:30:13 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55074113AC4E
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:30:15 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id P44zOBFrCWvo8EUq for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:30:15 -0800 (PST)
Date: Fri, 14 Dec 2007 20:29:40 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make inode reclaim synchronise with xfs_iflush_done()
Message-ID: <20071214202940.GA23564@infradead.org>
References: <475F878D.6090407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F878D.6090407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Dec 12, 2007 at 06:02:37PM +1100, Lachlan McIlroy wrote:
> On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
> If the inode flush lock is not already held and there is an outstanding
> xfs_iflush_done() then we might free the inode prematurely.  By acquiring
> and releasing the flush lock we will synchronise with xfs_iflush_done().

Sound fine, but I think it would be nicer if we could keep the else if
formatting, ala:

 	/*
 	 * We are not interested in doing an iflush if we're
	 * in the process of shutting down the filesystem forcibly.
	 * So, just reclaim the inode.
	 */
	} else if (locked) {
		xfs_ifunlock(ip);
		xfs_iunlock(ip, XFS_ILOCK_EXCL);
	} else {
		/* 
		 * If the flush lock is not already held then temporarily
		 * acquire it to synchronize with xfs_iflush_done.
		 */
		xfs_iflock(ip);
		xfs_ifunlock(ip);
	}
