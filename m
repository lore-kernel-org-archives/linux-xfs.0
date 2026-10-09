Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44A3B775A
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564626; cv=none; b=BUAavL0zwz+2VWNu25OhewNqiz70q3T/pPMtf81afJecWHGVuS+RZ0RoOL1NlSOzBpPBZ17w+ZhxeWVNE4UAWkqKc9K5nSyEFoyVHFfXW7dwctH9LbPuDLj/oRQDFfupjRblLzrtJhteU1BHm+bHvHToDJ0spnIvN8jf9oMq6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564626; c=relaxed/simple;
	bh=xdvTrLLNkhh/VNie1HKBr0I6wCWduLL9Lh+uwojAFoU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l2YHEUafF1p/lcTS9chl9qL4ZKpv7ySyPHLPMXjTtMaiYOHZzi9DBfPQOAi2vK8GeamTUt5hTl2d9ZQxzlDZFe0L76WnhLMpGMC+GgI72z08mgCjRURRW3V1DhFK5YRZAekZbm9SGj3MMfif9Ot3AHo3OyzzFT6D3IYK3VCKPNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fxhzHHvR; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ScxV2J5P; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fxhzHHvR";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ScxV2J5P"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYJbW541564
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=UxC4
	2J9hWjW5KsD4TB2Zh7izZ1X3VipEtKIilECW9Gs=; b=fxhzHHvRJYZRJLkIFrmY
	5T358/S67swKEemAYgjfR6piavFRpBVUxVXJfPLu0deYbmhS/GDsd6nV0qP0aYkj
	QUcveg9BBDg7GZfWd1ExfUBgwRj43iynQb2lsBYCfLylni1voW80duP27imsp8cD
	8ufToG31tUzxeH6A8D7dLS0HPhEKhaDelFFL/raORv8CywaLqtU+SQcgc+lvSFNj
	lTYtxCVEueX5AJ6lJY68rtxR4CliJFvp7WF7Qsxo3j5wWSLNh2vAbkhOwIKNMcA6
	iLcpkZLaw1pvt2YZ7W+yHaY6n/ercF27/Zc4MN4l2oQFt7HYVwj6483UcV/y9ZJy
	cQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h6y4w3645-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:22 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-535131e4c25so119663421cf.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564622; x=1792169422; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UxC42J9hWjW5KsD4TB2Zh7izZ1X3VipEtKIilECW9Gs=;
        b=ScxV2J5P0mQFZxK+NQDuuQt06+JnsBS5zzIarsyTz4UPrMIyGZD4+QbJJNsQDV7y+2
         jHuR+SRSR+Eg6SDv9daK58PbkJKSnmew7q3RghpSoudbsRE3K2QZlhKRU1b+y0wwoqxi
         9owITtq0TRSEMHvFK1TlR50v8V28Tt9NCV4pFSuSl0iTbxdpAAL2eC63Zeq2OUtmTwoY
         M55VqsEjhqALMibl9u4dyvYGdWfDoeJ+si0TbYf9LFJCpvPfm1GrC4xypQ5KHkm2FpEe
         ftnq0YzHg4u5E4cYRhkVsTTKJDzrMNu1VMRd2KeBVxDm0jfNVgo7i++EoqnzhkadEePT
         GH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564622; x=1792169422;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UxC42J9hWjW5KsD4TB2Zh7izZ1X3VipEtKIilECW9Gs=;
        b=DfD7m2V/I5uMZIoGJmNpgAHaRXdG5TUKJpJDSl/R3Ipbmw3yilfBUWFtPVKO7mOS40
         Y+WWrQJeuS+IdOuHyIrGSx8sxwBFtA5pCiwMfnAm7snoANPfFdAv/aAwXFF+ZA9dt4Sx
         rngGl0KVFo/r5jRG8ji+zi4FUodMLGza1Q1E2/fw4TYR0HW916wOV1lS1NFbbMrJq81y
         +rf8Z108EAY1Whq/1EMm0F8w0UE0rNJ3ZYcdWhidw3n5P9lVH4b7h0/9m449W+qb7PNj
         UuKWnkzIrZZOHyb97Dn/Kfa2cyUvq5lv6nj2yxmzz6Dikhv8nGwtFPxVUI4jRlWaYpGZ
         z07g==
