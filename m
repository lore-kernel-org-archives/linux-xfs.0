Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9Sden006897 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:40 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F2zyabz8hx9IMZII for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001Aa-3O
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005V8-0K
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/18] xfstests: kill useless test owner fields
Date: Thu, 26 Jul 2012 19:27:57 +1000
Message-Id: <1343294892-20991-4-git-send-email-david@fromorbit.com>
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

Back many years ago, the owner field was used to email the test
owner when auto-qa failed that test. It is not needed anymore - if
you want to know who wrote the test, look it up in git....

Script used was:

$ sed -i -e "/^# creator/d" -e "/^owner/d" [0-2][0-9][0-9]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 001   |    2 --
 002   |    2 --
 003   |    2 --
 004   |    2 --
 005   |    2 --
 006   |    2 --
 007   |    2 --
 008   |    2 --
 009   |    2 --
 010   |    2 --
 011   |    2 --
 012   |    2 --
 013   |    2 --
 014   |    2 --
 015   |    2 --
 016   |    2 --
 017   |    2 --
 018   |    2 --
 019   |    2 --
 020   |    2 --
 021   |    2 --
 022   |    2 --
 023   |    2 --
 024   |    2 --
 025   |    2 --
 026   |    2 --
 027   |    2 --
 028   |    2 --
 029   |    2 --
 030   |    2 --
 031   |    2 --
 032   |    2 --
 033   |    2 --
 034   |    2 --
 035   |    2 --
 036   |    2 --
 037   |    2 --
 038   |    2 --
 039   |    2 --
 040   |    2 --
 041   |    2 --
 042   |    2 --
 043   |    2 --
 044   |    2 --
 045   |    2 --
 046   |    2 --
 047   |    2 --
 048   |    2 --
 049   |    2 --
 050   |    2 --
 051   |    2 --
 052   |    2 --
 053   |    2 --
 054   |    2 --
 055   |    2 --
 056   |    2 --
 057   |    2 --
 058   |    2 --
 059   |    2 --
 060   |    2 --
 061   |    2 --
 062   |    2 --
 063   |    2 --
 064   |    2 --
 065   |    2 --
 066   |    2 --
 067   |    2 --
 068   |    2 --
 069   |    2 --
 070   |    2 --
 071   |    2 --
 072   |    2 --
 073   |    2 --
 074   |    2 --
 075   |    2 --
 076   |    2 --
 077   |    2 --
 078   |    2 --
 079   |    2 --
 080   |    2 --
 081   |    2 --
 082   |    2 --
 083   |    2 --
 084   |    2 --
 085   |    2 --
 086   |    2 --
 087   |    2 --
 088   |    2 --
 089   |    2 --
 090   |    2 --
 091   |    2 --
 092   |    2 --
 093   |    2 --
 094   |    2 --
 095   |    2 --
 096   |    2 --
 097   |    2 --
 098   |    2 --
 099   |    1 -
 100   |    2 --
 101   |    2 --
 102   |    2 --
 103   |    2 --
 104   |    2 --
 105   |    2 --
 106   |    2 --
 107   |    2 --
 108   |    2 --
 109   |    2 --
 110   |    2 --
 111   |    2 --
 112   |    2 --
 113   |    2 --
 114   |    2 --
 115   |    2 --
 116   |    2 --
 117   |    2 --
 118   |    2 --
 119   |    2 --
 120   |    2 --
 121   |    2 --
 122   |    2 --
 123   |    2 --
 124   |    2 --
 125   |    2 --
 126   |    2 --
 127   |    2 --
 128   |    2 --
 129   |    2 --
 130   |    2 --
 131   |    2 --
 132   |    2 --
 133   |    2 --
 134   |    2 --
 135   |    2 --
 136   |    2 --
 137   |    2 --
 138   |    2 --
 139   |    2 --
 140   |    2 --
 141   |    2 --
 142   |    2 --
 143   |    2 --
 144   |    2 --
 145   |    2 --
 146   |    2 --
 147   |    2 --
 148   |    2 --
 149   |    2 --
 150   |    2 --
 151   |    2 --
 152   |    2 --
 153   |    2 --
 154   |    2 --
 155   |    2 --
 156   |    2 --
 157   |    2 --
 158   |    2 --
 159   |    2 --
 160   |    2 --
 161   |    2 --
 162   |    2 --
 163   |    2 --
 164   |    2 --
 165   |    2 --
 166   |    2 --
 167   |    2 --
 168   |    2 --
 169   |    2 --
 170   |    2 --
 171   |    2 --
 172   |    2 --
 173   |    2 --
 174   |    2 --
 175   |    1 -
 176   |    1 -
 177   |    2 --
 178   |    2 --
 179   |    2 --
 180   |    2 --
 181   |    2 --
 182   |    2 --
 183   |    2 --
 184   |    2 --
 185   |    2 --
 186   |    2 --
 187   |    2 --
 188   |    2 --
 189   |    2 --
 190   |    2 --
 191   |    2 --
 192   |    2 --
 193   |    2 --
 194   |    2 --
 195   |    2 --
 196   |    2 --
 197   |    2 --
 198   |    2 --
 199   |    2 --
 200   |    2 --
 201   |    2 --
 202   |    2 --
 203   |    2 --
 204   |    2 --
 205   |    2 --
 206   |    2 --
 207   |    2 --
 208   |    2 --
 209   |    2 --
 210   |    2 --
 211   |    2 --
 212   |    2 --
 213   |    2 --
 214   |    2 --
 215   |    2 --
 216   |    2 --
 217   |    2 --
 218   |    2 --
 219   |    2 --
 220   |    2 --
 221   |    2 --
 222   |    2 --
 223   |    2 --
 224   |    2 --
 225   |    2 --
 226   |    2 --
 227   |    2 --
 228   |    2 --
 229   |    2 --
 230   |    2 --
 231   |    2 --
 232   |    2 --
 233   |    2 --
 234   |    2 --
 235   |    2 --
 236   |    2 --
 237   |    2 --
 238   |    2 --
 239   |    2 --
 240   |    2 --
 241   |    2 --
 242   |    2 --
 243   |    2 --
 244   |    2 --
 245   |    2 --
 246   |    2 --
 247   |    2 --
 248   |    2 --
 249   |    2 --
 250   |    2 --
 251   |    1 -
 252   |    2 --
 253   |    2 --
 254   |    2 --
 255   |    2 --
 256   |    2 --
 257   |    2 --
 258   |    2 --
 259   |    2 --
 260   |    1 -
 261   |    2 --
 262   |    2 --
 263   |    2 --
 264   |    2 --
 265   |    2 --
 266   |    2 --
 267   |    2 --
 268   |    2 --
 269   |    2 --
 270   |    2 --
 271   |    2 --
 272   |    2 --
 273   |    1 -
 274   |    1 -
 275   |    1 -
 276   |    2 --
 277   |    2 --
 278   |    2 --
 279   |    2 --
 280   |    2 --
 281   |    2 --
 282   |    2 --
 283   |    2 --
 284   |    2 --
 group |   60 ++++++++++++++++++++++++++++++------------------------------
 new   |   13 -------------
 soak  |    2 --
 287 files changed, 30 insertions(+), 605 deletions(-)

