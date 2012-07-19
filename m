Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6J3UW82248367 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 22:30:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pSZ4WkVc78ooMuUL for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 20:30:30 -0700 (PDT)
Date: Thu, 19 Jul 2012 13:30:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: prevent xfs_bmap_extsize_align() to exceed
	maximum extent size.
Message-ID: <20120719033027.GD23387@dastard>
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
	<50059437.6070705@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50059437.6070705@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 17, 2012 at 06:35:03PM +0200, Alain Renaud wrote:
> Here is a second revision. Needed to remove an ASSERT and added a new one.

FWIW, the change log goes in the section after the first --- (i.e.
where the diffstat is) as it is not needed in the commit message...

> xfs: prevent xfs_bmap_extsize_align() to exceed maximum extent size.
> 
> When trying to do preallocation that exceed the the maximum size of
> an extent, the extsize alignment can exceed this value.
> 
> We are already trying to solve this issue for delay allocation but we
> have the same with prealloc. So I think the simple solution is to limit
> the size in xfs_bmap_extsize_align() and remove the code specific to
> delay allocation.
> 
> We do have a simple test case to confirm that the problem exist.
> 
> # cd/xfs_dir/
> # xfs_io -c 'extsize 4m' .
> # xfs_io -f -c 'resvsp 0 8g' test_file
> XFS_IOC_RESVSP64: No space left on device

simpler: xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' test_file

I was able to reproduce this, for a short while. Then it went away:

$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' test_file
XFS_IOC_RESVSP64: No space left on device
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' test_file
XFS_IOC_RESVSP64: No space left on device
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' -c bmap test_file
XFS_IOC_RESVSP64: No space left on device
test_file: no extents
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' -c "bmap -vp" test_file
test_file:
 EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET               TOTAL FLAGS
   0: [0..16732159]:        238228480..254960639  8 (11596800..28328959) 16732160 10011
   1: [16732160..16781311]: 445662208..445711359 15 (20727808..20776959)    49152 10011
$ 
$ rm test_file
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' -c "bmap -vp" test_file
test_file:
 EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET               TOTAL FLAGS
   0: [0..16732159]:        238228480..254960639  8 (11596800..28328959) 16732160 10011
   1: [16732160..16781311]: 445662208..445711359 15 (20727808..20776959)    49152 10011
$ rm test_file
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' -c "bmap -vp" test_file
test_file:
 EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET               TOTAL FLAGS
   0: [0..16732655]:        238227984..254960639  8 (11596304..28328959) 16732656 11011
   1: [16732656..16781807]: 445662208..445711359 15 (20727808..20776959)    49152 10011
$ rm test_file
$ /usr/sbin/xfs_io -f -c 'extsize 4m' -c 'resvsp 0 8g' -c "bmap -vp" test_file
test_file:
 EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET               TOTAL FLAGS
   0: [0..16732655]:        238227984..254960639  8 (11596304..28328959) 16732656 11011
   1: [16732656..16781807]: 445662208..445711359 15 (20727808..20776959)    49152 10011
$ uname -a
Linux disappointment 3.4-trunk-amd64 #1 SMP Tue Jun 26 17:23:03 UTC 2012 x86_64 GNU/Linux


And it appears to be realted to the fact I don't have an AG with an
8G free extent in it. Initially, the trace was indicating the
allocation was asking for a signle 8GB extent, and failing because
it didn't find one, hence ENOSPC. I'd see this:

     kworker/4:0-22    [004] 1223944.610192: xfs_alloc_vextent_loopfailed: dev 9:0 agno 2 agbno 1213074 minlen 2097152 maxlen 2097152 mod 0 prod 1024 minleft 1 total 0 alignment 128 minalignslop 0 len 2661202812 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 136 isfl 0 userdata 2 firstblock 0xffffffffffffffff

where the minlen/maxlen values indicate the acceptible extent range.

When it started succeeding, I'd see this:

kworker/5:1-49    [005] 1225590.604825: xfs_alloc_vextent_loopfailed: dev 9:0 agno 15 agbno 471304 minlen 1348384 maxlen 2097152 mod 0 prod 1024 minleft 1 total 0 alignment 1 minalignslop 0 len 2348686204 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 136 isfl 0 userdata 2 firstblock 0xffffffffffffffff

Note the minlen? It's been shortened to reflect the fact I don't
have 8GB freespace extents in the filesystem.

Firstly, can you reproduce this on your test setup, Alain? What is
the size (and number) of the AGs in the filesystem? If you do see
this behaviour, then the alignment code is not the problem...

> +        * Make sure we do not exceed the maximum len of an extent.
> +        */
> +       align_alen = XFS_FILBLKS_MIN(align_alen,
> +                                    MAXEXTLEN - (MAXEXTLEN % extsz));

I don't think that is correct. alignment happens at both the start
and end of the extent, so you need to take into account two lots of
(extsz - 1) blocks of range extension for alignment.

> +	/*
>  	 * If the previous block overlaps with this proposed allocation
>  	 * then move the start forward without adjusting the length.
>  	 */
> @@ -1999,7 +2004,6 @@ xfs_bmap_extsize_align(
>  			return XFS_ERROR(EINVAL);
>  	} else {
>  		ASSERT(orig_off >= align_off);
> -		ASSERT(orig_end <= align_off + align_alen);

Why is this removed? What it is checking is that the aligned end
covers the entire range of the original space requested.

>  	}
>  #ifdef DEBUG
> @@ -2009,6 +2013,7 @@ xfs_bmap_extsize_align(
>  		ASSERT(align_off >= prevp->br_startoff + prevp->br_blockcount);
>  #endif
> +	ASSERT(align_alen <= MAXEXTLEN);
>  	*lenp = align_alen;
>  	*offp = align_off;
>  	return 0;
> @@ -4450,13 +4455,6 @@ xfs_bmapi_reserve_delalloc(
>  	/* Figure out the extent size, adjust alen */
>  	extsz = xfs_get_extsz_hint(ip);
>  	if (extsz) {
> -		/*
> -		 * Make sure we don't exceed a single extent length when we
> -		 * align the extent by reducing length we are going to
> -		 * allocate by the maximum amount extent size aligment may
> -		 * require.
> -		 */
> -		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));

This code is allowing for both head and tail extent alignment....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
