Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4078F7F4E
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 04:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 114BF304062
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 02:02:27 -0700 (PDT)
Date: Wed, 9 Jul 2014 02:02:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: free inodes on log recovery error
Message-ID: <20140709090224.GA31122@infradead.org>
References: <20140702143206.438456679@sgi.com>
	<20140702144139.894251516@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140702144139.894251516@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 02, 2014 at 09:32:10AM -0500, Mark Tinguely wrote:
> Recovery may free inodes that end up on the inode
> reclaim RCU. If recovery fails, we leak these inodes.
> The filesystem should be in forced shutdown at this
> point, so a call to xfs_reclaim_inode is a fast path
> to freeing the inodes and RCU entries.

I haven't really started reviewing the series, but your terminology
here seems wrong.  RCU is just a way to synchronize updates - do you
mean inodes are marked as reclaimable in the radix tree?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
