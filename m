Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 04:21:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NBKlbh002212
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 04:20:50 -0700
Date: Wed, 23 Jul 2008 07:21:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Prevent log tail pushing from blocking on buffer locks
Message-ID: <20080723112154.GA17338@infradead.org>
References: <48857EFB.3030301@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48857EFB.3030301@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 22, 2008 at 04:32:27PM +1000, Lachlan McIlroy wrote:
> This changes xfs_inode_item_push() to use XFS_IFLUSH_ASYNC_NOBLOCK when
> flushing an inode so the flush wont block on inode cluster buffer lock.
> Also change the prototype of the IOP_PUSH operation so that xfsaild_push()
> can bump it's stuck count.
>
> This change was prompted by a deadlock that would only occur on a debug
> XFS where a thread creating an inode had the buffer locked and was trying
> to allocate space for the inode tracing facility.  That recursed back into
> the filesystem to flush data which created a transaction and needed log
> space which wasn't available.

The stuck propagation looks good, but I don't think this should be
blindly done for all errors.  The only error where it makes sense is
the EAGAIN from xfs_iflush.  All other returns inside the item_push
handlers basically indicate filesystem corruption.
