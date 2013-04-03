Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EADD7F5D
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 12:40:47 -0500 (CDT)
Message-Id: <20130403173245.376605011@sgi.com>
Date: Wed, 03 Apr 2013 12:31:49 -0500
From: rjohnston@sgi.com
Subject: [PATCH] cleanup duplicates in all tests
Content-Disposition: inline;
	filename=xfstests-cleanup-duplicates-in-tests.patch
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
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

There are duplicate blank lines, comment hash and lines
containing duplicate seqres= declarations, remove them.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 tests/btrfs/254   |    3 ---
 tests/btrfs/264   |    4 ----
 tests/btrfs/265   |    3 ---
 tests/btrfs/276   |    3 ---
 tests/btrfs/284   |    3 ---
 tests/btrfs/307   |    3 ---
 tests/ext4/271    |    2 --
 tests/ext4/301    |    2 --
 tests/ext4/302    |    2 --
 tests/ext4/303    |    2 --
 tests/ext4/304    |    2 --
 tests/generic/001 |    2 --
 tests/generic/002 |    2 --
 tests/generic/005 |    2 --
 tests/generic/006 |    2 --
 tests/generic/007 |    2 --
 tests/generic/010 |    2 --
 tests/generic/011 |    2 --
 tests/generic/013 |    3 ---
 tests/generic/014 |    2 --
 tests/generic/015 |    2 --
 tests/generic/020 |    4 ----
 tests/generic/053 |    2 --
 tests/generic/062 |    4 ----
 tests/generic/068 |    4 ----
 tests/generic/069 |    2 --
 tests/generic/070 |    2 --
 tests/generic/074 |    3 ---
 tests/generic/075 |    3 ---
 tests/generic/076 |    2 --
 tests/generic/077 |    2 --
 tests/generic/079 |    2 --
 tests/generic/083 |    5 -----
 tests/generic/088 |    2 --
 tests/generic/089 |    4 ----
 tests/generic/091 |    2 --
 tests/generic/093 |    2 --
 tests/generic/097 |    2 --
 tests/generic/099 |    4 ----
 tests/generic/100 |    3 ---
 tests/generic/105 |    2 --
 tests/generic/112 |    3 ---
 tests/generic/113 |    3 ---
 tests/generic/117 |    2 --
 tests/generic/120 |    3 ---
 tests/generic/123 |    3 ---
 tests/generic/124 |    2 --
 tests/generic/125 |    2 --
 tests/generic/126 |    2 --
 tests/generic/127 |    3 ---
 tests/generic/128 |    2 --
 tests/generic/129 |    2 --
 tests/generic/130 |    2 --
 tests/generic/131 |    2 --
 tests/generic/132 |    3 ---
 tests/generic/133 |    2 --
 tests/generic/135 |    4 ----
 tests/generic/141 |    2 --
 tests/generic/169 |    2 --
 tests/generic/184 |    2 --
 tests/generic/192 |    2 --
 tests/generic/193 |    6 ------
 tests/generic/198 |    2 --
 tests/generic/204 |    2 --
 tests/generic/207 |    2 --
 tests/generic/208 |    2 --
 tests/generic/209 |    2 --
 tests/generic/210 |    2 --
 tests/generic/211 |    2 --
 tests/generic/212 |    2 --
 tests/generic/213 |    2 --
 tests/generic/214 |    3 ---
 tests/generic/215 |    2 --
 tests/generic/219 |    2 --
 tests/generic/221 |    2 --
 tests/generic/223 |    2 --
 tests/generic/224 |    2 --
 tests/generic/225 |    3 ---
 tests/generic/226 |    2 --
 tests/generic/228 |    2 --
 tests/generic/230 |    2 --
 tests/generic/231 |    2 --
 tests/generic/232 |    2 --
 tests/generic/233 |    2 --
 tests/generic/234 |    2 --
 tests/generic/235 |    2 --
 tests/generic/236 |    2 --
 tests/generic/237 |    2 --
 tests/generic/239 |    2 --
 tests/generic/240 |    2 --
 tests/generic/241 |    2 --
 tests/generic/245 |    3 ---
 tests/generic/246 |    2 --
 tests/generic/247 |    2 --
 tests/generic/248 |    2 --
 tests/generic/249 |    2 --
 tests/generic/251 |    3 ---
 tests/generic/255 |    2 --
 tests/generic/256 |    3 ---
 tests/generic/257 |    2 --
 tests/generic/258 |    2 --
 tests/generic/260 |    3 ---
 tests/generic/263 |    2 --
 tests/generic/269 |    2 --
 tests/generic/270 |    2 --
 tests/generic/273 |    2 --
 tests/generic/274 |    2 --
 tests/generic/275 |    2 --
 tests/generic/277 |    2 --
 tests/generic/280 |    2 --
 tests/generic/285 |    2 --
 tests/generic/286 |    2 --
 tests/generic/288 |    3 ---
 tests/generic/294 |    2 --
 tests/generic/299 |    2 --
 tests/generic/300 |    2 --
 tests/shared/051  |    6 ------
 tests/shared/218  |    2 --
 tests/shared/243  |    2 --
 tests/shared/272  |    2 --
 tests/shared/289  |    2 --
 tests/shared/298  |    2 --
 tests/shared/305  |    2 --
 tests/udf/098     |    2 --
 tests/udf/101     |    2 --
 tests/udf/102     |    2 --
 tests/xfs/003     |    2 --
 tests/xfs/004     |    3 ---
 tests/xfs/008     |    2 --
 tests/xfs/009     |    3 ---
 tests/xfs/012     |    2 --
 tests/xfs/016     |    2 --
 tests/xfs/017     |    2 --
 tests/xfs/018     |    3 ---
 tests/xfs/019     |    2 --
 tests/xfs/021     |    2 --
 tests/xfs/022     |    2 --
 tests/xfs/023     |    2 --
 tests/xfs/024     |    2 --
 tests/xfs/025     |    2 --
 tests/xfs/026     |    2 --
 tests/xfs/027     |    2 --
 tests/xfs/028     |    3 ---
 tests/xfs/029     |    2 --
 tests/xfs/030     |    3 ---
 tests/xfs/031     |    2 --
 tests/xfs/033     |    2 --
 tests/xfs/034     |    2 --
 tests/xfs/035     |    2 --
 tests/xfs/036     |    2 --
 tests/xfs/037     |    2 --
 tests/xfs/038     |    2 --
 tests/xfs/039     |    2 --
 tests/xfs/040     |    2 --
 tests/xfs/041     |    2 --
 tests/xfs/042     |    2 --
 tests/xfs/043     |    2 --
 tests/xfs/044     |    3 ---
 tests/xfs/045     |    3 ---
 tests/xfs/046     |    2 --
 tests/xfs/047     |    5 -----
 tests/xfs/048     |    2 --
 tests/xfs/049     |    2 --
 tests/xfs/050     |    5 -----
 tests/xfs/052     |    2 --
 tests/xfs/054     |    2 --
 tests/xfs/055     |    2 --
 tests/xfs/056     |    2 --
 tests/xfs/057     |   10 ----------
 tests/xfs/058     |    2 --
 tests/xfs/059     |    2 --
 tests/xfs/060     |    2 --
 tests/xfs/061     |    2 --
 tests/xfs/063     |    2 --
 tests/xfs/064     |    3 ---
 tests/xfs/065     |    3 ---
 tests/xfs/066     |    2 --
 tests/xfs/067     |    2 --
 tests/xfs/071     |    3 ---
 tests/xfs/072     |    2 --
 tests/xfs/073     |    3 ---
 tests/xfs/078     |    3 ---
 tests/xfs/080     |    2 --
 tests/xfs/081     |    3 ---
 tests/xfs/082     |    2 --
 tests/xfs/084     |    2 --
 tests/xfs/085     |    2 --
 tests/xfs/086     |    2 --
 tests/xfs/087     |    2 --
 tests/xfs/090     |    3 ---
 tests/xfs/092     |    2 --
 tests/xfs/094     |    2 --
 tests/xfs/095     |    2 --
 tests/xfs/096     |    4 ----
 tests/xfs/103     |    3 ---
 tests/xfs/104     |    2 --
 tests/xfs/106     |    3 ---
 tests/xfs/107     |    3 ---
 tests/xfs/108     |    2 --
 tests/xfs/109     |    2 --
 tests/xfs/110     |    2 --
 tests/xfs/111     |    2 --
 tests/xfs/114     |    7 -------
 tests/xfs/115     |    5 -----
 tests/xfs/116     |    3 ---
 tests/xfs/118     |    3 ---
 tests/xfs/119     |    2 --
 tests/xfs/121     |    2 --
 tests/xfs/122     |    2 --
 tests/xfs/134     |    3 ---
 tests/xfs/136     |    3 ---
 tests/xfs/137     |    2 --
 tests/xfs/138     |    2 --
 tests/xfs/139     |    2 --
 tests/xfs/140     |    2 --
 tests/xfs/142     |    2 --
 tests/xfs/143     |    2 --
 tests/xfs/144     |    2 --
 tests/xfs/145     |    2 --
 tests/xfs/146     |    2 --
 tests/xfs/147     |    2 --
 tests/xfs/148     |    3 ---
 tests/xfs/149     |    2 --
 tests/xfs/150     |    2 --
 tests/xfs/151     |    2 --
 tests/xfs/152     |    2 --
 tests/xfs/153     |    2 --
 tests/xfs/154     |    2 --
 tests/xfs/155     |    2 --
 tests/xfs/156     |    2 --
 tests/xfs/157     |    2 --
 tests/xfs/158     |    2 --
 tests/xfs/159     |    2 --
 tests/xfs/160     |    2 --
 tests/xfs/161     |    2 --
 tests/xfs/162     |    2 --
 tests/xfs/163     |    3 ---
 tests/xfs/164     |    4 ----
 tests/xfs/165     |    4 ----
 tests/xfs/166     |    2 --
 tests/xfs/167     |    2 --
 tests/xfs/168     |    2 --
 tests/xfs/170     |    2 --
 tests/xfs/171     |    2 --
 tests/xfs/172     |    2 --
 tests/xfs/173     |    2 --
 tests/xfs/174     |    2 --
 tests/xfs/175     |    2 --
 tests/xfs/176     |    3 ---
 tests/xfs/177     |    3 ---
 tests/xfs/178     |    2 --
 tests/xfs/179     |    2 --
 tests/xfs/180     |    2 --
 tests/xfs/181     |    2 --
 tests/xfs/182     |    2 --
 tests/xfs/183     |    2 --
 tests/xfs/185     |    3 ---
 tests/xfs/186     |    3 ---
 tests/xfs/187     |    3 ---
 tests/xfs/188     |    2 --
 tests/xfs/189     |    3 ---
 tests/xfs/190     |    2 --
 tests/xfs/191     |    2 --
 tests/xfs/194     |    2 --
 tests/xfs/195     |    2 --
 tests/xfs/196     |    2 --
 tests/xfs/197     |    2 --
 tests/xfs/199     |    2 --
 tests/xfs/200     |    3 ---
 tests/xfs/201     |    5 -----
 tests/xfs/202     |    2 --
 tests/xfs/203     |    2 --
 tests/xfs/205     |    2 --
 tests/xfs/206     |    2 --
 tests/xfs/216     |    2 --
 tests/xfs/217     |    2 --
 tests/xfs/220     |    3 ---
 tests/xfs/222     |    2 --
 tests/xfs/227     |    2 --
 tests/xfs/229     |    2 --
 tests/xfs/238     |    2 --
 tests/xfs/242     |    3 ---
 tests/xfs/244     |    2 --
 tests/xfs/250     |    2 --
 tests/xfs/252     |    2 --
 tests/xfs/253     |    2 --
 tests/xfs/259     |    2 --
 tests/xfs/261     |    2 --
 tests/xfs/262     |    3 ---
 tests/xfs/266     |    2 --
 tests/xfs/267     |    2 --
 tests/xfs/268     |    2 --
 tests/xfs/278     |    3 ---
 tests/xfs/279     |    2 --
 tests/xfs/281     |    2 --
 tests/xfs/282     |    2 --
 tests/xfs/283     |    2 --
 tests/xfs/287     |    2 --
 tests/xfs/290     |    2 --
 tests/xfs/291     |    2 --
 tests/xfs/292     |    2 --
 tests/xfs/293     |    2 --
 tests/xfs/295     |    2 --
 tests/xfs/296     |    2 --
 tests/xfs/297     |    2 --
 305 files changed, 722 deletions(-)

