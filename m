Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 294CB7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:10:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6872AC005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:10:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oTYV8gfZyyz3XoY3 for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:10:41 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:10:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/18] xfs: refactor xfs_inobt_insert() to eliminate loop
	and support variable count
Message-ID: <20140724221038.GN20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 10:22:51AM -0400, Brian Foster wrote:
> Inodes are always allocated in chunks of 64 and thus the loop in
> xfs_inobt_insert() is unnecessary.

I don't believe this is true. The number of inodes allocated at once
is:

        mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
	                                        sbp->sb_inopblock);

So when the block size is, say, 64k, the number of 512 byte inodes
allocated at once is 128. i.e. 2 chunks. Hence xfs_inobt_insert()
can be called with a inode could of > 64 and therefore the loop is
still necessary...

And, indeed, we might want to increase the allocation size in future
to do entire stripe units or stripe widths of inodes at once:

http://xfs.org/index.php/Improving_inode_Caching#Contiguous_Inode_Allocation

This also means a loop would be required -somewhere-...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
