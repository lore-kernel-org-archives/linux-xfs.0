Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B1157F56
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:25:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D08C4304062
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:25:28 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id YnklkKgLxB57YYH2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:25:27 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id rd3so39028802pab.9
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:25:26 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.215.112])
	by mx.google.com with ESMTPSA id ug6sm7934790pab.7.2015.01.29.05.25.24
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 29 Jan 2015 05:25:26 -0800 (PST)
Message-ID: <54ca34c6.4696420a.0f32.4513@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Thu, 29 Jan 2015 18:55:21 +0530
Subject: [PATCH 2/4] xfsprogs: Addition in debug option -d of xfs_spaceman
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


The xfs_spaceman utility did not have a a proper title to the content
displayed using -d (debug) option.

Old output (Before changes).

$ sudo xfs_spaceman -c "freesp -d" /media/xfs
       0        4        1
       0        5        1
       0        6        1
       0        7        1
       0   170382    11870
       0   213742     1262
       0   351845     5126
       0   463591    11331
       0   495531    12143
       0   553400   414028
       1        4        1
       1        5        1
       1        6        1
       1        7        1
       1        8   967420
       2     2564        1
       2     2565        1
       2     2566        1
       2     2567        1
       2     2568   453578
       2   456150    43989
       2   500140   467288
       3        4        1
       3        5        1
       3        6        1
       3        7        1
       3        8   967420
   from      to extents  blocks    pct
      1       1      16      16   0.00
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

This patch adds a suitable title header to the output, making it much
more readable to the user.

New output (After implementing this patch).

$ uname -a
Linux dhruv-MacBookAir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014 x86_64 x86_64 x86_64 GNU/Linux
$ sudo xfs_spaceman -V
xfs_spaceman version 3.2.2
$ sudo xfs_spaceman -c "freesp -d" /media/xfs
    agno    agbno      len
       0        4        1
       0        5        1
       0        6        1
       0        7        1
       0   170382    11870
       0   213742     1262
       0   351845     5126
       0   463591    11331
       0   495531    12143
       0   553400   414028
       1        4        1
       1        5        1
       1        6        1
       1        7        1
       1        8   967420
       2     2564        1
       2     2565        1
       2     2566        1
       2     2567        1
       2     2568   453578
       2   456150    43989
       2   500140   467288
       3        4        1
       3        5        1
       3        6        1
       3        7        1
       3        8   967420
   from      to extents  blocks    pct
      1       1      16      16   0.00
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

-------------------------------------------------------------------------------------------

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
---
spaceman/freesp.c	| 3 +++
1 file changed, 3 insertions(+)

--- a/spaceman/freesp.c	2015-01-28 19:17:43.471341809 +0530
+++ b/spaceman/freesp.c	2015-01-28 19:17:11.279343228 +0530

@@ -332,20 +332,23 @@
 static int
 freesp_f(
 	int		argc,
 	char		**argv)
 {
 	xfs_agnumber_t	agno;		
 
 	if (!init(argc, argv))
 		return 0;
 
+	if (dumpflag)
+		printf("%8s %8s %8s\n", "agno", "agbno", "len");
+
 	for (agno = 0; agno < file->geom.agcount; agno++)  {
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
 	if (histcount)
 		printhist();		
 	if (summaryflag) {
 		printf(_("total free extents %lld\n"), totexts);
 		printf(_("total free blocks %lld\n"), totblocks);
 		printf(_("average free extent size %g\n"),

-------------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
