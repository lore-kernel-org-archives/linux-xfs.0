Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUKXJZ9057520 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 14:33:20 -0600
Date: Mon, 30 Nov 2009 15:33:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: check for not fully initialized inodes in
	xfs_ireclaim
Message-ID: <20091130203349.GB16127@infradead.org>
References: <20091112190657.GA32110@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83AF45@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF45@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 30, 2009 at 02:07:40PM -0600, Alex Elder wrote:
> Christoph Hellwig wrote:
> > Add an assert for inodes not added to the inode cache in xfs_ireclaim, to make
> > sure we're not going to introduce something like the famous nfsd inode cache
> > bug again.
> 
> I confess I have not looked at the radix tree
> code in detail yet, but radix_tree_delete()
> returns a value that is ignored here.  It reportedly
> will return a null pointer if the index has no
> corresponding item in the tree, so this could be
> used in the assertion rather than doing a separate
> lookup.
> 
> I think the change is fine, but would rather see
> it done without the extra lookup (though there may
> be a good reason for doing it anyway).

Sounds good, I'll redo it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
