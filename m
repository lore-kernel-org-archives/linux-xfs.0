Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EIrrTk026618 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:53:53 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: fix missing error check in xfs_rtfree_range
Date: Thu, 14 Jan 2010 12:54:47 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A696F@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1263458686-21308-1-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> When xfs_rtfind_forw() returns an error, the block is returned
> uninitialised.  xfs_rtfree_range() is not checking the error return,
> so could be using an uninitialised block number for modifying bitmap
> summary info.
> 
> The problem was found by gcc when compiling the *userspace* libxfs
> code - it is an copy of the kernel code with the exact same bug.
> gcc gives an uninitialised variable warning on the userspace code
> but not on the kernel code. You gotta love the consistency (Mmmm,
> slightly chewy today!).

Looks good.  I'll send this for 2.6.33-rc4.

> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Alex Elder <aelder@sgi.com>


>  fs/xfs/xfs_rtalloc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 9e15a11..6be05f7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1517,6 +1517,8 @@ xfs_rtfree_range(
>  	 */
>  	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
>  		&postblock);
> +	if (error)
> +		return error;
>  	/*
>  	 * If there are blocks not being freed at the front of the
>  	 * old extent, add summary data for them to be allocated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
