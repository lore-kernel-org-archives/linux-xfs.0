Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E4BC7F98
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 09:08:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EB3C304062
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 07:08:02 -0700 (PDT)
Received: from mail-yh0-f51.google.com (mail-yh0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id yFMtrA74rewisbGW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Oct 2013 07:08:01 -0700 (PDT)
Received: by mail-yh0-f51.google.com with SMTP id t59so212394yho.24
	for <xfs@oss.sgi.com>; Wed, 02 Oct 2013 07:08:00 -0700 (PDT)
Message-ID: <524C28B8.8080306@gmail.com>
Date: Wed, 02 Oct 2013 10:07:52 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 13/16] xfs: vectorise encoding/decoding directory headers
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-14-git-send-email-david@fromorbit.com>
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

On 09/29/2013 11:07 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Conversion from on-disk structures to in-core header structures
> currently relies on magic number checks. If the magic number is
> wrong, but one of the supported values, we do the wrong thing with
> the encode/decode operation. Split these functions so that there are
> discrete operations for the specific directory format we are
> handling.

[snip]

> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index 17e65c7..aea65ce 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -507,20 +460,20 @@ xfs_dir2_leafn_add(
>  #ifdef DEBUG
>  static void
>  xfs_dir2_free_hdr_check(
> -	struct xfs_mount *mp,
> +	struct xfs_inode *dp,
>  	struct xfs_buf	*bp,
>  	xfs_dir2_db_t	db)
>  {
>  	struct xfs_dir3_icfree_hdr hdr;
>  
> -	xfs_dir3_free_hdr_from_disk(&hdr, bp->b_addr);
> +	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
>  
> -	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(mp)) == 0);
> +	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(dp->i_mount)) == 0);
>  	ASSERT(hdr.firstdb <= db);
>  	ASSERT(db < hdr.firstdb + hdr.nvalid);
>  }
>  #else
> -#define xfs_dir2_free_hdr_check(mp, dp, db)
> +#define xfs_dir2_free_hdr_check(dp, dp, db)
>  #endif	/* DEBUG */

For non-debug XFS only, the above statement causes this to happen:

  CC      fs/xfs/xfs_dir2_data.o
  CC      fs/xfs/xfs_dir2_leaf.o
  CC      fs/xfs/xfs_dir2_node.o
fs/xfs/xfs_dir2_node.c:478:37: error: duplicate macro parameter "dp"
 #define xfs_dir2_free_hdr_check(dp, dp, db)
                                     ^
fs/xfs/xfs_dir2_node.c: In function 'xfs_dir2_leafn_lookup_for_addname':
fs/xfs/xfs_dir2_node.c:613:5: error: implicit declaration of function 'xfs_dir2_free_hdr_check' [-Werror=implicit-function-declaration]
     xfs_dir2_free_hdr_check(dp, curbp, curdb);

I get by with a patch like this...

diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 50958c3..30cbf10 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -475,7 +475,7 @@ xfs_dir2_free_hdr_check(
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
 #else
-#define xfs_dir2_free_hdr_check(dp, dp, db)
+#define xfs_dir2_free_hdr_check(dp, bp, db)
 #endif	/* DEBUG */
 
 /*
-- 
1.8.3.2

...but really don't know what trouble this will cause.  xfstests looks 
OK on one PC, not so good on the other PC: underpowered hardware, bad 
science, upgraded kernel and xfsprogs at the same time, etc., ...

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
