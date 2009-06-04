Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n549j3pj233848 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 04:45:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48C361053373
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 02:51:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Z3wbhHZS4GvkOJKt for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2009 02:51:57 -0700 (PDT)
Date: Thu, 4 Jun 2009 19:45:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: fix xfs_quiesce_data
Message-ID: <20090604094512.GU16929@discord.disaster>
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140708.279368000@bombadil.infradead.org>
	<4A071F06.8040106@sandeen.net>
	<20090511201511.GB14195@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090511201511.GB14195@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, May 11, 2009 at 04:15:11PM -0400, Christoph Hellwig wrote:
> On Sun, May 10, 2009 at 01:37:58PM -0500, Eric Sandeen wrote:
> > I guess I too would like a reason for the filestream_flush move
> > somewhere in the changelog...
> 
> Hehe, maybe Dave can chime in.  Or I can test if it actually affects
> anything and maybe move it out to another patch.  The lack of
> reliability of the filesystreams tests doesn't make this any easier to
> test.

(Just catching up on my mail backlog)

I think that the filestream_flush() call should actually be after
the data flush. filestream_flush() is used to clear the filestream
association cache which holds references to the inodes.

Where the flush is currently placed is destroying the association
that defines the AG the data should be written to before the data is
written. As a result it may not end up in the AG carefully
associated with the inode during the write() syscall.

This may be one of the reasons for the filestreams tests failing
frequently....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
