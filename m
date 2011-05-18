Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4IDFZ7q239485 for <xfs@oss.sgi.com>; Wed, 18 May 2011 08:15:35 -0500
Received: from mail-px0-f182.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB5F7465BA0
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 06:15:34 -0700 (PDT)
Received: from mail-px0-f182.google.com (mail-px0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	jtwJsPED65q5cCb5 for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 06:15:34 -0700 (PDT)
Received: by pxi20 with SMTP id 20so1318692pxi.41
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 06:15:34 -0700 (PDT)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] xfstests:Make 225 compare map and fiemap at each block.
Date: Wed, 18 May 2011 21:14:50 +0800
Message-Id: <1305724490-29408-1-git-send-email-xiaoqiangnk@gmail.com>
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
To: josef@redhat.com
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs@oss.sgi.com

Hi All,

Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
225 could not find it.  So I looked into the 225 and could not figure out
logic in compare_map_and_fiemap(), which seemed to mixed extents with
blocks.  Then I made 225 compare map and fiemap at each block, the new
225 can find another bug in ext4's fiemap.  After the new 225 is accepted,
I will send out the patch for ext4's fiemap.

The new 225 works well on ext3 and ext4 with both 1K and 4K block. However,
it report fiemap error on xfs with 4K block.  My working tree is 2.6.39-rc3
pulled from Ted's tree. The error message is as follows.

 QA output created by 225
 fiemap run without preallocation, with sync
+map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDHDDDDDDDDHDDHHHDDDHDDHHD
DDDDDHHHHHHDDHHHHHDHDHDHDDDHDDHD'
+logical: [       0..      15] phys:       12..      27 flags: 0x000 tot: 16
+logical: [      17..      31] phys:       29..      43 flags: 0x000 tot: 15
+logical: [      34..      63] phys:       46..      75 flags: 0x000 tot: 30
+logical: [      65..      95] phys:       77..     107 flags: 0x001 tot: 31
+Problem comparing fiemap and map
 fiemap run without preallocation or sync
+map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDHDDDDDDDDHDDHHHDDDHDDHHDD
DDDDHHHHHHDDHHHHHDHDHDHDDDHDDHD'
+logical: [       0..      15] phys:        0..      15 flags: 0x006 tot: 16
+Problem comparing fiemap and map
Ran: 225
Failures: 225
Failed 1 of 1 tests

I am not sure this is a bug in new 225 or xfs.

Yongqiang.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 src/fiemap-tester.c |  223 ++++++++++++++++++++++++++++----------------------
 1 files changed, 125 insertions(+), 98 deletions(-)

diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 1663f84..99bb5ce 100644
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
 
@@ -80,7 +83,8 @@ generate_file_mapping(int blocks, int prealloc)
 		}
 		cur_block++;
 	}
-
+	
+	map[blocks] = 0;
 	return map;
 }
 
@@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
 }
 
 static int
-check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
+check_data(struct fiemap_extent * extent ,  __u64 logical_offset, int blocksize,
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
-
+	
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
 
@@ -370,37 +355,26 @@ check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
 }
 
 static int
-check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int blocksize)
+check_hole(struct fiemap_extent *extent, int fd, __u64 logical_offset, int blocksize)
 {
-	struct fiemap_extent *extent;
-	int c;
+	__u64 start, end;
 
-	for (c = 0; c < fiemap->fm_mapped_extents; c++) {
-		__u64 start, end;
-		extent = &fiemap->fm_extents[c];
+	start = extent->fe_logical;
+	end = extent->fe_logical + extent->fe_length;
 
-		start = extent->fe_logical;
-		end = extent->fe_logical + extent->fe_length;
+	if (logical_offset >= start &&
+	    logical_offset < end) {
 
-		if (logical_offset > end)
-			continue;
-		if (logical_offset + blocksize < start)
-			break;
+		if (check_weird_fs_hole(fd, logical_offset,
+					blocksize) == 0)
+			return 0;
 
-		if (logical_offset >= start &&
-		    logical_offset < end) {
-
-			if (check_weird_fs_hole(fd, logical_offset,
-						blocksize) == 0)
-				break;
-
-			printf("ERROR: found an allocated extent where a hole "
-			       "should be: %llu\n",
-			       (unsigned long long)(start / blocksize));
-			return -1;
-		}
+		printf("ERROR: found an allocated extent where a hole "
+		       "should be: %llu\n",
+		       (unsigned long long)(start / blocksize));
+		return -1;
 	}
-
+	
 	return 0;
 }
 
@@ -423,9 +397,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
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
@@ -451,8 +427,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
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
@@ -465,45 +444,93 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 		if (check_flags(fiemap, blocksize))
 			goto error;
 
-		for (i = cur_extent, c = 1; i < blocks; i++, c++) {
-			__u64 logical_offset = i * blocksize;
+		nr_extents = fiemap->fm_mapped_extents;
+		if (nr_extents == 0) {
+			int block = cur_block + (map_length - 1)/ blocksize;
+			for (; cur_block <= block && cur_block < blocks; cur_block++) {
+				/* check hole */
+				if (map[cur_block] != 'H') {
+					printf("ERROR: map[%d] should not be "
+					       "a hole\n", cur_block);
+					goto error;
+				}
+			}
+			continue;
+		}
 
-			if (c > fiemap->fm_mapped_extents) {
-				i++;
-				break;
+		for (c = 0; c < nr_extents; c++) {
+			__u64 offset;
+			int block;
+			struct fiemap_extent *extent;
+
+			if (last_found) {
+				printf("ERROR: there is extent after"
+				       "the last extent\n");
+				goto error;
 			}
 
-			switch (map[i]) {
-			case 'D':
-				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 0))
-					goto error;
-				break;
-			case 'H':
-				if (check_hole(fiemap, fd, logical_offset,
-					       blocksize))
-					goto error;
-				break;
-			case 'P':
-				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 1))
+			extent = &fiemap->fm_extents[c];
+			offset = extent->fe_logical;
+			block = offset / blocksize;
+
+			/* check hole. */
+			for (; cur_block < block; cur_block++) {
+				if (map[cur_block] != 'H') {
+					printf("ERROR: map[%d] should not be "
+					       "a hole\n", cur_block);
 					goto error;
-				break;
-			default:
-				printf("ERROR: weird value in map: %c\n",
-				       map[i]);
+				}
+			}
+
+			offset = extent->fe_logical + extent->fe_length;
+			block = offset / blocksize;
+
+			if (block > blocks) {
+				printf("ERROR: there are extents beyond EOF\n");
 				goto error;
 			}
+
+			/* check data */
+			for (; cur_block < block; cur_block++) {
+				offset = (__u64)cur_block * blocksize;
+				last_found = (last_data == cur_block);
+				switch (map[cur_block]) {
+				case 'D':
+					if (check_data(extent, offset,
+						       blocksize, last_found, 0))
+						goto error;
+					break;
+				case 'H':
+					if (check_hole(extent, fd, offset,
+						       blocksize));
+						goto error;
+					break;
+
+				case 'P':
+					if (check_data(extent, offset,
+						       blocksize, last_found, 1))
+						goto error;
+					break;
+				default:
+					printf("ERROR: weird value in map: %c\n",
+					       map[i]);
+					goto error;
+				}
+			}
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
 
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
