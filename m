Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0F66C7F9D
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 17:10:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CB81AC001
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:10:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dqkprAMRqmueGJla for
	<xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:10:38 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7DMAbBc006995
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 18:10:37 -0400
Received: from laptop.bfoster (vpn-52-106.rdu2.redhat.com [10.10.52.106])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r7DMAaGe013675
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 18:10:37 -0400
Message-ID: <520AAE10.6080003@redhat.com>
Date: Tue, 13 Aug 2013 18:07:12 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: ***** SUSPECTED SPAM ***** [RFD 06/17] xfs: partial inode chunk
	allocation
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
	<1376313607-28133-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-7-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 08/12/2013 09:19 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a filesystem ages or when certain workloads dominate the storage capacity
> of the filesystem, it can become difficult to find contiguous free space in the
> filesystem and hence inode allocation can fail long before the filesystem is out
> of space.
> 
...
> ---

The issue outlined above is something that was observed with workloads
running against swift (object storage) on top of gluster (distributed
storage) on top of XFS with larger than default inode sizes (512b, 1k).
Unfortunately, I don't have any specific data to describe the workload.
If I recall correctly, the end result was free space fragmentation
leading to premature ENOSPC on inode allocation due to unavailability of
sufficiently sized extents for inode chunks.

After a brief irc conversation, Dave suggested that the immediately
previous item:

[RFD 05/17] xfs: introduce a free inode allocation btree

... tie in with and precede this partial chunk allocation work, so I'm
going to try to pick off this new free inode btree and partial chunk
allocation work. Just a heads up to the list to try and avoid any
duplicate effort. :)

Thanks again for writing this up, Dave.

Brian

>  fs/xfs/xfs_ialloc_btree.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
> index 3ac36b76..75ee794 100644
> --- a/fs/xfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/xfs_ialloc_btree.h
> @@ -48,7 +48,9 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
>   */
>  typedef struct xfs_inobt_rec {
>  	__be32		ir_startino;	/* starting inode number */
> -	__be32		ir_freecount;	/* count of free inodes (set bits) */
> +	__be16		ir_alloc_mask;
> +	__u8		ir_pad;
> +	__u8		ir_freecount;
>  	__be64		ir_free;	/* free inode mask */
>  } xfs_inobt_rec_t;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
