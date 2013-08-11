Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57CE87CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:26:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27C8E30404E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 16:26:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5CBZA9FzJNJAH6G3 for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 16:26:54 -0700 (PDT)
Date: Mon, 12 Aug 2013 09:26:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 3/14] xfsprogs: pull in the
	rest of 93848a999cf
Message-ID: <20130811232651.GC12779@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808211352.GQ3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808211352.GQ3111@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 04:13:52PM -0500, Ben Myers wrote:
> XXX Maybe I missed some more...
> 
> ---
>  libxfs/xfs_ialloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/libxfs/xfs_ialloc.c
> ===================================================================
> --- a/libxfs/xfs_ialloc.c	2013-08-06 11:25:54.400817879 -0500
> +++ b/libxfs/xfs_ialloc.c	2013-08-06 11:26:32.420897946 -0500
> @@ -204,7 +204,7 @@ xfs_ialloc_inode_init(
>  		 *	individual transactions causing a lot of log traffic.
>  		 */
>  		fbuf->b_ops = &xfs_inode_buf_ops;
> -		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> +		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
>  		for (i = 0; i < ninodes; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
>  			uint	isize = xfs_dinode_size(version);

It's fixed in the second series of patches, along with all the other
little differences between the kernel and userspace. There's no
point in trying to fix them one by one here, because untill it's
easy to diff the files with the kernel code these sorts of issues
will be easily missed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
