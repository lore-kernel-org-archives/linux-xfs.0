Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAs27B086358 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:54:23 -0500
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE50819C8E8
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:53:40 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id iAAP9GVmfQy8WaOy
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:53:40 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:35:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] [XFS] introduce a AG inode tree walker
Message-ID: <20090316103518.GF26138@disturbed>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
	<20090316075338.GA19858@infradead.org>
	<20090316094019.GD26138@disturbed>
	<20090316100116.GA16218@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316100116.GA16218@infradead.org>
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

On Mon, Mar 16, 2009 at 06:01:16AM -0400, Christoph Hellwig wrote:
> On Mon, Mar 16, 2009 at 08:40:19PM +1100, Dave Chinner wrote:
> > If you drop the last patch (the iterator patch) does it work
> > ok?
> 
> No.  With patches 1-5 applied we deadlock early on because pag_ici_lock
> never gets released in xfs_sync_inodes_ag for the normal non-error case.

Ah, then I screwed up the migration of the patches from one set of
trees to another. I'll go back and rework this one, including your
feedback and repost when done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
