Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGwjbK198161 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 10:58:45 -0600
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id TebPF0Wj8eKE1esH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 08:58:44 -0800 (PST)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 21 Feb 2012 09:58:44 -0700
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 06BE7C90050
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:41 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1LGweLO3706926
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:40 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q1LGwe8Z013080 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:40 -0500
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 10:58:39 -0600
Message-Id: <20120221165839.23253.45298.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 1/4] xfstests: Fix a problem where using bsize was not working
	as expected
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
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From d60824ddc4a60c7902a53fded6773b3385180cc6 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 8 Feb 2012 10:02:37 -0600
Subject: [PATCH 1/3] Fix a problem wherein the bsize argument setting to mkfs fails to be
 included since MKFS_OPTIONS already has bsize.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 common.rc |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/common.rc b/common.rc
index cab0b64..61889b0 100644
--- a/common.rc
+++ b/common.rc
@@ -350,7 +350,10 @@ _scratch_mkfs_sized()
 
     case $FSTYP in
     xfs)
-	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
+	# replace bsize= in MKFS_OPTIONS if already defined
+	export MKFS_OPTIONS=$(echo $MKFS_OPTIONS | \
+			 sed -e "s/-bsize=[0-9]*/-bsize=$blocksize/")
+	_scratch_mkfs_xfs "-d size=$fssize"
 	;;
     ext2|ext3|ext4|ext4dev)
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
