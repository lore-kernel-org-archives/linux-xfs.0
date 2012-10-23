Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9N10AVV180356 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 20:00:10 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Pg6O20T7wr80xGQY for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 18:01:52 -0700 (PDT)
Date: Tue, 23 Oct 2012 12:01:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 05/10] xfs: create function to scan and clear
	EOFBLOCKS inodes
Message-ID: <20121023010150.GI4291@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349446636-8611-6-git-send-email-bfoster@redhat.com>
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

On Fri, Oct 05, 2012 at 10:17:11AM -0400, Brian Foster wrote:
> xfs_inodes_free_eofblocks() implements scanning functionality for
> EOFBLOCKS inodes. It uses the AG iterator to walk the tagged inodes
> and free post-EOF blocks via the xfs_inode_free_eofblocks() execute
> function. The scan can be invoked in best-effort mode or wait
> (force) mode.
> 
> A best-effort scan (default) handles all inodes that do not have a
> dirty cache and we successfully acquire the io lock via trylock. In
> wait mode, we continue to cycle through an AG until all inodes are
> handled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