diff --git a/001 b/001
index 8e3aabd..b9997f3 100755
--- a/001
+++ b/001
@@ -30,8 +30,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=kenmcd@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/002 b/002
index 896fd1e..db63fa0 100755
--- a/002
+++ b/002
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=kenmcd@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/003 b/003
index 61afac5..79b6bc5 100755
--- a/003
+++ b/003
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/004 b/004
index 23729da..d75c3c0 100755
--- a/004
+++ b/004
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/005 b/005
index 40b8b2e..27da3d3 100755
--- a/005
+++ b/005
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 #
 # Note1: On Linux, ELOOP limit used to be 32 but changed to 8, and lately
diff --git a/006 b/006
index e4d5e32..1437b46 100755
--- a/006
+++ b/006
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/007 b/007
index 50a8418..2bb981f 100755
--- a/007
+++ b/007
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/008 b/008
index dfc938a..0dee9f5 100755
--- a/008
+++ b/008
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/009 b/009
index d2a19d8..1883f15 100755
--- a/009
+++ b/009
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/010 b/010
index 78813a8..245f407 100755
--- a/010
+++ b/010
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/011 b/011
index 2fcc9d3..4ede2d8 100755
--- a/011
+++ b/011
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/012 b/012
index 7d33f4c..10498d5 100755
--- a/012
+++ b/012
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/013 b/013
index 58426ea..0879a2a 100755
--- a/013
+++ b/013
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/014 b/014
index 057e4d9..93caaa6 100755
--- a/014
+++ b/014
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/015 b/015
index a99f1ed..52ab251 100755
--- a/015
+++ b/015
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/016 b/016
index 08a73f4..538ba14 100755
--- a/016
+++ b/016
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 #
 # pv 796141
diff --git a/017 b/017
index b3a7f9c..59d092d 100755
--- a/017
+++ b/017
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/018 b/018
index 85df390..156cc1d 100755
--- a/018
+++ b/018
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/019 b/019
index 42e3c22..1fb0d83 100755
--- a/019
+++ b/019
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/020 b/020
index 8b8db30..2bd1d9f 100755
--- a/020
+++ b/020
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/021 b/021
index a6176f1..18fe40e 100755
--- a/021
+++ b/021
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/022 b/022
index b83b063..962316f 100755
--- a/022
+++ b/022
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/023 b/023
index b9eeafe..3e7fdd2 100755
--- a/023
+++ b/023
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/024 b/024
index 64b59bc..b7f1c10 100755
--- a/024
+++ b/024
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/025 b/025
index 90d3389..4ccb5de 100755
--- a/025
+++ b/025
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/026 b/026
index ef6aaa6..37a23cc 100755
--- a/026
+++ b/026
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/027 b/027
index 9df06c3..772705d 100755
--- a/027
+++ b/027
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/028 b/028
index 6628f66..0bf042f 100755
--- a/028
+++ b/028
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/029 b/029
index e4fe715..70c0d10 100755
--- a/029
+++ b/029
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/030 b/030
index a8fb92c..080d3fe 100755
--- a/030
+++ b/030
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/031 b/031
index fb6f15b..422a271 100755
--- a/031
+++ b/031
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/032 b/032
index d093b45..ad1909d 100755
--- a/032
+++ b/032
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/033 b/033
index 68a688e..dc5a32d 100755
--- a/033
+++ b/033
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/034 b/034
index c09f63b..27f3f22 100755
--- a/034
+++ b/034
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/035 b/035
index 34f5cac..b2fc417 100755
--- a/035
+++ b/035
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/036 b/036
index 4ed2ebc..e9bb411 100755
--- a/036
+++ b/036
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/037 b/037
index fd1e1af..e2e71c5 100755
--- a/037
+++ b/037
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/038 b/038
index f2af214..b62a4c9 100755
--- a/038
+++ b/038
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/039 b/039
index 016d2bc..428e8bb 100755
--- a/039
+++ b/039
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/040 b/040
index ea24ff5..0021c22 100755
--- a/040
+++ b/040
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/041 b/041
index 28dcb33..a9a9a23 100755
--- a/041
+++ b/041
@@ -23,8 +23,6 @@
 #-----------------------------------------------------------------------
 #
 set +x
