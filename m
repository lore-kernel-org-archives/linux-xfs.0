Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RIYVcx225080 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 12:34:31 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 0HOGXblorpqUJrgB for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 10:34:29 -0800 (PST)
Message-ID: <4F22EE37.6080306@sandeen.net>
Date: Fri, 27 Jan 2012 12:34:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: 020: make this xattr test generic
References: <4ECD4579.4080706@redhat.com>
	<20111128110158.GB13766@infradead.org>
In-Reply-To: <20111128110158.GB13766@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

020 can be made generic by limiting the total attribute space
used in the tests as appropriate.  Unless we know we have a
large-xattr-capable fs, limit total space to a bit under one
fs block.

Now passes for me on ext3, ext4, btrfs, as well as xfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Move max attr definitions to common.attr, and change
their names a bit.

diff --git a/020 b/020
index 56b9c3c..8b8db30 100755
--- a/020
+++ b/020
@@ -80,7 +80,7 @@ _attr_list()
 
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os Linux
 
 _require_attrs
@@ -119,9 +119,10 @@ _attr_list $testfile
 
 echo "*** add lots of attributes"
 v=0
-while [ $v -lt 1000 ]
+
+while [ $v -lt $MAX_ATTRS ]
 do
-    echo "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
+    echo -n "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
     if [ $? -ne 0 ]
     then
         echo "!!! failed to add \"attribute_$v\""
@@ -139,11 +140,12 @@ getfattr --absolute-names $testfile \
     	/^#/ { next }
 	/^[ 	]*$/ { next }
         { l++ } 
-	END {print "   *** " (l - 1) " attribute(s)" }'
+	END {print "   *** " (l - 1) " attribute(s)" }' \
+    | sed s/$MAX_ATTRS/MAX_ATTRS/
 
 echo "*** remove lots of attributes"
 v=0
-while [ $v -lt 1000 ]
+while [ $v -lt $MAX_ATTRS ]
 do
     if ! $ATTR_PROG -r "attribute_$v" $testfile >>$seq.full
     then
@@ -157,10 +159,11 @@ done
 _attr_list $testfile
 
 echo "*** really long value"
-dd if=/dev/zero bs=1024 count=100 2>/dev/null \
+dd if=/dev/zero bs=1 count=$MAX_ATTRVAL_SIZE 2>/dev/null \
     | _attr -s "long_attr" $testfile >/dev/null
-    
-_attr -g "long_attr" $testfile | tail -n +2 | od -t x1
+
+OCTAL_SIZE=`echo "obase=8; $MAX_ATTRVAL_SIZE" | bc`
+_attr -q -g "long_attr" $testfile | od -t x1 | sed -e "s/^0*$OCTAL_SIZE$/ATTRSIZE/"    
 _attr -r "long_attr" $testfile >/dev/null
 
 
diff --git a/020.out b/020.out
index 3e444be..7e3e65b 100644
--- a/020.out
+++ b/020.out
@@ -40,7 +40,7 @@ user.snrub="fish2\012"
 
 *** add lots of attributes
 *** check
-   *** 1000 attribute(s)
+   *** MAX_ATTRS attribute(s)
 *** remove lots of attributes
    *** print attributes
 # file: <TESTFILE>
@@ -49,8 +49,7 @@ user.snrub="fish2\012"
 *** really long value
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0200000 0a
-0200001
+ATTRSIZE
 *** set/get/remove really long names (expect failure)
 attr_set: Invalid argument
 Could not set "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" for <TESTFILE>
diff --git a/common.attr b/common.attr
index 37d0927..3e2ba85 100644
--- a/common.attr
+++ b/common.attr
@@ -176,5 +176,26 @@ _require_attrs()
     rm -f $TEST_DIR/syscalltest.out
 }
 
+# set maximum total attr space based on fs type
+if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
+	MAX_ATTRS=1000
+else # Assume max ~1 block of attrs
+	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
+	let MAX_ATTRS=$BLOCK_SIZE/40
+fi
+
+export MAX_ATTRS
+
+# Set max attr value size based on fs type
+if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
+	MAX_ATTRVAL_SIZE=64
+else # Assume max ~1 block of attrs
+	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	# leave a little overhead
+	let MAX_ATTRVAL_SIZE=$BLOCK_SIZE-256
+fi
+
+export MAX_ATTRVAL_SIZE
 # make sure this script returns success
 /bin/true

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
