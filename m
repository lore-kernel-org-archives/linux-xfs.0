Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4N76iVr248994 for <xfs@oss.sgi.com>; Mon, 23 May 2011 02:06:44 -0500
Received: from mail-pv0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 226081ECAE3D
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 00:06:42 -0700 (PDT)
Received: from mail-pv0-f181.google.com (mail-pv0-f181.google.com
	[74.125.83.181]) by cuda.sgi.com with ESMTP id G11y0385qYVNh7O6
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 00:06:42 -0700 (PDT)
Received: by pvg13 with SMTP id 13so2894377pvg.26
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 00:06:42 -0700 (PDT)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v3] xfstests:Make 225 compare map and fiemap at each block.
Date: Mon, 23 May 2011 15:07:03 +0800
Message-Id: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
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
To: sandeen@redhat.com
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>, josef@redhat.com, xfs@oss.sgi.com

Due to my carelessness,  I induced a ugly patch to ext4's fiemap, as a result
delayed-extents that did not start at the head block of a page was ignored
in ext4 with 1K block, but 225 could not find it.  So I looked into the 225
and could not figure out logic in compare_map_and_fiemap(), which seemed to
mix extents with blocks.  Then I made 225 compare map and fiemap at each block,
the new 225 can find the bug I induced and another bug in ext4 with 1k block,
which ignored delayed-extents after a hole, which did not start at the head
block of a page.


The new 225 works well on ext3, ext4 and xfs with both 1K and 4K block.

Reviewed-by: josef@rehat.com
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
v2->v3:
  Add much more specific changelog expalining the bug the old 225 could not find.

v1->v2:
Josef <josef@redhat.com> reviewed the v1 patch and pointed out the bug which
made xfs not work and several coding styles.

According to reply from Josef, I
 fixed the bug which added ';' after an if statement.
 removed the trailing whitespace.

Apart from things above, I
 made check_weird_fs_hole() verify bytes read by pread().

 src/fiemap-tester.c |  251 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 140 insertions(+), 111 deletions(-)

diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 1663f84..319a9bb 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -14,6 +14,9 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Compare map and fiemap at each block,
+ * Yongqiang Yang <xiaoqiangnk@gmail.com>, 2011
  */
 
 #include <stdio.h>
@@ -57,7 +60,7 @@ generate_file_mapping(int blocks, int prealloc)
 	int num_types = 2, cur_block = 0;
 	int i = 0;
 
-	map = malloc(sizeof(char) * blocks);
+	map = malloc(sizeof(char) * (blocks + 1));
 	if (!map)
 		return NULL;
 
@@ -81,6 +84,7 @@ generate_file_mapping(int blocks, int prealloc)
 		cur_block++;
 	}
 
+	map[blocks] = 0;
 	return map;
 }
 
@@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
 }
 
 static int