X-Forwarded-Encrypted: i=1; AKwUvBym4H2KW7mPOTdJqMZdiQIZ5EIoiKiENjuM0149lOjgusPqGs8dWsX9dxQiAoIlICNqaVdK5tbm84M=@vger.kernel.org
X-Gm-Message-State: AFuF++mTF0Vy4CLmuCPykwjdPaHFmr7Bh8zwsTg5ZvI6suM9HPP4ayM3
	pRxV6T7dcJLCXezi52W09HWfPePESYwQTeQlSz0INVHTcKl8YN/RjaDDc955ybCTyeEAVDaEEj2
	d6Byx25RyLFT1HUkm09zmQZPpn8uR75+sU4WwVrD2tZY5SIku0P6vhgcU3w==
X-Gm-Gg: AYBFou2psZBsE9pXFZQSCF4gajd8re/o2jwd6dv4UbMrEC0m/LZGHHMO2npSMo+rObS
	ejO2vnBbB4WDHmS2Oc6TzxnMb/9KEHJj4Jf7D4WY/O3iurwX4BSAZ2QXEWoBLU6B/PBObYUql3D
	OwO0+SYBBQmXkgEl5ZhAyIPaJwgmbWLvni4dZnKVeidyVScf8JRsxl8stfJMzSHTvdC0w0d9uaw
	5pPP9DYrIVLfIwT82czlsQobOt5zbRJ+1VRzRrJlMlVnte1siGTzuCShoOp3rhw01qj0VtUD4XV
	WK6bUQlG8eG8ySWqxU3fNIz0aY5sN9iRxUxgkAaxBxzVk+kqUiOmYMKLtFY/tVbfgRIjC6+eDzA
	9usH0Wp5u8fIL3gdh8ILaQ9J4NCq3CgZzTR/WlKf8amJlXCo=
X-Received: by 2002:a05:622a:2483:b0:534:b7b2:6353 with SMTP id d75a77b69052e-5359fdcab5bmr34976651cf.56.1791564621951;
        Fri, 09 Oct 2026 09:50:21 -0700 (PDT)
X-Received: by 2002:a05:622a:2483:b0:534:b7b2:6353 with SMTP id d75a77b69052e-5359fdcab5bmr34976201cf.56.1791564621494;
        Fri, 09 Oct 2026 09:50:21 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 09 Oct 2026 12:50:11 -0400
Subject: [PATCH v6 3/9] block: take i_rwsem for the splice read path
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-blkdev-fixes-v6-3-307939c387df@columbia.edu>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
In-Reply-To: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
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
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=2887;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=xdvTrLLNkhh/VNie1HKBr0I6wCWduLL9Lh+uwojAFoU=;
 b=0DVWtwMl4wsi7+jJcHHGeA+AlLkkvxb6Jkr/lBvb7bzhr+NsN0nmUXaOJB0k5WE+DI+dh8rxn
 kNvPxKcALCpDFiKIM74BqIosqqq/ghwO5ckLKsjqEODWHtm4w1RaWls
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=UYHE26SN c=1 sm=1 tr=0 ts=6ac91b4e cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=JF9118EUAAAA:8 a=kXXCQoMOyz17bj_MZH4A:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=xVlTc564ipvMDusKsbsT:22
X-Proofpoint-GUID: firusoF-9Ql208NEEFlA0RYBkBk7R_ur
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX5h0tRCsossDK
 GBQ02jI4r/DH6OYGbNCtePWxuNmZBTqcfAzTUZDKjHKEJ6jEDKWN/xx0cPB3eR/U78Kr8c+vdro
 OEHNbYLP+MzBaPx41DUtaEvh1deKVOlENYiFo24spJXsjUkqtHD1ieyhFM2wGvxhCZyz+BFqGyT
 fL0ZBk6cj/MFErkCMwAYk7vyNitEmExXyvD0gWO9TySX3KFvaQQhg9l1LLLHEcyV4LnZ8AG1lNl
 s98RlESFTuyBsCYVYCMemIBRBr8iabmz2SU/DV6j3cvhUFfNHSxznA3xJJSFkGTUBF821HjlKuJ
 5xQ4i3Hkch+SqOtZ6KEA0a4z1lUL8fUpGnyn5+ve/YEq1AcHwUoTtwb10Cxu8F0REJTsxx/R2gi
 nf+t04N6Tvt0I7s9kT7iEW8pymJ+ZLOjM6lpj6KLiC4K1YwYsMqdEZ4toFVxjyg5qhM8zBiteJK
 GfNoVTOdIF50p2696oQ==
