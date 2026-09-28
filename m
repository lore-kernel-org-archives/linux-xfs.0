Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CED4BA9E5;
	Mon, 28 Sep 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597070; cv=none; b=JvH4oGCutTzA0k2fPyGMpZs8hJfC0YRC7LvtH0WMiPu6GQpOTtEMQcfW714SZBgZbGLMAAytAuCjnoRrG1ooq8phbvV7luS9aHrPwc9ZDu2rcl9szjNqGyDI7Td0dngZCePzE1IrRAKo6iA3kS/4gk3D3X7ZmbNHOl50mRxC2rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597070; c=relaxed/simple;
	bh=rXsF90viXVgOz1/Wx72ln1OcuYcA8Ab69KKaJJQ6GwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULKjIR8Hv6Dagj/EEhoeyqjKIWgADI1r0tcWp5amAus/UoiOARGKbzGCANfkuSCAbiKPGviZnyQODVby66YlKcy0GkxfPs94wAIXDNhXptPqsS/3sZSYm+DdxwC7Tp2Sv1K1zDOdLxM9VnE8/kGX5jKZCikrt/Xrhi/mQRwl/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qLsefK9v; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qLsefK9v"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZr193971561;
	Mon, 28 Sep 2026 12:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LT3f4XRZksSdTsVHY
	WJOEFX7OSYqroFmRxpRhh33NrE=; b=qLsefK9vM4872bI156YxKSXMljUOV9sCV
	NSB16bhUBfhrgQXmln4HgsDL7kcuvwn1Pd35a85Z0D8lW1viTGl97u2++Q+/iWeo
	U6VjcaA18dAbndJZvMLtuPx44dGBfy13jTcZMGHbVOjVX4wMWmCvZGH3k3MRqX6j
	De/H/g+s+1yKGoqefBVEwV8h73hpMv+sbdU5UYns/CnLXB8BZOmJMQYgnvMDNkOr
	luPqcqTzAr5LX7bj9SY742jMn0kzBP8brT7zm0OH4JFMyR1aqM414IZSbnflwyCN
	rR/ivS8rGVagmT5yK3U6PrIkgg1x2ulm1/+aE4bsPS7xgwKlt7Rbg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe0v55-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBI3pm076961;
	Mon, 28 Sep 2026 12:03:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsvhd1km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3snm41943526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 784352004D;
	Mon, 28 Sep 2026 12:03:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1870D20040;
	Mon, 28 Sep 2026 12:03:50 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:49 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 06/12] xfs: Add RWF_WRITETHROUGH support to xfs
Date: Mon, 28 Sep 2026 17:33:07 +0530
Message-ID: <d4bde7d19c5da922cd7c378db269b10ed841f93a.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba57ad cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=blzBfGsx_J9-v_-YAw0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX5P0yjgM8rqh6
 ORVkjxomZ3sBqU17akCWVDst0ZLLBUbd0jRDTdwlMapTx+D/8BBnNLwPUzIo0k/WZffspGLPld8
 mBIXgSAmclVbLp9XcF7qxJnEDvV2RYo=
X-Proofpoint-ORIG-GUID: DZk_I_kyeBKCo2l0F_OfYqAoSxSd5f-C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX2XV7XpGYKeTI
 wJi5VN6dcz6ZblezOBa0PFlhwT8U63YGb1TsXrrxVa1BVr1w3obM2J707uNOpbQZm2236V9BApS
 PFaF909oHB9V+MLwNxCavHdP9KbP8IBeZDFB5nnpcNyU+m69oxqAA3pfluUCSEXSimipsBHRNmj
 TdRDfHmEroW4saH1jO5cSw7gMYwofoFyddgTlMsAHWNGkW/dbRf0oijRSy1h2AQB8oGYaeiaV81
 YdjruwgFRz3iRbcdWqrCkNOD+IqS5IEAwtIZnbeX/hr5xxDPXdV4xFvftdgr1k0FflJCtMLT+Wf
 3pPJ3maw66KoAkLJOhG9ZKY0aho+3wq/yMh0q4B8pVuOu1VSiN/SqD1i1zno2W8UU+F5yl4Fctp
 pcdzkAc7vggFdGaDWeuYtxLxumuF1sFN7eIUksBJZMTA+o5H9jBuwOxSOcEGKQ1qGDV+fm7UCTA
 drZ4Gs4UVIzPNZmOtRw==
X-Proofpoint-GUID: 8YDeIOryvpKSmv4BbbRRhrop-o2RCNUf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046

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
 fs/xfs/xfs_file.c | 95 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 89 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d53a329b6a58..3e25baca22c2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -690,6 +690,48 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
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
+	if (unlikely(error))
+		goto error;
+
+	/*
+	 * writethrough completions are handled same as dio with the exception
+	 * that we need to explicitly change the i_disk_size. This is because
+	 * unlike dio, we have already updated the i_size and hence the
+	 * (i_disk_size < i_size) check will fail in dio code
+	 */
+	error = xfs_dio_write_end_io(wt_ctx->iocb, size, error, flags);
+	if (error)
+		goto error;
+	if (!size)
+		goto out;
+
+	/* Fast lockless check similar to how we do in buffered endio */
+	if (offset + size > ip->i_disk_size) {
+		error = xfs_setfilesize(ip, offset, size);
+		if (error)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	if (wt_ctx->flags & IOMAP_DIO_COW)
+		xfs_reflink_cancel_cow_range(ip, offset, size, true);
+
+out:
+	return error;
+}
+
 static void
 xfs_dio_zoned_submit_io(
 	const struct iomap_iter	*iter,
@@ -1021,6 +1063,39 @@ xfs_file_dax_write(
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
@@ -1043,9 +1118,13 @@ xfs_file_buffered_write(
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
@@ -1080,8 +1159,12 @@ xfs_file_buffered_write(
 
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
@@ -2176,7 +2259,7 @@ const struct file_operations xfs_file_operations = {
 	.remap_file_range = xfs_file_remap_range,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
-			  FOP_DONTCACHE,
+			  FOP_DONTCACHE | FOP_WRITETHROUGH,
 	.setlease	= generic_setlease,
 };
 
-- 
2.55.0

