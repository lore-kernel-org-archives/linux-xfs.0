Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC7470136
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 23:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207835; cv=none; b=TpffRj5jtryfZB5AKCQHXMw3cD5BKjfp0sQ5q3D+1loSMLEjY7zuAbU8oJu+G8Qssj4yWXtCopsAo+lgTpT1Guu503ORiVaUXOiVHvS1+w/h1GhlzBQ7rgKjVxeulyQvmoX+5IYo1gga0uyL9TRJN5Q71r6fDg7LCmaAibofHts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207835; c=relaxed/simple;
	bh=Nu/5r3TfT/Q/vsXNVUhqfpuzZC3aCtD8nZTl9rIbR08=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PZl8gT7rq//tyKg3vG/Sc9ph3ghnPmDQrIhy84Gz12KgEcHI3OFevcIuJ5fdhkiQbvOivdXZX8vplBzT0/hyg6LyYfyGUQ2sgpjckdvDuqF5d4H4dWpVuKUmHwL097XIa/KZ6jGuRCcPXvHfHDSf+QfAC7EcATcEjI6KU1aRKdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dHyNcdDs; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=w1o9YZEL; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dHyNcdDs";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="w1o9YZEL"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NNCdRH2170577
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3uhH
	QLJjfq0DoIJAX+Cur8K6P4W0lN4dox1XMY9jjcM=; b=dHyNcdDsw0mxu8q5hicJ
	NzTaUcTdarP0BPx5WFUkDegaaMOdP2Lrlxo2YIk6UNJxt/WxrunFt7PjJ+oMIig4
	aadw98a5ApMep0vwsAVQiJ/AUKeDSyGM2AzvJr9cUcmlz7G9yTZV0USzmgGov58L
	szLTEaCF+vFwp0O1uOu1h5+H9lX196sfxF+JPC6VSpEPM0365yzguTeOQ2vtBxbl
	oMW4mZkFLrF7gswHnUMGsS2i59EXswlwGE5/LQ1sBYgNx3GJ1eMZjW1ft/e1GEce
	zSWFaC/AydDGVKcYovjjI2p9hB/N/CJZl8xmW8a/VgFTgBFYhvayQFukawkxLAWT
	cQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gvmrat1jw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:04 -0400 (EDT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so1566496a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790207824; x=1790812624; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3uhHQLJjfq0DoIJAX+Cur8K6P4W0lN4dox1XMY9jjcM=;
        b=w1o9YZELBtHSwbFNi4z8wFyQ77ZO2wf6B465myG5lFffQmLjmuk2I2LJs8WqOWQca9
         Y92RC8mjTEATcv9Dhzr87WTFB/acjwyqSZ77MTKRA8Ah0bPvYBsee3OBrNvYB8x1zKIY
         RLSGbKkXK2Th2vETILm2prN3J7Hb/Yqq7ZlToGHzYsoLR3PC3I7SpzpWKCsulSNIK1M+
         P/U6qJas10oF8hNIPqBh4Xcj15m4f1Pj3WLa5mDinDiWVbBugj9XrzbbZlWxk904UII5
         H+gwaqSoeH6A7VUC4REVpHaShmr/ZxNc4u4zob5/P5pODbKQDq4/tjviKzYbM4QCDGit
         ny6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207824; x=1790812624;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3uhHQLJjfq0DoIJAX+Cur8K6P4W0lN4dox1XMY9jjcM=;
        b=D9t+vPQrnp2mxS4eV4b6cIJCumyiaKv0DHwPx0R3CkJpVuX97+RaNELQhHs82iE5Mt
         WOoIQZs/vFYHYQokQ/hp3NtjGveIF/b9sxD6eE2PHMMhT79HYlATjy30Ntd/Q7c69d/2
         hcbb3PET6y+fVxP2jG+HnKZzTa4gOkPgR3jQeBlqVc8JhoOZmejKpkcmJf76iCNsNdf5
         f0pW9O8JqAZEnB9Ug7zlUppJdx/TFaqBoS02xCXiA6TjlF8j/5rvFbwjMwO27hE+KAJf
         itAtJNOfKasl6Rj90et7iG2+/HGq9ipyfuyc9PoSd0gNxhk1e/4S2PHW6WC00xrLpkOP
         +ZCQ==
X-Forwarded-Encrypted: i=1; AKwUvBzpZspFOi/TcDJU+TdaOMZWzwdWjt8P2XkjrMfPgyR2TDEpAoJ+GU5Xkj1cEr02bpCUb22Me8y7u/E=@vger.kernel.org
X-Gm-Message-State: AFuF++k97OCYUkA6Zva+pvUI8n+avTR2C74CmO0i5/pw9WYIuZwuE6Tl
	ZMU89VNP3wrMs8RndRn8MBxmJZKi343KJOC8+QywTHsNz4umU1CIRidpOe1STt2vYf1QxjkAEBb
	18AZtRQB3k/mfubL7BX594KgsyM7kuYtKU3Canf1Bgcei3YOO8/j1PvZfDytqSvyQIw==
X-Gm-Gg: AYBFou1yrEbW32FJ5/Qy2vSybSeEd46vwYrF4q2fxbSZzwq5MjfP1Phxv2kSRece0o2
	2H5WQ9CuyjeifZms/JVybpHiikyJo4Ufj0pAR8WB+US1F2r2XFKGsoO1qD3QL5pKJ6iKfMkDzjt
	9/n8dkLfNILk6/+cUfULZ2Zy6ukOKAak1GPzMnxtivm6PYFlGwqVeAYY15hh6rW1LtDcmHQW1u9
	xNRfX5/kPqE4kGhdAkkfxtdKPiB6yPo9qWg55hjB6aO7GwRMAcpdP6mnObc6v2NNX29goev4kxm
	NVT//kKG3zKX5kZfjwOUDHIJnl/IrpmrnD03AQgcglGlSPU/THZLP9Pu43trlBkS+ItlwAFlWfy
	WfQorpzzcT+3D+WZDZIu5dL/pqJXhmzhaJ9Z2y89yIJ3naw==
X-Received: by 2002:a17:90b:52d0:b0:3a0:903b:f254 with SMTP id 98e67ed59e1d1-3a0985e68a2mr574539a91.15.1790207824156;
        Wed, 23 Sep 2026 16:57:04 -0700 (PDT)
X-Received: by 2002:a17:90b:52d0:b0:3a0:903b:f254 with SMTP id 98e67ed59e1d1-3a0985e68a2mr574518a91.15.1790207823749;
        Wed, 23 Sep 2026 16:57:03 -0700 (PDT)
Received: from [127.0.1.1] (RED-LION-HO.car2.Seattle1.Level3.net. [4.53.155.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976ca5f9sm1331613a91.14.2026.09.23.16.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:57:02 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 23 Sep 2026 19:56:39 -0400
Subject: [PATCH v5 6/9] block: don't fall back to buffered I/O for atomic
 writes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-blkdev-fixes-v5-6-89e60d66eb38@columbia.edu>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
In-Reply-To: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        John Garry <john.garry@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sashiko <sashiko-bot@kernel.org>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790207813; l=1775;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Nu/5r3TfT/Q/vsXNVUhqfpuzZC3aCtD8nZTl9rIbR08=;
 b=DXmB7fQK9D2lfhFBOvF3+NbMxz6a5uoj8VE/L3TXgOqQFNw4KwOJzMuRHd3rufj/AV8xliIC+
 84FjyOzp3XiAKHWIVKzOaQ7t/WKZ4kqDrpqIzo7WfN8pRUhL1j5MjIW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX2+vPF75S/Cri
 ruQzTiGERJoF6TZ8CEq+Y4t/S0S9UVvXxR/s8drsCKx6lsGlI2mWwUpkrC7C6i7aOCsfrj188pR
 FdtIE9Kwg3MS1em+1CZmV4wdSJ+z3wFjOhVNY00GmxONCK6VrKQA
X-Proofpoint-ORIG-GUID: 6wMH6MU2ai6LA7eAQsToT4cmJUyjfbkn
X-Authority-Analysis: v=2.4 cv=cPp1IVeN c=1 sm=1 tr=0 ts=6ab46750 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=6aZ3Ysb2zzbY2sELL/OBJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=s8mzj7eOnaliLhoSWqYA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfXywqFk0lG+3nB
 LpaFkPmkm2cfWHSLK/WnPMhmDQrRln17CTHe0dXGSU+Xm5OJH1uhRTUmWrwNG0nXNZGy38p2jOd
 ByNJ1zKwWfNi5mviR9iT2b7LwwfSzM8vl95ZeV8YKZ+geK51BcXGq3wk45zNR/U/TdoDZgQH1DE
 TBEw7kd2eDXK1JRo8d4JZLwKooZu5x5dMdkZ1ZQG/g4/EtK1/bfihWOToPe444XFzxpjh25U2Bk
 6pxd3MUwCoLEZFaD+wZwF5VEbapDlp3hgZsAxxEDO/ZbCNQZ5GQoXdpOdtVJiUxLeIWb+BGQL2N
 GvVMR3PTnHw/9ZwqPJTZ2RUVAD10Y47hG+q+DgZkJARAPlT1JKob+hQpk8hRN2hXHGPRhFJpkij
 Ny9Gz9OqTwDYJaFFUiUiZlU6cFuNxNW58aypPMfulZvxJK3O7Scld3ufA8YczxyXea/iNn9dt96
 Fb0yB88vc6FwFYfQVCw==
X-Proofpoint-GUID: 6wMH6MU2ai6LA7eAQsToT4cmJUyjfbkn
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11914
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=10 priorityscore=1501
 adultscore=0 phishscore=0 bulkscore=10 clxscore=1015 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230100

blkdev_direct_write() turns an -EBUSY from page cache invalidation into
a 0 return, so an IOCB_ATOMIC write is retried in full through
blkdev_buffered_write(), with no atomicity guarantee.

Skip the buffered fallback in blkdev_write_iter() for IOCB_ATOMIC, as
it already does for IOCB_NOWAIT, so the -EBUSY case returns -EAGAIN and
the caller retries, matching __iomap_dio_rw().

ext4 has the same fallback and only warns in it. For block devices the
fallback can be skipped before any I/O is submitted, so fail early
instead.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d143a664c770..59af4e808204 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -771,10 +771,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
 		if (ret >= 0 && iov_iter_count(from)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_ATOMIC)) {
 				/*
 				 * The buffered fallback blocks on i_rwsem and
-				 * on writeback of the data it copied: return
+				 * on writeback of the data it copied, and
+				 * can't provide torn-write protection: return
 				 * the short direct write instead and let the
 				 * caller retry.
 				 */

-- 
2.39.5

