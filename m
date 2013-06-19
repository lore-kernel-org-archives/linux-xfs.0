Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC12B7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:44:36 -0500 (CDT)
Date: Wed, 19 Jun 2013 17:44:36 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [RFC PATCH 1/3] xfstests: get some basic source tree info
Message-ID: <20130619224436.GU20932@sgi.com>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
	<1371675639.22504.63.camel@chandra-dt.ibm.com>
	<20130619223750.GT20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619223750.GT20932@sgi.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

Grab some basic information about the souce trees being tested and save
it off for later.  This includes information about the git commit and
any patches which are applied.

Set SRCDIRS environment variable with paths to the sources you're
testing, colon delimited like PATH. 

e.g.

export SRCDIRS="/path/to/kernel:/path/to/xfsprogs:/path/to/xfsdump:/path/to/xfstests"

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 check     |    4 ++++
 common.rc |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

Index: xfstests/check
===================================================================
--- xfstests.orig/check
+++ xfstests/check
@@ -316,6 +316,7 @@ END	{ if (NR > 0) {
 
 	echo "" >>$check.log
 	date >>$check.log
+	cat /tmp/check.desc >>$check.log
 	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>$check.log
 	$interrupt && echo "Interrupted!" >>$check.log
         
@@ -363,6 +364,9 @@ rm -f $check.full
 
 [ -f $check.time ] || touch $check.time
 
+_full_source_details > /tmp/check.desc
+cat /tmp/check.desc
+
 # print out our test configuration
 echo "FSTYP         -- `_full_fstyp_details`"
 echo "PLATFORM      -- `_full_platform_details`"
Index: xfstests/common/rc
===================================================================
--- xfstests.orig/common/rc
+++ xfstests/common/rc
@@ -1738,6 +1738,48 @@ _full_platform_details()
      echo "$os/$platform $host $kernel"
 }
 
+_full_source_details()
+{
+    if [ -z $SRCDIRS ]; then
+        return
+    fi
+
+    echo "SRCDIRS       -- $SRCDIRS"
+
+    dirs=$(echo $SRCDIRS | tr ":" "\n")
+    for dir in $dirs
+    do
+        echo "    $dir:"
+        if [ -d $dir/.git ]; then
+            # git url, branch, and description
+            url=$(cd $dir; git remote show origin | grep 'Fetch URL' | awk '{print $3}')
+            echo -e "\tURL           -- $url"
+            branch=$(cd $dir; git symbolic-ref HEAD)
+            echo -e "\tBRANCH        -- $branch"
+            desc=$(cd $dir; git describe)
+            echo -e "\tDESC          -- $desc"
+        fi
+
+        if [ -d $dir/patches ]; then
+            # quilt patches which are applied
+            echo -e "\tPATCHES:"
+            for p in $(cd $dir; quilt applied 2> /dev/null)
+            do
+                p=${p##patches/}
+                md5=$(md5sum $dir/patches/$p)
+                md5_checksum=${md5%% *}
+                patch_fn=${md5##* }
+                patchworkid=$(egrep -i '^X-Patchwork-Id:' $dir/patches/$p)
+                messageid=$(egrep -i '^Message-Id:' $dir/patches/$p)
+                echo -e "\t\t$patch_fn"
+                echo -e "\t\tmd5sum:\t\t$md5_checksum"
+                echo -e "\t\tX-Patchwork-Id:\t${patchworkid##* }"
+                echo -e "\t\tMessage-Id:\t${messageid##* }"
+            done
+        fi
+    done
+}
+
 _setup_udf_scratchdir()
 {
     [ "$FSTYP" != "udf" ] \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
