Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LLfPfd177932 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 16:41:25 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfstests: 253: test the metadump functionality of xfs_db
Date: Thu, 21 Apr 2011 16:44:45 -0500
Message-Id: <01d934eed0de0a992f3f8d6d609fa32d7e966b04.1303422281.git.aelder@sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0480451347080536659=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

--===============0480451347080536659==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch creates a test that exercises xfs_metadump, with a focus
on its obfuscation of names.  It was created to verify fixes that
avoided a hang condition when running "xfs_metadump" on a directory
containing files having particular bit patterns in their name.
Arkadiusz Mi√Ö¬õkiewicz first reported seeing this while attempting
to create a metadump for a filesystem containing a file named
"R\323\257NE".

For now this script checks the following (using only filenames, not
attributes):
- that short names (4 characters or less) aren't obfuscated
- that long names get obfuscated
- that (long) directory names get obfuscated
- that names that are known to produce bit patterns that lead
  to invalid path components still generate obfuscated names
  (this could previously lead to a hang)
- that many names of the same length can still generate new
  obfuscated names (this could previously lead to a hang)
- that neither "lost+found" nor orphaned files stored in it ge
  obfuscated

Right now there are two sets of "ls" commands executed (one before
and one after obfuscation).  This produces repeatable results for
me on one filesystem, but on a different filesystem I expect the
inode numbers to change (and random number generation might change
the output too).  I'm interested in suggestions on how to filter
the output so the results can be verified.  If nothing else, the
test serves its purpose if I simply comment out those commands,
and will do that if there's not a better suggstion.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 253     |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 253.out |  145 +++++++++++++++++++++++++++++++++++++++++++++++
 group   |    1 +
 3 files changed, 338 insertions(+), 0 deletions(-)
 create mode 100755 253
 create mode 100644 253.out

