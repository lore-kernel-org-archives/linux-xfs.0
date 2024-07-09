Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493451DFCF
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552235; cv=none; b=l7r87H5bhVwGjlXsBf7KvSIWrKCDTPiNoMkBzpMtafScvxTvytn08mdNF4eD5V3AjSzymDo1kpaQMnhWrH1eiBbfRSz39kZUMdJptMv5Pn57JeyVESkrUkQFzjb0d4tqhGKDihLyylFfTVNsx5DyE85sJamFiLpCvwPYu/XH9mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552235; c=relaxed/simple;
	bh=uDOe3pHBc4dIq3zZa0zgN2Tr3LLI8iFh8Boxai9CXMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e3eSXu2x9kPKnauMSa4JBtSM62OGQwMqUHV79vLKojZBAbuwvTgk53kW3LduWECb6lGdV4M/PRRkl7MsBLTfuOZU4l4mmmajW7Nbk4AT/hScUcczdMnb+jqyoOMJI9clDjLtNDyzvYe/wC2svoiTEpKGp9JyB9mwF8Q3KuKeA0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aIr+ef1Q; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aIr+ef1Q"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469Ftaaa031069
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=p
	VMPjBAdGgZWYKviwKIl5YJCE63y5stLsGOKs90PX/I=; b=aIr+ef1Qh2uTr6kdz
	G3EuKhajG8HKddVKGvVdxKNDjjWMe03URVxiJi7voTjs7MpafjgFecRy44SDWAEf
	vcyj53eXWfwanaR+IMK2DXFhBaS2J46Cvxy01NL0yK8WSxPL8oQRut1hb4zXhUPN
	pwVGaO2VcIfW7ulLyXoZnL+o4KOzPmh2omU5bErGmgpK8zT4AQjO4rV2ca/8OLcB
	k1eSZMYxtVhSaLcY5P54lrNgSIPy6Gn8+9mJfwGwYo5MdE6b0Lxdce0WQu10+sMi
	lpdLzHj0WLj2r0PXjB+Ec4wHXRArfRlFsvFQ70UqNg6UUfKoEtH3vRQbDV+4oO2k
	FCANQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky5tme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IDmWH014129
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:32 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPS024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:31 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-3;
	Tue, 09 Jul 2024 19:10:31 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Date: Tue,  9 Jul 2024 12:10:21 -0700
Message-Id: <20240709191028.2329-3-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240709191028.2329-1-wen.gang.wang@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_08,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407090129
X-Proofpoint-ORIG-GUID: mrbkXX6LXIGMx7B_fCzXOhADIEVqkyi3
X-Proofpoint-GUID: mrbkXX6LXIGMx7B_fCzXOhADIEVqkyi3

segments are the smallest unit to defragment.

A segment
1. Can't exceed size limit
2. contains some extents
3. the contained extents can't be "unwritten"
4. the contained extents must be contigous in file blocks

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 204 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index c9732984..175cf461 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -14,6 +14,32 @@
 #include "space.h"
 #include "input.h"
 
+#define MAPSIZE 512
+/* used to fetch bmap */
+struct getbmapx	g_mapx[MAPSIZE];
+/* current offset of the file in units of 512 bytes, used to fetch bmap */
+static long long 	g_offset = 0;
+/* index to indentify next extent, used to get next extent */
+static int		g_ext_next_idx = -1;
+
+/*
+ * segment, the smallest unit to defrag
+ * it includes some contiguous extents.
+ * no holes included,
+ * no unwritten extents included
+ * the size is limited by g_segment_size_lmt
+ */
+struct defrag_segment {
+	/* segment offset in units of 512 bytes */
+	long long	ds_offset;
+	/* length of segment in units of 512 bytes */
+	long long	ds_length;
+	/* number of extents in this segment */
+	int		ds_nr;
+	/* flag indicating if segment contains shared blocks */
+	bool		ds_shared;
+};
+
 /* defrag segment size limit in units of 512 bytes */
 #define MIN_SEGMENT_SIZE_LIMIT 8192 /* 4MiB */
 #define DEFAULT_SEGMENT_SIZE_LIMIT 32768 /* 16MiB */
