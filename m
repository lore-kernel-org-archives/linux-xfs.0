Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EIftGJ116644 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:41:56 -0500
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4ECB1EDAD41
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:41:54 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id WD7x5QmrUJ0q2oYg for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:41:54 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EIUArj027816
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:30:10 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5EIfrJI110536 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:41:53 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5EIfqgH030571 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:41:52 -0400
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p5EIfpKe030473 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:41:51 -0400
Subject: Failure of test case 244
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 14 Jun 2011 11:41:50 -0700
Message-ID: <1308076910.7661.470.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>

Hello,

test case 244 expects a mkfs option projid32bit, which is not present in
older version of mkfs.xfs(for example 3.1.1 in RHEL 6.1).

I though of making it a "requires" for this test, so that the test case
doesn't generate a "failure" when the test is run on older versions.

Opinions ?

regards

chandra

PS: here is the test o/p

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 elm3c201 2.6.39-rc4-xfs.git.p2+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdd2 /mnt/xfsScratchMntPt

244	 [failed, exit status 1] - output mismatch (see 244.out.bad)
--- 244.out	2011-04-20 08:34:36.000000000 -0700
+++ 244.out.bad	2011-06-14 11:29:57.000000000 -0700
@@ -1,2 +1,25 @@
 QA output created by 244
-Silence is golden
+unknown option -i projid32bit=0
+Usage: mkfs.xfs
+/* blocksize */		[-b log=n|size=num]
+/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
+			    (sunit=value,swidth=value|su=num,sw=num),
+			    sectlog=n|sectsize=num
+/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]
+/* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n
+			    sunit=value|su=num,sectlog=n|sectsize=num,
+			    lazy-count=0|1]
+/* label */		[-L label (maximum 12 characters)]
+/* naming */		[-n log=n|size=num,version=2|ci]
+/* prototype file */	[-p fname]
+/* quiet */		[-q]
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]
+/* sectorsize */	[-s log=n|size=num]
+/* version */		[-V]
+			devicename
+<devicename> is required unless -d name=xxx is given.
+<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
+      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
+<value> is xxx (512 byte blocks).
+mkfs failed
+(see 244.full for details)
Ran: 244
Failures: 244
Failed 1 of 1 tests


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
