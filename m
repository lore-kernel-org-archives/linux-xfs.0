Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANJBwHL230664 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 13:11:59 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2510716DDD30
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:11:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QavB28D4JBycdbDk for
	<xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:11:57 -0800 (PST)
Message-ID: <4ECD4579.4080706@redhat.com>
Date: Wed, 23 Nov 2011 13:11:53 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make xattr test 020 generic
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

020 can be made generic by limiting the total attribute space
used in the tests as appropriate.  Unless we know we have a
large-xattr-capable fs, limit total space to a bit under one
fs block.

Now passes for me on ext3, ext4, btrfs, as well as xfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
- ---

incidentally the test used to send a 100k xattr value to
the attr command on xfs; it wrote only 64k but did not complain.
Feature or bug?

diff --git a/020 b/020
index 56b9c3c..d196318 100755
- --- a/020
+++ b/020
@@ -80,7 +80,7 @@ _attr_list()
 
 
 # real QA test starts here
- -_supported_fs xfs udf
+_supported_fs generic
 _supported_os Linux
 
 _require_attrs
@@ -119,9 +119,19 @@ _attr_list $testfile
 
 echo "*** add lots of attributes"
 v=0
- -while [ $v -lt 1000 ]
+
+# set maximum total attr space based on fs type
+if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
+	NUMATTRS=1000
+else # Assume max ~1 block of attrs
+	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
+	let NUMATTRS=$BLOCK_SIZE/40
+fi
+
+while [ $v -lt $NUMATTRS ]
 do
- -    echo "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
+    echo -n "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
     if [ $? -ne 0 ]
     then
         echo "!!! failed to add \"attribute_$v\""
@@ -139,11 +149,12 @@ getfattr --absolute-names $testfile \
     	/^#/ { next }
 	/^[ 	]*$/ { next }
         { l++ } 
- -	END {print "   *** " (l - 1) " attribute(s)" }'
+	END {print "   *** " (l - 1) " attribute(s)" }' \
+    | sed s/$NUMATTRS/NUMATTRS/
 
 echo "*** remove lots of attributes"
 v=0
- -while [ $v -lt 1000 ]
+while [ $v -lt $NUMATTRS ]
 do
     if ! $ATTR_PROG -r "attribute_$v" $testfile >>$seq.full
     then
@@ -156,11 +167,21 @@ done
 
 _attr_list $testfile
 
+# Set max attr vlue size based on fs type
+if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
+	ATTRVAL_SIZE=64
+else # Assume max ~1 block of attrs
+	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	# leave a little overhead
+	let ATTRVAL_SIZE=$BLOCK_SIZE-256
+fi
+
 echo "*** really long value"
- -dd if=/dev/zero bs=1024 count=100 2>/dev/null \
+dd if=/dev/zero bs=1 count=$ATTRVAL_SIZE 2>/dev/null \
     | _attr -s "long_attr" $testfile >/dev/null
- -    
- -_attr -g "long_attr" $testfile | tail -n +2 | od -t x1
+
+OCTAL_SIZE=`echo "obase=8; $ATTRVAL_SIZE" | bc` 
+_attr -q -g "long_attr" $testfile | od -t x1 | sed -e "s/^0*$OCTAL_SIZE$/ATTRSIZE/"
 _attr -r "long_attr" $testfile >/dev/null
 
 
diff --git a/020.out b/020.out
index 3e444be..b303200 100644
- --- a/020.out
+++ b/020.out
@@ -40,7 +40,7 @@ user.snrub="fish2\012"
 
 *** add lots of attributes
 *** check
- -   *** 1000 attribute(s)
+   *** NUMATTRS attribute(s)
 *** remove lots of attributes
    *** print attributes
 # file: <TESTFILE>
@@ -49,8 +49,7 @@ user.snrub="fish2\012"
 *** really long value
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
- -0200000 0a
- -0200001
+ATTRSIZE
 *** set/get/remove really long names (expect failure)
 attr_set: Invalid argument
 Could not set "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" for <TESTFILE>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzUV4AAoJECCuFpLhPd7gZ6QP/39tqAYI/Luh4s8YaMADgop0
w/zH6swZDZni2/iBgBbfvx4Gg+UEYYVZ3CnJ6Q5LnIUbD/L5/IXNDxmxmin4782C
M8Hdl1Tjy/tQDu/AtIPI7e9FOAxCJVO781ArO9BXwgtPEk8CJVZFOnQ1ZZkpyI0T
JVKS+I/iuDxX97kYLCCwLkk8tVPzr8X61nymrwSkf/YMxlcMXrVuGbr1Usoac97o
QyRy53ivePGdW62eRVpUSHNU7jm1SaCAWX6OrnC31EzRwUdpeO8yHiVEFhI0he3x
g1ODe/fxCoXbT+EkmEAWbBx6TvyscgOTWcQ7tGWmcNkjP2xN7jVde7NJDrRWAS2C
aFzC3qbtl6Bw9AMX3roglxWFbFsheggtspDiO/El4Vx/zEbdMEFvrAP51rtRqFha
VK6W98FweFY1Zb73ZRqR7EozFN86JXroEIPnvLlqoxcRF2M0iRerZuf/8CWE/rqb
LAwfmZbDmXlPpK+lskbS3LJnMJZ6LaDnx64z0EUQFRT3jmSRKV949E2/V/mtx/t4
Fj9ECrGbD+f7fBe7kqdkb6RdtCDCU4ZdD20G++n7+Uiype82cUrPnrPBxDrDOD3Q
BQRYCsBsRIyVXrcLsZ0YicAPAPJGa8bxd0Hg2ZI4WTnBEpQhuvXdk69IHBMX3NFN
aMIIVDdshJ+bPCC/0jor
=A/u5
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
