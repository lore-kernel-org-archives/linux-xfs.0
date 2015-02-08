Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDFAC7F60
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 15:21:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D042AC004
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 13:21:07 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5uL5w5k7yBe85wIN for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 13:21:05 -0800 (PST)
Date: Mon, 9 Feb 2015 08:20:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move the comment on log device near the right log
	dev check in xfs_mount_validate_sb
Message-ID: <20150208212051.GZ4251@dastard>
References: <1423370704-3464-1-git-send-email-shhuiw@foxmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423370704-3464-1-git-send-email-shhuiw@foxmail.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: bfoster@redhat.com, tinguely@sgi.com, sandeen@sandeen.net, hch@lst.de, xfs@oss.sgi.com

On Sun, Feb 08, 2015 at 12:45:04PM +0800, Wang Sheng-Hui wrote:
> The beginning is about magic and version number check.
> Move the comment on log device near the log dev check logic.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>

The comment is old and redundant. The error messages document the
reason for the checks better than the comment and the comments about
volume mounts date back to Irix and so aren't relevant any more. So
just remove the comment.

> ---
>  fs/xfs/libxfs/xfs_sb.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 752915f..b4bb852 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -174,20 +174,13 @@ xfs_mount_validate_sb(
>  	bool		check_inprogress,
>  	bool		check_version)
>  {
> +	/* check magic number and version number */

No need to add a redundant comment - it is obvious what the code it
refers to is checking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