-# creator
-owner=ajag@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/042 b/042
index c583746..15fa5dc 100755
--- a/042
+++ b/042
@@ -24,8 +24,6 @@
 #-----------------------------------------------------------------------
 #
 set +x
-# creator
-owner=ajag@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/043 b/043
index 189dc5b..ef92c0a 100755
--- a/043
+++ b/043
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/044 b/044
index 60a6e58..d0d8bd8 100755
--- a/044
+++ b/044
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/045 b/045
index db40333..c20e3a8 100755
--- a/045
+++ b/045
@@ -22,8 +22,6 @@
 #-----------------------------------------------------------------------
 #
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/046 b/046
index 783459c..fb83b7a 100755
--- a/046
+++ b/046
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/047 b/047
index f5f6a52..7c5e896 100755
--- a/047
+++ b/047
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/048 b/048
index 9d360d6..6139361 100755
--- a/048
+++ b/048
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/049 b/049
index 149c4b5..0a6e69c 100755
--- a/049
+++ b/049
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/050 b/050
index cf70b5a..6a66032 100755
--- a/050
+++ b/050
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/051 b/051
index 9d35138..07d5a9b 100755
--- a/051
+++ b/051
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 
diff --git a/052 b/052
index 2d8b73d..01d5469 100755
--- a/052
+++ b/052
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/053 b/053
index ac2162d..388c9b4 100755
--- a/053
+++ b/053
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajag@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/054 b/054
index e5e500c..1ce6180 100755
--- a/054
+++ b/054
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/055 b/055
index 309b9c3..965b43a 100755
--- a/055
+++ b/055
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/056 b/056
index a19b85a..be65bfb 100755
--- a/056
+++ b/056
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/057 b/057
index f3219a3..faa4776 100755
--- a/057
+++ b/057
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/058 b/058
index 43b2293..dfce43b 100755
--- a/058
+++ b/058
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/059 b/059
index 1f3f8e3..a2a07c9 100755
--- a/059
+++ b/059
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/060 b/060
index 4adc00f..f0d9870 100755
--- a/060
+++ b/060
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/061 b/061
index 8f1d149..fa98085 100755
--- a/061
+++ b/061
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/062 b/062
index 9800e33..5a6081e 100755
--- a/062
+++ b/062
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/063 b/063
index 42a323a..cdaf524 100755
--- a/063
+++ b/063
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/064 b/064
index 8e9e694..c7e727c 100755
--- a/064
+++ b/064
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/065 b/065
index c1dee5d..12f2ac9 100755
--- a/065
+++ b/065
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/066 b/066
index a6e76c1..7a68f79 100755
--- a/066
+++ b/066
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/067 b/067
index eb91aa1..baaed77 100755
--- a/067
+++ b/067
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/068 b/068
index b595d1d..fe4684c 100755
--- a/068
+++ b/068
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/069 b/069
index 820ca5f..3451715 100755
--- a/069
+++ b/069
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/070 b/070
index f48c33c..1d978cd 100755
--- a/070
+++ b/070
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/071 b/071
index ace0ee4..c135d1a 100755
--- a/071
+++ b/071
@@ -20,8 +20,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/072 b/072
index 981c408..930a983 100755
--- a/072
+++ b/072
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/073 b/073
index 9605662..d19c8f5 100755
--- a/073
+++ b/073
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/074 b/074
index b9fb9d5..0e5e820 100755
--- a/074
+++ b/074
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/075 b/075
index 87d273f..de581b6 100755
--- a/075
+++ b/075
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/076 b/076
index e472b26..a8b5d4a 100755
--- a/076
+++ b/076
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/077 b/077
index 3fb3e81..2b86a37 100755
--- a/077
+++ b/077
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/078 b/078
index 7af552e..901723e 100755
--- a/078
+++ b/078
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/079 b/079
index 8f6e179..048b220 100755
--- a/079
+++ b/079
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/080 b/080
index 8ece84d..3243fe1 100755
--- a/080
+++ b/080
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/081 b/081
index 96156c8..f0ee819 100755
--- a/081
+++ b/081
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/082 b/082
index c413c10..e21a793 100755
--- a/082
+++ b/082
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/083 b/083
index 7a73f30..dd60118 100755
--- a/083
+++ b/083
@@ -31,8 +31,6 @@
 #-----------------------------------------------------------------------
 #
 
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/084 b/084
index e04a402..ba5743a 100755
--- a/084
+++ b/084
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/085 b/085
index f4a45b7..44123ad 100755
--- a/085
+++ b/085
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/086 b/086
index 9c3f22d..b59ad0a 100755
--- a/086
+++ b/086
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=root@icy.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/087 b/087
index 48e5eaa..30e117b 100755
--- a/087
+++ b/087
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/088 b/088
index 9fd0df5..b6266ef 100755
--- a/088
+++ b/088
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=root@icy.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/089 b/089
index 1714bec..2653183 100755
--- a/089
+++ b/089
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/090 b/090
index 0cdbe34..8ce50c0 100755
--- a/090
+++ b/090
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/091 b/091
index 8a14602..ad82b8e 100755
--- a/091
+++ b/091
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/092 b/092
index 02ccc71..2f849f3 100755
--- a/092
+++ b/092
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/093 b/093
index d730651..881a833 100755
--- a/093
+++ b/093
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 
diff --git a/094 b/094
index 75fc565..4f4cf34 100755
--- a/094
+++ b/094
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/095 b/095
index b85b97f..9de4476 100755
--- a/095
+++ b/095
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/096 b/096
index 237edad..ecadd73 100755
--- a/096
+++ b/096
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/097 b/097
index 643d6f8..d3174e4 100755
--- a/097
+++ b/097
@@ -26,8 +26,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/098 b/098
index 5efd78f..58d2a95 100755
--- a/098
+++ b/098
@@ -28,8 +28,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/099 b/099
index b68bfcd..edd88a9 100755
--- a/099
+++ b/099
@@ -22,7 +22,6 @@
 #
 #_acl_list
 # modifier
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/100 b/100
index f3504ce..1ba5eb7 100755
--- a/100
+++ b/100
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/101 b/101
index e58f8b6..0d274e5 100755
--- a/101
+++ b/101
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/102 b/102
index dab9b5c..68407a7 100755
--- a/102
+++ b/102
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/103 b/103
index e383991..9750153 100755
--- a/103
+++ b/103
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/104 b/104
index 14f2669..4e61837 100755
--- a/104
+++ b/104
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/105 b/105
index 6c7f327..01bae98 100755
--- a/105
+++ b/105
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=fsgqa@snap.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/106 b/106
index 8278691..613b12c 100755
--- a/106
+++ b/106
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/107 b/107
index 74403e6..e887384 100755
--- a/107
+++ b/107
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/108 b/108
index 638cea9..6b656e6 100755
--- a/108
+++ b/108
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/109 b/109
index a9c174f..56364f4 100755
--- a/109
+++ b/109
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/110 b/110
index c58e6c9..8749afa 100755
--- a/110
+++ b/110
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/111 b/111
index 719a0e0..8f4c142 100755
--- a/111
+++ b/111
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/112 b/112
index 763b17a..bcdcfec 100755
--- a/112
+++ b/112
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/113 b/113
index b2ec510..fd301cd 100755
--- a/113
+++ b/113
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/114 b/114
index 7679222..fa64093 100755
--- a/114
+++ b/114
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@crackle.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/115 b/115
index 0679cfc..ebcc995 100755
--- a/115
+++ b/115
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@crackle.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/116 b/116
index cc2bb0f..2c3ab92 100755
--- a/116
+++ b/116
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=fsgqa@snap.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/117 b/117
index 2e3f658..8afc962 100755
--- a/117
+++ b/117
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/118 b/118
index 403655e..d140a8b 100755
--- a/118
+++ b/118
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@crackle.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/119 b/119
index 1509ece..85af211 100755
--- a/119
+++ b/119
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@crackle.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/120 b/120
index 010a8f3..8389925 100755
--- a/120
+++ b/120
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/121 b/121
index 2137ebc..a590bb0 100755
--- a/121
+++ b/121
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/122 b/122
index a57f8c3..1c4f3a4 100755
--- a/122
+++ b/122
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/123 b/123
index ee1194d..d45c516 100755
--- a/123
+++ b/123
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/124 b/124
index adae304..6fbb028 100755
--- a/124
+++ b/124
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/125 b/125
index 9a29941..c7215a3 100755
--- a/125
+++ b/125
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ajones@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/126 b/126
index c2348f4..a95c1e4 100755
--- a/126
+++ b/126
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/127 b/127
index 62e584c..d1101df 100755
--- a/127
+++ b/127
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/128 b/128
index 7760b95..85d0f45 100755
--- a/128
+++ b/128
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/129 b/129
index 38f12a6..18d891b 100755
--- a/129
+++ b/129
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/130 b/130
index ea5270d..943df72 100755
--- a/130
+++ b/130
@@ -30,8 +30,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/131 b/131
index 783765e..176c8b4 100755
--- a/131
+++ b/131
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/132 b/132
index e90f56c..98229a9 100755
--- a/132
+++ b/132
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/133 b/133
index 9dbcb64..ec225f3 100755
--- a/133
+++ b/133
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/134 b/134
index 7317168..2117b4a 100755
--- a/134
+++ b/134
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/135 b/135
index 976619d..f0bf9b9 100755
--- a/135
+++ b/135
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/136 b/136
index acf50b7..6479c8c 100755
--- a/136
+++ b/136
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@puffy.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/137 b/137
index 42fb853..0f65d08 100755
--- a/137
+++ b/137
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/138 b/138
index e7b5609..f8af8dd 100755
--- a/138
+++ b/138
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/139 b/139
index 706a112..7d2e409 100755
--- a/139
+++ b/139
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/140 b/140
index 1f88302..a8cbd09 100755
--- a/140
+++ b/140
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/141 b/141
index cc501d6..45c1b5e 100755
--- a/141
+++ b/141
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=bnaujok@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/142 b/142
index c09a968..526167d 100755
--- a/142
+++ b/142
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/143 b/143
index 7db6fea..63281f9 100755
--- a/143
+++ b/143
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/144 b/144
index 36b9263..52123cc 100755
--- a/144
+++ b/144
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/145 b/145
index 3d6c158..54b8198 100755
--- a/145
+++ b/145
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/146 b/146
index 477df83..bb4975c 100755
--- a/146
+++ b/146
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/147 b/147
index b775478..e366dc7 100755
--- a/147
+++ b/147
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/148 b/148
index 7bb1722..abc516a 100755
--- a/148
+++ b/148
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/149 b/149
index 193e6d7..b1793b7 100755
--- a/149
+++ b/149
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/150 b/150
index a865875..b6a04c5 100755
--- a/150
+++ b/150
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/151 b/151
index f10460d..4bfaff3 100755
--- a/151
+++ b/151
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/152 b/152
index 071be85..2317291 100755
--- a/152
+++ b/152
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/153 b/153
index 7c609d2..81be175 100755
--- a/153
+++ b/153
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/154 b/154
index 2384d26..62e79c2 100755
--- a/154
+++ b/154
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/155 b/155
index de88ecb..949bd98 100755
--- a/155
+++ b/155
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/156 b/156
index 0f3b229..549cac8 100755
--- a/156
+++ b/156
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/157 b/157
index 11488c6..9ae3c40 100755
--- a/157
+++ b/157
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/158 b/158
index 2b95ec6..e740654 100755
--- a/158
+++ b/158
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/159 b/159
index 203afca..bfc225d 100755
--- a/159
+++ b/159
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/160 b/160
index 095951b..3900299 100755
--- a/160
+++ b/160
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/161 b/161
index 8d0aed2..c419380 100755
--- a/161
+++ b/161
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/162 b/162
index 409d3a1..acd70e0 100755
--- a/162
+++ b/162
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/163 b/163
index faf02e4..d4eef64 100755
--- a/163
+++ b/163
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=allanr@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/164 b/164
index 2aea353..1ef4aaf 100755
--- a/164
+++ b/164
@@ -27,8 +27,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@puffy.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/165 b/165
index ec349da..3b321b9 100755
--- a/165
+++ b/165
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@puffy.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/166 b/166
index 65c46da..527686f 100755
--- a/166
+++ b/166
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/167 b/167
index ccb6c2a..c2e15e8 100755
--- a/167
+++ b/167
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/168 b/168
index e044091..8980f9b 100755
--- a/168
+++ b/168
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/169 b/169
index 627981e..413a86b 100755
--- a/169
+++ b/169
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/170 b/170
index a807de0..b725d3a 100755
--- a/170
+++ b/170
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator - based on work from ddiss@sgi.co
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/171 b/171
index 7e70466..4f77a41 100755
--- a/171
+++ b/171
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/172 b/172
index 3220697..b6b496c 100755
--- a/172
+++ b/172
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/173 b/173
index 9156403..7146d2f 100755
--- a/173
+++ b/173
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/174 b/174
index 4828854..7745a6a 100755
--- a/174
+++ b/174
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/175 b/175
index 523dce1..4fc3ffb 100755
--- a/175
+++ b/175
@@ -24,7 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/176 b/176
index b988783..93083c4 100755
--- a/176
+++ b/176
@@ -21,7 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-owner=ddiss@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/177 b/177
index b6f4789..ec8aca7 100755
--- a/177
+++ b/177
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=mohamedb@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/178 b/178
index e4e104e..8856656 100755
--- a/178
+++ b/178
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=mohamedb@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/179 b/179
index 5cec718..f3facca 100755
--- a/179
+++ b/179
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/180 b/180
index c303169..0f82306 100755
--- a/180
+++ b/180
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/181 b/181
index 6db52ac..fb65100 100755
--- a/181
+++ b/181
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/182 b/182
index ae1f920..33e8010 100755
--- a/182
+++ b/182
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lachlan@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/183 b/183
index 5558eb9..4624ab4 100755
--- a/183
+++ b/183
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=xaiki@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/184 b/184
index 8544dc1..a37f700 100755
--- a/184
+++ b/184
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq - silence is golden"
diff --git a/185 b/185
index ed0793c..928eb24 100755
--- a/185
+++ b/185
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=xaiki@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/186 b/186
index a2d7e14..2c66026 100755
--- a/186
+++ b/186
@@ -32,8 +32,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@emu.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/187 b/187
index 8086c8e..bff0caa 100755
--- a/187
+++ b/187
@@ -26,8 +26,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@emu.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/188 b/188
index ed93e65..4ebbfc1 100755
--- a/188
+++ b/188
@@ -28,8 +28,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=bnaujok@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/189 b/189
index e91d5cd..a5a5682 100755
--- a/189
+++ b/189
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/190 b/190
index 096b871..5bb4743 100755
--- a/190
+++ b/190
@@ -25,8 +25,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=pleckie@sgi.com
 
 #This is the list of holes to punch in the file limited to $filesize
 #NOTE holes cannot overlap or this script will fail.
