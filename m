Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 02:10:08 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3O9A4fB007257
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 02:10:05 -0700
Date: Tue, 24 Apr 2007 10:10:00 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: don't hold ilock when calling vn_iowait
Message-ID: <20070424091000.GA31652@infradead.org>
References: <20070422230303.GX32602149@melbourne.sgi.com> <20070423214338.GA17561@infradead.org> <20070423231706.GO32602149@melbourne.sgi.com> <1A5D0CA3BA5C7CF8B7241F39@timothy-shimmins-power-mac-g5.local> <20070424030826.GG48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424030826.GG48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 01:08:26PM +1000, David Chinner wrote:
> > It would be nice if this could be clearer somehow.
> 
> Yes, we should be looking to rip all this cruft out because most of
> it is redundant - the generic inode writeback does most of this
> for us anyway.

In theory it does the same thing.  The problem is that it's really
hard to verify.

Btw, before starting with this bit there's another item on my TODO
list to simplify xfs_sync_inodes, and that's getting rid
of the vp == NULL case totally.  Per definition all vp == NULL
inodes are on mp->m_del_inodes.  So instead of letting xfs_sync_inodes
deals with them we should always call into xfs_finish_reclaim_all
after cleaning the latter up a little and veryfing we get
the same behaviour.
