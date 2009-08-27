Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R6dItZ068696 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 01:39:28 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A178C8F80C9
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 23:40:11 -0700 (PDT)
Message-Id: <DD638BCE-CCAA-4540-9187-C0ACED984731@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090827031242.GB6147@infradead.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: PATCH] xfs: implement .dirty_inode to fix timestamp handling
Date: Thu, 27 Aug 2009 01:40:08 -0500
References: <20090827031242.GB6147@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Aug 26, 2009, at 10:12 PM, Christoph Hellwig wrote:

> [Note: this patch needs the O_SYNC patch applies first]

I assume O_SYNC is not a prerequisite to this patch, it's just
needed to apply the current patch cleanly.

>
> This is picking up on Felix's repost of Dave's patch to implement a
> .dirty_inode method.  We really need this notification because
> the VFS keeps writing directly into the inode structure instead
> of going through methods to update this state.  In addition to
> the long-known atime issue we now also have a caller in VM code
> that updates c/mtime that way for shared writeable mmaps.  And
> I found another one that no one has noticed in practice in the FIFO
> code.
>
> So implement ->dirty_inode to set i_update_core whenever the
> inode gets externally dirties, and switch the c/mtime handling to
> the same scheme we already use for atime (always picking up
> the value from the Linux inode).
>
> Note that this patch also removes the xfs_synchronize_atime call
> in xfs_reclaim - it was not only superflous (we'll never reclaim
> a dirty inode), but also didn't do anything (I_CLEAR is always set
> at this point).  I replaced it with a myriad of ASSERTs for now
> to make my point.

I like that ^)

>
>
> Also switch to just using file_update_time for regular reads/writes -
> that will get us all optimization done to it for free and make
> sure we notice early when it breaks.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
