Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4I6wrAb232679 for <xfs@oss.sgi.com>; Mon, 18 May 2009 01:58:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81FE5291456
	for <xfs@oss.sgi.com>; Sun, 17 May 2009 23:59:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	9HLcSeToOfJis3yc for <xfs@oss.sgi.com>;
	Sun, 17 May 2009 23:59:01 -0700 (PDT)
Date: Mon, 18 May 2009 16:58:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: split inode data writeback from
	xfs_sync_inodes_ag
Message-ID: <20090518065854.GP16929@discord.disaster>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.014747000@bombadil.infradead.org>
	<921ca19c0905142149m68c9717cg83db37c468769c4d@mail.gmail.com>
	<20090515172122.GB14804@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090515172122.GB14804@infradead.org>
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
Cc: Sujit Karataparambil <sjt.kar@gmail.com>, xfs@oss.sgi.com

On Fri, May 15, 2009 at 01:21:22PM -0400, Christoph Hellwig wrote:
> That beeing said I don't really like the current implementation where we
> have a SYNC_WAIT that waits for completion of data I/O and need a
> separate SYNC_IOWAIT that waits for the after data I/O metadata
> transaction completions.

SYNC_IOWAIT is really only for waiting for direct IO to complete.
e.g. for synchronisation with truncate. I'm not sure that it even
matters for pure buffered data writeback.

> fs/xfs/linux-2.6/xfs_quotaops.c:        return -xfs_sync_data(mp, 0);
> fs/xfs/linux-2.6/xfs_super.c:           xfs_sync_data(mp, 0);
> fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, 0);
> fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_WAIT|SYNC_IOWAIT);
> fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_TRYLOCK);
> fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_IOWAIT);

And only the data queisce cares about direct IO (i.e. for freeze)
so I suspect that the SYNC_IOWAIT now could be removed and we
use SYNC_WAIT to trigger the ioend completion wait....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
