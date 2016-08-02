Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A39CA7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:48:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29717AC001
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 11:48:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e2istbrTdiyzoXny (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 11:48:48 -0700 (PDT)
Date: Tue, 2 Aug 2016 14:48:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 20/47] xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
Message-ID: <20160802184845.GC58152@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907709719.25461.3104352212846077948.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907709719.25461.3104352212846077948.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:58:17PM -0700, Darrick J. Wong wrote:
> By my calculations, a 1,073,741,824 block AG with a 1k block size
> can attain a maximum height of 9.  Assuming a record size of 24
> bytes, a key/ptr size of 44 bytes, and half-full btree nodes,
> we'd need 53,687,092 blocks for the records and ~6 million blocks
> for the keys.  That requires a btree of height 9.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I believe you.. :) but could you add a bit more detail to the commit log
just to describe the calculations (e.g., how many records per leaf
block, keys per node block) so 1.) I don't have to try and figure it out
;) (and probably get it wrong) and 2.) so we have a reference in the git
repo going forward?

Brian

>  fs/xfs/libxfs/xfs_btree.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index b8bbb21..629ef4f 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -133,7 +133,7 @@ do {    \
>  	}       \
>  } while (0)
>  
> -#define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
> +#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
>  
>  struct xfs_btree_ops {
>  	/* size of the key and record structures */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
