Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E52097F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:07:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B620B304059
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:07:50 -0800 (PST)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id Bpi4SOs4GBU8q5vf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:07:48 -0800 (PST)
Received: by mail-pa0-f47.google.com with SMTP id lf10so4887234pab.6
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:07:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150210072559.GA12722@dastard>
References: <54ca343a.43df440a.3c11.4474@mx.google.com>
	<20150210072559.GA12722@dastard>
Date: Wed, 11 Feb 2015 21:37:47 +0530
Message-ID: <CALJmpHMDO04-r+OgoQdfp=wZjZ6Hm0KSqMd1DtPx2k7qsAS5GQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] xfs: Accounting for AGFL blocks in xfs_spaceman
From: Dhruvesh Rathore <adrscube@gmail.com>
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

>> +     if (error)
>> +             return error;
>> +
>> +     agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
>> +
>> +     for(i = be32_to_cpu(agf->agf_flfirst);
>> +             i <= be32_to_cpu(agf->agf_fllast);) {
>
> Whitespace after the "for" statement, and indentation of logic inside
> for/if/while/etc needs to be aligned to the same column.
>
> As it is, this code doesn't work. Hint: what happens when last wraps
> around back to the start ofthe freelist array? last < first, and
> hence i > last....
>
> Yes, I know it the code is similar to what I suggested last time I
> pointed out the iteration is wrong, but I'm often wrong, especially
> about intricate details that I've just quickly pulled a solution for
> off the top of my head.  IOWs, don't assume what I say is correct -
> verifiy and test it, and then tell me I'm wrong.
>
> So, perhaps a different loop structure is appropriate?

We had addressed this issue in the previous code version, but
changed it when a doubt was raised in the previous patch comments.
We will ensure that we verify and test the feedback we receive from
now on. :)

> Patch as applied to my tree is below. Please apply it to your tree
> and test it.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: Accounting for AGFL blocks in xfs_spaceman
>
> From: Dhruvesh Rathore <adrscube@gmail.com>
>
> The xfs_spaceman utility previously failed to account for AGFL
> blocks.  Old output:
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
> were 4 AGs in this filesystem).  This patch adds a new function
> which accounts for the the free extents tracked by the AGFL.
>
> New output:
>
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
> [dchinner: fixed whitespace issues, agfl iteration logic,
>            error handling]
>
> Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
> Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
> Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1ae53ad..544c945 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2633,6 +2633,68 @@ error0:
>  }
>
>  /*
> + * When we map free space we need to take into account the blocks
> + * that are indexed by the AGFL. They aren't found by walking the
> + * free space btrees, so we have to walk each AGFL to find them.
> + */
> +static int
> +xfs_alloc_agfl_freespace_map(
> +       struct xfs_mount        *mp,
> +       struct xfs_agf          *agf,
> +       struct fiemap_extent_info *fieinfo,
> +       xfs_agnumber_t          agno,
> +       xfs_agblock_t           sagbno,
> +       xfs_agblock_t           eagbno)
> +{
> +       xfs_buf_t               *agflbp;
> +       __be32                  *agfl_bno;
> +       int                     i;
> +       int                     error = 0;
> +
> +       error = xfs_alloc_read_agfl(mp, NULL, agno, &agflbp);
> +       if (error)
> +               return error;
> +
> +       agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> +       for (i = be32_to_cpu(agf->agf_flfirst);;) {
> +               xfs_agblock_t   fbno;
> +               xfs_extlen_t    flen;
> +               xfs_daddr_t     dbno;
> +               xfs_fileoff_t   dlen;
> +               int             flags = 0;
> +
> +               fbno = be32_to_cpu(agfl_bno[i]);
> +               flen = 1;
> +
> +               /* range check - must be wholly withing requested range */
> +               if (fbno < sagbno ||
> +                   (eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
> +                       xfs_warn(mp, "10: %d/%d, %d/%d",
> +                                sagbno, eagbno, fbno, flen);
> +                       continue;
> +               }
> +
> +               /*
> +                * Use daddr format for all range/len calculations as that is
> +                * the format the range/len variables are supplied in by
> +                * userspace.
> +                */
> +               dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
> +               dlen = XFS_FSB_TO_BB(mp, flen);
> +               error = fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
> +                                               BBTOB(dbno), BBTOB(dlen), flags);
> +               if (error)
> +                       break;
> +               if (i == be32_to_cpu(agf->agf_fllast))
> +                       break;
> +               if (++i == XFS_AGFL_SIZE(mp))
> +                       i = 0;
> +       }
> +       xfs_buf_relse(agflbp);
> +       return error;
> +}
> +
> +/*
>   * Walk the extents in the tree given by the cursor, and dump them all into the
>   * fieinfo. At the last extent in the tree, set the FIEMAP_EXTENT_LAST flag so
>   * that we return only free space from this tree in a given request.
> @@ -2793,6 +2855,13 @@ xfs_alloc_freespace_map(
>                         goto put_agbp;
>                 }
>
> +               /* Account for the free blocks in AGFL */
> +               error = xfs_alloc_agfl_freespace_map(mp, XFS_BUF_TO_AGF(agbp),
> +                                       fieinfo, agno, sagbno,
> +                                       agno == eagno ? eagbno : NULLAGBLOCK);
> +               if (error)
> +                       goto put_agbp;
> +
>                 cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
>                                               XFS_BTNUM_BNO);
>                 error = xfs_alloc_lookup_ge(cur, sagbno, 1, &i);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

We thank you for taking the time out and working on the patches. We will
apply the above reworked patch and test it, and get back to you.

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
