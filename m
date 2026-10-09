Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2864746EC99
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564633; cv=none; b=StmrMDtD2bZl0ipHaekytGEZPwBF8pmhsL42mK683WxFopMCUJt5ouaxkd1F2IBtsd/ZSAZ1X64gepX9v8lqgLw3e9C6OkvUKzgVm4a+byuPVpapBbuvgCE/JxTBYXUjABitNXiNgJNkIdIhVQuLXtBnwvvwqLFnpptlJDdSZfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564633; c=relaxed/simple;
	bh=TjEmrIwoDfGD/tJl+VVnQl6XHOIQk68grd/DlzMzZsM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JeQobDUPk5gaiNkzFk/CNa8f7hYW88+glvrRMNejQbQzlP/Y6cm6aaHCaPq5QqfUZFsovwVoOAZIYr/ub/WE0rj1FooIucsu3a7TZNp/4hhL3AgCVJXpFflwyAxYEQOro2jVvtE3zLziiMdaNLFvG4N5lpIGa8PKr8nGfg5+yHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KjFOJMlh; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CGM4Tlkx; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KjFOJMlh";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CGM4Tlkx"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYdCM141711
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=YGcz
	I1vSHasliXD66Zjo2T9yKyc6ElYvYCgnRIuVKQY=; b=KjFOJMlhN1+3lGbf0LpR
	No0/4aMtdq6WbA9PKdTRS6CMrn4lWqPrvC1gWTjcPwgDef0/tKi+mSIaD2u6FKBk
	T77LqQcgz4L4VAoTaN+/A5QzTj9LiSAhoPFNAqfc20Rl17rRJKt/UzSkJOkpCBCx
	EMza0toduGjnEt+5u2FLIf8zuRmUgBaziKPWyIKnb9uuFmV0UavqGGtwnnqJyrOm
	DVyAzCGblDPduVqjQNzmnyhIIo+t/F33HJtPdv9ifFMzW+tLcEiJJQvMUsK4XQXw
	vIRGcd9Ka/4v+2JBYuc7nEOS68OxSRaQ/B3XzVOE0Vfo82ov9jp7HmcNOYpnDXoF
	4w==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h6xqqu28c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:31 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5338c59f90dso44084811cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564630; x=1792169430; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YGczI1vSHasliXD66Zjo2T9yKyc6ElYvYCgnRIuVKQY=;
        b=CGM4Tlkx2j9os9joEuyGTQXgvVrYq+mU6PiOkIAOWt/YTk4w9amjaoUHmFj6TC2zlP
         ohYem+p7w1Ju3WJoAUPjZAcijzgRAQiLez0//kOwBFKd8gISJAfons9PWlt8o+qPYFYa
         Fi+5UyW30YQZi0qMEEaQeoaMyG/eZ+pBAT6JZL1LP646c7rmNSAu+VOOZ4/8TbUvX9VL
         l4ByKCTO5JFbwglm0eqgsXfpa3FWYhMPdQE3AgnHyIp7A0/tt5n+Qt475Es9MLgUfTHD
         F/tHpIIWotmK+/UteUhL8qw9UmPfkNt9CiXye0+kjaZt06zYmLVHlQDs9yNni0ghjK2g
         m4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564630; x=1792169430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YGczI1vSHasliXD66Zjo2T9yKyc6ElYvYCgnRIuVKQY=;
        b=PryvC2B7ajRNYaF4DZFZTAeKSprM3M2WY+N+kUf3LPDjtNkRLUw16XZKtP8c9dThcs
         k0u4kLunU69L+xMyCUh2xaKMiRRtbQO/GLiDUuRmZ/Jrlh/nglRwsXdQofjD8VZsNZm+
         vBRH08i+vzqRlznwMVM0iuyrk5wkm97RfZzK0tB8FF9Ku2sYpYAmXBRhIlTOEBDw5yIu
         3he+XnFogmTlIm+oJNB0WU/W40Rjr/4flShKjNO/1bbjqWFVEAJelZtLQome0k6BfR1d
         IQ/VuVVCIIJXHjkpHICw8fuDy9t2doEKwKUFQMmFXaSyY9e7tXlRTKlkd/tD6Y6q3JQt
         qybw==
X-Forwarded-Encrypted: i=1; AKwUvBylIWhtPUuMD1RJYasOxYM/+yDHta15dbCBtHgB9Cdxb09HlbZqnXeJlLr/cTpWlQGR/siwdC6K7Lg=@vger.kernel.org
X-Gm-Message-State: AFuF++npxNk2ECHzAWHRfKQEed7kemv1xy6iG/rJGq2lqunkUMTeO1P8
	qDYs/6uHmx3Y5OLTMICU4GCzPldOjG6zZNUC/wt0D66aOtfjdDKU9URxlsBvKStD57dj251Lj2V
	leGLBUUaxRPZ3Kr2c4BTYEm8zc0VPcBXxZU/vSVmKiKA2XLrq7DgCsekFY1BdjRIaWA==
