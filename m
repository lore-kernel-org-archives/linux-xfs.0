Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B0blbg163836 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 19:37:47 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24A7217B0AB9
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 17:37:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nv0oA06dYT2Z9UsG for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 17:37:46 -0700 (PDT)
Date: Mon, 11 Jul 2011 10:37:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: factor out xfs_da_grow_inode_int
Message-ID: <20110711003743.GC23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.485558926@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110710205017.485558926@bombadil.infradead.org>
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

On Sun, Jul 10, 2011 at 04:49:20PM -0400, Christoph Hellwig wrote:
> xfs_da_grow_inode and xfs_dir2_grow_inode are mostly duplicate code.  Factor
> the meat of those two functions into a new common helper.

Hmmmm. I'm in the process of splitting xfs_dir2_grow_inode() into
data space vs free space variants so I can play speculative
preallocation tricks in the directory data space to reduce dataspace
fragmentation for large directories. Combined with a rework of the
readir readahead code, it significantly reduces IO count and seeks
for readdir calls...

I'll probably just rebase on top of this patch, though, because I did
notice that the two functions were very similar to begin with. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
