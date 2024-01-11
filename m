Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5434CE01
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="THU52w5l"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BGmv7S017263
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=sMtoWGhVOCtWPfYppCCfOvURmUpXTPwwhSWxrYavfWs=;
 b=THU52w5lgSv/ysqxFys2fTkgLLwzkCU5iSfj3UfXdFmEbRLdOayw7AKwvb16aCllehc3
 6iabx4g6SnEBbIZOr3iTy5dpe0IHLU2aUncnxOpEhbXuOjta/KfvQgZ+Hsug0VosNDAK
 oA5gd0gDfrYRRxPzePvBNfVTDxTqwA6mSxwGub8Jc2vrXdyNMfiFhxys/Av1M6rZ76pB
 0LuCUOIWHPK+O4XbGLNvYL8u5a9XWUpfgYQ2MM3PqhkxlSXk8pzvL51Yz9WAFN+YTE7/
 61EcGFxrUFosYi9zdGo3F66YUqLeV8a64Qzkav76MDo8a8vWT3wNt6Zmm9D47DTAd4fG yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjcbkh7m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40BH4Ptm030155
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vfutqg5de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:39:59 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BHdxxJ031568
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:39:59 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-138-212.vpn.oracle.com [10.159.138.212])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vfutqg5cy-1;
	Thu, 11 Jan 2024 17:39:59 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 1/2] xfsprogs: introduce defrag command to spaceman
Date: Thu, 11 Jan 2024 09:39:58 -0800
Message-Id: <20240111173958.50483-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_09,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110139
X-Proofpoint-ORIG-GUID: HIbV6CRjPo6DnoxHQ4KvAFZyPTTo_Rmx
X-Proofpoint-GUID: HIbV6CRjPo6DnoxHQ4KvAFZyPTTo_Rmx

