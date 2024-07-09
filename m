Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFD5182A52
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552237; cv=none; b=p8wBaNo8ySTnxqTvMBteRG2wSIH2rruYEYOjvAjCsnlUBUFgqPBFscxqZ7R9GTPaF5BoZSRagmSQuryXaj7mysR6Z4ggD/h0MW8nbzJ3Sgn4iXb0IB9guVtd2cp9b8CcQtCcjbvlzKlBMyg4W7v+OpetlZzg2JaI/bDmchgL4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552237; c=relaxed/simple;
	bh=wI2N9OsGHsVBdcHzXzgUW+61rIclaKvyk+yYkgRUTuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QOGzzkfhpGDV2dDs2BfInHdsTIkpo7OY7qsNLCU1jR+IWOhEfbb2v4caI/PaiLUBdlkGA+s4rayRZaLCxzdGYXz5Js2q09mC3iC7r5ACQSPrHkuREvWtxe1IcBFO1gXjxMAJcJOAUsEoO+DKcYaD4tidl7vu0kGBGjZ/I20rCFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AuzBObVX; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AuzBObVX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtbwW031087
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=o
	TOfKYbgdWEFJfJu+uP4fTM2V4QNGrtqZwhzGOHmJMk=; b=AuzBObVXdYQBagSnI
	7H6ijuw5bQcAMz02KEEO7hZ47OTrsMX8pImaQRmmyTMpfzZH0b7RPDybgU36iP2e
	PahfqlzXC8w0GmWaSI1rbXs5bSx3Z7bkEiFMOS8/Jsi/n+oB5bqVCtxzEOkm78Y+
	nYYpGVuxXtKESjupDPjgaZlYuu7N0B64S4w8gRqxj1Tbdca/I7AYWsz7L+d7/qI1
	0+445uXuy+jDHOeqx3Pt3BjstOZtThfdl5wio3hwPOKvOxmlgYXnto4dUg/azvj5
	F6mMh4/jOUmJNfgRi2fBQigwI3P2r8hQZmasQ5rfbExzHYHtAdeq56gGtpjx6VB2
	KdvnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky5tmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IjXJh014344
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:32 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPU024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:32 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-4;
	Tue, 09 Jul 2024 19:10:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 3/9] spaceman/defrag: defrag segments
Date: Tue,  9 Jul 2024 12:10:22 -0700
Message-Id: <20240709191028.2329-4-wen.gang.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: k50HGC8-K1Wvg25fVYCVeEnNyXYYi6nu
X-Proofpoint-GUID: k50HGC8-K1Wvg25fVYCVeEnNyXYYi6nu

For each segment, the following steps are done trying to defrag it:

1. share the segment with a temporary file
2. unshare the segment in the target file. kernel simulates Cow on the whole
   segment complete the unshare (defrag).
3. release blocks from the tempoary file.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index 175cf461..9f11e36b 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -263,6 +263,40 @@ add_ext:
 	return ret;
 }
 
