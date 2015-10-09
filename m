Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 452957F5A
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 08:24:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11EA830404E
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 06:24:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fnC8j3qg7ZFtRqJl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 06:24:46 -0700 (PDT)
Date: Fri, 9 Oct 2015 09:24:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs_repair: fix left-shift overflows
Message-ID: <20151009132444.GE27982@bfoster.bfoster>
References: <56170906.5090301@redhat.com>
 <561709E9.3000406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561709E9.3000406@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 08, 2015 at 07:27:21PM -0500, Eric Sandeen wrote:
> pmask in struct parent_list is a __uint64_t, but in some places
> we populated it with "1LL << shift" where shift could be up
> to 63; this really needs to be a 1ULL type for this to be correct.
> 
> Also spotted by libubsan...
> 
> The code in prefetch.c has another issue with large fs blocks
> (32 or 64k) because it shifts by up to 128 bits, but that's left
> for later...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/incore_ino.c |   14 +++++++-------
>  repair/prefetch.c   |    2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/repair/incore_ino.c b/repair/incore_ino.c
> index 32d7678..1898257 100644
> --- a/repair/incore_ino.c
> +++ b/repair/incore_ino.c
> @@ -625,7 +625,7 @@ set_inode_parent(
>  		else
>  			irec->ino_un.plist = ptbl;
>  
> -		ptbl->pmask = 1LL << offset;
> +		ptbl->pmask = 1ULL << offset;
>  		ptbl->pentries = (xfs_ino_t*)memalign(sizeof(xfs_ino_t),
>  							sizeof(xfs_ino_t));
>  		if (!ptbl->pentries)
> @@ -638,8 +638,8 @@ set_inode_parent(
>  		return;
>  	}
>  
> -	if (ptbl->pmask & (1LL << offset))  {
> -		bitmask = 1LL;
> +	if (ptbl->pmask & (1ULL << offset))  {
> +		bitmask = 1ULL;
>  		target = 0;
>  
>  		for (i = 0; i < offset; i++)  {
> @@ -655,7 +655,7 @@ set_inode_parent(
>  		return;
>  	}
>  
> -	bitmask = 1LL;
> +	bitmask = 1ULL;
>  	cnt = target = 0;
>  
>  	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> @@ -691,7 +691,7 @@ set_inode_parent(
>  	ptbl->cnt++;
>  #endif
>  	ptbl->pentries[target] = parent;
> -	ptbl->pmask |= (1LL << offset);
> +	ptbl->pmask |= (1ULL << offset);
>  }
>  
>  xfs_ino_t
> @@ -707,8 +707,8 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
>  	else
>  		ptbl = irec->ino_un.plist;
>  
> -	if (ptbl->pmask & (1LL << offset))  {
> -		bitmask = 1LL;
> +	if (ptbl->pmask & (1ULL << offset))  {
> +		bitmask = 1ULL;
>  		target = 0;
>  
>  		for (i = 0; i < offset; i++)  {
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 52238ca..b11dcb3 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -762,7 +762,7 @@ pf_queuing_worker(
>  			 * sparse state in cluster sized chunks as cluster size
>  			 * is the min. granularity of sparse irec regions.
>  			 */
> -			if ((sparse & ((1 << inodes_per_cluster) - 1)) == 0)
> +			if ((sparse & ((1ULL << inodes_per_cluster) - 1)) == 0)
>  				pf_queue_io(args, &map, 1,
>  					    (cur_irec->ino_isa_dir != 0) ?
>  					     B_DIR_INODE : B_INODE);
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