diff --git a/253 b/253
new file mode 100755
index 0000000..45e0525
--- /dev/null
+++ b/253
@@ -0,0 +1,192 @@
+#! /bin/bash
+# FS QA Test No. 253
+#
+# Test xfs_db metadump functionality.
+#
+# This test was created to verify fixes for problems where metadump
+# would never complete due to an inability to find a suitable
+# obfuscated name to use.  It also verifies a few other things,
+# including ensuring the "lost+found" directory and orphaned files
+# in it do not get obfuscated.
+#
+# This test also creates a number of files that are effectively
+# duplicates of existing files; this can happen in certain rare
+# instances where the obfuscation process has produced a filename
+# that is already in use (and no other name is available to use).
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 SGI.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+# creator
+owner=aelder@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    rm -rf "${OUTPUT_DIR}"
+    rm -f "${METADUMP_FILE}"
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_require_scratch
+
+# real QA test starts here
+
+OUTPUT_DIR="${SCRATCH_MNT}/test_${seq}"
+METADUMP_FILE="${TEST_MNT}/${seq}_metadump"
+ORPHANAGE="lost+found"
+
+_supported_fs xfs
+_supported_os Linux
+
+function create_file() {
+	[ $# -eq 1 ] ||		return 1
+	touch $(printf "$@")
+}
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Initialize and mount the scratch filesystem, then create a bunch
+# of files that exercise the original problem.
+#
+# The problem arose when a file name produced a hash that contained
+# either 0x00 (string terminator) or 0x27 ('/' character) in a
+# spot used to determine a character in an obfuscated name.  This
+# occurred in one of 5 spots at the end of the name, at position
+# (last-4), (last-3), (last-2), (last-1), or (last).
+
+rm -f "${METADUMP_FILE}"
+
+mkdir -p "${OUTPUT_DIR}"
+
+cd "${OUTPUT_DIR}"
+# Start out with some basic test files
+create_file 'abcde'		# hash 0x1c58f263 ("normal" name)
+
+create_file 'f'			# hash 0x00000066 (1-byte name)
+create_file 'gh'		# hash 0x000033e8 (2-byte name)
+create_file 'ijk'		# hash 0x001a756b (3-byte name)
+create_file 'lmno'		# hash 0x0d9b776f (4-byte name)
+create_file 'pqrstu'		# hash 0x1e5cf9f2 (6-byte name)
+create_file 'abcdefghijklmnopqrstuvwxyz' # a most remarkable word (0x55004ae3)
+
+# Create a short directory name; it won't be obfuscated.  Populate
+# it with some longer named-files.  The first part of the obfuscated
+# filenames should use printable characters.
+mkdir foo
+create_file 'foo/longer_file_name_1'	# hash 0xe83634ec
+create_file 'foo/longer_file_name_2'	# hash 0xe83634ef
+create_file 'foo/longer_file_name_3'	# hash 0xe83634ee
+
+# Now create a longer directory name
+mkdir longer_directory_name
+create_file 'longer_directory_name/f1'	# directory hash 0x9c7accdd
+create_file 'longer_directory_name/f2'	# filenames are short, no hash
+create_file 'longer_directory_name/f3'
+
+# The problematic name originally reported by Arkadiusz Mi≈õkiewicz
+
+create_file 'R\323\257NE'	# hash 0x3a4be740, forces  (last-3) = 0x2f
+
+# Other names that force a 0x00 byte
+create_file 'Pbcde'		# hash 0x0c58f260, forces  (last-4) = 0x00
+create_file 'a\001\203de'	# hash 0x1000f263, forces  (last-3) = 0x00
+create_file 'ab\001\344e'	# hash 0x1c403263, forces  (last-2) = 0x00
+create_file 'abc\200e'		# hash 0x1c588063, forces  (last-1) = 0x00
+create_file 'abcd\006'		# hash 0x1c58f200, forces    (last) = 0x00
+
+# Names that force a 0x2f byte; note no name will ever force (last-4) = 0x2f
+create_file 'a.\343de'		# hash 0x15f8f263 forces   (last-3) = 0x00
+create_file 'ac\257de'		# hash 0x1c4bf263, forces  (last-2) = 0x2f
+create_file 'abe\257e'		# hash 0x1c5917e3, forces  (last-1) = 0x2f
+create_file 'abcd)'		# hash 0x1c58f22f, forces    (last) = 0x2f
+
+# The following names are possible results of obfuscating the name
+# "abcde".  Previously, xfs_metadump could get hung up trying to
+# obfuscate names when too many of the same length had the same hash
+# value.
+create_file '!bcda'		# essentially a dup of 'abcde'
+create_file 'Abcdg'		# essentially a dup of 'abcde'
+create_file 'qbcdd'		# essentially a dup of 'abcde'
+create_file '1bcd`'		# essentially a dup of 'abcde'
+create_file 'Qbcdf'		# essentially a dup of 'abcde'
+create_file '\001bcdc'		# essentially a dup of 'abcde'
+create_file 'Qbce\346'		# essentially a dup of 'abcde'
+create_file 'abb\344e'		# essentially a dup of 'abcde'
+
+# The orphanage directory (lost+found) should not be obfuscated.
+# Files thereunder can be, but not if their name is the same as
+# their inode number.  Test this.
+
+cd "${SCRATCH_MNT}"
+mkdir -p "${ORPHANAGE}"
+
+TEMP_ORPHAN="${ORPHANAGE}/__orphan__"
+NON_ORPHAN="${ORPHANAGE}/__should_be_obfuscated__"
+
+# Create an orphan, whose name is the same as its inode number
+touch "${TEMP_ORPHAN}"
+INUM=$(ls -i "${TEMP_ORPHAN}" | awk '{ print $1; }')
+ORPHAN="${SCRATCH_MNT}/lost+found/${INUM}"
+mv "${TEMP_ORPHAN}" "${ORPHAN}"
+
+# Create non-orphan, which *should* be obfuscated
+touch "${NON_ORPHAN}"
+
+# Get a listing of all the files before obfuscation
+ls -R
+ls -R | od -c
+
+# Now unmount the filesystem and create a metadump file
+cd /; sync; sync		# Old school
+
+_scratch_unmount
+
+xfs_metadump -f "${SCRATCH_DEV}" "${METADUMP_FILE}"
+
+# Now restore the obfuscated one back and take a look around
+xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
+
+_scratch_mount
+
+# Get a listing of all the files after obfuscation
+cd "${SCRATCH_MNT}"
+ls -R
+ls -R | od -c
+
+# Finally, re-make the filesystem since to ensure we don't
+# leave a directory with duplicate entries lying around.
+cd /
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+
+# all done
+status=0
+exit
diff --git a/253.out b/253.out
new file mode 100644
index 0000000..685c042
--- /dev/null
+++ b/253.out
@@ -0,0 +1,145 @@
+QA output created by 253
+.:
+lost+found
+test_253
+
+./lost+found:
+201326721
+__should_be_obfuscated__
+
+./test_253:
+bcdc
+!bcda
+1bcd`
+Abcdg
+Pbcde
+Qbcdf
+QbceÊ
+R”ØNE
+aÉde
+a.„de
+ab‰e
+abb‰e
+abcd
+abcd)
+abcde
+abcdefghijklmnopqrstuvwxyz
+abcÄe
+abeØe
+acØde
+f
+foo
+gh
+ijk
+lmno
+longer_directory_name
+pqrstu
+qbcdd
+
+./test_253/foo:
+longer_file_name_1
+longer_file_name_2
+longer_file_name_3
+
+./test_253/longer_directory_name:
+f1
+f2
+f3
+0000000   .   :  \n   l   o   s   t   +   f   o   u   n   d  \n   t   e
+0000020   s   t   _   2   5   3  \n  \n   .   /   l   o   s   t   +   f
+0000040   o   u   n   d   :  \n   2   0   1   3   2   6   7   2   1  \n
+0000060   _   _   s   h   o   u   l   d   _   b   e   _   o   b   f   u
+0000100   s   c   a   t   e   d   _   _  \n  \n   .   /   t   e   s   t
+0000120   _   2   5   3   :  \n 001   b   c   d   c  \n   !   b   c   d
+0000140   a  \n   1   b   c   d   `  \n   A   b   c   d   g  \n   P   b
+0000160   c   d   e  \n   Q   b   c   d   f  \n   Q   b   c   e 346  \n
+0000200   R 323 257   N   E  \n   a 001 203   d   e  \n   a   . 343   d
+0000220   e  \n   a   b 001 344   e  \n   a   b   b 344   e  \n   a   b
+0000240   c   d 006  \n   a   b   c   d   )  \n   a   b   c   d   e  \n
+0000260   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p
+0000300   q   r   s   t   u   v   w   x   y   z  \n   a   b   c 200   e
+0000320  \n   a   b   e 257   e  \n   a   c 257   d   e  \n   f  \n   f
+0000340   o   o  \n   g   h  \n   i   j   k  \n   l   m   n   o  \n   l
+0000360   o   n   g   e   r   _   d   i   r   e   c   t   o   r   y   _
+0000400   n   a   m   e  \n   p   q   r   s   t   u  \n   q   b   c   d
+0000420   d  \n  \n   .   /   t   e   s   t   _   2   5   3   /   f   o
+0000440   o   :  \n   l   o   n   g   e   r   _   f   i   l   e   _   n
+0000460   a   m   e   _   1  \n   l   o   n   g   e   r   _   f   i   l
+0000500   e   _   n   a   m   e   _   2  \n   l   o   n   g   e   r   _
+0000520   f   i   l   e   _   n   a   m   e   _   3  \n  \n   .   /   t
+0000540   e   s   t   _   2   5   3   /   l   o   n   g   e   r   _   d
+0000560   i   r   e   c   t   o   r   y   _   n   a   m   e   :  \n   f
+0000600   1  \n   f   2  \n   f   3  \n
+0000610
+.:
+lost+found
+nGp^`%,
+
+./lost+found:
+201326721
+P4cqsw77yv8UsYbcCa-!i7
+
+./nGp^`%,:
+Édc
+.„dc
+b‰c
+b.‰c
+bb„
+bcdc
+bce„
+bd.„
+‚cd`
+R.Œ@
+bcd
+bcd.
+!bcda
+Abcdg
+AbceÁ
+R_KspN6ry7jG8CU4bonN2ovd
+aujzfJamyN3xYjal:X|
+f
+foo
+gh
+ijk
+lmno
+zrst"
+Åbcdk
+ÅbceÎ
+¡bcdo
+¡bceÔ
+
+./nGp^`%,/aujzfJamyN3xYjal:X|:
+f1
+f2
+f3
+
+./nGp^`%,/foo:
+UROC0Bh9cHwp-qI{
+dFXYpeUryNGb0	a7
+hBh8n-B-XqcrW
{-KY
+0000000   .   :  \n   l   o   s   t   +   f   o   u   n   d  \n   n   G
+0000020   p 004   ^   `   %   ,  \n  \n   .   /   l   o   s   t   +   f
+0000040   o   u   n   d   :  \n   2   0   1   3   2   6   7   2   1  \n
+0000060   P   4   c   q   s   w   7   7   y   v   8   U   s   Y   b   c
+0000100   C   a   -  \v 031   !   i   7  \n  \n   .   /   n   G   p 004
+0000120   ^   `   %   ,   :  \n 001 001 203   d   c  \n 001   . 343   d
+0000140   c  \n 001   b 001 344   c  \n 001   b   . 344   c  \n 001   b
+0000160   b 001 343  \n 001   b   c   d   c  \n 001   b   c   e 343  \n
+0000200 001   b   d   . 343  \n 001 342   c   d   `  \n 003   R   . 316
+0000220   @  \n 021   b   c   d 001  \n 021   b   c   d   .  \n   !   b
+0000240   c   d   a  \n   A   b   c   d   g  \n   A   b   c   e 347  \n
+0000260   R   _   K   s   p   N   6   r   y   7   j   G   8   C   U   4
+0000300   b   o   n   N   2  \b   o   v   d 024  \n   a   u   j   z   f
+0000320   J   a   m   y   N   3   x   Y   j   a   l 001   :   X 030   |
+0000340  \n   f  \n   f   o   o  \n   g   h  \n   i   j   k  \n   l   m
+0000360   n   o  \n   z 001   r   s   t   "  \n 201   b   c   d   k  \n
+0000400 201   b   c   e 353  \n 301   b   c   d   o  \n 301   b   c   e
+0000420 357  \n  \n   .   /   n   G   p 004   ^   `   %   ,   /   a   u
+0000440   j   z   f   J   a   m   y   N   3   x   Y   j   a   l 001   :
+0000460   X 030   |   :  \n   f   1  \n   f   2  \n   f   3  \n  \n   .
+0000500   /   n   G   p 004   ^   `   %   ,   /   f   o   o   :  \n   U
+0000520   R   O   C   0   B   h   9   c   H   w   p   -  \b   q 031   I
+0000540   {  \n   d   F   X   Y   p   e   U   r   y   N   G   b   0  \t
+0000560 025 026   a   7  \n   h   B   h   8   n   -   B   -   X   q   c
+0000600   r   W  \r   {   -   K   Y  \n
+0000610
diff --git a/group b/group
index 2ee921f..9f88e75 100644
--- a/group
+++ b/group
@@ -366,3 +366,4 @@ deprecated
 250 auto quick rw prealloc metadata
 251 ioctl trim
 252 auto quick prealloc
+253 auto quick
-- 
1.7.4.4


--===============0480451347080536659==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0480451347080536659==--