-check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
+check_data(struct fiemap_extent *extent ,  __u64 logical_offset, int blocksize,
 	   int last, int prealloc)
 {
-	struct fiemap_extent *extent;
-	__u64 orig_offset = logical_offset;
-	int c, found = 0;
-
-	for (c = 0; c < fiemap->fm_mapped_extents; c++) {
-		__u64 start, end;
-		extent = &fiemap->fm_extents[c];
-
-		start = extent->fe_logical;
-		end = extent->fe_logical + extent->fe_length;
-
-		if (logical_offset > end)
-			continue;
-
-		if (logical_offset + blocksize < start)
-			break;
-
-		if (logical_offset >= start &&
-		    logical_offset < end) {
-			if (prealloc &&
-			    !(extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)) {
-				printf("ERROR: preallocated extent is not "
-				       "marked with FIEMAP_EXTENT_UNWRITTEN: "
-				       "%llu\n",
-				       (unsigned long long)
-				       (start / blocksize));
-				return -1;
-			}
-
-			if (logical_offset + blocksize > end) {
-				logical_offset = end+1;
-				continue;
-			} else {
-				found = 1;
-				break;
-			}
+	int found = 0;
+	__u64 start, end;
+
+	start = extent->fe_logical;
+	end = extent->fe_logical + extent->fe_length;
+
+	if (logical_offset >= start &&
+	    logical_offset < end) {
+		if (prealloc &&
+		    !(extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)) {
+			printf("ERROR: preallocated extent is not "
+			       "marked with FIEMAP_EXTENT_UNWRITTEN: "
+			       "%llu\n",
+			       (unsigned long long)
+			       (start / blocksize));
+			return -1;
 		}
+		found = 1;
 	}
 
 	if (!found) {
 		printf("ERROR: couldn't find extent at %llu\n",
-		       (unsigned long long)(orig_offset / blocksize));
+		       (unsigned long long)(logical_offset / blocksize));
 	} else if (last &&
-		   !(fiemap->fm_extents[c].fe_flags & FIEMAP_EXTENT_LAST)) {
+		   !(extent->fe_flags & FIEMAP_EXTENT_LAST)) {
 		printf("ERROR: last extent not marked as last: %llu\n",
-		       (unsigned long long)(orig_offset / blocksize));
+		       (unsigned long long)(logical_offset / blocksize));
 		found = 0;
 	}
 
@@ -306,7 +291,7 @@ static int
 check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
 {
 	static int warning_printed = 0;
-	int block, i;
+	int block, i, count;
 	size_t buf_len = sizeof(char) * blocksize;
 	char *buf;
 
@@ -330,15 +315,16 @@ check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
 		return -1;
 	}
 
-	if (pread(fd, buf, buf_len, (off_t)logical_offset) < 0) {
+	count = pread(fd, buf, buf_len, (off_t)logical_offset);
+	if (count < 0) {
 		perror("Error reading from file");
 		free(buf);
 		return -1;
 	}
 
-	for (i = 0; i < buf_len; i++) {
+	for (i = 0; i < count; i++) {
 		if (buf[i] != 0) {
-			printf("ERROR: FIEMAP claimed there was data (%c) at "
+			printf("ERROR: FIEMAP claimed there was data (%x) at "
 			       "block %llu that should have been a hole, and "
 			       "FIBMAP confirmed that it was allocated, but "
 			       "it should be filled with 0's, but it was not "
@@ -370,35 +356,25 @@ check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
 }
 
 static int
-check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int blocksize)
+check_hole(struct fiemap_extent *extent, int fd, __u64 logical_offset,
+	   int blocksize)
 {
-	struct fiemap_extent *extent;
-	int c;
+	__u64 start, end;
 
-	for (c = 0; c < fiemap->fm_mapped_extents; c++) {
-		__u64 start, end;
-		extent = &fiemap->fm_extents[c];
-
-		start = extent->fe_logical;
-		end = extent->fe_logical + extent->fe_length;
-
-		if (logical_offset > end)
-			continue;
-		if (logical_offset + blocksize < start)
-			break;
+	start = extent->fe_logical;
+	end = extent->fe_logical + extent->fe_length;
 
-		if (logical_offset >= start &&
-		    logical_offset < end) {
+	if (logical_offset >= start &&
+	    logical_offset < end) {
 
-			if (check_weird_fs_hole(fd, logical_offset,
-						blocksize) == 0)
-				break;
+		if (check_weird_fs_hole(fd, logical_offset,
+					blocksize) == 0)
+			return 0;
 
-			printf("ERROR: found an allocated extent where a hole "
-			       "should be: %llu\n",
-			       (unsigned long long)(start / blocksize));
-			return -1;
-		}
+		printf("ERROR: found an allocated extent where a hole "
+		       "should be: %llu\n",
+		       (unsigned long long)(logical_offset / blocksize));
+		return -1;
 	}
 
 	return 0;
@@ -423,9 +399,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 {
 	struct fiemap *fiemap;
 	char *fiebuf;
-	int blocks_to_map, ret, cur_extent = 0, last_data;
+	int blocks_to_map, ret, last_data = -1;
 	__u64 map_start, map_length;
 	int i, c;
+	int cur_block = 0;
+	int last_found = 0;
 
 	if (query_fiemap_count(fd, blocks, blocksize) < 0)
 		return -1;
@@ -451,8 +429,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 	fiemap->fm_extent_count = blocks_to_map;
 	fiemap->fm_mapped_extents = 0;
 
+	/* check fiemap by looking at each block. */
 	do {
-		fiemap->fm_start = map_start;
+		int nr_extents;
+
+		fiemap->fm_start = cur_block * blocksize;
 		fiemap->fm_length = map_length;
 
 		ret = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -465,45 +446,93 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 		if (check_flags(fiemap, blocksize))
 			goto error;
 
-		for (i = cur_extent, c = 1; i < blocks; i++, c++) {
-			__u64 logical_offset = i * blocksize;
-
-			if (c > fiemap->fm_mapped_extents) {
-				i++;
-				break;
+		nr_extents = fiemap->fm_mapped_extents;
+		if (nr_extents == 0) {
+			int block = cur_block + (map_length - 1) / blocksize;
+			for (; cur_block <= block &&
+			       cur_block < blocks; cur_block++) {
+				/* check hole */
+				if (map[cur_block] != 'H') {
+					printf("ERROR: map[%d] should not be "
+					       "a hole\n", cur_block);
+					goto error;
+				}
 			}
+			continue;
+		}
 
-			switch (map[i]) {
-			case 'D':
-				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 0))
+		for (c = 0; c < nr_extents; c++) {
+			__u64 offset;
+			int block;
+			struct fiemap_extent *extent;
+
+
+			extent = &fiemap->fm_extents[c];
+			offset = extent->fe_logical;
+			block = offset / blocksize;
+
+			/* check hole. */
+			for (; cur_block < block && cur_block < blocks;
+			     cur_block++) {
+				if (map[cur_block] != 'H') {
+					printf("ERROR: map[%d] should not be "
+					       "a hole\n", cur_block);
 					goto error;
-				break;
-			case 'H':
-				if (check_hole(fiemap, fd, logical_offset,
-					       blocksize))
+				}
+			}
+
+			offset = extent->fe_logical + extent->fe_length;
+			block = offset / blocksize;
+			/* check data */
+			for (; cur_block < block && cur_block < blocks;
+			     cur_block++) {
+				int last;
+				offset = (__u64)cur_block * blocksize;
+				last = (cur_block == last_data);
+				last_found = last_found ? last_found : last;
+				switch (map[cur_block]) {
+				case 'D':
+					if (check_data(extent, offset,
+						       blocksize, last, 0))
+						goto error;
+					break;
+				case 'H':
+					if (check_hole(extent, fd, offset,
+						       blocksize))
+						goto error;
+					break;
+
+				case 'P':
+					if (check_data(extent, offset,
+						       blocksize, last, 1))
+						goto error;
+					break;
+				default:
+					printf("ERROR: weird value in "
+					       "map: %c\n", map[i]);
 					goto error;
-				break;
-			case 'P':
-				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 1))
+				}
+			}
+
+			for (; cur_block < block; cur_block++) {
+				offset = (__u64)cur_block * blocksize;
+				if (check_hole(extent, fd, offset, blocksize))
 					goto error;
-				break;
-			default:
-				printf("ERROR: weird value in map: %c\n",
-				       map[i]);
-				goto error;
 			}
 		}
-		cur_extent = i;
-		map_start = i * blocksize;
-	} while (cur_extent < blocks);
+	} while (cur_block < blocks);
 
-	ret = 0;
-	return ret;
+	if (!last_found && last_data != -1) {
+		printf("ERROR: find no last extent\n");
+		goto error;
+	}
+
+	free(fiebuf);
+	return 0;
 error:
 	printf("map is '%s'\n", map);
 	show_extents(fiemap, blocksize);
+	free(fiebuf);
 	return -1;
 }
 
@@ -605,6 +634,18 @@ main(int argc, char **argv)
 		printf("Starting infinite run, if you don't see any output "
 		       "then its working properly.\n");
 	do {
+		if (ftruncate(fd, 0)) {
+			perror("Could not truncate file\n");
+			close(fd);
+			exit(1);
+		}
+
+		if (lseek(fd, 0, SEEK_SET)) {
+			perror("Could not seek set\n");
+			close(fd);
+			exit(1);
+		}
+
 		if (!map) {
 			blocks = random() % maxblocks;
 			if (blocks == 0) {
@@ -639,18 +680,6 @@ main(int argc, char **argv)
 		free(map);
 		map = NULL;
 
-		if (ftruncate(fd, 0)) {
-			perror("Could not truncate file\n");
-			close(fd);
-			exit(1);
-		}
-
-		if (lseek(fd, 0, SEEK_SET)) {
-			perror("Could not seek set\n");
-			close(fd);
-			exit(1);
-		}
-
 		if (runs) runs--;
 	} while (runs != 0);
 
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
