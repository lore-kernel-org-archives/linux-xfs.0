Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C69E129E05
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 03:03:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 924C3304043
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 01:03:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J3itkNEcUQSDrrYA (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 01:03:54 -0700 (PDT)
Date: Sun, 9 Aug 2015 01:03:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11] xfs: clean up root inode properly on mount failure
Message-ID: <20150809080354.GD4253@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-11-git-send-email-bfoster@redhat.com>
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

On Thu, Aug 06, 2015 at 01:44:31PM -0400, Brian Foster wrote:
> The root inode is read as part of the xfs_mountfs() sequence and the
> reference is dropped in the event of failure after we grab the inode.
> The reference drop doesn't necessarily free the inode, however. It marks
> it for reclaim and potentially kicks off the reclaim workqueue.  The
> workqueue is destroyed further up the error path, which means we are
> subject to crash if the workqueue job runs after this point or a memory
> leak which is identified if the xfs_inode_zone is destroyed (e.g., on
> module removal). Both of these outcomes are reproducible via manual
> instrumentation of a mount error after the root inode xfs_iget() call in
> xfs_mountfs().
> 
> Update the xfs_mountfs() error path to cancel any potential reclaim work
> items and to run a synchronous inode reclaim if the root inode is marked
> for reclaim. This ensures that no jobs remain on the queue before it is
> destroyed and that the root inode is freed before the reclaim mechanism
> is torn down.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
