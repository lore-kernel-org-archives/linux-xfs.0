Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B590B7CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 10:59:50 -0500 (CDT)
Message-ID: <5149DD16.7060006@sgi.com>
Date: Wed, 20 Mar 2013 11:00:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Count journal size in test 289
References: <1363776648-14061-1-git-send-email-jack@suse.cz>
In-Reply-To: <1363776648-14061-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Thanks Jan for submitting this patch, it has been committed with Eric 
suggestions.

Thanks
--Rich

commit 3574531af49bdde338aff0131100852e87e9d0fd
Author: Jan Kara <jack@suse.cz>
Date:   Wed Mar 20 10:50:48 2013 +0000

     xfstests: count journal size in test 289

     Test 289 ignored the fact that historically journal is not accounted as
     fs overhead in ext3. For larger filesystems it is hidden in 1% 
tolerance
     but for filesystems smaller than 12G the test fails. So make the
     counting precise to work everywhere.

     CC: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Jan Kara <jack@suse.cz>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     [rjohnston@sgi.com: add lower case units to filter]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

+	read size
diff --git a/289 b/289
index b057c20..eb5c63b 100755
--- a/289
+++ b/289
@@ -59,10 +59,18 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
  FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
  		| awk '/Free blocks:/{print $3}'`

-# nb: kernels today don't count journal blocks  as overhead, but should.
-# For most filesystems this will still be within tolerance.
-# Overhead is all the blocks (already) used by the fs itself:
-OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
+# ext3 doesn't count journal blocks as overhead, ext4 does.
+if [ $FSTYP = "ext3" ]; then
+	JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
+	BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Block size:/{print $3}'`
+	JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
+else
+	JOURNAL_BLOCKS=0
+fi
+
+OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))

  #  bsddf|minixdf
  #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
diff --git a/common.filter b/common.filter
index da5675f..bdd6427 100644
--- a/common.filter
+++ b/common.filter
@@ -265,5 +265,20 @@ _filter_size()
  	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][b]\?/<SIZE>/ig"
  }

+# Convert string read from stdin like 128K to bytes and print it to stdout
+_filter_size_to_bytes()
+{
+	read size
+	suffix=${size:${#size}-1}
+	mul=1
+	case $suffix in
+		k|K) mul=1024 ;;
+		m|M) mul=$((1024*1024)) ;;
+		g|G) mul=$((1024*1024*1024)) ;;
+		t|T) mul=$((1024*1024*1024*1024)) ;;
+	esac
+	echo $((${size:0:${#size}-1}*$mul))
+}
+
  # make sure this script returns success
  /bin/true

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
