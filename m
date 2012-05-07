Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47Gaaxg093087 for <xfs@oss.sgi.com>; Mon, 7 May 2012 11:36:36 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id o6kZT2WbgU1mGflO
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 09:36:35 -0700 (PDT)
Message-ID: <4FA7FA14.6080700@hardwarefreak.com>
Date: Mon, 07 May 2012 11:36:36 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
In-Reply-To: <4FA77842.5010703@profihost.ag>
Reply-To: stan@hardwarefreak.com
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/7/2012 2:22 AM, Stefan Priebe - Profihost AG wrote:

>    from      to extents  blocks    pct
>       1       1  942737  942737   0,87
>       2       3  671860 1590480   1,47
>       4       7  461268 2416025   2,23
>       8      15 1350517 18043063  16,67
>      16      31  111254 2547581   2,35
>      32      63  192032 9039799   8,35
>      64     127   33026 3317194   3,07
>     128     255   14254 2665812   2,46
>     256     511   12516 4631200   4,28
>     512    1023    6942 5031081   4,65
>    1024    2047    4622 6893270   6,37
>    2048    4095    3268 9412271   8,70
>    4096    8191    2135 12716435  11,75
>    8192   16383     338 3974884   3,67
>   16384   32767     311 7018658   6,49
>   32768   65535     105 4511372   4,17
>   65536  131071      29 2577756   2,38
>  131072  262143       8 1339796   1,24
>  262144  524287      10 3950416   3,65
>  524288 1048575       4 2580085   2,38
> 1048576 2097151       2 3028028   2,80

This shows what I originally suspected.  Notice how top heavy this
histogram is.  Over half of your free space sits on little islands of
8MB or less.  17% is in islands of 60KB or less.  This is heavily
fragmented free space.  Contrast this with an XFS from the opposite end
of the aging spectrum that is only 1/3rd full and has seen very few
deletes as it has aged:

   from      to extents  blocks    pct
      1       1    1028    1028   0.01
      2       3    1185    2864   0.02
      4       7    1656    9007   0.06
      8      15    5232   67674   0.41
     16      31      36     775   0.00
     32      63       7     292   0.00
     64     127       4     350   0.00
    128     255       6    1286   0.01
    256     511       4    1460   0.01
    512    1023       5    4278   0.03
   1024    2047       5    6965   0.04
   2048    4095       5   12935   0.08
   4096    8191       1    8179   0.05
   8192   16383       2   29570   0.18
  16384   32767       2   60352   0.37
  32768   65535       3  148594   0.91
  65536  131071       2  195575   1.20
 131072  262143       2  420917   2.57
 524288 1048575       2 1499689   9.17
4194304 6103694       3 13876795  84.88

Notice how it is very bottom heavy, and that 85% of the free space is in
large islands of 16GB to 24GB.

Stefan, at this point in your filesystem's aging process, it may not
matter how much space you keep freeing up, as your deletion of small
files simply adds more heavily fragmented free space to the pool.  It's
the nature of your workload causing this.  If you were rsyncing and
deleting 500MB files the story would be much different.

What I would suggest is doing an xfsdump to a filesystem on another LUN
or machine, expand the size of this LUN by 50% or more (I gather this is
an external RAID), format it appropriately, then xfsrestore.  This will
eliminate your current free space fragmentation, and the 50% size
increase will delay the next occurrence of this problem.  If you can't
expand the LUN, simply do the xfsdump/format/xfsrestore, which will give
you contiguous free space.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
