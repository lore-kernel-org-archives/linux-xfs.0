Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A3037F6D
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 16:42:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18505AC001
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 14:42:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wpv6mh6CsdCk3rCv for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 14:42:06 -0800 (PST)
Date: Mon, 9 Feb 2015 09:33:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 13/18] xfs: update free inode record logic to support
	sparse inode records
Message-ID: <20150208223317.GE4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-14-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-14-git-send-email-bfoster@redhat.com>
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

On Fri, Feb 06, 2015 at 02:53:00PM -0500, Brian Foster wrote:
> xfs_difree_inobt() uses logic in a couple places that assume inobt
> records refer to fully allocated chunks. Specifically, the use of
> mp->m_ialloc_inos can cause problems for inode chunks that are sparsely
> allocated. Sparse inode chunks can, by definition, define a smaller
> number of inodes than a full inode chunk.
> 
> Fix the logic that determines whether an inode record should be removed
> from the inobt to use the ir_free mask rather than ir_freecount.
> 
> Fix the agi counters modification to use ir_freecount to add the actual
> number of inodes freed rather than assuming a full inode chunk.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This should be moved to the start of the series, along with any
other code that does rec.ir_freecount checks to see if the chunk
has inodes in use or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
