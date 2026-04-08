Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA83D9037;
	Wed,  8 Apr 2026 18:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674003; cv=none; b=ScjP9Tk/ARv5pY5fI7mp8KjWVdlOfLHVtLhqdn2cE2jqf42c0DWcGraR7cT3XUVWvdFROETyi3WxdA9her8uYiIKTcC2BWPr6TMsWOqYZlIquQnxP+HEi4yHwJOqvRvsKSRvmbxUBUKbC2oxRYaynC85Vzcuz3yEE4V3dV8+g5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674003; c=relaxed/simple;
	bh=KFf5G4dg0UA/kzEpgKk2F9MtHgKbbl9t3yAzS/f9yng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsExNwCGtILt8j0fWuihtoUiGKdV/MEASVAe1rZ8rwTUYiUhUaRkz/xseocV8khTlOzrAWjo9NQ9fX/FHiXc8dprlPUz8oO0s5G4GdtjMjikZHhLVjM0b0E8W6G4CvkgArFq9MumtGWSf7cepNXQijMJ4eqQAgJ94DyEkweibOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RzBJYlpS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RzBJYlpS"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638GvXtO2326654;
	Wed, 8 Apr 2026 18:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GWsab/zXI/rmB25rg
	T+Eersuw1LHHRUH6P1t+A9btZc=; b=RzBJYlpS9CmDoLcJMNoKlevCowfW1u5y3
	JSaRns3FRaG4L19pcZLCC88vhRiKCJ4kxWSKxGxwvP5GZgZKDq4EqByfzM1anhWw
	b1YTjcXIPO4nekgI4SXrEQUxcsPcv8vZ/WgohJbyripVErYh98nLAWypP3klhw7e
	4p7lE4O2JRKuC3yiiBtW7S1lV/2dTHbciyYPjqjEYcOqUbQi1HunCgogEQseVLdD
	hM7GgaudpgJqHSExP7C2ryBtFtwxLoaso307U51nUbBKFYG+KbUqoZiviQkJ04Ix
	poBe/KHVV0+sZjFMiaHldBbGhmgk+4SvHFOsmVDOyGZJVHipEdsxQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kgvhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638G1gW4013902;
	Wed, 8 Apr 2026 18:46:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf48kke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkJcf26280438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E328120040;
	Wed,  8 Apr 2026 18:46:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD0C92004B;
	Wed,  8 Apr 2026 18:46:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:46:14 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 3/5] xfs: Add RWF_WRITETHROUGH support to xfs
Date: Thu,  9 Apr 2026 00:15:44 +0530
Message-ID: <dcd7512fff636f9b150a0f0f5af29365807da305.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX+pY9KjE/O0wJ
 5Qv9InESbJrBOWCheiI8hacugq0s48jJEcYleWI4/o/GkI4fA0+1MVuBjyRutZl5AUfKqnpho4B
 2W5xO1DxAIzceQamJNMzBjlCkU+P/YUwoWOEXNRZsbLh2jfF6M/l2nKORMDlKO5xl0tFxVU176K
 bT7V4sQyLyxRzRPkLwVMw09albjnSnU++zTq4+h5URSazjBI55kLNboXDCy3UwvVRHDluYn7RhN
 5IsBmrwNyti6dmEUqbd3gjv2ZcyuOWsK1kpL2ElSwy+1dZ+/JrnFACNyyFZlP7ZxTZWqhMysffe
 u6+KN6DAp8ZbNJGH48/f9+dFhTIXvuDrczMN57y0VX0zs5WXzGRbQtwozqxEFhhpR2XR3k1yroV
 MgoZV+Pf3O07IZgI9gpJ+8kR2BCVZecluVKny4l79lfaCq3g/Myn7YThClfeQjq22zBqZzdKlKI
 8oQ96D0ORwSPPUTWS6g==
X-Proofpoint-ORIG-GUID: PB1ueZShDNExrGjC3ZrhskDNHCzfpFBP
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d6a27e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=F43LGkGvbWfUyK2stg0A:9
X-Proofpoint-GUID: AUBYMZn19w9l95TykjMhGGMIqiGzdvX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170

Add the boilerplate needed to start supporting RWF_WRITETHROUGH in XFS.
We use the direct wirte ->iomap_begin() functions to ensure the range
under write through always has a real non-delalloc extent. We reuse the xfs
dio's end IO function to perform extent conversion and i_size handling
for us.

*Note on COW extent over DATA hole case*

In case of an unmapped COW extent over a DATA hole
(due to COW preallocations), leave the extent unmapped until we are just
about to send IO. At that time, use the ->writethrough_submit() call
back to convert the COW extent to written.

We initially tried converting during iomap_begin() time (like dio does)
but that results in a stale data exposure as follows:

1. iomap_begin() - converts COW extent over DATA hole to written and
marks IOMAP_F_NEW to handle zeroing.
2. During iomap_write_begin() -> realise extent is stale and return back
without zeroing.
3. iomap_begin() - Again sees the same COW extent but it's written
this time so we don't mark IOMAP_F_NEW
4. Since IOMAP_F_NEW is unmarked, we never zeroout and hence expose
stale data.

To avoid the above, take the buffered IO approach of converting the
extent just before IO, when we are sure to have zeroed out the folio.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_file.c | 53 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..d8436d840476 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -988,6 +988,39 @@ xfs_file_dax_write(
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
+	.dops			= &xfs_dio_write_ops,
+	.writethrough_submit	= &xfs_writethrough_submit
+};
+
+
 STATIC ssize_t
 xfs_file_buffered_write(
 	struct kiocb		*iocb,
@@ -1010,9 +1043,13 @@ xfs_file_buffered_write(
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
@@ -1047,8 +1084,12 @@ xfs_file_buffered_write(
 
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
@@ -2042,7 +2083,7 @@ const struct file_operations xfs_file_operations = {
 	.remap_file_range = xfs_file_remap_range,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
-			  FOP_DONTCACHE,
+			  FOP_DONTCACHE | FOP_WRITETHROUGH,
 	.setlease	= generic_setlease,
 };
 
-- 
2.53.0

