Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F93DDB0A;
	Wed,  5 Aug 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911390; cv=none; b=Zg/cZHZ9z/dBuxzsiVMszOArqnOOMO6KMtKCOuIx+9QF/TI0oRryeGCuxManl1BPHlwMkQUZ2/MqpOYgPwXrgdSmWLOkcva7NJQbXuhW96cGYz7ZbhrlCeH/L6RReleFN0JqTg6/DlxKCX58FC1hWOtNGFG9iFUFuIkMSdcJNTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911390; c=relaxed/simple;
	bh=dE70m9vMxqcxDFLDQ1hzZVu8qRknlnqRPTnCxnH9WFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ3+Gc8A452YW11NpI1BS6dP9h5GIc2vvAfXMTwgNi8kVDKNdNS7JHfZiamELxMuRgLHn8QnuoIozkNpiApA25B86xHOSBox+3Hp9GUzSICZRzgeOlOKbeOb1PKTlyP8qZiidiS+tlIBCr+X5dZ6P7XfIAQ5h7hhgDT15V+UvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bBvr2fzV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bBvr2fzV"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lYV33005218;
	Wed, 5 Aug 2026 06:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VzXHAc99PQ8Pj4WEG
	R+XDuOXowi9q0bk7CdO8SzPF5w=; b=bBvr2fzVxG7VA/gr6N5kW73fFSkUZdy3w
	ES37ze7Sh6oezBRZfNTaddg4bfVNMGXNzD9R3TrR6yRRCIORrN0lHVdkAXo9z4Wl
	qGX53qlIfDlsEFUq5txbMLPJOEzdSn0acMmDHq3e014kplWkAv8HsRorA34vhZQ6
	PXMMyZfjeQSdd3W5aclT80vfTj59k3xX+KBBvzOhiUCS2r5SrmwPtgoYxDK1Y37X
	km7V4TOJxed2zY5kotIowyDXTW5Cfh9ayesLb1r8wH9rsl6uqhkUWkk8Hbyf1Ypo
	a06Jkk9r/GBKWp5YU2wzSuYg2txsKx7gqjDVTe+M9Zd6FsgQaCuBA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51n5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QGAE010624;
	Wed, 5 Aug 2026 06:28:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw5efh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756SnTn28180854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 049582004B;
	Wed,  5 Aug 2026 06:28:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5CA620040;
	Wed,  5 Aug 2026 06:28:44 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:44 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH v3 05/11] xfs: Add RWF_WRITETHROUGH support to xfs
Date: Wed,  5 Aug 2026 11:58:11 +0530
Message-ID: <c284da9ae8f72cea47dfee7bd9f28a270c31a08d.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXyUXErExjDlHp
 OAzHyx0JKN6qnQycvqT/PyoGvF9V7PEaZz4h4Rcmaw+gYn9mtrAKNx16FIk9QAezB/qIt/RLUCR
 0KYjQb2r7nt3i76wT8kWCVm6f+hAfe8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXx2mb1u2yBckF
 QvBCvASeyp1TFd1xJ91Jg5x/aDeBvE6+lTTUxH9uoZ6A8SX00EsAQJC4/7AXNje1DZo2LsFV215
 vcfU/w8rnJV9qKiRtesVsSjYBYtRGqLHiYdMRSwTKSvioPwgTK6XJiXce72pNU1D5MskyJm9/vV
 ixFWSxdUYt+2unXDRn9eLdAGZTd2Xkj+r/w5cgWnV+luRGB1wKvnSRbWbXIwOQW+Vv3l8bh1CBg
 68VLO+s9oxvoBUbZABec3eAj2GmceULkTOoUEdUjWuU+z8558Bpo7cmSXc4K27wkVIhnNRst8M6
 cb56tJlPrLlLnuO4By1f6YNIXWNzPrzlN3GfNwqYz6MVoch3U4fv6KTUEQmAMXGa0hpSmhvZhCC
 IiL0mz2hA8lORb5tneGJ+Dl8PFn72PSfzh0oyPuv8L160btCnOquDboV/maPXTmEgO2fqjBW5dl
 otHKReNq9jXZFzde/Cw==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d825 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=FqVmevUCyaZ_8sojNSgA:9
X-Proofpoint-ORIG-GUID: zKijQG-cOKQ-oHjO_FM0F1bT9Hs5a1-B
X-Proofpoint-GUID: 3uEF_eBIjDI1ffaCKDAAxBebhYLDgGk0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

Add the boilerplate needed to start supporting RWF_WRITETHROUGH in XFS.
We use the direct write ->iomap_begin() functions to ensure the range
under write through always has a real non-delalloc extent. We reuse the xfs
dio's end IO function to perform extent conversion and i_size handling
for us.

*Note on COW extent over DATA hole case*

