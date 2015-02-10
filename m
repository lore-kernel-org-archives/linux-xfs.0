Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 891927FBC
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 01:26:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0703FAC003
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 23:26:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JRIBwOqRCA5Etcse for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 23:26:03 -0800 (PST)
Date: Tue, 10 Feb 2015 18:25:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: Accounting for AGFL blocks in xfs_spaceman
Message-ID: <20150210072559.GA12722@dastard>
References: <54ca343a.43df440a.3c11.4474@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ca343a.43df440a.3c11.4474@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 06:53:01PM +0530, Dhruvesh Rathore wrote:
> 
> The xfs_spaceman utility previously failed to account for AGFL blocks.
> Old output (Before changes).
> 
> $ sudo xfs_spaceman -c "freesp" /media/xfs
>    from      to extents  blocks    pct
>    1024    2047       1    1262   0.04
>    4096    8191       1    5126   0.15
>    8192   16383       3   35344   1.05
>   32768   65535       1   43989   1.31
>  262144  524287       3 1334894  39.78
>  524288  967428       2 1934840  57.66
> 
> As you can see the AGFL blocks were unaccounted (4 per AG, and there 
> were 4 AGs in this filesystem).
> 
> This patch is concerned with adding a new function which will walk the free
> extents in AGFL and account for these AGFL blocks, while file system scanning.
> 
> New output (After implementing this patch).
> 
> $ uname -a
> Linux dhruv-MacBookAir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014 x86_64 x86_64 x86_64 GNU/Linux
> $ sudo xfs_spaceman -V
> xfs_spaceman version 3.2.2
> $ sudo xfs_spaceman -c "freesp" /media/xfs
>    from      to extents  blocks    pct
>       1       1      16      16   0.00
>    1024    2047       1    1262   0.04
>    4096    8191       1    5126   0.15
>    8192   16383       3   35344   1.05
>   32768   65535       1   43989   1.31
>  262144  524287       3 1334894  39.78
>  524288  967428       2 1934840  57.66
> 
Good description, but:

> -------------------------------------------------------------------------------------------

Tmhese lines confuse any utility that attempts to parse the patch.
Lines starting with "---" have have special meaning to patch. They
haven't come from diff or git, so you must have added them manually.

That makes me think you composed this email manually from a variety
of different sources.  Please, learn to use git to make your changes and
produce diffs that you send. git send-email is your friend - learn
to use it. There's a basic howto on the xfs web site:

http://xfs.org/index.php/XFS_git_howto

As such, I've hacked the patch into a format I can apply - I've
attached the patch generated from my git tree so you see how
different it looks.

> Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
> Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
> Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
> ---
> fs/xfs/libxfs/xfs_alloc.c | 69 ++++++++++++++++
> 1 file changed, 69 insertions(+)
> 
> --- a/fs/xfs/libxfs/xfs_alloc.c	2015-01-29 09:07:07.116439198 +0530
> +++ b/fs/xfs/libxfs/xfs_alloc.c	2015-01-29 09:06:39.664440229 +0530
> 
> @@ -2698,6 +2698,71 @@
>  }
>  
>  
> +/*
> + * When we map free space we need to take into account the blocks
> + * that are indexed by the AGFL. They aren't found by walking the
> + * free space btrees, so we have to walk each AGFL to find them.
> + */
> +static int
> +xfs_alloc_agfl_freespace_map(
> +	struct xfs_mount	*mp,
> +	struct xfs_agf		*agf,
> +	struct fiemap_extent_info *fieinfo,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		sagbno,
> +	xfs_agblock_t		eagbno)
> +{
> +	xfs_buf_t		*agflbp;
> +	__be32			*agfl_bno;
> +	int			i;
> +	int			error = 0;
> +
> +	error = xfs_alloc_read_agfl(mp, NULL, be32_to_cpu(agf->agf_seqno), &agflbp);

Line longer than 80 columns, and the AG number we are working on is
passed as a parameter to the function so there is no need to read it
from the AGF.

> +

stray extra line.

> +	if (error)
> +		return error;
> +
> +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> +
> +	for(i = be32_to_cpu(agf->agf_flfirst);
> +		i <= be32_to_cpu(agf->agf_fllast);) {

Whitespace after the "for" statement, and indentation of logic inside
for/if/while/etc needs to be aligned to the same column.

As it is, this code doesn't work. Hint: what happens when last wraps
around back to the start ofthe freelist array? last < first, and
hence i > last....

Yes, I know it the code is similar to what I suggested last time I
pointed out the iteration is wrong, but I'm often wrong, especially
about intricate details that I've just quickly pulled a solution for
off the top of my head.  IOWs, don't assume what I say is correct -
verifiy and test it, and then tell me I'm wrong.

So, perhaps a different loop structure is appropriate?

> +
> +		xfs_agblock_t	fbno;
> +		xfs_extlen_t	flen;
> +		xfs_daddr_t	dbno;
> +		xfs_fileoff_t	dlen;	

Trailing whitespace.

> +		int		flags = 0;
> +
> +		fbno = be32_to_cpu(agfl_bno[i]);
> +		flen = 1;
> +
> +		/* range check - must be wholly withing requested range */
> +		if (fbno < sagbno ||
> +			(eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
> +		xfs_warn(mp, "10: %d/%d, %d/%d", sagbno, eagbno, fbno, flen);
> +			continue;

Indentation:
		if (fbno < sagbno ||
		    (eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
			xfs_warn(mp, "10: %d/%d, %d/%d",
				 sagbno, eagbno, fbno, flen);

> +		}
> +
> +		/*
> +		 * Use daddr format for all range/len calculations as that is
> +		 * the format the range/len variables are supplied in by
> +		 * userspace.
> +		 */
> +
> +		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
> +		dlen = XFS_FSB_TO_BB(mp, flen);
> +
> +		error = -fiemap_fill_next_extent(fieinfo,BBTOB(dbno),
> +						BBTOB(dbno), BBTOB(dlen), flags);

We don't need to negate the error any more, also whitespace after
fieinfo.

> +	

Stray whitespace in a stray line..

> +		if (error)
> +			break;
> +		if (++i == XFS_AGFL_SIZE(mp))
> +			i = 0;
> +	}
> +	xfs_buf_relse(agflbp);
> +	return error;
> +}
>  
>  /*
>   * Map the freespace from the requested range in the requested order.
> @@ -2804,6 +2869,10 @@
>  		}
>  		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>  
> +		/* Account for the free blocks in AGFL */
> +		error = xfs_alloc_agfl_freespace_map(mp, XFS_BUF_TO_AGF(agbp), fieinfo, agno, sagbno,
> +						agno == eagno ? eagbno : NULLAGBLOCK);
> +

Line is much longer than 80 columns. checkpatch will catch trivial
things like whitespace and line length....

Also, if there is an error, we need to handle it appropriately.

Patch as applied to my tree is below. Please apply it to your tree
and test it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Accounting for AGFL blocks in xfs_spaceman

From: Dhruvesh Rathore <adrscube@gmail.com>

The xfs_spaceman utility previously failed to account for AGFL
blocks.  Old output:

$ sudo xfs_spaceman -c "freesp" /media/xfs
   from      to extents  blocks    pct
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

As you can see the AGFL blocks were unaccounted (4 per AG, and there
were 4 AGs in this filesystem).  This patch adds a new function
which accounts for the the free extents tracked by the AGFL.

New output:

$ sudo xfs_spaceman -c "freesp" /media/xfs
   from      to extents  blocks    pct
      1       1      16      16   0.00
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

[dchinner: fixed whitespace issues, agfl iteration logic,
	   error handling]

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>

---
 fs/xfs/libxfs/xfs_alloc.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1ae53ad..544c945 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2633,6 +2633,68 @@ error0:
 }
 
 /*
+ * When we map free space we need to take into account the blocks
+ * that are indexed by the AGFL. They aren't found by walking the
+ * free space btrees, so we have to walk each AGFL to find them.
+ */
+static int
+xfs_alloc_agfl_freespace_map(
+	struct xfs_mount	*mp,
+	struct xfs_agf		*agf,
+	struct fiemap_extent_info *fieinfo,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		sagbno,
+	xfs_agblock_t		eagbno)
+{
+	xfs_buf_t		*agflbp;
+	__be32			*agfl_bno;
+	int			i;
+	int			error = 0;
+
+	error = xfs_alloc_read_agfl(mp, NULL, agno, &agflbp);
+	if (error)
+		return error;
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	for (i = be32_to_cpu(agf->agf_flfirst);;) {
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+		xfs_daddr_t	dbno;
+		xfs_fileoff_t	dlen;
+		int		flags = 0;
+
+		fbno = be32_to_cpu(agfl_bno[i]);
+		flen = 1;
+
+		/* range check - must be wholly withing requested range */
+		if (fbno < sagbno ||
+		    (eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
+			xfs_warn(mp, "10: %d/%d, %d/%d",
+				 sagbno, eagbno, fbno, flen);
+			continue;
+		}
+
+		/*
+		 * Use daddr format for all range/len calculations as that is
+		 * the format the range/len variables are supplied in by
+		 * userspace.
+		 */
+		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dlen = XFS_FSB_TO_BB(mp, flen);
+		error = fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
+						BBTOB(dbno), BBTOB(dlen), flags);
+		if (error)
+			break;
+		if (i == be32_to_cpu(agf->agf_fllast))
+			break;
+		if (++i == XFS_AGFL_SIZE(mp))
+			i = 0;
+	}
+	xfs_buf_relse(agflbp);
+	return error;
+}
+
+/*
  * Walk the extents in the tree given by the cursor, and dump them all into the
  * fieinfo. At the last extent in the tree, set the FIEMAP_EXTENT_LAST flag so
  * that we return only free space from this tree in a given request.
@@ -2793,6 +2855,13 @@ xfs_alloc_freespace_map(
 			goto put_agbp;
 		}
 
+		/* Account for the free blocks in AGFL */
+		error = xfs_alloc_agfl_freespace_map(mp, XFS_BUF_TO_AGF(agbp),
+					fieinfo, agno, sagbno,
+					agno == eagno ? eagbno : NULLAGBLOCK);
+		if (error)
+			goto put_agbp;
+
 		cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
 					      XFS_BTNUM_BNO);
 		error = xfs_alloc_lookup_ge(cur, sagbno, 1, &i);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
