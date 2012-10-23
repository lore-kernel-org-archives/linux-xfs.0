Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9N0unFZ179624 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 19:56:49 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nL04lnk9HewHHTt2 for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 17:58:30 -0700 (PDT)
Date: Tue, 23 Oct 2012 11:58:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 03/10] xfs: create helper to check whether to free
	eofblocks on inode
Message-ID: <20121023005828.GH4291@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349446636-8611-4-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 05, 2012 at 10:17:09AM -0400, Brian Foster wrote:
> This check is used in multiple places to determine whether we
> should check for (and potentially free) post EOF blocks on an
> inode. Add a helper to consolidate the check.
> 
> Note that when we remove an inode from the cache (xfs_inactive()),
> we are required to trim post-EOF blocks even if the inode is marked
> preallocated or append-only to maintain correct space accounting.
> The 'force' parameter to xfs_can_free_eofblocks() specifies whether
> we should ignore the prealloc/append-only status of the inode.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good. I'm glad this little mess is going away :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
