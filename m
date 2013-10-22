Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFA7A7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 18:48:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD2498F8033
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:48:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6Zu4bMYnEzqECNAy for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 16:48:49 -0700 (PDT)
Date: Wed, 23 Oct 2013 10:48:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/19, V2] xfs: decouple inode and bmap btree header files
Message-ID: <20131022234841.GM2797@dastard>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-10-git-send-email-david@fromorbit.com>
	<20131022182932.GP1935@sgi.com> <20131022234049.GL2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131022234049.GL2797@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 23, 2013 at 10:40:49AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans.h has a dependency on xfs_log.h for a couple of
> structures. Most code that does transactions doesn't need to know
> anything about the log, bu this dependency means that they have to
> include xfs_log.h. Decouple the xfs_trans.h and xfs_log.h header
> files and clean up the includes to be in dependency order.
> 
> In doing this, remove the direct include of xfs_trans_reserve.h from
> xfs_trans.h so that we remove the dependency between xfs_trans.h and
> xfs_mount.h. Hence the xfs_trans.h include can be moved to the
> indicate the actual dependencies oher header files have on it.
> 
> Note that these are kernel only header files, so this does not
> translate to any userspace changes at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>
> ---
> V2: rebase due to changed fs/xfs/xfs_file.c include files as a
> result of the fallocate rework.

Ignore this patch - it's a rebase for 08/19, not 09/19. I'll send
the rebase for this patch in a minute.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