Index: b/tests/btrfs/254
===================================================================
--- a/tests/btrfs/254
+++ b/tests/btrfs/254
@@ -24,9 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/btrfs/264
===================================================================
--- a/tests/btrfs/264
+++ b/tests/btrfs/264
@@ -24,9 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -123,7 +120,6 @@ _fill_blk()
 	wait $!
 }
 
-
 # Append a random size to the files
 # arg1 : FS in question
 _append_file()
Index: b/tests/btrfs/265
===================================================================
--- a/tests/btrfs/265
+++ b/tests/btrfs/265
@@ -23,9 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/btrfs/276
===================================================================
--- a/tests/btrfs/276
+++ b/tests/btrfs/276
@@ -27,9 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/btrfs/284
===================================================================
--- a/tests/btrfs/284
+++ b/tests/btrfs/284
@@ -23,9 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 here="`pwd`"
 tmp=/tmp/$$
Index: b/tests/btrfs/307
===================================================================
--- a/tests/btrfs/307
+++ b/tests/btrfs/307
@@ -24,9 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "== QA output created by $seq"
 
 here=`pwd`
Index: b/tests/ext4/271
===================================================================
--- a/tests/ext4/271
+++ b/tests/ext4/271
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/ext4/301
===================================================================
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/ext4/302
===================================================================
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/ext4/303
===================================================================
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/ext4/304
===================================================================
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/001
===================================================================
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -33,8 +33,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 # get standard environment, filters and checks
Index: b/tests/generic/002
===================================================================
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 # get standard environment, filters and checks
Index: b/tests/generic/005
===================================================================
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -34,8 +34,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/006
===================================================================
--- a/tests/generic/006
+++ b/tests/generic/006
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/007
===================================================================
--- a/tests/generic/007
+++ b/tests/generic/007
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/010
===================================================================
--- a/tests/generic/010
+++ b/tests/generic/010
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/011
===================================================================
--- a/tests/generic/011
+++ b/tests/generic/011
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 out=""
Index: b/tests/generic/013
===================================================================
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -91,7 +89,6 @@ _do_test()
     _check_test_fs
 }
 
