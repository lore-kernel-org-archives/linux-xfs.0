Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5T8DaI8116122 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 03:13:37 -0500
Message-ID: <4A4877CA.2030209@dermichi.com>
Date: Mon, 29 Jun 2009 10:14:02 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: implement ->dirty_inode callout
References: <EBC1B5EB-A971-4769-8E2A-9C15BB069E11@sgi.com>
In-Reply-To: <EBC1B5EB-A971-4769-8E2A-9C15BB069E11@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Hi Felix!
> I'd like to (re)propose Dave's patch from the last October to
> address the problem of atime never making to the disk. Many
> people complained about it.
Tested here on 2.6.30 & works perfectly. I noticed that "strictatime" and "relatime" mounts options can't be used with XFS - had to change the default directly in fs/namespace.c.

> Can you run some benchmarks to see what impact it has with the
> new relatime default?
I did some benchmarks here and wasn't able to see any significant differences, even when atime is fully enabled. The tests were done with kernel 2.6.30 on a VMWare ESXi Server 3.5.0. Real Hardware is a dual Quad Xeon 2.66GHz, 6-disk 146GB 15k RAID5 on PERC6 with 128MB BBU cache.

xfs_info of test fs
--------------------
meta-data=/dev/sda3              isize=256    agcount=4, agsize=2365440 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=9461760, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

bonnie++ results
----------------
bonnie_relatime_nopatch.txt
Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
gentoo-x64-xfste 2G  1261  97 191145  34 95765  27  2951  97 234814  22  1169  17
Latency             12375us     271ms     927ms   11581us   17640us   54677us
Version 1.93c       ------Sequential Create------ --------Random Create--------
gentoo-x64-xfstest  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    32:100000:10/64  3951  42  1842  26 15114  87  4240  44   170   2  7004  57
Latency               622ms   19046us     156ms     543ms     106ms    1080ms
1.93c,1.93c,gentoo-x64-xfstest,1,1246251173,2G,,1261,97,191145,34,95765,27,2951,97,234814,22,1169,17,32,100000,10,,64,3951,42,1842,26,15114,87,4240,44,170,2,7004,57,12375us,271ms,927ms,11581us,17640us,54677us,622ms,19046us,156ms,543ms,106ms,1080ms

bonnie_relatime_withpach.txt
Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
gentoo-x64-xfste 2G  1271  99 284571  57 120562  27  2925  98 234804  24  1227  19
Latency             12436us     429ms     145ms   13323us   11892us   48055us
Version 1.93c       ------Sequential Create------ --------Random Create--------
gentoo-x64-xfstest  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    32:100000:10/64  3178  46  2308  32 17881  96  4451  54   171   2  7380  60
Latency               573ms   17378us   28025us   77271us     326ms     928ms
1.93c,1.93c,gentoo-x64-xfstest,1,1245948051,2G,,1271,99,284571,57,120562,27,2925,98,234804,24,1227,19,32,100000,10,,64,3178,46,2308,32,17881,96,4451,54,171,2,7380,60,12436us,429ms,145ms,13323us,11892us,48055us,573ms,17378us,28025us,77271us,326ms,928ms

bonnie_atime_withpatch.txt
Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
gentoo-x64-xfste 2G  1309  99 166258  21 117374  29  3015  98 223034  25  1182  22
Latency              8626us     496ms   23729us    9696us   28558us   43342us
Version 1.93c       ------Sequential Create------ --------Random Create--------
gentoo-x64-xfstest  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    32:100000:10/64  3696  52  1806  27 16913  89  4072  60   167   2  6838  58
Latency               600ms   21008us   26798us   55639us    1068ms    1045ms
1.93c,1.93c,gentoo-x64-xfstest,1,1245923465,2G,,1309,99,166258,21,117374,29,3015,98,223034,25,1182,22,32,100000,10,,64,3696,52,1806,27,16913,89,4072,60,167,2,6838,58,8626us,496ms,23729us,9696us,28558us,43342us,600ms,21008us,26798us,55639us,1068ms,1045ms

bonnie_noatime.txt
Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
gentoo-x64-xfste 2G  1302  99 312421  52 115066  29  3121  99 243930  24  1282  18
Latency              7750us     562ms   24417us   10083us   12990us   50122us
Version 1.93c       ------Sequential Create------ --------Random Create--------
gentoo-x64-xfstest  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    32:100000:10/64  3917  55  1942  28 16849  91  4043  59   172   2  7705  63
Latency               312ms     105ms    3530us     130ms     159ms     690ms
1.93c,1.93c,gentoo-x64-xfstest,1,1245922347,2G,,1302,99,312421,52,115066,29,3121,99,243930,24,1282,18,32,100000,10,,64,3917,55,1942,28,16849,91,4043,59,172,2,7705,63,7750us,562ms,24417us,10083us,12990us,50122us,312ms,105ms,3530us,130ms,159ms,690ms


hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
