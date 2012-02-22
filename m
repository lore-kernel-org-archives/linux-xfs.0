Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1MISSWM041167 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 12:28:28 -0600
Message-Id: <20120222182832.076759206@sgi.com>
Date: Wed, 22 Feb 2012 12:27:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [patch 1/1] xfstests: update inode softlimit output in 050
References: <20120222182713.040087240@sgi.com>
Content-Disposition: inline; filename=xfstests-fix-050-after-20f12d8
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Ben Myers <bpm@sgi.com>, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

With Mitsuo Hayasaka's kernel patch "xfs: change available ranges of softlimit
and hardlimit in quota check", xfs quota behavior is slightly different.

This needs to be reflected in test 050.  The new behavior is that we only start
the timer when we're above soft inode quota, and we don't start the timer when
we're at or below.

Signed-off-by: Ben Myers <bpm@sgi.com>
Index: xfstests/050.out
===================================================================
--- xfstests.orig/050.out
+++ xfstests/050.out
@@ -20,7 +20,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
@@ -52,7 +52,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
@@ -148,7 +148,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
