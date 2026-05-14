Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3B63CFF42
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 21:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778795531; cv=none; b=jVkNK+G2BPFQbmLI5UQJ6zCMzXfZnDT6lKnQlBuQiinOqP/N8N/QcddkJaQu/S14JqftMJFjZTPt80t525ephaPf00cx6Ra6PVdsMjTLOLtFFZgrRlhTwWMcNX0hvezLM3F63urkJS+DrhNFBmDGKoywTIN4+pWFYi/6p0pM+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778795531; c=relaxed/simple;
	bh=4kYnZvc+owx18DdRK+b0WjIntKdQQVbjejy+2ia87ck=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fZfJxaw2WMtYNdQ7h34ThmhSW3oalSL9uG2noBbz00cqY9VDnwrN10KJQI/jRRDWv4ymzCXXet6xxA5TbS/dnkz6/MT2XYPDSPdcwlXxquzCRdg++GTWsJ3535Q/lLAWAtI1DkKT0Fbv3kBUGkPOvtkEXm8I0ObxEiSgMU/nNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eZyHj6/o; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eZyHj6/o"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELhTsa3842419
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3Hr8
	xytd8pzj0HErDwC1OWfZgJX2Msw8AYmLwQIxWTo=; b=eZyHj6/o229FuGb6obFP
	y01//iQN2R10GEr4qVdWRAcKfbBn39iOW7pDeiamYsItYvBz9nE/Pon62/FrHbRT
	ca25JObOyp6I0YgF1LVja0LAoUrXTH8PN4c9FaJLVX4cocBvkgvr8P1/bXRUtYEU
	ezdeGP/xD8FpSO71pFPt2m+7sM8WNaM3qd7Ykfu81marJvVKRJ43F9LEndWsCW/H
	RNqSJjAMDbssaOoJUGGgGwOzvmON7E+wXPvY9wvASbmqJ2uqaCGwOtc7KTVgCX9l
	VxxXI7XPNFK0AnLfKFz1TVkvCMAgh/s6LpNCtKUT3llAjiwNjZdOQCTCQf/Jzy6W
	FA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m239nbg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:53 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-91207972031so26391085a.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795513; x=1779400313;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3Hr8xytd8pzj0HErDwC1OWfZgJX2Msw8AYmLwQIxWTo=;
        b=kg0lSUdPu1ZZXtNjk75SRAn0NYXmWeq+aRlcHDOtH/b8W+bLS4C2aydo5WfWbVyZY3
         mgbOIpVDI0M+n7h3c6mRNQyI8YrV9o83do+Gr4UqUXT1CXEY0nPbgvp8zHKA6SevGrai
         IdrU+gchQA+g/IwzFz2kl29l2xfGdoX/7+l69Zghk6sjVtEo/48yHmsuIuVaBmwaDVdO
         A8kJwZ1GLIgLJa698nomHiirHFIPkD4oxog0nCxKSQGBNUTXPnK83uhsmSlw4zJ0nYpx
         CfBsZ6AhmiZ/oVmzPovCIvZsnBYYxuGJK2ut8tu6ofzoz5C8wWr5aU06sYsNeKxc4pDt
         Eu9A==
X-Forwarded-Encrypted: i=1; AFNElJ/IH+XMBlUV936wRr/KYot5cU71rcE/Fy7GRxsQXYl6M1eyMp1AvFml5ZKiDg0LKRi0TsU7qMkunXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfALCNDj0hb+seqbN1I4yc3ociHTp2/4dW22fMPTYis1Do+bHf
	hYdVHJULbmoZirCYUBwkJkCJEgzpU/wtxQChJ7IbuCHBhFkHcyR9IgTYZdAxFIToWGZPDxahxGm
	3VTHOvgBo2gCiZ6p7oNcBlMVBnZnIPdYqf7d+jNpN/h5mpKPg0Jxoi5P9IQ==
X-Gm-Gg: Acq92OFl9vnXuHhuTPddWv7Q1KhJCZB7/onuB+OvQm4RH5s0iDPtGnOxhVcv1rT6Xxo
	sHwvZw8im2PDcuLC0yIgrOf9Mk+HaLSjoA7z2Hhh+cQm/nDruOme2a44o82oXnyX7fj3sZiRbsd
	ZamprxnCblTbafE38yF5vain1MRa2QkXsBOVyXjsYOW7Q8JsYP+8E0de1SU8V0wXsR5zkPrQr8I
	agnId+NqfziCp7Ix4hMiayUSqqSJfBBA85hBEczw04II7EATI8ofLIxmUwBSGxZ1SjUh8F1VtaZ
	5JifbYegMV4RFR7wrFrCAWGkspqbnDIfpA3UF4DSOBitHFXsfzjUO828b4ompiZNHL6o8lj3o0W
	hGSAi5Mc6i2PE9XAsqv0eF61psGvLBERH
X-Received: by 2002:a05:620a:2987:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-911d0c5d023mr239923385a.60.1778795513388;
        Thu, 14 May 2026 14:51:53 -0700 (PDT)
X-Received: by 2002:a05:620a:2987:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-911d0c5d023mr239919185a.60.1778795512909;
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:17 -0400
Subject: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=1606;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4kYnZvc+owx18DdRK+b0WjIntKdQQVbjejy+2ia87ck=;
 b=h/wC1HCfLFItwTEGisusw9jduZm6p1jTrRpV6ed4zqtg5o3ocYnG/8kC6WqedCRsxxH5uzIMI
 xkDRAyq8KAYA0Vpg3tuCs1ya2+fmJNNoRSOmfuMYQk5UpCQHPwkaVV6
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: AXBdP9gE_tjS3VnatJPBau1qu29qm6vd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX5JvlpMYLrsqz
 z5GTyEf4XkD1YGrv+N8/WN/i3jIwfgM4wmlOrazcdDLtPThMY7Puh9Z2SxQ39x56ol1//PWYzed
 Dt/16MdfXUwupyc/Rc5h0vOnMs3rdSF/049ZFQQ7H6bJ56csWs7qUKVOwspTge3FjUMQpJ/GHZQ
 PNYjrjWDrakt6sQjf//3ZG/+pghVqYX2D8XrjltV7E0+TIsUbvI51ah0UA46e++qR8/PiLhfM3y
 WfLlxrJt8IQ1KbKnzSA6iguox36aKgT+KyNE9sP+/3i+ti5Hi2pB+X1UGHaqMn7TW5tv+9UVuLK
 sDGx1gqx+J+KfpAn/6eWrxDmsDgwyWUJkVsBxeZ/i96cLQOshav9IPbzwOZgQQ1yQjQpPJrqRzN
 b+BByygNMCOikUaGp0ncZ60t25oXZeR/cu8rYls449VKzLkXE3dlpZ89M3ykHeTfJTcdMcPyNh4
 QjgCUXxf5FIon8ZcPlg==
X-Authority-Analysis: v=2.4 cv=PLs/P/qC c=1 sm=1 tr=0 ts=6a0643fa cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=hW3giJO2Q2g30DqAd_4A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: AXBdP9gE_tjS3VnatJPBau1qu29qm6vd
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=10 bulkscore=10 adultscore=0 clxscore=1015 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y paths, use block_write_begin_iocb() in
blkdev_write_begin() to thread the kiocb through so that buffer_head
writeback gets dropbehind support.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..31b073181d87 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)

-- 
2.39.5