X-Proofpoint-ORIG-GUID: firusoF-9Ql208NEEFlA0RYBkBk7R_ur
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX6GV9VK6+1x8J
 LstFCnV6LX0QlsULb0Bdch+wb2rcs1I3zGIHrF+i7NJ2q0fvJsLRgF4FyNVHnPRFcFcY6XKSiEq
 j7Ey9rWo5x153OaO/cbCOWFcoEenE0C53qRkmutorbhYqkEY28nn
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 spamscore=0 bulkscore=10 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=10 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090067

def_blk_fops wires ->splice_read directly to filemap_splice_read(),
which allocates folios based on mapping_min_folio_order() without any
lock against set_blocksize(). A splice from a block device can race
set_blocksize() raising the minimum folio order and insert a folio that
is too small for the mapping. blkdev_read_iter() wraps filemap_read()
in inode_lock_shared() for this reason, but the splice path was missed.

Splicing from a block device while toggling the block size between 512
bytes and 64K with BLKBSZSET hits this within seconds on a
CONFIG_DEBUG_VM kernel:

  page dumped because: VM_BUG_ON_FOLIO(folio_order(folio) < mapping_min_folio_order(mapping))
  kernel BUG at mm/filemap.c:858!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  RIP: 0010:__filemap_add_folio+0x51c/0x570
  Call Trace:
   filemap_add_folio+0x64/0x140
   page_cache_ra_order+0x1dd/0x3d0
   filemap_get_pages+0x153/0x760
   filemap_splice_read+0x13f/0x300
   splice_file_to_pipe+0xc0/0xd0
   do_splice+0x6a8/0x890
   __do_splice+0xb0/0x210
   __x64_sys_splice+0x80/0x100
   do_syscall_64+0x10e/0x520
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Take inode_lock_shared() around filemap_splice_read(), like the read
path does.

Fixes: 3c20917120ce ("block/bdev: enable large folio support for large logical block sizes")
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 52ebf5bd1443..9c556bd08c6b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -883,6 +883,22 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+/*
+ * Take i_rwsem to avoid racing with set_blocksize changing i_blkbits/folio
+ * order and punching out the pagecache.
+ */
+static ssize_t blkdev_splice_read(struct file *in, loff_t *ppos,
+		struct pipe_inode_info *pipe, size_t len, unsigned int flags)
+{
+	struct inode *bd_inode = bdev_file_inode(in);
+	ssize_t ret;
+
+	inode_lock_shared(bd_inode);
+	ret = filemap_splice_read(in, ppos, pipe, len, flags);
+	inode_unlock_shared(bd_inode);
+	return ret;
+}
+
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_WRITE_ZEROES)
@@ -984,7 +1000,7 @@ const struct file_operations def_blk_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
-	.splice_read	= filemap_splice_read,
+	.splice_read	= blkdev_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,

-- 
2.39.5