diff --git a/191 b/191
index b1e66bf..3120dcb 100755
--- a/191
+++ b/191
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@emu.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/192 b/192
index 4b69147..691ab7d 100755
--- a/192
+++ b/192
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=tes@emu.melbourne.sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/193 b/193
index 9891256..88ab971 100755
--- a/193
+++ b/193
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/194 b/194
index 931068d..595da25 100755
--- a/194
+++ b/194
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/195 b/195
index b910f72..cd64db1 100755
--- a/195
+++ b/195
@@ -22,8 +22,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/196 b/196
index 6b9998f..321fe47 100755
--- a/196
+++ b/196
@@ -23,8 +23,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/197 b/197
index 0996630..8c2ebd2 100755
--- a/197
+++ b/197
@@ -26,8 +26,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/198 b/198
index 2c72677..31de96c 100755
--- a/198
+++ b/198
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/199 b/199
index 2151cd2..127f307 100755
--- a/199
+++ b/199
@@ -23,8 +23,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/200 b/200
index d1f7e9d..34139cc 100755
--- a/200
+++ b/200
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/201 b/201
index 99bcde8..e868d99 100755
--- a/201
+++ b/201
@@ -23,8 +23,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/202 b/202
index f3030fc..27f9e67 100755
--- a/202
+++ b/202
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/203 b/203
index 4d60bb0..ed89600 100755
--- a/203
+++ b/203
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/204 b/204
index 9f4839c..6c4a3f0 100755
--- a/204
+++ b/204
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/205 b/205
index bd916a1..7c953db 100755
--- a/205
+++ b/205
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=david@fromorbit.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/206 b/206
index e8bc922..1c25305 100755
--- a/206
+++ b/206
@@ -26,8 +26,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/207 b/207
index 6fff833..6eaf50c 100755
--- a/207
+++ b/207
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/208 b/208
index ca01558..7ea7514 100755
--- a/208
+++ b/208
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/209 b/209
index 650e300..8b2a4e1 100755
--- a/209
+++ b/209
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/210 b/210
index a0873f8..56ac8ad 100755
--- a/210
+++ b/210
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/211 b/211
index bb8d2aa..5667d20 100755
--- a/211
+++ b/211
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/212 b/212
index 1b4bb8a..e211cc4 100755
--- a/212
+++ b/212
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/213 b/213
index 9982dd4..e297fdf 100755
--- a/213
+++ b/213
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/214 b/214
index cef7626..0a27fc5 100755
--- a/214
+++ b/214
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/215 b/215
index c61f7a5..749b27b 100755
--- a/215
+++ b/215
@@ -22,8 +22,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/216 b/216
index 71e6dd7..a997d5a 100755
--- a/216
+++ b/216
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/217 b/217
index ef0761e..b33c2e7 100755
--- a/217
+++ b/217
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dgc@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/218 b/218
index 77782c6..4b46452 100755
--- a/218
+++ b/218
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/219 b/219
index ad4e64d..047e285 100755
--- a/219
+++ b/219
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/220 b/220
index b913434..061b395 100755
--- a/220
+++ b/220
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/221 b/221
index 6681237..9cab3c4 100755
--- a/221
+++ b/221
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/222 b/222
index a65c845..133f221 100755
--- a/222
+++ b/222
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=david@fromorbit.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/223 b/223
index 2e0a245..8eba2d7 100755
--- a/223
+++ b/223
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/224 b/224
index 00ebd2e..23ee7c2 100755
--- a/224
+++ b/224
@@ -26,8 +26,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=david@fromorbit.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/225 b/225
index e7f1d9c..c09bd2a 100755
--- a/225
+++ b/225
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/226 b/226
index 6f28ac9..2179f2a 100755
--- a/226
+++ b/226
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/227 b/227
index dfcb1a5..8403724 100755
--- a/227
+++ b/227
@@ -26,8 +26,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=david@fromorbit.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/228 b/228
index fa230b0..2704934 100755
--- a/228
+++ b/228
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=aarora@in.ibm.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/229 b/229
index 81a2491..52be5c3 100755
--- a/229
+++ b/229
@@ -27,8 +27,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/230 b/230
index e66c5b9..a442857 100755
--- a/230
+++ b/230
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/231 b/231
index 115b4c0..6d8bda7 100755
--- a/231
+++ b/231
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/232 b/232
index 2795da7..81cd3ca 100755
--- a/232
+++ b/232
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/233 b/233
index 28e6ac7..52d2259 100755
--- a/233
+++ b/233
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/234 b/234
index 4e98035..dbb13f6 100755
--- a/234
+++ b/234
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/235 b/235
index 0c2ae8f..f4a1fce 100755
--- a/235
+++ b/235
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=jack@suse.cz
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/236 b/236
index a7500ed..ec70cdb 100755
--- a/236
+++ b/236
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=shiwh@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/237 b/237
index 4d7bb40..7ebb88e 100755
--- a/237
+++ b/237
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=shiwh@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/238 b/238
index 4daca89..e1a8749 100755
--- a/238
+++ b/238
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dchinner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/239 b/239
index 6457c46..8aa4ed0 100755
--- a/239
+++ b/239
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/240 b/240
index dafcef3..d5f8940 100755
--- a/240
+++ b/240
@@ -27,8 +27,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/241 b/241
index bb920fe..ee572a7 100755
--- a/241
+++ b/241
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/242 b/242
index 9a0c89e..eb5f9df 100755
--- a/242
+++ b/242
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dchinner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/243 b/243
index 48f7932..6a1b6d7 100755
--- a/243
+++ b/243
@@ -40,8 +40,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=alal@google.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/244 b/244
index cd5f5e8..c96d4eb 100755
--- a/244
+++ b/244
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=arekm@maven.pl
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/245 b/245
index 02b3173..fb81d39 100755
--- a/245
+++ b/245
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/246 b/246
index faa5cca..d82e27d 100755
--- a/246
+++ b/246
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=hch@lst.de
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/247 b/247
index 91410b6..3a2f735 100755
--- a/247
+++ b/247
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lmcilroy@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/248 b/248
index 38eb442..f245c1c 100755
--- a/248
+++ b/248
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=xin.zhong@intel.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/249 b/249
index 100cd4c..e72092d 100755
--- a/249
+++ b/249
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dchinner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/250 b/250
index 9eca2b6..2dd12e8 100755
--- a/250
+++ b/250
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dchinner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/251 b/251
index f46b6e2..c5fc79e 100755
--- a/251
+++ b/251
@@ -23,7 +23,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-owner=lczerner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/252 b/252
index 441bed0..9f0424d 100755
--- a/252
+++ b/252
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=josef@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/253 b/253
index d8c94a2..b63b7f6 100755
--- a/253
+++ b/253
@@ -31,8 +31,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=aelder@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/254 b/254
index 7b74a02..73089d1 100755
--- a/254
+++ b/254
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=josef@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/255 b/255
index 0083963..e08c726 100755
--- a/255
+++ b/255
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=josef@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/256 b/256
index ffe172a..0d72795 100755
--- a/256
+++ b/256
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=achender@linux.vnet.ibm.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/257 b/257
index fb81e07..b58bd56 100755
--- a/257
+++ b/257
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=notasas@gmail.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/258 b/258
index e0441a5..87817bc 100755
--- a/258
+++ b/258
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/259 b/259
index d260b79..91503a0 100755
--- a/259
+++ b/259
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=branto@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/260 b/260
index b005cd3..5bd3b39 100755
--- a/260
+++ b/260
@@ -21,7 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-owner=lczerner@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/261 b/261
index 121b9e1..8903ec8 100755
--- a/261
+++ b/261
@@ -24,8 +24,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=aelder@sgi.com
 
 seq=$(basename $0)
 echo "QA output created by ${seq}"