-
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
Index: b/tests/generic/014
===================================================================
--- a/tests/generic/014
+++ b/tests/generic/014
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/015
===================================================================
--- a/tests/generic/015
+++ b/tests/generic/015
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/020
===================================================================
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -79,7 +77,6 @@ _attr_list()
     fi
 }
 
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
@@ -167,7 +164,6 @@ OCTAL_SIZE=`echo "obase=8; $MAX_ATTRVAL_
 _attr -q -g "long_attr" $testfile | od -t x1 | sed -e "s/^0*$OCTAL_SIZE$/ATTRSIZE/"    
 _attr -r "long_attr" $testfile >/dev/null
 
-
 echo "*** set/get/remove really long names (expect failure)"
 short="XXXXXXXXXX"
 long="$short$short$short$short$short$short$short$short$short$short"
Index: b/tests/generic/053
===================================================================
--- a/tests/generic/053
+++ b/tests/generic/053
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/062
===================================================================
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -142,7 +140,6 @@ for nsp in $ATTR_MODES; do
 	done
 done
 
-
 # 
 # Test the directory descent code
 # 
@@ -174,7 +171,6 @@ echo
 echo "*** directory descent without following symlinks"
 getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr_output
 
-
 # 
 # Test the backup/restore code
 # 
Index: b/tests/generic/068
===================================================================
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -46,7 +44,6 @@ _cleanup()
 
 trap "_cleanup" 0 1 2 3 15
 
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -71,7 +68,6 @@ _scratch_mount
 
 touch $tmp.running
 
-
 # start fsstress loop in a background block
 {
     STRESS_DIR="$SCRATCH_MNT/fsstress_test_dir"
Index: b/tests/generic/069
===================================================================
--- a/tests/generic/069
+++ b/tests/generic/069
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/070
===================================================================
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/074
===================================================================
--- a/tests/generic/074
+++ b/tests/generic/074
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -108,7 +106,6 @@ _process_args()
     done
 }
 
-
 # real QA test starts here
 rm -f $seqres.full
 
Index: b/tests/generic/075
===================================================================
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -123,7 +121,6 @@ _process_args()
     done
 }
 
-
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
Index: b/tests/generic/076
===================================================================
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/077
===================================================================
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/079
===================================================================
--- a/tests/generic/079
+++ b/tests/generic/079
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/083
===================================================================
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -31,11 +29,8 @@
 #-----------------------------------------------------------------------
 #
 
-
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/088
===================================================================
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -26,8 +26,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/089
===================================================================
--- a/tests/generic/089
+++ b/tests/generic/089
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 mtab_output=$TEST_DIR/mtab_output
Index: b/tests/generic/091
===================================================================
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/093
===================================================================
--- a/tests/generic/093
+++ b/tests/generic/093
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 
 here=`pwd`
 tmp=/tmp/$$
Index: b/tests/generic/097
===================================================================
--- a/tests/generic/097
+++ b/tests/generic/097
@@ -30,8 +30,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/099
===================================================================
--- a/tests/generic/099
+++ b/tests/generic/099
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -236,7 +234,6 @@ chacl o::---,g::---,u:$acl2:rwx,u::---,m
 echo "Expect to PASS as should match on user"
 $runas -u $acl2 -g $acl2 ./file1 2>&1
 
-
 #-------------------------------------------------------
 
 echo ""
@@ -272,7 +269,6 @@ _acl_list file3
 cd ..
 umask 022
 
-
 #-------------------------------------------------------
 
 echo ""
Index: b/tests/generic/100
===================================================================
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -78,7 +76,6 @@ cd $testdir
 tar -xRvf $TEMP_DIR/$TAR_FILE >>$seqres.full 2>&1
 cd $here
 
-
 # use diff -qr to compare
 ls -R -l ${testdir}${POPULATED_DIR} >>$seqres.full 2>&1
 diff -qr $POPULATED_DIR ${testdir}${POPULATED_DIR}
Index: b/tests/generic/105
===================================================================
--- a/tests/generic/105
+++ b/tests/generic/105
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/112
===================================================================
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -121,7 +119,6 @@ _process_args()
     done
 }
 
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
Index: b/tests/generic/113
===================================================================
--- a/tests/generic/113
+++ b/tests/generic/113
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -76,7 +74,6 @@ _do_test()
     rm -f $_files
 }
 
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
Index: b/tests/generic/117
===================================================================
--- a/tests/generic/117
+++ b/tests/generic/117
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/120
===================================================================
--- a/tests/generic/120
+++ b/tests/generic/120
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -94,7 +92,6 @@ echo "*** writing to file ***"
 echo "asdf" >> $SCRATCH_MNT/testfile2
 _compare_access_times $SCRATCH_MNT/testfile2 "writing file"
 
-
 umount $SCRATCH_MNT
 
 # success, all done
Index: b/tests/generic/123
===================================================================
--- a/tests/generic/123
+++ b/tests/generic/123
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -77,5 +75,4 @@ _user_do "mv $my_test_subdir/data_cohere
 
 cat $my_test_subdir/data_coherency.txt
 
-
 exit
Index: b/tests/generic/124
===================================================================
--- a/tests/generic/124
+++ b/tests/generic/124
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/125
===================================================================
--- a/tests/generic/125
+++ b/tests/generic/125
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/126
===================================================================
--- a/tests/generic/126
+++ b/tests/generic/126
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/127
===================================================================
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -121,7 +119,6 @@ FSX_ARGS="-f $FSX_ARGS"
 _fsx_std_nommap
 _fsx_std_mmap
 
-
 status=0
 _cleanup
 exit
Index: b/tests/generic/128
===================================================================
--- a/tests/generic/128
+++ b/tests/generic/128
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/129
===================================================================
--- a/tests/generic/129
+++ b/tests/generic/129
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/130
===================================================================
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -33,8 +33,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/131
===================================================================
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/132
===================================================================
--- a/tests/generic/132
+++ b/tests/generic/132
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/133
===================================================================
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/135
===================================================================
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -61,8 +59,6 @@ _umount_mount()
     cd "$CWD"
 }
 
-
-
 _umount_mount
 
 cd $SCRATCH_MNT
Index: b/tests/generic/141
===================================================================
--- a/tests/generic/141
+++ b/tests/generic/141
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/169
===================================================================
--- a/tests/generic/169
+++ b/tests/generic/169
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/184
===================================================================
--- a/tests/generic/184
+++ b/tests/generic/184
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq - silence is golden"
 
 here=`pwd`
Index: b/tests/generic/192
===================================================================
--- a/tests/generic/192
+++ b/tests/generic/192
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/193
===================================================================
--- a/tests/generic/193
+++ b/tests/generic/193
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -70,13 +68,11 @@ _supported_os Linux
 _require_user
 _need_to_be_root
 
-
 #
 # make sure we have a normal umask set
 #
 umask 022
 
-
 #
 # Test the ATTR_UID case
 #
@@ -127,7 +123,6 @@ su ${qa_user} -c "chgrp ${qa_user} test.
 
 _cleanup_files
 
-
 #
 # Test the ATTR_MODE case
 #
@@ -230,7 +225,6 @@ echo -n "after:  "; stat -c '%A' test.${
 
 _cleanup_files
 
-
 #
 # Test ATTR_*TIMES_SET
 #
Index: b/tests/generic/198
===================================================================
--- a/tests/generic/198
+++ b/tests/generic/198
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/204
===================================================================
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/207
===================================================================
--- a/tests/generic/207
+++ b/tests/generic/207
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/208
===================================================================
--- a/tests/generic/208
+++ b/tests/generic/208
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/209
===================================================================
--- a/tests/generic/209
+++ b/tests/generic/209
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/210
===================================================================
--- a/tests/generic/210
+++ b/tests/generic/210
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/211
===================================================================
--- a/tests/generic/211
+++ b/tests/generic/211
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/212
===================================================================
--- a/tests/generic/212
+++ b/tests/generic/212
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/213
===================================================================
--- a/tests/generic/213
+++ b/tests/generic/213
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/generic/214
===================================================================
--- a/tests/generic/214
+++ b/tests/generic/214
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
@@ -146,7 +144,6 @@ $XFS_IO_PROG -F -f \
         -c "pwrite 1136718 104115"      \
         $TEST_DIR/test214-7 | _filter_xfs_io_unique
 
-
 # success, all done
 status=0
 exit
Index: b/tests/generic/215
===================================================================
--- a/tests/generic/215
+++ b/tests/generic/215
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/generic/219
===================================================================
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/221
===================================================================
--- a/tests/generic/221
+++ b/tests/generic/221
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/223
===================================================================
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/224
===================================================================
--- a/tests/generic/224
+++ b/tests/generic/224
@@ -29,8 +29,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/225
===================================================================
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -55,7 +53,6 @@ rm -f $seqres.full
 fiemapfile=$SCRATCH_MNT/$seq.fiemap
 fiemaplog=$SCRATCH_MNT/$seq.log
 
-
 [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
 seed=`date +%s`
Index: b/tests/generic/226
===================================================================
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/228
===================================================================
--- a/tests/generic/228
+++ b/tests/generic/228
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/generic/230
===================================================================
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/231
===================================================================
--- a/tests/generic/231
+++ b/tests/generic/231
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/232
===================================================================
--- a/tests/generic/232
+++ b/tests/generic/232
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/233
===================================================================
--- a/tests/generic/233
+++ b/tests/generic/233
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/234
===================================================================
--- a/tests/generic/234
+++ b/tests/generic/234
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/235
===================================================================
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/236
===================================================================
--- a/tests/generic/236
+++ b/tests/generic/236
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/generic/237
===================================================================
--- a/tests/generic/237
+++ b/tests/generic/237
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/239
===================================================================
--- a/tests/generic/239
+++ b/tests/generic/239
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/240
===================================================================
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -30,8 +30,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/241
===================================================================
--- a/tests/generic/241
+++ b/tests/generic/241
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/245
===================================================================
--- a/tests/generic/245
+++ b/tests/generic/245
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -59,7 +57,6 @@ _filter_directory_not_empty()
  
 trap "_cleanup ; exit \$status" 0 1 2 3 15
 
-
 mkdir $dir
 
 mkdir $dir/aa
Index: b/tests/generic/246
===================================================================
--- a/tests/generic/246
+++ b/tests/generic/246
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/247
===================================================================
--- a/tests/generic/247
+++ b/tests/generic/247
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/248
===================================================================
--- a/tests/generic/248
+++ b/tests/generic/248
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/249
===================================================================
--- a/tests/generic/249
+++ b/tests/generic/249
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/251
===================================================================
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -23,11 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/255
===================================================================
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/256
===================================================================
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -54,7 +52,6 @@ _require_user
 
 testfile=$TEST_DIR/256.$$
 
-
 # _fill_fs()
 #
 # Fills a file system by repeatedly creating files in the given folder
Index: b/tests/generic/257
===================================================================
--- a/tests/generic/257
+++ b/tests/generic/257
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/258
===================================================================
--- a/tests/generic/258
+++ b/tests/generic/258
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/260
===================================================================
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -21,11 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/263
===================================================================
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/269
===================================================================
--- a/tests/generic/269
+++ b/tests/generic/269
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/270
===================================================================
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/273
===================================================================
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/274
===================================================================
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/275
===================================================================
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/277
===================================================================
--- a/tests/generic/277
+++ b/tests/generic/277
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=1	# failure is the default!
Index: b/tests/generic/280
===================================================================
--- a/tests/generic/280
+++ b/tests/generic/280
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/285
===================================================================
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/286
===================================================================
--- a/tests/generic/286
+++ b/tests/generic/286
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/288
===================================================================
--- a/tests/generic/288
+++ b/tests/generic/288
@@ -21,11 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=0
Index: b/tests/generic/294
===================================================================
--- a/tests/generic/294
+++ b/tests/generic/294
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/299
===================================================================
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/generic/300
===================================================================
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/shared/051
===================================================================
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 
 here=`pwd`
 tmp=/tmp/$$
@@ -230,7 +228,6 @@ chacl o::---,g::---,u:$acl2:rwx,u::---,m
 echo "Expect to PASS as should match on user"
 $runas -u $acl2 -g $acl2 ./file1 2>&1
 
-
 #-------------------------------------------------------
 
 echo ""
@@ -266,7 +263,6 @@ chacl -l file3 | _acl_filter_id
 cd ..
 umask 022
 
-
 #-------------------------------------------------------
 
 echo ""
@@ -283,7 +279,6 @@ chacl -l file1 | _acl_filter_id
 chacl -l acldir | _acl_filter_id
 chacl -l acldir/file2 | _acl_filter_id
 
-
 #-------------------------------------------------------
 
 echo ""
@@ -307,7 +302,6 @@ echo "Change #2..."
 $runas -u 12345 -g 54321 -- `which chacl` -r u::---,g::---,o::--- root
 find root -print | xargs chacl -l
 
-
 #-------------------------------------------------------
 
 echo ""
Index: b/tests/shared/218
===================================================================
--- a/tests/shared/218
+++ b/tests/shared/218
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/shared/243
===================================================================
--- a/tests/shared/243
+++ b/tests/shared/243
@@ -43,8 +43,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/shared/272
===================================================================
--- a/tests/shared/272
+++ b/tests/shared/272
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/shared/289
===================================================================
--- a/tests/shared/289
+++ b/tests/shared/289
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/shared/298
===================================================================
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=1	# failure is the default!
Index: b/tests/shared/305
===================================================================
--- a/tests/shared/305
+++ b/tests/shared/305
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/udf/098
===================================================================
--- a/tests/udf/098
+++ b/tests/udf/098
@@ -31,8 +31,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/udf/101
===================================================================
--- a/tests/udf/101
+++ b/tests/udf/101
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/udf/102
===================================================================
--- a/tests/udf/102
+++ b/tests/udf/102
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/003
===================================================================
--- a/tests/xfs/003
+++ b/tests/xfs/003
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 # get standard environment, filters and checks
Index: b/tests/xfs/004
===================================================================
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -54,7 +52,6 @@ _populate_scratch()
 	_scratch_mount				# and then remount
 }
 
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
Index: b/tests/xfs/008
===================================================================
--- a/tests/xfs/008
+++ b/tests/xfs/008
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/009
===================================================================
--- a/tests/xfs/009
+++ b/tests/xfs/009
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -185,6 +183,5 @@ EOF
 
 _filesize $out
 
-
 status=0
 exit
Index: b/tests/xfs/012
===================================================================
--- a/tests/xfs/012
+++ b/tests/xfs/012
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/016
===================================================================
--- a/tests/xfs/016
+++ b/tests/xfs/016
@@ -37,8 +37,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/017
===================================================================
--- a/tests/xfs/017
+++ b/tests/xfs/017
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/018
===================================================================
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -58,7 +56,6 @@ _require_v2log
 # link correct .out file
 _link_out_file $seq.op $seqfull.op
 
-
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
 
Index: b/tests/xfs/019
===================================================================
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/021
===================================================================
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/022
===================================================================
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -28,8 +28,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/023
===================================================================
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -26,8 +26,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/024
===================================================================
--- a/tests/xfs/024
+++ b/tests/xfs/024
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/025
===================================================================
--- a/tests/xfs/025
+++ b/tests/xfs/025
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/026
===================================================================
--- a/tests/xfs/026
+++ b/tests/xfs/026
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/027
===================================================================
--- a/tests/xfs/027
+++ b/tests/xfs/027
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/028
===================================================================
--- a/tests/xfs/028
+++ b/tests/xfs/028
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -73,6 +71,5 @@ _dump_inventory
 _do_invutil -F
 _dump_inventory
 
-
 # success, all done
 exit
Index: b/tests/xfs/029
===================================================================
--- a/tests/xfs/029
+++ b/tests/xfs/029
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/030
===================================================================
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -105,7 +103,6 @@ _scratch_mkfs_xfs $DSIZE | _filter_mkfs
 _check_ag 0
 _check_ag -1
 
-
 # success, all done
 status=0
 exit
Index: b/tests/xfs/031
===================================================================
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/033
===================================================================
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/034
===================================================================
--- a/tests/xfs/034
+++ b/tests/xfs/034
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/035
===================================================================
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/036
===================================================================
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/037
===================================================================
--- a/tests/xfs/037
+++ b/tests/xfs/037
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/038
===================================================================
--- a/tests/xfs/038
+++ b/tests/xfs/038
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/039
===================================================================
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/040
===================================================================
--- a/tests/xfs/040
+++ b/tests/xfs/040
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/041
===================================================================
--- a/tests/xfs/041
+++ b/tests/xfs/041
@@ -26,8 +26,6 @@ set +x
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/042
===================================================================
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -27,8 +27,6 @@ set +x
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/043
===================================================================
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -27,8 +27,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/044
===================================================================
--- a/tests/xfs/044
+++ b/tests/xfs/044
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -109,7 +107,6 @@ _unexpected()
     exit
 }
 
-
 # real QA test starts here
 # 
 _require_scratch
Index: b/tests/xfs/045
===================================================================
--- a/tests/xfs/045
+++ b/tests/xfs/045
@@ -21,12 +21,9 @@
 #
 #-----------------------------------------------------------------------
 #
-#
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/046
===================================================================
--- a/tests/xfs/046
+++ b/tests/xfs/046
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/047
===================================================================
--- a/tests/xfs/047
+++ b/tests/xfs/047
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/048
===================================================================
--- a/tests/xfs/048
+++ b/tests/xfs/048
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/049
===================================================================
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/xfs/050
===================================================================
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -46,12 +44,10 @@ _cleanup()
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux IRIX
 
-
 cp /dev/null $seqres.full
 chmod a+rwx $seqres.full	# arbitrary users will write here
 
@@ -63,7 +59,6 @@ bhard=500
 isoft=4
 ihard=10
 
-
 _filter_report()
 {
 	tr -s '[:space:]' | \
Index: b/tests/xfs/052
===================================================================
--- a/tests/xfs/052
+++ b/tests/xfs/052
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/054
===================================================================
--- a/tests/xfs/054
+++ b/tests/xfs/054
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/055
===================================================================
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/056
===================================================================
--- a/tests/xfs/056
+++ b/tests/xfs/056
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/057
===================================================================
--- a/tests/xfs/057
+++ b/tests/xfs/057
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -47,11 +45,3 @@ _supported_os IRIX
 status=0
 exit
 
-
-
-
-
-
-
-
-
Index: b/tests/xfs/058
===================================================================
--- a/tests/xfs/058
+++ b/tests/xfs/058
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/059
===================================================================
--- a/tests/xfs/059
+++ b/tests/xfs/059
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/060
===================================================================
--- a/tests/xfs/060
+++ b/tests/xfs/060
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/061
===================================================================
--- a/tests/xfs/061
+++ b/tests/xfs/061
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/063
===================================================================
--- a/tests/xfs/063
+++ b/tests/xfs/063
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/064
===================================================================
--- a/tests/xfs/064
+++ b/tests/xfs/064
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +36,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common/filter
 . ./common/dump
 
-
 _ls_size_filter()
 {
     #
Index: b/tests/xfs/065
===================================================================
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -194,7 +192,6 @@ while [ $i -le $num_dumps ]; do
     let i=$i+1
 done
 
-
 # success, all done
 status=0
 exit
Index: b/tests/xfs/066
===================================================================
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/067
===================================================================
--- a/tests/xfs/067
+++ b/tests/xfs/067
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/071
===================================================================
--- a/tests/xfs/071
+++ b/tests/xfs/071
@@ -24,8 +24,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 rm -f $seqres.full
 
Index: b/tests/xfs/072
===================================================================
--- a/tests/xfs/072
+++ b/tests/xfs/072
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/xfs/073
===================================================================
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -125,7 +123,6 @@ _verify_copy()
 	rm -f $target
 }
 
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
Index: b/tests/xfs/078
===================================================================
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -122,7 +120,6 @@ _grow_loop 168024b 1376452608 2048 1
 _grow_loop 168024b 1376452608 512 1 16m
 _grow_loop 168024b 688230400 1024 1
 
-
 # Other corner cases suggested by dgc
 # also the following doesn't check if the filesystem is consistent.
 #  - grow 1TB by 1.5TB (control)
Index: b/tests/xfs/080
===================================================================
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/081
===================================================================
--- a/tests/xfs/081
+++ b/tests/xfs/081
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -61,7 +59,6 @@ _require_v2log
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
 
-
 # do a simple quota test to ensure DQUOT data is happening
 export MOUNT_OPTIONS="-o quota,gquota"
 
Index: b/tests/xfs/082
===================================================================
--- a/tests/xfs/082
+++ b/tests/xfs/082
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/084
===================================================================
--- a/tests/xfs/084
+++ b/tests/xfs/084
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/085
===================================================================
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/086
===================================================================
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/087
===================================================================
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/090
===================================================================
--- a/tests/xfs/090
+++ b/tests/xfs/090
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -114,7 +112,6 @@ realtime_mmap_unaligned()
 	_check_scratch_fs
 }
 
-
 _create_scratch
 
 realtime_direct_aligned 0
Index: b/tests/xfs/092
===================================================================
--- a/tests/xfs/092
+++ b/tests/xfs/092
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/094
===================================================================
--- a/tests/xfs/094
+++ b/tests/xfs/094
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/095
===================================================================
--- a/tests/xfs/095
+++ b/tests/xfs/095
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/096
===================================================================
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -26,8 +26,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -130,7 +128,6 @@ cat >$tmp.seq.params <<EOF
   -l version=1 -d sunit=`expr $big_su / 512`,swidth=`expr $big_su / 512`
 EOF
 
-
 #
 # call mkfs in a loop for various params
 #
Index: b/tests/xfs/103
===================================================================
--- a/tests/xfs/103
+++ b/tests/xfs/103
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -73,7 +71,6 @@ _require_scratch
 
 _create_scratch
 
-
 echo "*** testing nosymlinks directories"
 mkdir $SCRATCH_MNT/nosymlink
 echo "*** setting nosymlinks bit"
Index: b/tests/xfs/104
===================================================================
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/106
===================================================================
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -93,7 +91,6 @@ $FSSTRESS_PROG -z -s 57069 -m 8 -n 1000
 -f setxattr=500 \
 -d $target
 
-
 # also use space, to be able to go over/under limits easily
 uid=255
 gid=254
Index: b/tests/xfs/107
===================================================================
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -108,7 +106,6 @@ $FSSTRESS_PROG -z -s 47806 -m 8 -n 500 -
 -f setxattr=250 \
 -d $target
 
-
 QARGS="-x -D $tmp.projects -P /dev/null $SCRATCH_MNT"
 
 echo "### initial report"
Index: b/tests/xfs/108
===================================================================
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/109
===================================================================
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/110
===================================================================
--- a/tests/xfs/110
+++ b/tests/xfs/110
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/111
===================================================================
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/114
===================================================================
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -39,7 +37,6 @@ _cleanup()
     rm -f $tmp.*
 }
 
-
 _check_paths()
 {
 	_path=$1 # might want to only check this path
@@ -143,7 +140,6 @@ _test_hardlink()
 		_check_paths $SCRATCH_MNT/$x
 	done
 
-
 	echo ""
 	echo "now try removing half of the hardlinks"
 	echo ""
@@ -178,7 +174,6 @@ _test_hardlink()
 # dir to dir2 where dir2 does not exist
 # dir to dir/dir3 - not allowed
 #
-#
 _test_rename()
 {
 	echo ""
@@ -238,7 +233,6 @@ _filter_num()
 	    -e 's/seed = [0-9][0-9]*/seed = S/'
 }
 
-
 _test_fsstress()
 {
 	echo ""
@@ -264,7 +258,6 @@ _test_fsstress()
 	_check_paths
 }
 
-
 _test_dirstress()
 {
 	echo ""
Index: b/tests/xfs/115
===================================================================
--- a/tests/xfs/115
+++ b/tests/xfs/115
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -92,7 +90,6 @@ _filter()
 	 -e 's/Attribute "[0-9][0-9]*/Attribute "INODE/'
 }
 
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -136,7 +133,6 @@ touch $d/file7
 touch $d/file8
 touch $d/file9
 
-
 _do_test()
 {
 	echo ""
Index: b/tests/xfs/116
===================================================================
--- a/tests/xfs/116
+++ b/tests/xfs/116
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -62,7 +60,6 @@ mount $SCRATCH_DEV $SCRATCH_MNT
 umount $SCRATCH_MNT
 xfs_db -r -c sb -c print $SCRATCH_DEV | grep qflags
 
-
 # success, all done
 status=0
 exit
Index: b/tests/xfs/118
===================================================================
--- a/tests/xfs/118
+++ b/tests/xfs/118
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -73,7 +71,6 @@ _chowning_file()
 	echo ""
 }
 
-
 echo "mkfs on scratch"
 _scratch_mkfs_xfs >$seqres.full
 
Index: b/tests/xfs/119
===================================================================
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/121
===================================================================
--- a/tests/xfs/121
+++ b/tests/xfs/121
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/122
===================================================================
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/134
===================================================================
--- a/tests/xfs/134
+++ b/tests/xfs/134
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -88,7 +86,6 @@ fi
 src/feature -p $SCRATCH_DEV
 [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
 
-
 mkdir $dir
 $XFS_IO_PROG -r -c "chproj -R 1" -c "chattr -R +P" $dir
 
Index: b/tests/xfs/136
===================================================================
--- a/tests/xfs/136
+++ b/tests/xfs/136
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -132,7 +130,6 @@ _print_inode_a()
     _scratch_mount
 }
 
-
 _test_add_eas()
 {
 	_print_inode
Index: b/tests/xfs/137
===================================================================
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/138
===================================================================
--- a/tests/xfs/138
+++ b/tests/xfs/138
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/139
===================================================================
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/140
===================================================================
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/142
===================================================================
--- a/tests/xfs/142
+++ b/tests/xfs/142
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/143
===================================================================
--- a/tests/xfs/143
+++ b/tests/xfs/143
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/144
===================================================================
--- a/tests/xfs/144
+++ b/tests/xfs/144
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/145
===================================================================
--- a/tests/xfs/145
+++ b/tests/xfs/145
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/146
===================================================================
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -25,8 +25,6 @@
 seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/147
===================================================================
--- a/tests/xfs/147
+++ b/tests/xfs/147
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/148
===================================================================
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -106,7 +104,6 @@ _scratch_mkfs_xfs $DSIZE | _filter_mkfs
 _check_ag 0
 _check_ag -1
 
-
 # success, all done
 status=0
 exit
Index: b/tests/xfs/149
===================================================================
--- a/tests/xfs/149
+++ b/tests/xfs/149
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/150
===================================================================
--- a/tests/xfs/150
+++ b/tests/xfs/150
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/151
===================================================================
--- a/tests/xfs/151
+++ b/tests/xfs/151
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/152
===================================================================
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/153
===================================================================
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/154
===================================================================
--- a/tests/xfs/154
+++ b/tests/xfs/154
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/155
===================================================================
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/156
===================================================================
--- a/tests/xfs/156
+++ b/tests/xfs/156
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/157
===================================================================
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/158
===================================================================
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/159
===================================================================
--- a/tests/xfs/159
+++ b/tests/xfs/159
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/160
===================================================================
--- a/tests/xfs/160
+++ b/tests/xfs/160
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/161
===================================================================
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/162
===================================================================
--- a/tests/xfs/162
+++ b/tests/xfs/162
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/163
===================================================================
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -62,7 +60,6 @@ _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _dmapi_scratch_mount
 
-
 qa_file=$SCRATCH_MNT/dmapi_hole_file
 touch $qa_file
 
Index: b/tests/xfs/164
===================================================================
--- a/tests/xfs/164
+++ b/tests/xfs/164
@@ -30,8 +30,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -53,7 +51,6 @@ _filter_io()
 #
 #   1: [128..199]:      212280..212351    0 (212280..212351)    72 10000
 #  
-#  
 _filter_bmap()
 {
     awk '$3 ~ /hole/ { print $1, $2, $3; next }
@@ -61,7 +58,6 @@ _filter_bmap()
          {print $1, $2}' >> $seqres.full
 }
 
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
Index: b/tests/xfs/165
===================================================================
--- a/tests/xfs/165
+++ b/tests/xfs/165
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -51,7 +49,6 @@ _filter_io()
 # <    1: [8..79]:         6552..6623        0 (6552..6623)        72
 # >    1: [8..79]:         202544..202615    0 (202544..202615)    72
 #
-#
 _filter_bmap()
 {
     awk '$3 ~ /hole/ { print $1, $2, $3; next }
@@ -81,7 +78,6 @@ end=`expr 10 \* $len`
 # write the initial file
 $XFS_IO_PROG -f -c "pwrite 0  ${end}k" $testfile | _filter_io
 
-
 off=0
 while [ $off -le $end ]
 do
Index: b/tests/xfs/166
===================================================================
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/167
===================================================================
--- a/tests/xfs/167
+++ b/tests/xfs/167
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/168
===================================================================
--- a/tests/xfs/168
+++ b/tests/xfs/168
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/170
===================================================================
--- a/tests/xfs/170
+++ b/tests/xfs/170
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/171
===================================================================
--- a/tests/xfs/171
+++ b/tests/xfs/171
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/172
===================================================================
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/173
===================================================================
--- a/tests/xfs/173
+++ b/tests/xfs/173
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/174
===================================================================
--- a/tests/xfs/174
+++ b/tests/xfs/174
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/175
===================================================================
--- a/tests/xfs/175
+++ b/tests/xfs/175
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/176
===================================================================
--- a/tests/xfs/176
+++ b/tests/xfs/176
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/177
===================================================================
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -81,7 +79,6 @@ _scratch_mount "-o dmapi,mtpt=$SCRATCH_M
 echo "Start bulkstat_unlink_test_modified"
 $here/src/bulkstat_unlink_test_modified 10 1000 1 $SCRATCH_MNT/bulkstat
 
-
 # success, all done
 status=0
 exit
Index: b/tests/xfs/178
===================================================================
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/179
===================================================================
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/180
===================================================================
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/181
===================================================================
--- a/tests/xfs/181
+++ b/tests/xfs/181
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 _cleanup()
Index: b/tests/xfs/182
===================================================================
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/183
===================================================================
--- a/tests/xfs/183
+++ b/tests/xfs/183
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/185
===================================================================
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -51,7 +49,6 @@ _require_scratch
 _scratch_mkfs_xfs -b size=512 >/dev/null 2>&1
 _dmapi_scratch_mount
 
-
 cat > $tmp.dmapi-param <<EOF
 # length	offset
   16k		0    # page aligned
Index: b/tests/xfs/186
===================================================================
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -35,8 +35,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -136,7 +134,6 @@ _changeto_attr1()
 	$XFS_DB_PROG -x -c "version attr1" $SCRATCH_DEV | _filter_version
 }
 
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
Index: b/tests/xfs/187
===================================================================
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -29,8 +29,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/188
===================================================================
--- a/tests/xfs/188
+++ b/tests/xfs/188
@@ -31,8 +31,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/189
===================================================================
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -161,7 +159,6 @@ _test_remount_barrier()
 	umount $SCRATCH_MNT
 }
 
-
 #
 # Example fstab entry
 # /dev/sdb2            /mnt/scratch1        xfs       defaults 0 0
Index: b/tests/xfs/190
===================================================================
--- a/tests/xfs/190
+++ b/tests/xfs/190
@@ -36,8 +36,6 @@ filename=test-190
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/191
===================================================================
--- a/tests/xfs/191
+++ b/tests/xfs/191
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/194
===================================================================
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/195
===================================================================
--- a/tests/xfs/195
+++ b/tests/xfs/195
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/196
===================================================================
--- a/tests/xfs/196
+++ b/tests/xfs/196
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/197
===================================================================
--- a/tests/xfs/197
+++ b/tests/xfs/197
@@ -29,8 +29,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/199
===================================================================
--- a/tests/xfs/199
+++ b/tests/xfs/199
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/200
===================================================================
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -121,7 +119,6 @@ blockdev --setrw $SCRATCH_DEV
 echo "mounting filesystem that needs recovery with -o ro:"
 _scratch_mount -o ro 2>&1 | _filter_scratch
 
-
 # success, all done
 echo "*** done"
 rm -f $seqres.full
Index: b/tests/xfs/201
===================================================================
--- a/tests/xfs/201
+++ b/tests/xfs/201
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -43,8 +41,6 @@ do_pwrite()
 	xfs_io -d -f $file -c "pwrite $offset $length" >/dev/null
 }
 
-
-
 _cleanup()
 {
 	umount $SCRATCH_MNT
Index: b/tests/xfs/202
===================================================================
--- a/tests/xfs/202
+++ b/tests/xfs/202
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/203
===================================================================
--- a/tests/xfs/203
+++ b/tests/xfs/203
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/205
===================================================================
--- a/tests/xfs/205
+++ b/tests/xfs/205
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/206
===================================================================
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -29,8 +29,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/216
===================================================================
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/217
===================================================================
--- a/tests/xfs/217
+++ b/tests/xfs/217
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/220
===================================================================
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -68,7 +66,6 @@ xfs_quota -x -c off $SCRATCH_DEV
 # and unmount (this used to crash)
 umount $SCRATCH_DEV
 
-
 # create scratch filesystem
 _scratch_mkfs_xfs >/dev/null 2>&1
 
Index: b/tests/xfs/222
===================================================================
--- a/tests/xfs/222
+++ b/tests/xfs/222
@@ -27,8 +27,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/227
===================================================================
--- a/tests/xfs/227
+++ b/tests/xfs/227
@@ -29,8 +29,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/229
===================================================================
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -30,8 +30,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/238
===================================================================
--- a/tests/xfs/238
+++ b/tests/xfs/238
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/242
===================================================================
--- a/tests/xfs/242
+++ b/tests/xfs/242
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -57,7 +55,6 @@ _test_io_zero()
 
 [ $(_test_io_zero) -eq 0 ] && _notrun "zero command not supported"
 
-
 testfile=$TEST_DIR/242.$$
 
 _test_generic_punch resvsp unresvsp zero 'bmap -p' _filter_bmap $testfile
Index: b/tests/xfs/244
===================================================================
--- a/tests/xfs/244
+++ b/tests/xfs/244
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/250
===================================================================
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/252
===================================================================
--- a/tests/xfs/252
+++ b/tests/xfs/252
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/253
===================================================================
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -34,8 +34,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/259
===================================================================
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=1	# failure is the default!
Index: b/tests/xfs/261
===================================================================
--- a/tests/xfs/261
+++ b/tests/xfs/261
@@ -27,8 +27,6 @@
 
 seq=$(basename $0)
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by ${seq}"
 
 here=$(pwd)
Index: b/tests/xfs/262
===================================================================
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -28,8 +28,6 @@
 
 seq=$(basename $0)
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=$(pwd)
@@ -71,7 +69,6 @@ _supported_os Linux
 _require_quota
 _require_scratch
 
-
 # Make sure the hard limits reported are what was set.
 # It is entirely too clever...
 # It exploits the fact that we've set the soft and hard limits to
Index: b/tests/xfs/266
===================================================================
--- a/tests/xfs/266
+++ b/tests/xfs/266
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/267
===================================================================
--- a/tests/xfs/267
+++ b/tests/xfs/267
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/268
===================================================================
--- a/tests/xfs/268
+++ b/tests/xfs/268
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/278
===================================================================
--- a/tests/xfs/278
+++ b/tests/xfs/278
@@ -5,7 +5,6 @@
 # at the first run. See also commit 198b747f255346bca64408875763b6ca0ed3d57d
 # from xfsprogs tree.
 #
-#
 #-----------------------------------------------------------------------
 # Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
 #
@@ -26,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/279
===================================================================
--- a/tests/xfs/279
+++ b/tests/xfs/279
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/281
===================================================================
--- a/tests/xfs/281
+++ b/tests/xfs/281
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/282
===================================================================
--- a/tests/xfs/282
+++ b/tests/xfs/282
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/283
===================================================================
--- a/tests/xfs/283
+++ b/tests/xfs/283
@@ -26,8 +26,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/287
===================================================================
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 tmp=/tmp/$$
 here=`pwd`
Index: b/tests/xfs/290
===================================================================
--- a/tests/xfs/290
+++ b/tests/xfs/290
@@ -28,8 +28,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/291
===================================================================
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/292
===================================================================
--- a/tests/xfs/292
+++ b/tests/xfs/292
@@ -24,8 +24,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/293
===================================================================
--- a/tests/xfs/293
+++ b/tests/xfs/293
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/295
===================================================================
--- a/tests/xfs/295
+++ b/tests/xfs/295
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/296
===================================================================
--- a/tests/xfs/296
+++ b/tests/xfs/296
@@ -23,8 +23,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
Index: b/tests/xfs/297
===================================================================
--- a/tests/xfs/297
+++ b/tests/xfs/297
@@ -25,8 +25,6 @@
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
-seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
