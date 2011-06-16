Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5G0sHxn239114 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 19:54:18 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F79EDB36AB
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 17:54:16 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id YERjr2sIdkn9kdcc for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2011 17:54:16 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5G0U3r4022483
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 20:30:03 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5G0sFXP132780 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 20:54:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5G0sFIS006605 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 21:54:15 -0300
Subject: xfstests test case 032 fails for wrong reason
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 15 Jun 2011 17:54:12 -0700
Message-ID: <1308185652.7661.492.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

Hello All,

xfstests test case 032 creates different filesystems on the scratch
partition and tries mkfs.xfs on the same filesystem expecting it to
fail.

In my system, for whatever reason, mkfs of btrfs fails which leads to
the test case failure like this:
----------------
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 elm3c201 2.6.39-rc4-xfs.git.p2+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
MOUNT_OPTIONS -- -o
context=system_u:object_r:nfs_t:s0 /dev/sdd2 /mnt/xfsScratchMntPt

032 20s ... - output mismatch (see 032.out.bad)
--- 032.out	2011-06-10 17:25:22.000000000 -0700
+++ 032.out.bad	2011-06-15 17:47:23.000000000 -0700
@@ -1,2 +1,3 @@
 QA output created by 032
 Silence is golden.
+Failed - overwrote fs type btrfs!
Ran: 032
Failures: 032
Failed 1 of 1 tests
---------------------

which is incorrect. I am thinking of submitting the following change (to
run mkfs.xfs only if the preceding mkfs.$fs succeeds). Anybody has any
opinions or better suggestions ?

---------------
diff --git a/032 b/032
index 839b913..4261ca2 100755
--- a/032
+++ b/032
@@ -75,11 +75,15 @@ do
        echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seq.full
        eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seq.full 2>&1
 
-       # next, ensure we don't overwrite it
-       echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
-       /sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
+       if [ $? -eq 0 ] ; then
+               # next, ensure we don't overwrite it
+               echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
+               /sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
 
-       [ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
+               [ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
+       else
+               echo "mkfs of type ${fs} failed" >>$seq.full
+       fi
------------------

regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