diff --git a/262 b/262
index 6de514d..5a060f1 100755
--- a/262
+++ b/262
@@ -25,8 +25,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=aelder@sgi.com
 
 seq=$(basename $0)
 echo "QA output created by ${seq}"
diff --git a/263 b/263
index 315a938..18cd5de 100755
--- a/263
+++ b/263
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=nathans@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/264 b/264
index d655d1e..a589c7c 100755
--- a/264
+++ b/264
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=anand.jain@oracle.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/265 b/265
index 10f214f..f28d4e5 100755
--- a/265
+++ b/265
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=anand.jain@oracle.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/266 b/266
index 232e729..89c590f 100755
--- a/266
+++ b/266
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/267 b/267
index 2ef8dd3..c52d810 100755
--- a/267
+++ b/267
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/268 b/268
index e1decd9..36391a3 100755
--- a/268
+++ b/268
@@ -22,8 +22,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/269 b/269
index 7e13ed9..5bf24af 100755
--- a/269
+++ b/269
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dmonakhov@openvz.org
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/270 b/270
index b9ada27..c095606 100755
--- a/270
+++ b/270
@@ -22,8 +22,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dmonakhov@openvz.org
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/271 b/271
index b96d702..50b4c0b 100755
--- a/271
+++ b/271
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dmonakhov@openvz.org
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/272 b/272
index 26dfa3b..ed85216 100755
--- a/272
+++ b/272
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dmonakhov@openvz.org
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/273 b/273
index 67f3d6b..9a40394 100755
--- a/273
+++ b/273
@@ -22,7 +22,6 @@
 #-----------------------------------------------------------------------
 #
 #creator
