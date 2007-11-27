Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 13:43:16 -0800 (PST)
Received: from av9-2-sn2.hy.skanova.net (av9-2-sn2.hy.skanova.net [81.228.8.180])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lARLhAxj013431
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 13:43:12 -0800
Received: from smtp4-2-sn2.hy.skanova.net (smtp4-2-sn2.hy.skanova.net [81.228.8.93])
	by av9-2-sn2.hy.skanova.net (Postfix) with ESMTP id 8DA1938E6D
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 22:20:50 +0100 (CET)
Received: from cobra.e-626.net (h193n1fls32o1110.telia.com [213.67.141.193])
	by smtp4-2-sn2.hy.skanova.net (Postfix) with ESMTP id 7657137E4A
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 22:20:50 +0100 (CET)
Received: from [192.168.1.9] (h193n1fls32o1110.telia.com [213.67.141.193])
	(authenticated bits=0)
	by cobra.e-626.net (8.14.0/8.14.0) with ESMTP id lARLKfTr022579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 22:20:46 +0100
Message-ID: <474C8A05.3020604@e-626.net>
Date: Tue, 27 Nov 2007 22:20:05 +0100
From: Johan Andersson <johan@e-626.net>
MIME-Version: 1.0
Subject: XFS performance problems on Linux x86_64 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

I am using Gentoo Linux on XFS root filesystem on a number of machines, 
where some are P4 based i686, and some new are Intel Core 2 Duo based 
x86_64 based.
When the new x86_64 based machines were put into service, we noticed 
that they are extremely slow on file io. I have now created two test 
partitions, each 5G in size, on the same disk. One is xfs and one is 
ext3, both filesystems created with default options. My simple test is 
to rsync our local portage tree to the 5G partition:
=====================================================================
tmpc-masv2 xfs # time rsync -r --delete rsync://devsrv/portage portage

real    5m55.037s
user    0m1.291s
sys     0m10.352s

======================================================================
tmpc-masv2 ext3 # time rsync -r --delete rsync://devsrv/portage portage

real    0m28.943s
user    0m1.095s
sys     0m5.384s

I have repeated this a number of times to make sure caching on the 
server does not interfere, with about the same results every time.

Any idea why XFS appears to be 12 times slower than ext3 on the 64-bit 
machine?

I have also some statistics from bonnie++:
XFS:
> Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> tmpc-masv2       4G   929  99 48914   8 23036   3  1872  96 50322   4 162.0   1
> Latency              8913us    1675ms     492ms   54567us     161ms     503ms
> Version 1.93c       ------Sequential Create------ --------Random Create--------
> tmpc-masv2          -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16  3241  13 +++++ +++  3541  13  3729  14 +++++ +++  1001   4
> Latency             60600us      80us   34066us   82412us      22us     269ms

EXT3:
> Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> tmpc-masv2       4G   581  98 43340   9 22933   4  2435  96 50829   4 153.5   1
> Latency             56412us    2111ms    1885ms   41179us     101ms     690ms
> Version 1.93c       ------Sequential Create------ --------Random Create--------
> tmpc-masv2          -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16 31286  38 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
> Latency             11233us     145us     165us    7555us       8us      40us

As it looks here, xfs performs ok (but not as good as expected) on large 
files, but creating and deleting files is extremely slow.

The machine these test run on uses Gentoo kernel sources 
2.6.23-gentoo-r1 (also tested with 2.6.22-gentoo-r8). xfsprogs is 2.9.4.

/Johan Andersson