+/*
+ * check if the segment exceeds EoF.
+ * fix up the clone range and return true if EoF happens,
+ * return false otherwise.
+ */
+static bool
+defrag_clone_eof(struct file_clone_range *clone)
+{
+	off_t delta;
+
+	delta = clone->src_offset + clone->src_length - g_defrag_file_size;
+	if (delta > 0) {
+		clone->src_length = 0; // to the end
+		return true;
+	}
+	return false;
+}
+
+/*
+ * get the time delta since pre_time in ms.
+ * pre_time should contains values fetched by gettimeofday()
+ * cur_time is used to store current time by gettimeofday()
+ */
+static long long
+get_time_delta_us(struct timeval *pre_time, struct timeval *cur_time)
+{
+	long long us;
+
+	gettimeofday(cur_time, NULL);
+	us = (cur_time->tv_sec - pre_time->tv_sec) * 1000000;
+	us += (cur_time->tv_usec - pre_time->tv_usec);
+	return us;
+}
+
 /*
  * defragment a file
  * return 0 if successfully done, 1 otherwise
@@ -273,6 +307,7 @@ defrag_xfs_defrag(char *file_path) {
 	long	nr_seg_defrag = 0, nr_ext_defrag = 0;
 	int	scratch_fd = -1, defrag_fd = -1;
 	char	tmp_file_path[PATH_MAX+1];
+	struct file_clone_range clone;
 	char	*defrag_dir;
 	struct fsxattr	fsx;
 	int	ret = 0;
@@ -296,6 +331,8 @@ defrag_xfs_defrag(char *file_path) {
 		goto out;
 	}
 
+	clone.src_fd = defrag_fd;
+
 	defrag_dir = dirname(file_path);
 	snprintf(tmp_file_path, PATH_MAX, "%s/.xfsdefrag_%d", defrag_dir,
 		getpid());
@@ -309,7 +346,11 @@ defrag_xfs_defrag(char *file_path) {
 	}
 
 	do {
+		struct timeval t_clone, t_unshare, t_punch_hole;
 		struct defrag_segment segment;
+		long long seg_size, seg_off;
+		int time_delta;
+		bool stop;
 
 		ret = defrag_get_next_segment(defrag_fd, &segment);
 		/* no more segments, we are done */
@@ -322,6 +363,79 @@ defrag_xfs_defrag(char *file_path) {
 			ret = 1;
 			break;
 		}
+
+		/* we are done if the segment contains only 1 extent */
+		if (segment.ds_nr < 2)
+			continue;
+
+		/* to bytes */
+		seg_off = segment.ds_offset * 512;
+		seg_size = segment.ds_length * 512;
+
+		clone.src_offset = seg_off;
+		clone.src_length = seg_size;
+		clone.dest_offset = seg_off;
+
+		/* checks for EoF and fix up clone */
+		stop = defrag_clone_eof(&clone);
+		gettimeofday(&t_clone, NULL);
+		ret = ioctl(scratch_fd, FICLONERANGE, &clone);
+		if (ret != 0) {
+			fprintf(stderr, "FICLONERANGE failed %s\n",
+				strerror(errno));
+			break;
+		}
+
+		/* for time stats */
+		time_delta = get_time_delta_us(&t_clone, &t_unshare);
+		if (time_delta > max_clone_us)
+			max_clone_us = time_delta;
+
+		/* for defrag stats */
+		nr_ext_defrag += segment.ds_nr;
+
+		/*
+		 * For the shared range to be unshared via a copy-on-write
+		 * operation in the file to be defragged. This causes the
+		 * file needing to be defragged to have new extents allocated
+		 * and the data to be copied over and written out.
+		 */
+		ret = fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, seg_off,
+				seg_size);
+		if (ret != 0) {
+			fprintf(stderr, "UNSHARE_RANGE failed %s\n",
+				strerror(errno));
+			break;
+		}
+
+		/* for time stats */
+		time_delta = get_time_delta_us(&t_unshare, &t_punch_hole);
+		if (time_delta > max_unshare_us)
+			max_unshare_us = time_delta;
+
+		/*
+		 * Punch out the original extents we shared to the
+		 * scratch file so they are returned to free space.
+		 */
+		ret = fallocate(scratch_fd,
+			FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE, seg_off,
+			seg_size);
+		if (ret != 0) {
+			fprintf(stderr, "PUNCH_HOLE failed %s\n",
+				strerror(errno));
+			break;
+		}
+
+		/* for defrag stats */
+		nr_seg_defrag += 1;
+
+		/* for time stats */
+		time_delta = get_time_delta_us(&t_punch_hole, &t_clone);
+		if (time_delta > max_punch_us)
+			max_punch_us = time_delta;
+
+		if (stop)
+			break;
 	} while (true);
 out:
 	if (scratch_fd != -1) {
-- 
2.39.3 (Apple Git-146)

