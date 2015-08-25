Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C9317F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39C15AC008
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 09:56:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id v6nrhinPvBv6kg8j for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 09:55:58 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 638ED63C77A5
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:55:57 -0500 (CDT)
Message-ID: <55DC9E1C.8090009@sandeen.net>
Date: Tue, 25 Aug 2015 11:55:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: set args.geo in dir2_kill_block
References: <55B14B40.5030209@sandeen.net>
In-Reply-To: <55B14B40.5030209@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Dave, ping on this?

Thanks,
-Eric

On 7/23/15 3:14 PM, Eric Sandeen wrote:
> This path in xfs_repair:
> 
> dir2_kill_block
> 	libxfs_da_shrink_inode
> 		xfs_dir2_shrink_inode
> 			xfs_dir2_db_to_da
> 
> segfaults, because dir2_kill_block() does not initialize
> args.geo, and a null geometry winds up in xfs_dir2_db_to_da(),
> which dereferences it.
> 
> Fix that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index de445c6..0c952ed 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1438,6 +1438,7 @@ dir2_kill_block(
>  	args.firstblock = &firstblock;
>  	args.flist = &flist;
>  	args.whichfork = XFS_DATA_FORK;
> +	args.geo = mp->m_dir_geo;
>  	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
>  		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
>  	else
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
