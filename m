Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 12:33:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEKXFOQ001591
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:33:17 -0800
Date: Fri, 14 Dec 2007 20:33:23 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make xfs_idestroy() wait for log I/O to complete
Message-ID: <20071214203323.GC23564@infradead.org>
References: <475F8BC3.8020804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F8BC3.8020804@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Dec 12, 2007 at 06:20:35PM +1100, Lachlan McIlroy wrote:
> An xfs inode can be destroyed before log I/O involving that inode
> is complete.  We need to wait for the inode to be unpinned before
> tearing it down.  The patch looks big but the only real change is
> adding a call to xfs_iunpin_wait() to the start of xfs_idestroy().
> The rest of the patch is moving xfs_idestroy() after the pinning
> routines.

Making sure the inode is unpinned before it's destroyed definitvely
sounds useful.  I can't think of any harm this might cause either.

I'd prefer to have to commits, one to move the function around and one
to add the call to xfs_iunpin_wait, though.