-owner=wu.bo@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/274 b/274
index dcad90e..9b0fb71 100755
--- a/274
+++ b/274
@@ -24,7 +24,6 @@
 #-----------------------------------------------------------------------
 #
 #creator
-owner=wu.bo@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/275 b/275
index 214262e..5bf06e4 100755
--- a/275
+++ b/275
@@ -23,7 +23,6 @@
 #-----------------------------------------------------------------------
 #
 #creator
-owner=wu.bo@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/276 b/276
index 082f943..fc87c28 100755
--- a/276
+++ b/276
@@ -24,8 +24,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=list.btrfs@jan-o-sch.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/277 b/277
index 8021214..8ef809c 100755
--- a/277
+++ b/277
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=lizf@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/278 b/278
index 73cd117..559e174 100755
--- a/278
+++ b/278
@@ -23,8 +23,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=cmaiolino@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/279 b/279
index 7d30251..8ee3328 100755
--- a/279
+++ b/279
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@redhat.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/280 b/280
index 55849ed..69c9afd 100755
--- a/280
+++ b/280
@@ -21,8 +21,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=sandeen@sandeen.net
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/281 b/281
index 137f69f..2af3533 100755
--- a/281
+++ b/281
@@ -21,8 +21,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/282 b/282
index 024bad8..4938408 100755
--- a/282
+++ b/282
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/283 b/283
index 27251bb..d1ce8ad 100755
--- a/283
+++ b/283
@@ -23,8 +23,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/284 b/284
index c00e6f1..f8d0340 100644
--- a/284
+++ b/284
@@ -20,8 +20,6 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=liubo2009@cn.fujitsu.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
diff --git a/group b/group
index 104ed35..538e10d 100644
--- a/group
+++ b/group
@@ -5,97 +5,97 @@
 #
 
 # catch-all
