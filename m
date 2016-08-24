Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06E607CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA54C304048
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 11:01:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HrnCJOsQtmRu8wR7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 11:01:57 -0700 (PDT)
Date: Wed, 24 Aug 2016 14:01:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't perform lookups on zero-height btrees
Message-ID: <20160824180154.GA8982@bfoster.bfoster>
References: <20160819203022.GD8268@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160819203022.GD8268@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 19, 2016 at 01:30:22PM -0700, Darrick J. Wong wrote:
> If the caller passes in a cursor to a zero-height btree (which is
> impossible), we never set block to anything but NULL, which causes the
> later dereference of it to crash.  Instead, just return -EFSCORRUPTED.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Did something actually cause this to happen?

Brian

>  fs/xfs/libxfs/xfs_btree.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 64fd847..4bffea4 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1814,6 +1814,10 @@ xfs_btree_lookup(
>  
>  	XFS_BTREE_STATS_INC(cur, lookup);
>  
> +	/* No such thing as a zero-level tree. */
> +	if (cur->bc_nlevels == 0)
> +		return -EFSCORRUPTED;
> +
>  	block = NULL;
>  	keyno = 0;
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
