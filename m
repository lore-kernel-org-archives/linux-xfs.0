Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 107D729E28
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 19:43:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2AAC304110
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 17:43:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YitgFc7cwQTFTq19 for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 17:43:14 -0700 (PDT)
Date: Wed, 9 Apr 2014 10:08:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest: log operations properly to generic/001.full
Message-ID: <20140409000809.GN27017@dastard>
References: <CAG+wggbx13tnYB=J8q83oK72td2VV=V1Fg=-q3JnZb=5tCgCSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG+wggbx13tnYB=J8q83oK72td2VV=V1Fg=-q3JnZb=5tCgCSQ@mail.gmail.com>
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
To: Ming Chen <v.mingchen@gmail.com>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>, xfs@oss.sgi.com

On Sat, Apr 05, 2014 at 01:52:43AM -0400, Ming Chen wrote:
> Part of the operations were written to 001.full from the awk script, while the
> rest were piped to 001.full using tee.  The resultant 001.full did not reflect
> what are really performed.  This makes debugging difficult.
> 
> Signed-off-by: Ming Chen <v.mingchen@gmail.com>

This patch causes generic/001 to fail because it pushes all the
debug into the output file as well as the generic/001.full file.

diff -u tests/generic/001.out /home/dave/src/xfstests-dev/results//generic/001.out.bad
--- tests/generic/001.out       2014-01-20 16:57:33.000000000 +1100
+++ /home/dave/src/xfstests-dev/results//generic/001.out.bad    2014-04-09 09:58:34.000000000 +1000
@@ -1,9 +1,1189 @@
 QA output created by 001
 cleanup
 setup ....................................
-iter 1 chain ... check ....................................
-iter 2 chain ... check ....................................
-iter 3 chain ... check ....................................
-iter 4 chain ... check ....................................
-iter 5 chain ... check ....................................
+iter 1 chain ... 2320100 sub/e.0
+2320101 sub/g.0
+2320102 sub/m00.0
+2320103 sub/b.0
+2320104 sub/d00.0
+2320105 sub/c.0
+2320106 sub/l00.0
+2320107 sub/c.1
.....

I'm going to drop this patch because it breaks a previously working
test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