-other		fsg@melbourne.sgi.com
+other
 
 # read/write integrity
-rw		dxm@sgi.com
+rw
 
 # directory operations, e.g. create/unlink
-dir		dxm@sgi.com
+dir
 
 # metadata and inodes in particular
-metadata	dxm@sgi.com
+metadata
 
 # xfs_db
-db		nathans@sgi.com dxm@sgi.com
+db
 
 # extended attributes
-attr		nathans@sgi.com dxm@sgi.com
+attr
 
 # xfs_logprint
-logprint	tes@sgi.com dxm@sgi.com
+logprint
 
 # XFS log related testing
-log		tes@sgi.com
+log
 
 # XFS log related testing
-v2log		tes@sgi.com
+v2log
 
 # xfsdump, xfsrestore, xfsinvutil
-dump		tes@sgi.com ivanr@sgi.com
+dump
 
 # xfsdump, xfsrestore to tapes
-tape		tes@sgi.com ivanr@sgi.com
+tape
 
 # xfsdump, xfsrestore to remote tapes
-remote		tes@sgi.com ivanr@sgi.com
+remote
 
 # xfs_copy
-copy		harshula@sgi.com
+copy
 
 # chacl, libacl
-acl		tes@sgi.com
+acl
 
 # capabilities
-cap		tes@sgi.com
+cap
 
 # permissions
