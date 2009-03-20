Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2KEfSbD175293 for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 09:41:48 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF3B38F80D0
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 07:41:09 -0700 (PDT)
Message-Id: <88A46616-5E3A-49D4-BAD5-9CEA426725D2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090320072618.GA26571@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs_io: fix extent array reallocation
Date: Fri, 20 Mar 2009 09:33:29 -0500
References: <20090320072618.GA26571@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: moosh009@gmail.com, xfs@oss.sgi.com


On Mar 20, 2009, at 2:26 AM, Christoph Hellwig wrote:

> From: Tomasz Majkowski <moosh009@gmail.com>
>
> The XFS_IOC_FSGETXATTRA ioctl only returns the number of allocated
> extents, so when we reallocate the extent array in the bmap command
> we have to account for the worst case where there is a whole between
> each two allocated extents.  Also add some slack to that case to
> allow for a file growing while we are racing with it.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
>
> Index: xfsprogs-dev/io/bmap.c
> ===================================================================
> --- xfsprogs-dev.orig/io/bmap.c	2009-03-20 06:28:33.000000000 +0000
> +++ xfsprogs-dev/io/bmap.c	2009-03-20 06:29:52.000000000 +0000
> @@ -217,8 +217,8 @@
> 			exitcode = 1;
> 			return 0;
> 		}
> -		if (fsx.fsx_nextents >= map_size-1) {
> -			map_size = 2*(fsx.fsx_nextents+1);
> +		if (2 * fsx.fsx_nextents > map_size) {
> +			map_size = 2 * fsx.fsx_nextents + 1;
> 			map = realloc(map, map_size*sizeof(*map));
> 			if (map == NULL) {
> 				fprintf(stderr,
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
