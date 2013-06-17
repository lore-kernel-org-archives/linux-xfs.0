Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3B1C29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 14:28:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 780BBAC001
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 12:28:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x8O7AXBcgskRpyYq for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 12:28:04 -0700 (PDT)
Message-ID: <51BF6447.9060608@redhat.com>
Date: Mon, 17 Jun 2013 15:32:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 27/27] xfs: fix issues that cause userspace warnings
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-28-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/12/2013 06:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some of the code shared with userspace causes compilation warnings
> from things turned off in the kernel code, such as differences in
> variable signedness. Fix those issues.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr_remote.c |    8 ++++----
>  fs/xfs/xfs_bmap.c        |    3 ---
>  fs/xfs/xfs_da_btree.c    |    6 +++---
>  fs/xfs/xfs_dir2_node.c   |    2 ++
>  fs/xfs/xfs_ialloc.c      |    2 +-
>  fs/xfs/xfs_rtalloc.c     |    4 ++--
>  6 files changed, 12 insertions(+), 13 deletions(-)
> 
...
>  
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 319d9e4..9831eff 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -1342,7 +1342,7 @@ xfs_imap(
>  	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
>  	int		error;	/* error code */
>  	int		offset;	/* index of inode in its buffer */
> -	int		offset_agbno;	/* blks from chunk start to inode */
> +	xfs_agino_t	offset_agbno;	/* blks from chunk start to inode */

xfs_agblock_t ?

Brian

>  	ASSERT(ino != NULLFSINO);
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 98dc670..c9a9a42 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -736,8 +736,8 @@ xfs_rtallocate_range(
>  {
>  	xfs_rtblock_t	end;		/* end of the allocated extent */
>  	int		error;		/* error value */
> -	xfs_rtblock_t	postblock;	/* first block allocated > end */
> -	xfs_rtblock_t	preblock;	/* first block allocated < start */
> +	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
> +	xfs_rtblock_t	preblock = 0;	/* first block allocated < start */
>  
>  	end = start + len - 1;
>  	/*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