-perms		tes@sgi.com
+perms
 
 # xfs_growfs
-growfs		ajag@sgi.com
+growfs
 
 # fsr.xfs
-fsr		ajag@sgi.com
+fsr
 
 # mkfs.xfs
-mkfs		nathans@sgi.com
+mkfs
 
 # xfs_repair
-repair		nathans@sgi.com
+repair
 
 # quota tools and XFS quota kernel code (XQM)
-quota		nathans@sgi.com
+quota
 
 # auto - tests to be run as part of nightly qa
-auto		dxm@sgi.com
+auto
 
 # ioctl - tests which use ioctl commands (directly/indirectly)
-ioctl		nathans@sgi.com
+ioctl
 
 # udf filesystem
-udf		ajones@sgi.com
+udf
 
 # AIO operations
-aio		nathans@sgi.com
+aio
 
 # Pattern writing and checking
-pattern         ajones@sgi.com
+pattern
 
 # dmapi based tests
 dmapi
 
 # filestreams based tests
-filestreams	dgc@sgi.com
+filestreams
 
 # case-insensitive based tests
-ci		bnaujok@sgi.com
+ci
 
 # test the mount/remount path
-mount		tes@sgi.com
+mount
 
 # test the NFS v4 ACL code if it exists
-nfs4acl		tes@sgi.com donaldd@sgi.com
+nfs4acl
 
 # test access time
 atime
diff --git a/new b/new
index eb5e0cb..8dde6c5 100755
--- a/new
+++ b/new
@@ -32,17 +32,6 @@ _cleanup()
     :
 }
 
-# fqdn for localhost
-_get_fqdn()
-{
-    NSLOOKUP_PROG="`set_prog_path nslookup`"
-    if [ "$NSLOOKUP_PROG" = "" ]; then
-	getent hosts `uname -n` | awk '{print $2}'
-    else
-	$NSLOOKUP_PROG `hostname` | $AWK_PROG '{ if ($1 == "Name:") print $2 }'
-    fi
-}
-
 if [ ! -f group ]
 then
     echo "Creating the group index ..."
@@ -116,8 +105,6 @@ cat <<End-of-File >$id
 #-----------------------------------------------------------------------
 #
 # creator
-owner=$USER@`_get_fqdn`
-
 seq=\`basename \$0\`
 echo "QA output created by \$seq"
 
diff --git a/soak b/soak
index 28a2e2e..0cf27a7 100755
--- a/soak
+++ b/soak
@@ -17,8 +17,6 @@
 #
 #-----------------------------------------------------------------------
 #
-# creator
-owner=dxm@sgi.com
 
 # get standard environment, filters and checks
 . ./common.rc
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
