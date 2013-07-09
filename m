Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DA257F37
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 06:05:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EA71304043
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 04:05:35 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id yVGa1kAVARmcQMrm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 04:05:33 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] large-fs: improve space diversification for ext4
Date: Tue,  9 Jul 2013 15:05:16 +0400
Message-Id: <1373367918-7516-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

Currently we allocated several giant files one by one until limit,
so empty space is located as one chunk which limit code-path coverage.
This patch consume all space with NUM_SPACE_FILES files (by default 1024)
each has same size, and when truncate each one by required delta.
As result we have $NUM_SPACE_FILES chunks of free blocks distributed
across whole filesystem.
This should help us to avoid regressions similar to e7c9e3e99adf6c49

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/rc |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/common/rc b/common/rc
index c44acea..902fc19 100644
--- a/common/rc
+++ b/common/rc
@@ -440,12 +440,17 @@ _setup_large_ext4_fs()
 	fs_empty_space=$((50*1024*1024*1024))
 
 	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
+	[ -z "$NUM_SPACE_FILES" ] && export NUM_SPACE_FILES=1024
 	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0	
 	fs_empty_space=$((fs_empty_space + $SCRATCH_DEV_EMPTY_SPACE))
 	[ $fs_empty_space -ge $fs_size ] && return 0
 
 	# calculate the size of the file we need to allocate.
+
 	space_to_consume=$(($fs_size - $fs_empty_space))
+	file_size_falloc=$(($fs_size/$NUM_SPACE_FILES))
+	file_size_final=$(($space_to_consume/$NUM_SPACE_FILES))
+
 	# mount the filesystem and create 16TB - 4KB files until we consume
 	# all the necessary space.
 	_scratch_mount 2>&1 >$tmp_dir/mnt.err
@@ -457,33 +462,20 @@ _setup_large_ext4_fs()
 		return $status
 	fi
 	rm -f $tmp_dir/mnt.err
-
-	file_size=$((16*1024*1024*1024*1024 - 4096))
-	nfiles=0
-	while [ $space_to_consume -gt $file_size ]; do
-
+	mkdir $SCRATCH_MNT/.use_space
+	# Consume all space on filesytem
+	for ((nfiles = 0; nfiles < nfiles_total; nfiles++)); do 
 		xfs_io -F -f \
-			-c "truncate $file_size" \
-			-c "falloc -k 0 $file_size" \
-			$SCRATCH_MNT/.use_space.$nfiles 2>&1
-		status=$?
-		if [ $status -ne 0 ]; then
-			break;
-		fi
-
-		space_to_consume=$(( $space_to_consume - $file_size ))
-		nfiles=$(($nfiles + 1))
+			-c "truncate $file_size_falloc" \
+			-c "falloc -k 0 $file_size_falloc" \
+			$SCRATCH_MNT/.use_space/use_space.$nfiles 2>&1
 	done
-
-	# consume the remaining space.
-	if [ $space_to_consume -gt 0 ]; then
+	# Truncate files to smaller size, will free chunks of space
+	for ((nfiles = 0; nfiles < nfiles_total; nfiles++)); do 
 		xfs_io -F -f \
-			-c "truncate $space_to_consume" \
-			-c "falloc -k 0 $space_to_consume" \
-			$SCRATCH_MNT/.use_space.$nfiles 2>&1
-		status=$?
-	fi
-	export NUM_SPACE_FILES=$nfiles
+			-c "truncate $file_size_final" \
+			$SCRATCH_MNT/.use_space/use_space.$nfiles 2>&1
+	done
 
 	umount $SCRATCH_MNT
 	if [ $status -ne 0 ]; then
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