@@ -78,6 +104,165 @@ defrag_check_file(char *path)
 	return true;
 }
 
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
+	int err = 0, i;
+
+	/* when no extents are cached in g_mapx, fetch from kernel */
+	if (g_ext_next_idx == -1) {
+		g_mapx[0].bmv_offset = g_offset;
+		g_mapx[0].bmv_length = -1LL;
+		g_mapx[0].bmv_count = MAPSIZE;
+		g_mapx[0].bmv_iflags = BMV_IF_NO_HOLES | BMV_IF_PREALLOC;
+		err = ioctl(fd, XFS_IOC_GETBMAPX, g_mapx);
+		if (err == -1) {
+			perror("XFS_IOC_GETBMAPX failed");
+			goto out;
+		}
+		/* for stats */
+		g_ext_stats.nr_ext_total += g_mapx[0].bmv_entries;
+
+		/* no more extents */
+		if (g_mapx[0].bmv_entries == 0) {
+			err = 1;
+			goto out;
+		}
+
+		/* for stats */
+		for (i = 1; i <= g_mapx[0].bmv_entries; i++) {
+			if (g_mapx[i].bmv_oflags & BMV_OF_PREALLOC)
+				g_ext_stats.nr_ext_unwritten++;
+			if (g_mapx[i].bmv_oflags & BMV_OF_SHARED)
+				g_ext_stats.nr_ext_shared++;
+		}
+
+		g_ext_next_idx = 1;
+		g_offset = g_mapx[g_mapx[0].bmv_entries].bmv_offset +
+				g_mapx[g_mapx[0].bmv_entries].bmv_length;
+	}
+
+	map_out->bmv_offset = g_mapx[g_ext_next_idx].bmv_offset;
+	map_out->bmv_length = g_mapx[g_ext_next_idx].bmv_length;
+	map_out->bmv_oflags = g_mapx[g_ext_next_idx].bmv_oflags;
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
+	if (g_ext_next_idx == g_mapx[0].bmv_entries)
+		g_ext_next_idx = -1;
+	else
+		g_ext_next_idx += 1;
+}
+
+/*
+ * check if the given extent is a defrag target.
+ * no need to check for holes as we are using BMV_IF_NO_HOLES
+ */
+static bool
+defrag_is_target(struct getbmapx *mapx)
+{
+	/* unwritten */
+	if (mapx->bmv_oflags & BMV_OF_PREALLOC)
+		return false;
+	return mapx->bmv_length < g_segment_size_lmt;
+}
+
+static bool
+defrag_is_extent_shared(struct getbmapx *mapx)
+{
+	return !!(mapx->bmv_oflags & BMV_OF_SHARED);
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
+	out->ds_shared = false;
+
+	do {
+		ret = defrag_get_next_extent(fd, &mapx);
+		if (ret != 0) {
+			/*
+			 * no more extetns, return current segment if its not
+			 * empty
+			*/
+			if (ret == 1 && out->ds_nr > 0)
+				ret = 0;
+			/* otherwise, error heppened, stop */
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
+		/* check for segment size limitation */
+		if (out->ds_length + mapx.bmv_length > g_segment_size_lmt)
+			break;
+
+		/* the segment is empty now, add this extent to it for sure */
+		if (out->ds_nr == 0) {
+			out->ds_offset = mapx.bmv_offset;
+			goto add_ext;
+		}
+
+		/*
+		 * the segment is not empty, check for hole since the last exent
+		 * if a hole exist before this extent, this extent can't be
+		 * added to the segment. return the segment
+		 */
+		if (out->ds_offset + out->ds_length != mapx.bmv_offset)
+			break;
+
+add_ext:
+		if (defrag_is_extent_shared(&mapx))
+			out->ds_shared = true;
+
+		out->ds_length += mapx.bmv_length;
+		out->ds_nr += 1;
+		defrag_move_next_extent();
+
+	} while (true);
+
+	return ret;
+}
+
 /*
  * defragment a file
  * return 0 if successfully done, 1 otherwise
@@ -92,6 +277,9 @@ defrag_xfs_defrag(char *file_path) {
 	struct fsxattr	fsx;
 	int	ret = 0;
 
+	g_offset = 0;
+	g_ext_next_idx = -1;
+
 	fsx.fsx_nextents = 0;
 	memset(&g_ext_stats, 0, sizeof(g_ext_stats));
 
@@ -119,6 +307,22 @@ defrag_xfs_defrag(char *file_path) {
 		ret = 1;
 		goto out;
 	}
+
+	do {
+		struct defrag_segment segment;
+
+		ret = defrag_get_next_segment(defrag_fd, &segment);
+		/* no more segments, we are done */
+		if (ret == 1) {
+			ret = 0;
+			break;
+		}
+		/* error happened when reading bmap, stop here */
+		if (ret == -1) {
+			ret = 1;
+			break;
+		}
+	} while (true);
 out:
 	if (scratch_fd != -1) {
 		close(scratch_fd);
-- 
2.39.3 (Apple Git-146)

