Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B16E97F53
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 21:39:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 898EC304039
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:39:59 -0700 (PDT)
Received: from mail-we0-f182.google.com (mail-we0-f182.google.com
	[74.125.82.182]) by cuda.sgi.com with ESMTP id 6vcvEzlFGJUeXIVz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:39:58 -0700 (PDT)
Received: by mail-we0-f182.google.com with SMTP id p61so1154269wes.13
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:39:56 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs/004, fix failure with inlined file extents
Date: Fri, 18 Apr 2014 04:39:46 +0100
Message-Id: <1397792386-18316-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Files that consist of an inline extent, have the corresponding
data in the filesystem btree and not on a dedicated extent. For
such extents filefrag (fiemap) will report a physical location
of 0 for that extent and set the 'inline' flag.

The btrfs inspect-internal logical-resolve command will cause a
lookup in the extent tree for the extent address we give it as
an argument, which fails with errno ENOENT if it is 0.

This error didn't happen always, as the test uses fsstress to
generate a random filesystem, which needed to generate at least
one file that could be inlined (content less than 4018 bytes).

Example, taken from results/btrfs/004.full:

   # filefrag -v /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1
   Filesystem type is: 9123683e
   File size of /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1 is 3860 (1 block of 4096 bytes)
    ext:     logical_offset:        physical_offset: length:   expected: flags:
      0:        0..    4095:          0..      4095:   4096:             not_aligned,inline,eof
      1:      280..     344:      35190..     35254:     65:          1: eof
   /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1: 2 extents found
   after filter: 0#0#0 0#0#0
   # stat -c %i /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1
   403
   # /home/fdmanana/git/hub/btrfs-progs/btrfs inspect-internal logical-resolve -P 0 /home/fdmanana/btrfs-tests/scratch_1
   ioctl ret=-1, error: No such file or directory

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/004 | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 670e1c2..1d5b816 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -65,9 +65,11 @@ FILEFRAG_FILTER='
 	($ext, $logical, $physical, $length) =
 		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
 	or next;
+	($flags) = /.*:\s*(\S*)$/;
 	print $physical * $blocksize, "#",
 	      $length * $blocksize, "#",
-	      $logical * $blocksize, " "'
+	      $logical * $blocksize, "#",
+	      $flags, " "'
 
 # this makes filefrag output script readable by using a perl helper.
 # output is one extent per line, with three numbers separated by '#'
@@ -230,16 +232,26 @@ workout()
 			continue;
 		fi
 		for i in $extents; do
-			physical=$i
-			length=$i
-			logical=$i
-			physical=`echo $physical | sed -e 's/#.*//'`
-			length=`echo $length | sed -e 's/[^#]+#//'`
-			length=`echo $length | sed -e 's/#.*//'`
-			logical=`echo $logical | sed -e 's/.*#//'`
-			_btrfs_inspect_check $file $physical $length $logical \
-						$snap_name
-			ret=$?
+			physical=`echo $i | cut -d '#' -f 1`
+			length=`echo $i | cut -d '#' -f 2`
+			logical=`echo $i | cut -d '#' -f 3`
+			flags=`echo $i | cut -d '#' -f 4`
+			# Skip inline extents, otherwise btrfs inspect-internal
+			# logical-resolve will fail (with errno ENOENT), as it
+			# can't find an extent with a start address of 0 in the
+			# extent tree.
+			if [ $physical -eq 0 ]; then
+				echo "$flags" | grep -E '(^|,)inline(,|$)' \
+					> /dev/null
+				ret=$?
+				if [ $ret -ne 0 ]; then
+					echo "Unexpected physical address 0 for non-inline extent, file $file, flags $flags"
+				fi
+			else
+				_btrfs_inspect_check $file $physical $length \
+					$logical $snap_name
+				ret=$?
+			fi
 			if [ $ret -ne 0 ]; then
 				errcnt=`expr $errcnt + 1`
 			fi
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
