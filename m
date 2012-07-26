Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SNYO006801 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bgy3YIioxC6eYkYt for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:19 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001Ab-4c
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005VC-1K
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/18] xfstests: remove stale machine configs
Date: Thu, 26 Jul 2012 19:27:58 +1000
Message-Id: <1343294892-20991-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Left over from the days of ASG, all stale. Remove them, leaving just
an simple example that defines all the variables that can be
configured. Also, add a localhost defined config set up for simple
KVM based guest test configs using virtio for their block devices to
simplify test setup in such scenarios..

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 configs/134.14.54.101.config |    8 --------
 configs/134.14.54.86.config  |    8 --------
 configs/bongo.config         |    8 --------
 configs/break.config         |   10 ----------
 configs/bruce.config         |   16 ----------------
 configs/burst.config         |    6 ------
 configs/carrot.config        |   12 ------------
 configs/chapter11.config     |   11 -----------
 configs/chook.config         |   10 ----------
 configs/cocky.config         |   15 ---------------
 configs/crackle.config       |    7 -------
 configs/cxfsirix1.config     |    7 -------
 configs/dassi.config         |    8 --------
 configs/dibbler.config       |   10 ----------
 configs/dmfnt2.config        |   10 ----------
 configs/dribble.config       |   12 ------------
 configs/emu.config           |    8 --------
 configs/example.config       |   15 +++++++++++++++
 configs/flame.config         |    9 ---------
 configs/frodo.config         |    9 ---------
 configs/galah.config         |   10 ----------
 configs/gaspode.config       |   13 -------------
 configs/giro.config          |   11 -----------
 configs/goldfish.config      |    8 --------
 configs/gonzo1.config        |   10 ----------
 configs/growler.config       |   10 ----------
 configs/hammer.config        |    7 -------
 configs/hellfire.config      |   15 ---------------
 configs/howler.config        |    8 --------
 configs/indra.config         |    6 ------
 configs/kermit1.config       |   10 ----------
 configs/lab343.config        |   10 ----------
 configs/linux-chatz.config   |   12 ------------
 configs/lite.config          |    8 --------
 configs/localhost.config     |   15 +++++++++++++++
 configs/lumpy.config         |    6 ------
 configs/mallet.config        |    7 -------
 configs/melt.config          |    7 -------
 configs/molten.config        |    8 --------
 configs/nobbs.config         |   13 -------------
 configs/permit.config        |    6 ------
 configs/puffy.config         |    9 ---------
 configs/rizzo1.config        |    7 -------
 configs/rooster.config       |   12 ------------
 configs/rosella.config       |   12 ------------
 configs/scaly.config         |    9 ---------
 configs/screamer.config      |   12 ------------
 configs/surly.config         |   11 -----------
 configs/tinkle.config        |    7 -------
 configs/usermode.config      |    8 --------
 configs/vimes.config         |   12 ------------
 51 files changed, 30 insertions(+), 468 deletions(-)
 delete mode 100644 configs/134.14.54.101.config
 delete mode 100644 configs/134.14.54.86.config
 delete mode 100644 configs/bongo.config
 delete mode 100644 configs/break.config
 delete mode 100644 configs/bruce.config
 delete mode 100644 configs/burst.config
 delete mode 100644 configs/carrot.config
 delete mode 100644 configs/chapter11.config
 delete mode 100644 configs/chook.config
 delete mode 100644 configs/cocky.config
 delete mode 100644 configs/crackle.config
 delete mode 100644 configs/cxfsirix1.config
 delete mode 100644 configs/dassi.config
 delete mode 100644 configs/dibbler.config
 delete mode 100644 configs/dmfnt2.config
 delete mode 100644 configs/dribble.config
 delete mode 100644 configs/emu.config
 create mode 100644 configs/example.config
 delete mode 100644 configs/flame.config
 delete mode 100644 configs/frodo.config
 delete mode 100644 configs/galah.config
 delete mode 100644 configs/gaspode.config
 delete mode 100644 configs/giro.config
 delete mode 100644 configs/goldfish.config
 delete mode 100644 configs/gonzo1.config
 delete mode 100644 configs/growler.config
 delete mode 100644 configs/hammer.config
 delete mode 100644 configs/hellfire.config
 delete mode 100644 configs/howler.config
 delete mode 100644 configs/indra.config
 delete mode 100644 configs/kermit1.config
 delete mode 100644 configs/lab343.config
 delete mode 100644 configs/linux-chatz.config
 delete mode 100644 configs/lite.config
 create mode 100644 configs/localhost.config
 delete mode 100644 configs/lumpy.config
 delete mode 100644 configs/mallet.config
 delete mode 100644 configs/melt.config
 delete mode 100644 configs/molten.config
 delete mode 100644 configs/nobbs.config
 delete mode 100644 configs/permit.config
 delete mode 100644 configs/puffy.config
 delete mode 100644 configs/rizzo1.config
 delete mode 100644 configs/rooster.config
 delete mode 100644 configs/rosella.config
 delete mode 100644 configs/scaly.config
 delete mode 100644 configs/screamer.config
 delete mode 100644 configs/surly.config
 delete mode 100644 configs/tinkle.config
 delete mode 100644 configs/usermode.config
 delete mode 100644 configs/vimes.config