In case of an unmapped COW extent over a DATA hole
(due to COW preallocations), leave the extent unmapped until we are just
about to send IO. At that time, use the ->writethrough_submit() call
back to convert the COW extent to written.

We initially tried converting during iomap begin() time (like dio does)
but that results in a stale data exposure as follows:

1. iomap begin() - converts COW extent over DATA hole to written and
marks IOMAP_F_NEW to handle zeroing.
2. During iomap_write_begin() -> realise extent is stale and return back
without zeroing.
3. iomap begin() - Again sees the same COW extent but it's written
this time so we don't mark IOMAP_F_NEW
4. Since IOMAP_F_NEW is unmarked, we never zeroout and hence expose
stale data.

To avoid the above, take the buffered IO approach of converting the
extent just before IO, when we are sure to have zeroed out the folio.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_file.c | 83 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 768cabf6250b..4b45ceacd461 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -702,6 +702,36 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
 	.end_io		= xfs_dio_write_end_io,
 };
 
+static int
+xfs_writethrough_end_io(
+	struct iomap_writethrough_ctx	*wt_ctx,
+	ssize_t				size,
+	int				error,
+	unsigned int			flags)
+{
+	struct xfs_inode *ip = XFS_I(wt_ctx->inode);
+	xfs_off_t offset = wt_ctx->iocb->ki_pos;
+
+	if (unlikely(error)) {
+		if (wt_ctx->flags & IOMAP_DIO_COW)
+			xfs_reflink_cancel_cow_range(ip, offset, size, true);
+
+		return error;
+	}
+
+	/*
+	 * writethrough completions are handled same as dio with the exception
+	 * that we need to explicitly change the i_disk_size. This is because
+	 * unlike dio, we have already updated the i_size and hence the
+	 * (i_disk_size < i_size) check will fail in dio code
+	 */
+	xfs_dio_write_end_io(wt_ctx->iocb, size, error, flags);
+	if (offset + size > ip->i_disk_size)
+		return xfs_setfilesize(ip, offset, size);
+
+	return 0;
+}
+
 static void
 xfs_dio_zoned_submit_io(
 	const struct iomap_iter	*iter,
@@ -1033,6 +1063,39 @@ xfs_file_dax_write(
 	return ret;
 }
 
+static int
+xfs_writethrough_submit(
+	struct inode		*inode,
+	struct iomap		*iomap,
+	loff_t			offset,
+	u64			count)
+{
+	int error = 0;
+	unsigned int		nofs_flag;
+
+	/*
+	 * Convert CoW extents to regular.
+	 *
+	 * We are under writethrough context with folio lock possibly held. To
+	 * avoid memory allocation deadlocks, set the task-wide nofs context.
+	 */
+	if (iomap->flags & IOMAP_F_SHARED) {
+		nofs_flag = memalloc_nofs_save();
+		error = xfs_reflink_convert_cow(XFS_I(inode), offset, count);
+		memalloc_nofs_restore(nofs_flag);
+	}
+
+	return error;
+}
+
+const struct iomap_writethrough_ops xfs_writethrough_ops = {
+	.ops			= &xfs_direct_write_iomap_ops,
+	.write_ops		= &xfs_iomap_write_ops,
+	.end_io		= xfs_writethrough_end_io,
+	.writethrough_submit	= &xfs_writethrough_submit
+};
+
+
 STATIC ssize_t
 xfs_file_buffered_write(
 	struct kiocb		*iocb,
@@ -1055,9 +1118,13 @@ xfs_file_buffered_write(
 		goto out;
 
 	trace_xfs_file_buffered_write(iocb, from);
-	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			NULL);
+	if (iocb->ki_flags & IOCB_WRITETHROUGH) {
+		ret = iomap_file_writethrough_write(iocb, from,
+						    &xfs_writethrough_ops, NULL);
+	} else
+		ret = iomap_file_buffered_write(iocb, from,
+						&xfs_buffered_write_iomap_ops,
+						&xfs_iomap_write_ops, NULL);
 
 	/*
 	 * If we hit a space limit, try to free up some lingering preallocated
@@ -1092,8 +1159,12 @@ xfs_file_buffered_write(
 
 	if (ret > 0) {
 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
-		/* Handle various SYNC-type writes */
-		ret = generic_write_sync(iocb, ret);
+		/*
+		 * Handle various SYNC-type writes.
+		 * For writethrough, we handle sync during completion.
+		 */
+		if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
+			ret = generic_write_sync(iocb, ret);
 	}
 	return ret;
 }
@@ -2104,7 +2175,7 @@ const struct file_operations xfs_file_operations = {
 	.remap_file_range = xfs_file_remap_range,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
-			  FOP_DONTCACHE,
+			  FOP_DONTCACHE | FOP_WRITETHROUGH,
 	.setlease	= generic_setlease,
 };
 
-- 
2.55.0

