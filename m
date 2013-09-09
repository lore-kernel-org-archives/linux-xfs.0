Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E78C29DFB
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 15:38:02 -0500 (CDT)
Message-ID: <522E31A6.7050509@sgi.com>
Date: Mon, 09 Sep 2013 15:37:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: recovery of swap extents operations for CRC
	filesystems
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<1377822225-17621-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1377822225-17621-3-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/29/13 19:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> This is the recovery side of the btree block owner change operation
> performed by swapext on CRC enabled filesystems. We detect that an
> owner change is needed by the flag that has been placed on the inode
> log format flag field. Because the inode recovery is being replayed
> after the buffers that make up the BMBT in the given checkpoint, we
> can walk all the buffers and directly modify them when we see the
> flag set on an inode.
>
> Because the inode can be relogged and hence present in multiple
> chekpoints with the "change owner" flag set, we could do multiple
> passes across the inode to do this change. While this isn't optimal,
> we can't directly ignore the flag as there may be multiple
> independent swap extent operations being replayed on the same inode
> in different checkpoints so we can't ignore them.
>
> Further, because the owner change operation uses ordered buffers, we
> might have buffers that are newer on disk than the current
> checkpoint and so already have the owner changed in them. Hence we
> cannot just peek at a buffer in the tree and check that it has the
> correct owner and assume that the change was completed.
>
> So, for the moment just brute force the owner change every time we
> see an inode with the flag set. Note that we have to be careful here
> because the owner of the buffers may point to either the old owner
> or the new owner. Currently the verifier can't verify the owner
> directly, so there is no failure case here right now. If we verify
> the owner exactly in future, then we'll have to take this into
> account.
>

...


Recovery of swap extent makes sense. Variable name, XFS_ILOG_DOWNER, 
gave me a chuckle but it is consistent with the other names.

Really could use some recovery test for this. Did inode create recovery 
get a test?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