X-Gm-Gg: AYBFou3jauWQi7S20Y1/GUzMeTQMBEWvI9VYLOPiXGNgJ4rPh7UBjS5YJ4fHrCBUzGL
	KOV/D4rE/C3Z6UmlexBxHjRoh4oZmu6BX5x9hnyRcGK1btn13P3fTA61zR4HzZRhfY3ijBmvIXw
	3INCtcgttl65X5PoSlwMEHUzetGrFQQK6q5uEyoHitF42MaR7RNqRbMvCp229B6X67xiTfACIAe
	tCv5JB08VSgWy6zGAZIkfCBJRDGztBQYde8Au9ZCIGh0auaaXTwj7c1X1w/UHI0+0AZA12vigyr
	qecRX1boEyhqV/wd3M2byk8Of/PO3Fe2WfsOWUx84L6WRgEt+vTruiQJRT/vBOKB9DfyiMcv1Mc
	Qgwy7vjyRURioMHFP7r4CES/Bbz59sca6DM0jMkhb6SYLXWc=
X-Received: by 2002:a05:622a:1b03:b0:533:3274:60c with SMTP id d75a77b69052e-5359dd26620mr40806121cf.29.1791564630467;
        Fri, 09 Oct 2026 09:50:30 -0700 (PDT)
X-Received: by 2002:a05:622a:1b03:b0:533:3274:60c with SMTP id d75a77b69052e-5359dd26620mr40805501cf.29.1791564629868;
        Fri, 09 Oct 2026 09:50:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 09 Oct 2026 12:50:17 -0400
Subject: [PATCH v6 9/9] block: remove dead metadata handling from the async
 direct I/O path
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-blkdev-fixes-v6-9-307939c387df@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=1396;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TjEmrIwoDfGD/tJl+VVnQl6XHOIQk68grd/DlzMzZsM=;
 b=kyR/6+0uUpySOm5+kLC7PnMLFfMvdbxJB3gn4ywQjE3A653IQAONvgDLa5uwCFOb8cb81Gxki
 mgjkL5Zh7XwBFha5mPhJAYuM10mgmerANhTN+Si/GE2JLVdD1jnvnyH
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX90XpKzA86uIL
 L11GCxIZ+3V6TEXFuR/rrR93BRnMRTtTS3Vm5wtmqKoOW1Wjc1bPMtoZnl734DpHPkMLm3raz9H
 YoRyEhxi9L87i7ld1eqQlLYxR2/ggmzSE0GWwM0c+oezJBamXK0S
X-Proofpoint-GUID: Z1ZfiE5SvX73Vgd_lSrfGxp0LQFEFNE_
X-Proofpoint-ORIG-GUID: Z1ZfiE5SvX73Vgd_lSrfGxp0LQFEFNE_
X-Authority-Analysis: v=2.4 cv=I+/w19gg c=1 sm=1 tr=0 ts=6ac91b57 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=-GSYpVTsbc7fiOcD5ogA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX+TlY4BlB52D7
 kM2IAde8fcc4LxR5Plc3ZyrYH1qZfbMR831plWrMY7/zZqkWjV2ETTMmiZuhvdCbHEsZOi8dstK
 mAti2ub8lfrcqyH/87RG0ilYG4QDyVLQvEBTfkj4buNb6qiALKhYMfM3YtdK9p9ffrFFVDpXPcS
 Sc9GnaG7z53yXnV4B6SYCCwvBHYwH9HhixDGITcUdwq6rW/P0SZJFNOJdtWnG8V/JGvO6dhO702
 7MTzhrYSqoWySEw2/AsYcxTuYxxsRXI+loeLlO10N64QGbXbLorq0tjd84UpVLtCkEKjPfOm8Wc
 MAdqvEfkqonAq8HkHIez39Zrx3rKt8dYamZ+14+qZFyJ0e8j+AisL/Y3DWsQ+qPJohvVfiWaTJA
 4CYT0x2j6ZYoCXzRw9yIgt4455K8DBhnU3z627Scky26ZFIGUUANZGMfjjGS3VM//fZPSbEhyfc
 L8WCsNjZvLWCcVAds3Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 bulkscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090067

Since commit 2729a60bbfb9 ("block: don't silently ignore metadata for
sync read/write"), blkdev_direct_IO() sends every IOCB_HAS_METADATA
request to __blkdev_direct_IO(). Remove the now unreachable metadata
mapping in __blkdev_direct_IO_async() and the unmap in its completion
handler.

No functional change.

Assisted-by: Claude:claude-fable-5
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 41fa0c663f77..f3ff4e62413b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -321,9 +321,6 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
-	if (bio_integrity(bio))
-		bio_integrity_unmap_user(bio);
-
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -385,13 +382,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
-	if (iocb->ki_flags & IOCB_HAS_METADATA) {
-		ret = bio_integrity_map_iter(bio, iocb->private);
-		WRITE_ONCE(iocb->private, NULL);
-		if (unlikely(ret))
-			goto out_bio_put;
-	}
-
 	if (iocb->ki_flags & IOCB_HIPRI) {
 		bio->bi_opf |= REQ_POLLED;
 		submit_bio(bio);

-- 
2.39.5