Non-exclusive defragment
Here we are introducing the non-exclusive manner to defragment a file,
especially for huge files, without blocking IO to it long.
Non-exclusive defragmentation divides the whole file into small segments.
For each segment, we lock the file, defragment the segment and unlock the file.
Defragmenting the small segment doesn’t take long. File IO requests can get
served between defragmenting segments before blocked long.  Also we put
(user adjustable) idle time between defragmenting two consecutive segments to
balance the defragmentation and file IOs.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/Makefile |   2 +-
 spaceman/defrag.c | 394 ++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c   |   1 +
 spaceman/space.h  |   1 +
 4 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/defrag.c

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 1f048d54..9c00b20a 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = info.c init.c file.c health.c prealloc.c trim.c
+CFILES = info.c init.c file.c health.c prealloc.c trim.c defrag.c
 LSRCFILES = xfs_info.sh
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/spaceman/defrag.c b/spaceman/defrag.c
new file mode 100644
index 00000000..fdc9b108
--- /dev/null
+++ b/spaceman/defrag.c
@@ -0,0 +1,394 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include <linux/fsmap.h>
+#include "libfrog/fsgeom.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "space.h"
+#include "input.h"
+
+#define MAPSIZE 512
+
+/* defrag segment size in units of 512 bytes */
+#define PIECE_SIZE 32768 /* 16MiB */
+#define TARGET_EXT_SIZE  (PIECE_SIZE/2)
+
+/*
+ * the defrag segment
+ * it includes some contiguous extents.
+ * no holes included,
+ * no unwritten extents included
+ * the size is limited by PIECE_SIZE, but can exceed that a bit.
+ */
+struct defrag_segment {
+	long long	ds_offset;	/* segment offset in units of 512 bytes */
+	long long	ds_length;	/* length of segment in units of 512 bytes */
+	int		ds_nr;		/* number of extents in this segment */
+};
+
+/* used to fetch bmap */
+static struct getbmapx	g_mapx[MAPSIZE];
+/* current offset of the file in units of 512 bytes, used to fetch bmap */
+static long long 	g_offset = 0;
+/* index to indentify next extent, use to get next extent */
+static int		g_next_idx = -1;
+/* sleep time in us between segment, overwritten by paramter */
+static useconds_t	g_idle_time = 0;
+/*
+ * numnber of extents. only the segments that contain more extents than this
+ * are defrag targets. overwritten by paramter
+ */
+static int		g_nr_ext = 1;
+
+/*
+ * get next extent in the file.
+ * Note: next call will get the same extent unless move_next_extent() is called.
+ * returns:
+ * -1:	error happened.
+ * 0:	extent returned
+ * 1:	no more extent left
+ */
+static int
+defrag_get_next_extent(int fd, struct getbmapx *map_out)
+{
+	int err = 0;
+
+	/* don't have extent cached in g_mapx, fetch from kernel */
+	if (g_next_idx == -1) {
+		g_mapx[0].bmv_offset = g_offset;
+		g_mapx[0].bmv_length = -1LL;
+		g_mapx[0].bmv_count = MAPSIZE;
+		g_mapx[0].bmv_iflags = BMV_IF_NO_HOLES | BMV_IF_PREALLOC;
+		err = ioctl(fd, XFS_IOC_GETBMAPX, g_mapx);
+		if (err == -1) {
+			perror("XFS_IOC_GETBMAPX failed");
+			goto out;
+		}
+		if (g_mapx[0].bmv_entries == 0) {
+			err = 1;
+			goto out;
+		}
+
+		g_next_idx = 1;
+		g_offset = g_mapx[g_mapx[0].bmv_entries].bmv_offset +
+				g_mapx[g_mapx[0].bmv_entries].bmv_length;
+	}
+	map_out->bmv_offset = g_mapx[g_next_idx].bmv_offset;
+	map_out->bmv_length = g_mapx[g_next_idx].bmv_length;
+	map_out->bmv_oflags = g_mapx[g_next_idx].bmv_oflags;
+out:
+	return err;
+}
+
+/*
+ * move to next extent
+ */
+static void
+defrag_move_next_extent()
+{
+	if (g_next_idx == g_mapx[0].bmv_entries)
+		g_next_idx = -1;
+	else
+		g_next_idx += 1;
+}
+
+/*
+ * check if the given extent is a defrag target.
+ * no need to check for holes as we are using BMV_IF_NO_HOLES
+ */
+static bool
+defrag_is_target(struct getbmapx *mapx)
+{
+	if (mapx->bmv_oflags & BMV_OF_PREALLOC)
+		return false;
+	return mapx->bmv_length < TARGET_EXT_SIZE;
+}
+
+/*
+ * get next segment to defragment.
+ * returns:
+ * -1	error happened.
+ * 0	segment returned.
+ * 1	no more segments to return
+ */
+static int
+defrag_get_next_segment(int fd, struct defrag_segment *out)
+{
+	struct getbmapx mapx;
+	int	ret;
+
+	out->ds_offset = 0;
+	out->ds_length = 0;
+	out->ds_nr = 0;
+
+	do {
+		ret = defrag_get_next_extent(fd, &mapx);
+		if (ret != 0) {
+			/* return current segment if its not empty */
+			if (ret == 1 && out->ds_nr > 0)
+				ret = 0;
+			break;
+		}
+
+		/*
+		 * If the extent is not a defrag target, skip it.
+		 * go to next extent if the segment is empty;
+		 * otherwise return the segment.
+		 */
+		if (!defrag_is_target(&mapx)) {
+			defrag_move_next_extent();
+			if (out->ds_nr == 0)
+				continue;
+			else
+				break;
+		}
+
+		/* the extent is the first in this segment */
+		if (out->ds_nr == 0) {
+			out->ds_offset = mapx.bmv_offset;
+			out->ds_length = mapx.bmv_length;
+			out->ds_nr = 1;
+			defrag_move_next_extent();
+			continue;
+		}
+
+		/*
+		 * now the extent is not the first one, check for hole.
+		 * if there is hole before this extent, return current segment.
+		 */
+		if (out->ds_offset + out->ds_length != mapx.bmv_offset)
+			break;
+
+		out->ds_length += mapx.bmv_length;
+		out->ds_nr += 1;
+		defrag_move_next_extent();
+	} while (out->ds_length < PIECE_SIZE);
+
+	return ret;
+}
+
+/*
+ * check if the target is a xfs file
+ * returns:
+ * ture -- yes
+ * false -- no
+ */
+static bool
+defrag_check_file(char *path)
+{
+	struct stat stat_s;
+	struct statfs statfs_s;
+
+	if (access(path, F_OK|W_OK) == -1) {
+		if (errno == ENOENT)
+			fprintf(stderr, "file \"%s\" doesn't exist\n", path);
+		else
+			fprintf(stderr, "no access to \"%s\", %s\n", path, strerror(errno));
+		return false;
+	}
+
+	if (stat(path, &stat_s) == -1) {
+		fprintf(stderr, "failed to get file info on \"%s\":  %s errno=%d\n",
+			path, strerror(errno), errno);
+		return false;
+	}
+
+	if (!S_ISREG(stat_s.st_mode)) {
+		fprintf(stderr, "\"%s\" is not a regular file\n", path);
+		return false;
+	}
+
+	if (statfs(path, &statfs_s) == -1) {
+		fprintf(stderr, "failed to get FS info on \"%s\":  %s errno=%d\n",
+			path, strerror(errno), errno);
+		return false;
+	}
+
+	if (statfs_s.f_type != XFS_SUPER_MAGIC) {
+		fprintf(stderr, "\"%s\" is not a xfs file\n", path);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * defragment a file
+ * return 0 if successfully done, 1 otherwise.
+ * params:
+ * file_path:	the file path to be defragmented
+ */
+static int
+defrag_xfs_defrag(char *file_path)
+{
+	long	nr_seg_defrag = 0, nr_ext_defrag = 0;
+	int	scratch_fd = -1, defrag_fd = -1;
+	char	*defrag_dir;
+	char	tmp_file_path[PATH_MAX+1];
+	int	ret = 0;
+
+	if (!defrag_check_file(file_path)) {
+		ret = 1;
+		goto out;
+	}
+
+	defrag_fd = open(file_path, O_RDWR);
+	if (defrag_fd == -1) {
+		fprintf(stderr, "Opening %s failed. %s\n", file_path, strerror(errno));
+		ret = -1;
+		goto out;
+	}
+
+	defrag_dir = dirname(file_path);
+	snprintf(tmp_file_path, PATH_MAX, "%s/.xfsdf_%d", defrag_dir, getpid());
+	tmp_file_path[PATH_MAX] = 0;
+	scratch_fd = open(tmp_file_path, O_CREAT|O_EXCL|O_RDWR, 0666);
+	if (scratch_fd == -1) {
+		fprintf(stderr, "Opening temporary file %s failed. %s\n",
+			tmp_file_path, strerror(errno));
+		ret = -1;
+		goto out;
+	}
+
+	do {
+		struct defrag_segment segment;
+		struct file_clone_range	clone;
+		long long seg_size, seg_off;
+
+		ret = defrag_get_next_segment(defrag_fd, &segment);
+		/* error happened or no more segments */
+		if (ret != 0)
+			break;
+		/* skip this segment if it contains less extents than specified */
+		if (segment.ds_nr <= g_nr_ext)
+			continue;
+
+		/* to bytes */
+		seg_off = segment.ds_offset * 512;
+		seg_size = segment.ds_length * 512;
+
+		clone.src_fd = defrag_fd;
+		clone.src_offset = seg_off;
+		clone.src_length = seg_size;
+		clone.dest_offset = seg_off;
+
+		nr_seg_defrag += 1;
+		nr_ext_defrag += segment.ds_nr;
+		ret = ioctl(scratch_fd, FICLONERANGE, &clone);
+		if (ret != 0) {
+			fprintf(stderr, "FICLONERANGE failed %s, errno=%d\n",
+				strerror(errno), errno);
+			goto out;
+		}
+
+		/*
+		 * For the shared range to be unshared via a copy-on-write
+		 * operation in the file to be defragged. This causes the
+		 * file needing to be defragged to have new extents allocated
+		 * and the data to be copied over and written out.
+		 */
+		ret = fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, seg_off, seg_size);
+		if (ret != 0) {
+			fprintf(stderr, "UNSHARE_RANGE failed %s, errno=%d\n",
+				strerror(errno), errno);
+			goto out;
+		}
+
+		ret = fdatasync(defrag_fd);
+		if (ret != 0) {
+			fprintf(stderr, "fdatasync failed %s, errno=%d\n",
+				strerror(errno), errno);
+			goto out;
+		}
+
+		/*
+		 * Punch out the original extents we shared to the
+		 * scratch file so they are returned to free space.
+		 */
+		ret = fallocate(scratch_fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE, seg_off, seg_size);
+		if (ret != 0) {
+			fprintf(stderr, "PUNCH_HOLE failed %s, errno=%d\n",
+				strerror(errno), errno);
+			goto out;
+		}
+		if (g_idle_time)
+			usleep(g_idle_time);
+	} while (true);
+out:
+	if (scratch_fd != -1) {
+		close(scratch_fd);
+		unlink(tmp_file_path);
+	}
+	if (defrag_fd != -1)
+		close(defrag_fd);
+	if (ret == 1)
+		ret = 0;
+
+	if (ret == 0)
+		printf("Defragmented %ld segments, %ld extents\n", nr_seg_defrag, nr_ext_defrag);
+	else
+		ret = 1;
+	return ret;
+}
+
+static cmdinfo_t defrag_cmd;
+
+static int
+defrag_f(int argc, char **argv)
+{
+	int	i;
+	int	c;
+
+	while ((c = getopt(argc, argv, "i:e:")) != EOF) {
+		switch(c) {
+		case 'i':
+			g_idle_time = atoi(optarg) * 1000;
+			break;
+		case 'e':
+			g_nr_ext = atoi(optarg);
+			break;
+		default:
+			printf("c is %c\n", c);
+			command_usage(&defrag_cmd);
+			return 1;
+		}
+	}
+
+	for (i = 0; i < filecount; i++)
+		defrag_xfs_defrag(filetable[i].name);
+	return 0;
+}
+
+static void defrag_help(void)
+{
+	printf(_(
+"\n"
+"Defragemnt file\n"
+"\n"
+" -i interval	-- sleep _interval_ ms between dedfragmenting segments.\n"
+"                  0 by default\n"
+" -e extnr	-- only segments with more than _extnr_ are defragment\n"
+"                  targets. 1 by default\n"));
+}
+
+void defrag_init(void)
+{
+	defrag_cmd.name		= "defrag";
+	defrag_cmd.altname	= "dfg";
+	defrag_cmd.cfunc	= defrag_f;
+	defrag_cmd.argmin	= 0;
+	defrag_cmd.argmax	= 4;
+	defrag_cmd.args		= "[-i interval] [-e extnr]";
+	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
+	defrag_cmd.oneline	= _("Defragment file");
+	defrag_cmd.help		= defrag_help;
+
+	add_command(&defrag_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cb..396f965c 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -35,6 +35,7 @@ init_commands(void)
 	trim_init();
 	freesp_init();
 	health_init();
+	defrag_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209ed..c288aeb9 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -26,6 +26,7 @@ extern void	help_init(void);
 extern void	prealloc_init(void);
 extern void	quit_init(void);
 extern void	trim_init(void);
+extern void	defrag_init(void);
 #ifdef HAVE_GETFSMAP
 extern void	freesp_init(void);
 #else
-- 
2.39.3 (Apple Git-145)