diff --git a/configs/134.14.54.101.config b/configs/134.14.54.101.config
deleted file mode 100644
index 6f6b610..0000000
--- a/configs/134.14.54.101.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host 134.14.54.101, by xaiki's hack.pl
-#The IP for file system resource on HA cluster.
-EMAIL="leenap@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/lxvm/test
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/lxvm/scratch
-
diff --git a/configs/134.14.54.86.config b/configs/134.14.54.86.config
deleted file mode 100644
index c2fec06..0000000
--- a/configs/134.14.54.86.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host 134.14.54.86, by xaiki's hack.pl
-#The IP for file system resource on HA cluster.
-EMAIL="leenap@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/lxvm/test
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/lxvm/scratch
-
diff --git a/configs/bongo.config b/configs/bongo.config
deleted file mode 100644
index d972181..0000000
--- a/configs/bongo.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host bongo, by xaiki's hack.pl
-TEST_DEV=/dev/hda8
-TEST_DIR=/xfs1
-SCRATCH_DEV=/dev/hda9
-SCRATCH_MNT=/xfs2
-SCRATCH_LOGDEV=/dev/hda10
-SCRATCH_RTDEV=/dev/hda11
-
diff --git a/configs/break.config b/configs/break.config
deleted file mode 100644
index 64f6d59..0000000
--- a/configs/break.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host break, by xaiki's hack.pl
-MODULAR=1
-EMAIL="nathans@larry"
-SCRATCH_MNT=/mnt/scratch
-#SCRATCH_DEV=/dev/sda6
-SCRATCH_DEV=budgie:/mnt/scratch
-TEST_DIR=/mnt/test
-#TEST_DEV=/dev/sda5
-TEST_DEV=budgie:/mnt/test
-
diff --git a/configs/bruce.config b/configs/bruce.config
deleted file mode 100644
index f4f37c4..0000000
--- a/configs/bruce.config
+++ /dev/null
@@ -1,16 +0,0 @@
-# Autogenerated config for host bruce, by xaiki's hack.pl
-MODULAR=0
-EMAIL="nathans@larry"
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdb5
-SCRATCH_RTDEV=/dev/sdc1
-SCRATCH_LOGDEV=/dev/ram0
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdc3
-TEST_RTDEV=/dev/sdb6
-TEST_LOGDEV=/dev/ram1
-#TAPE_DEV=/dev/st0
-#RMT_TAPE_DEV=bruce:/dev/st0
-#RMT_IRIXTAPE_DEV=snort:/dev/tape
-#RMT_TAPE_USER=guest
-
diff --git a/configs/burst.config b/configs/burst.config
deleted file mode 100644
index 95bb09d..0000000
--- a/configs/burst.config
+++ /dev/null
@@ -1,6 +0,0 @@
-# Autogenerated config for host burst, by xaiki's hack.pl
-TEST_DIR=/xfs
-TEST_DEV=/dev/hda3
-SCRATCH_DEV=/dev/hda7
-SCRATCH_MNT=/scratch
-
diff --git a/configs/carrot.config b/configs/carrot.config
deleted file mode 100644
index 26f8e49..0000000
--- a/configs/carrot.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host carrot, by xaiki's hack.pl
-#dedicated qa machine, used to be dribble
-MODULAR=0
-EMAIL="ddiss@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/dsk/dks0d2s0
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/dsk/dks0d2s6
-#TAPE_DEV=/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/chapter11.config b/configs/chapter11.config
deleted file mode 100644
index 70039e4..0000000
--- a/configs/chapter11.config
+++ /dev/null
@@ -1,11 +0,0 @@
-# Autogenerated config for host chapter11, by xaiki's hack.pl
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb5
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb7
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb6
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb8
-[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb9
-
diff --git a/configs/chook.config b/configs/chook.config
deleted file mode 100644
index 64f6d59..0000000
--- a/configs/chook.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host break, by xaiki's hack.pl
-MODULAR=1
-EMAIL="nathans@larry"
-SCRATCH_MNT=/mnt/scratch
-#SCRATCH_DEV=/dev/sda6
-SCRATCH_DEV=budgie:/mnt/scratch
-TEST_DIR=/mnt/test
-#TEST_DEV=/dev/sda5
-TEST_DEV=budgie:/mnt/test
-
diff --git a/configs/cocky.config b/configs/cocky.config
deleted file mode 100644
index 0d2e432..0000000
--- a/configs/cocky.config
+++ /dev/null
@@ -1,15 +0,0 @@
-# Autogenerated config for host cocky, by xaiki's hack.pl
-MODULAR=1
-EMAIL="ajones@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdb1
-TEST_LOGDEV=/dev/sdb3
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdb2
-SCRATCH_LOGDEV=/dev/sdb4
-#SCRATCH_RTDEV=/dev/sdb5
-TAPE_DEV=/dev/st0
-#RMT_IRIXTAPE_DEV=snort:/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/crackle.config b/configs/crackle.config
deleted file mode 100644
index ee3c0da..0000000
--- a/configs/crackle.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host crackle, by xaiki's hack.pl
-#irix-crackle
-TEST_DIR=/mnt/xfs
-SCRATCH_MNT=/mnt/xfs2
-TEST_DEV=/dev/dsk/dks0d1s3
-SCRATCH_DEV=/dev/dsk/dks0d1s4
-
diff --git a/configs/cxfsirix1.config b/configs/cxfsirix1.config
deleted file mode 100644
index c36568a..0000000
--- a/configs/cxfsirix1.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host cxfsirix1, by xaiki's hack.pl
-EMAIL="ajones@sgi.com"
-TEST_DIR=/mnt/xfs_test0
-TEST_DEV=/dev/cxvm/xfs_test0
-SCRATCH_MNT=/mnt/xfs_test1
-SCRATCH_DEV=/dev/cxvm/xfs_test1
-
diff --git a/configs/dassi.config b/configs/dassi.config
deleted file mode 100644
index 638c06a..0000000
--- a/configs/dassi.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host dassi, by xaiki's hack.pl
-MODULAR=0
-EMAIL="ddiss@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/dsk/dks0d2s0
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/dsk/dks0d2s1
-
diff --git a/configs/dibbler.config b/configs/dibbler.config
deleted file mode 100644
index 2068c19..0000000
--- a/configs/dibbler.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# configuration file for dibbler
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="mohamedb@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-
diff --git a/configs/dmfnt2.config b/configs/dmfnt2.config
deleted file mode 100644
index de6af2e..0000000
--- a/configs/dmfnt2.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host dmfnt2, by xaiki's hack.pl
-TEST_DEV=/dev/sda6
-TEST_DIR=/mnt/test
-SCRATCH_DEV=/dev/sdc6
-SCRATCH_MNT=/mnt/scratch
-TAPE_DEV=/dev/st0
-RMT_TAPE_DEV=longhorn:/dev/tape
-# RMT_IRIXTAPE_DEV=longhorn:/dev/tape
-RMT_TAPE_USER=guest
-
diff --git a/configs/dribble.config b/configs/dribble.config
deleted file mode 100644
index b548b8e..0000000
--- a/configs/dribble.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host dribble, by xaiki's hack.pl
-#dedicated qa machine
-MODULAR=0
-EMAIL="ddiss@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/dsk/dks0d2s0
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/dsk/dks0d2s6
-#TAPE_DEV=/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/emu.config b/configs/emu.config
deleted file mode 100644
index 6b21ff3..0000000
--- a/configs/emu.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host emu, by xaiki's hack.pl
-MODULAR=0
-EMAIL="tes@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdb1
-SCRATCH_MNT=/mnt/scratch1
-SCRATCH_DEV=/dev/sdb2
-
diff --git a/configs/example.config b/configs/example.config
new file mode 100644
index 0000000..7b6e142
--- /dev/null
+++ b/configs/example.config
@@ -0,0 +1,15 @@
+# Example config file with all typical device options set for full
+# XFS kernel, progs and dump testing.
+MODULAR=0
+SCRATCH_MNT=/mnt/scratch
+SCRATCH_DEV=/dev/sdb5
+SCRATCH_RTDEV=/dev/sdc1
+SCRATCH_LOGDEV=/dev/ram0
+TEST_DIR=/mnt/test
+TEST_DEV=/dev/sdc3
+TEST_RTDEV=/dev/sdb6
+TEST_LOGDEV=/dev/ram1
+TAPE_DEV=/dev/st0
+RMT_TAPE_DEV=bruce:/dev/st0
+RMT_IRIXTAPE_DEV=snort:/dev/tape
+RMT_TAPE_USER=guest
diff --git a/configs/flame.config b/configs/flame.config
deleted file mode 100644
index ad44006..0000000
--- a/configs/flame.config
+++ /dev/null
@@ -1,9 +0,0 @@
-# Autogenerated config for host flame, by xaiki's hack.pl
-#dedicated qa machine (has some values already set)
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/xfs_test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/lxvm/xfs_test
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/xfs_scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/lxvm/xfs_scratch
-
diff --git a/configs/frodo.config b/configs/frodo.config
deleted file mode 100644
index a8c262c..0000000
--- a/configs/frodo.config
+++ /dev/null
@@ -1,9 +0,0 @@
-# Autogenerated config for host frodo, by xaiki's hack.pl
-MODULAR=0
-EMAIL="nathans@larry"
-TEST_DEV=/dev/hda6
-TEST_DIR=/mnt/test
-SCRATCH_DEV=/dev/hda7
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_LOGDEV=/dev/hda9
-
diff --git a/configs/galah.config b/configs/galah.config
deleted file mode 100644
index dc4c835..0000000
--- a/configs/galah.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host galah, by xaiki's hack.pl
-MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-
diff --git a/configs/gaspode.config b/configs/gaspode.config
deleted file mode 100644
index 8d7f939..0000000
--- a/configs/gaspode.config
+++ /dev/null
@@ -1,13 +0,0 @@
-# Autogenerated config for host gaspode, by xaiki's hack.pl
-#dedicated qa machine (has some values already set)
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb5
-[ -z "$TAPE_DEV" ] && TAPE_DEV=/dev/st0
-
diff --git a/configs/giro.config b/configs/giro.config
deleted file mode 100644
index cab8b56..0000000
--- a/configs/giro.config
+++ /dev/null
@@ -1,11 +0,0 @@
-# Autogenerated config for host giro, by xaiki's hack.pl
-MODULAR=0
-EMAIL="ddiss@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/dsk/dks0d2s0
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/dsk/dks0d2s6
-#TAPE_DEV=/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/goldfish.config b/configs/goldfish.config
deleted file mode 100644
index 94f5fc8..0000000
--- a/configs/goldfish.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host goldfish, by xaiki's hack.pl
-MODULAR=0
-TEST_DEV=/dev/hdc1
-TEST_DIR=/mnt/xfs0
-SCRATCH_DEV=/dev/hdc2
-SCRATCH_MNT=/mnt/xfs1
-SCRATCH_LOGDEV=/dev/hdc3
-
diff --git a/configs/gonzo1.config b/configs/gonzo1.config
deleted file mode 100644
index e6d807b..0000000
--- a/configs/gonzo1.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host gonzo1, by xaiki's hack.pl
-EMAIL="leenap@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/xfs_test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/lxvm/xfs_test
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb1
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/xfs_scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/lxvm/xfs_scratch
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb2
-[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb3
-
diff --git a/configs/growler.config b/configs/growler.config
deleted file mode 100644
index bf99b05..0000000
--- a/configs/growler.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host growler, by xaiki's hack.pl
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-
diff --git a/configs/hammer.config b/configs/hammer.config
deleted file mode 100644
index a070f93..0000000
--- a/configs/hammer.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host hammer, by xaiki's hack.pl
-EMAIL="bnaujok@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sda5
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sda6
-
diff --git a/configs/hellfire.config b/configs/hellfire.config
deleted file mode 100644
index 7664829..0000000
--- a/configs/hellfire.config
+++ /dev/null
@@ -1,15 +0,0 @@
-# Autogenerated config for host hellfire, by xaiki's hack.pl
-MODULAR=1
-EMAIL="ajones@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sda3
-TEST_LOGDEV=/dev/sda5
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sda4
-SCRATCH_LOGDEV=/dev/sda6
-#SCRATCH_RTDEV=/dev/sda7
-TAPE_DEV=/dev/st0
-#RMT_IRIXTAPE_DEV=snort:/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/howler.config b/configs/howler.config
deleted file mode 100644
index 47d98c1..0000000
--- a/configs/howler.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host howler, by xaiki's hack.pl
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="allanr@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-
diff --git a/configs/indra.config b/configs/indra.config
deleted file mode 100644
index dce005e..0000000
--- a/configs/indra.config
+++ /dev/null
@@ -1,6 +0,0 @@
-# Autogenerated config for host indra, by xaiki's hack.pl
-TEST_DEV=/dev/sdb1
-TEST_DIR=/mnt/xfs0
-SCRATCH_DEV=/dev/sdb2
-SCRATCH_MNT=/mnt/xfs1
-
diff --git a/configs/kermit1.config b/configs/kermit1.config
deleted file mode 100644
index 7d09819..0000000
--- a/configs/kermit1.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host kermit1, by xaiki's hack.pl
-EMAIL="mohamedb@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/xfs_test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/lxvm/xfs_test
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb1
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/xfs_scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/lxvm/xfs_scratch
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb2
-[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb3
-
diff --git a/configs/lab343.config b/configs/lab343.config
deleted file mode 100644
index 4b38d3d..0000000
--- a/configs/lab343.config
+++ /dev/null
@@ -1,10 +0,0 @@
-# Autogenerated config for host lab343, by xaiki's hack.pl
-MODULAR=0
-EMAIL="hch@sgi.com"
-TEST_DEV=/dev/sdb1
-SCRATCH_DEV=/dev/sdb2
-SCRATCH_LOGDEV=/dev/sdb5
-SCRATCH_RTDEV=/dev/sdb6
-TEST_DIR=/qa/test
-SCRATCH_MNT=/qa/scratch
-
diff --git a/configs/linux-chatz.config b/configs/linux-chatz.config
deleted file mode 100644
index ba762c9..0000000
--- a/configs/linux-chatz.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host linux-chatz, by xaiki's hack.pl
-#vmware on pc-chatz
-MODULAR=1
-EMAIL="chatz@sgi.com"
-USE_EXTERNAL=yes
-TEST_DIR="/mnt/data"
-TEST_DEV=/dev/sdd
-TEST_LOGDEV=/dev/sdb
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdg
-SCRATCH_LOGDEV=/mnt/sde
-
diff --git a/configs/lite.config b/configs/lite.config
deleted file mode 100644
index 783cd3c..0000000
--- a/configs/lite.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host lite, by xaiki's hack.pl
-TEST_DEV=/dev/sda1
-TEST_DIR=/mnt/sda1
-SCRATCH_DEV=/dev/sda2
-SCRATCH_MNT=/mnt/sda2
-SCRATCH_LOGDEV=/dev/sda3
-SCRATCH_RTDEV=/dev/sda4
-
diff --git a/configs/localhost.config b/configs/localhost.config
new file mode 100644
index 0000000..f47e694
--- /dev/null
+++ b/configs/localhost.config
@@ -0,0 +1,15 @@
+# default localhost file, set up for virtual machines using KVM and
+# virtio for it's block devices
+#
+MODULAR=0
+TEST_DIR=/mnt/test
+SCRATCH_MNT=/mnt/scratch
+
+TEST_DEV=/dev/vda
+SCRATCH_DEV=/dev/vdb
+
+TEST_LOGDEV=/dev/vdc
+SCRATCH_LOGDEV=/dev/vdd
+
+TEST_RTDEV=/dev/vde
+SCRATCH_RTDEV=/dev/vdf
diff --git a/configs/lumpy.config b/configs/lumpy.config
deleted file mode 100644
index 321d852..0000000
--- a/configs/lumpy.config
+++ /dev/null
@@ -1,6 +0,0 @@
-# Autogenerated config for host lumpy, by xaiki's hack.pl
-TEST_DEV=/dev/sdc5
-TEST_DIR=/mnt/scratch_0
-SCRATCH_DEV=/dev/sdc7
-SCRATCH_MNT=/mnt/scratch_2
-
diff --git a/configs/mallet.config b/configs/mallet.config
deleted file mode 100644
index 197fef5..0000000
--- a/configs/mallet.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host mallet, by xaiki's hack.pl
-MODULAR=1
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sda3
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sda4
-
diff --git a/configs/melt.config b/configs/melt.config
deleted file mode 100644
index 59bf9fc..0000000
--- a/configs/melt.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host melt, by xaiki's hack.pl
-MODULAR=1
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdb1
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdb2
-
diff --git a/configs/molten.config b/configs/molten.config
deleted file mode 100644
index dc8bfea..0000000
--- a/configs/molten.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host molten, by xaiki's hack.pl
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb5
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb6
-
diff --git a/configs/nobbs.config b/configs/nobbs.config
deleted file mode 100644
index 7a3cf2d..0000000
--- a/configs/nobbs.config
+++ /dev/null
@@ -1,13 +0,0 @@
-# Autogenerated config for host nobbs, by xaiki's hack.pl
-#dedicated qa machine, used to be porky
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-#[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb7
-#[ -z "$TAPE_DEV" ] && TAPE_DEV=/dev/st0
-
diff --git a/configs/permit.config b/configs/permit.config
deleted file mode 100644
index 93b5326..0000000
--- a/configs/permit.config
+++ /dev/null
@@ -1,6 +0,0 @@
-# Autogenerated config for host permit, by xaiki's hack.pl
-TEST_DEV=/dev/sdc1
-TEST_DIR=/mnt/xfs0
-SCRATCH_DEV=/dev/sdd1
-SCRATCH_MNT=/mnt/xfs1
-
diff --git a/configs/puffy.config b/configs/puffy.config
deleted file mode 100644
index e1f77ae..0000000
--- a/configs/puffy.config
+++ /dev/null
@@ -1,9 +0,0 @@
-# Autogenerated config for host puffy, by xaiki's hack.pl
-MODULAR=1
-EMAIL="tes@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sda7
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sda8
-TAPE_DEV=/dev/st0
-
diff --git a/configs/rizzo1.config b/configs/rizzo1.config
deleted file mode 100644
index d1a55b1..0000000
--- a/configs/rizzo1.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host rizzo1, by xaiki's hack.pl
-EMAIL="mohamedb@sgi.com"
-TEST_DIR=/mnt/xfs_test
-TEST_DEV=/dev/lxvm/xfs_test
-SCRATCH_MNT=/mnt/xfs_scratch
-SCRATCH_DEV=/dev/lxvm/xfs_scratch
-
diff --git a/configs/rooster.config b/configs/rooster.config
deleted file mode 100644
index e5a3163..0000000
--- a/configs/rooster.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host rooster, by xaiki's hack.pl
-MODULAR=1
-EMAIL="ajones@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdb1
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdb2
-TAPE_DEV=/dev/st0
-#RMT_IRIXTAPE_DEV=snort:/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/rosella.config b/configs/rosella.config
deleted file mode 100644
index 3b441bf..0000000
--- a/configs/rosella.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host rosella, by xaiki's hack.pl
-MODULAR=1
-EMAIL="ajones@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdb1
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdb3
-TAPE_DEV=/dev/st0
-#RMT_IRIXTAPE_DEV=snort:/dev/tape
-#RMT_TAPE_DEV=icy:/dev/st0
-#RMT_TAPE_USER=guest
-
diff --git a/configs/scaly.config b/configs/scaly.config
deleted file mode 100644
index a6d5510..0000000
--- a/configs/scaly.config
+++ /dev/null
@@ -1,9 +0,0 @@
-# Autogenerated config for host scaly, by xaiki's hack.pl
-EMAIL="bnaujok@sgi.com"
-TEST_DIR=/mnt/test
-TEST_DEV=/dev/sdd3
-#TEST_LOGDEV=/dev/sdd1
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_DEV=/dev/sdd4
-#SCRATCH_LOGDEV=/dev/sdd2
-
diff --git a/configs/screamer.config b/configs/screamer.config
deleted file mode 100644
index 047d64b..0000000
--- a/configs/screamer.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host screamer, by xaiki's hack.pl
-#dedicated qa machine (has some values already set)
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/sdb1
-#[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/sdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/sdb2
-#[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/sdb4
-#[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb5
-
diff --git a/configs/surly.config b/configs/surly.config
deleted file mode 100644
index 67c69a3..0000000
--- a/configs/surly.config
+++ /dev/null
@@ -1,11 +0,0 @@
-# Autogenerated config for host surly, by xaiki's hack.pl
-TEST_DEV=/dev/hda9
-TEST_DIR=/mnt/xfs1
-SCRATCH_DEV=/dev/hda8
-SCRATCH_MNT=/mnt/xfs0
-SCRATCH_LOGDEV=/dev/hda10
-TAPE_DEV=/dev/st0
-RMT_TAPE_DEV=fuzzy:/dev/st0
-RMT_IRIXTAPE_DEV=blub:/dev/tape
-RMT_TAPE_USER=guest
-
diff --git a/configs/tinkle.config b/configs/tinkle.config
deleted file mode 100644
index 5b534e8..0000000
--- a/configs/tinkle.config
+++ /dev/null
@@ -1,7 +0,0 @@
-# Autogenerated config for host tinkle, by xaiki's hack.pl
-#irix-patchbox-tinkle
-TEST_DEV=/dev/dsk/dks0d2s0
-TEST_DIR=/mnt/xfs_test
-SCRATCH_DEV=/dev/dsk/dks0d2s1
-SCRATCH_MNT=/mnt/xfs_scratch
-
diff --git a/configs/usermode.config b/configs/usermode.config
deleted file mode 100644
index 12734a3..0000000
--- a/configs/usermode.config
+++ /dev/null
@@ -1,8 +0,0 @@
-# Autogenerated config for host usermode, by xaiki's hack.pl
-TEST_DEV=/dev/ubd/1
-TEST_DIR=/mnt/test
-SCRATCH_DEV=/dev/ubd/2
-SCRATCH_MNT=/mnt/scratch
-SCRATCH_RTDEV=/dev/ubd/3
-SCRATCH_LOGDEV=/dev/ubd/4
-
diff --git a/configs/vimes.config b/configs/vimes.config
deleted file mode 100644
index afc129b..0000000
--- a/configs/vimes.config
+++ /dev/null
@@ -1,12 +0,0 @@
-# Autogenerated config for host vimes, by xaiki's hack.pl       
-# dedicated qa machine, used to be sheila
-[ -z "$MODULAR" ] && MODULAR=1
-EMAIL="ddiss@sgi.com"
-[ -z "$TEST_DIR" ] && TEST_DIR=/mnt/test
-[ -z "$TEST_DEV" ] && TEST_DEV=/dev/hdb1
-[ -z "$TEST_LOGDEV" ] && TEST_LOGDEV=/dev/hdb3
-[ -z "$SCRATCH_MNT" ] && SCRATCH_MNT=/mnt/scratch
-[ -z "$SCRATCH_DEV" ] && SCRATCH_DEV=/dev/hdb2
-[ -z "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=/dev/hdb4
-[ -z "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=/dev/sdb5
-
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
