Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7574E7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:25:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 590E330405F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 23:25:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sSaeXiynC1hOAsmx for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 23:25:17 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:24:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 17/20] xfsprogs/repair: helpers for finding in-core
	inode records w/ free inodes
Message-ID: <20140423062443.GP15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-18-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146270-42993-18-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 10, 2014 at 12:11:07PM -0400, Brian Foster wrote:
> Add the findfirst_free_inode_rec() and next_free_ino_rec() helpers
> to assist scanning the in-core inode records for records with at
> least one free inode. These will be used to determine what records
> are included in the free inode btree.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  repair/incore.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/repair/incore.h b/repair/incore.h
> index 5419884..5f8c188 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -381,6 +381,33 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
>  		((ino_tree_node_t *) ((ino_node_ptr)->avl_node.avl_forw))
>  
>  /*
> + * finobt helpers
> + */
> +static inline ino_tree_node_t *
> +findfirst_free_inode_rec(xfs_agnumber_t agno)
> +{
> +	ino_tree_node_t *ino_rec;
> +
> +	ino_rec = findfirst_inode_rec(agno);
> +
> +	while (ino_rec && !ino_rec->ir_free)
> +		ino_rec = next_ino_rec(ino_rec);
> +
> +	return ino_rec;
> +}
> +
> +static inline ino_tree_node_t *
> +next_free_ino_rec(ino_tree_node_t *ino_rec)
> +{
> +	ino_rec = next_ino_rec(ino_rec);
> +
> +	while (ino_rec && !ino_rec->ir_free)
> +		ino_rec = next_ino_rec(ino_rec);
> +
> +	return ino_rec;
> +}

That looks a bit inefficient - walking the list of inode records to
find the next one with free inodes. Perhaps we woul dbe better
served by adding a new list for inode records with free entries and
walking that instead?

Iknow, it's a memory vs speed tradeoff, but if we've got millions of
inodes and very few free, the difference could be very significant.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
