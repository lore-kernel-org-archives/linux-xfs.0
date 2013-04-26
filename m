Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8671229DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 21:25:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CF94AC006
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 19:25:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	L5xvVWNt2yVCE0EH for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 19:25:33 -0700 (PDT)
Date: Fri, 26 Apr 2013 12:25:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: enhance warning on xfs_imap() failure in
	xfs_iunlink_remove()
Message-ID: <20130426022532.GZ30622@dastard>
References: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
	<1366904490-46821-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366904490-46821-3-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 25, 2013 at 11:41:30AM -0400, Brian Foster wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Include the global ino, ag number and agino in the warning message
> emitted should xfs_imap() fail in the xfs_iunlink_remove() code
> path.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c22f980..a4fe989 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1678,8 +1678,10 @@ xfs_iunlink_remove(
>  			error = xfs_imap(mp, tp, next_ino, &imap, 0);
>  			if (error) {
>  				xfs_warn(mp,
> -	"%s: xfs_imap returned error %d.",
> -					 __func__, error);
> +					"%s: xfs_imap() returned error %d "
> +					"for inode 0x%llx ag %d agino 0x%x",
> +					__func__, error, ip->i_ino, agno, agino);
> +

The fact the format string is now split across 2 lines makes it hard
to grep for. The indentation should be a clue that the warning code
is intentionally formatted that way so that long format strings
don't get wrapped. i.e:

 				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
+	"%s: xfs_imap() returned error %d for inode 0x%llx ag %d agino 0x%x",
+					__func__, error, ip->i_ino,
+					agno, agino);

fits into 80 columns and is much easier to read than the highly
indented version split across 2 lines....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
