Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC03C4B64
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207819; cv=none; b=VU8kqmK8JSEJe5AMW7O3631jqVgYpEPJOHN5xPVfFYSNservryKvfslK4OShv7yEna5PxdO4D4kehSX4YXz5lReVn4ti2Wy59aaDbOSLPlqXizbO7pYEE2IfNqpJugHTd293QNN8HuRMbwBS0OuzUYVHjdUFPmmMn2dcm0cLgpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207819; c=relaxed/simple;
	bh=ZiNOz2pyWd1hztFgQIT/fMRIRaCBoVisPLEJjghb3t4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=BvAQQqif4ncD2Uw0NGfvcdzcOvV14hNcrl6eze3JLc2JMlSsUr+KAbiDE9ITBgQOQ5kUJVfE00NHdRg6C/VC1Gvj+PlTBy9x1WpeSgqMmLsOWBJ55nCLFMd+yax6vcYqLsfjjvr9dViPSB3J2jTmt6slgAxt1VIKLg1uEd7BHIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lXYn+KLt; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=hLi32EWP; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lXYn+KLt";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="hLi32EWP"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NNCNsN3593965
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=pPbYomhTT2HKyD1AGH3HV6e6wx
	tqMVr9ETs6pnPl2CQ=; b=lXYn+KLt9HelHuvKnghqQvbqXjjPzH6ZZB3ZXbEQVD
	JZBo4lKPY3KiJUIBDyL9t9jydd2B75JtDioJxMTV3eQ9T6qkX+sDv7YlIuMS7IZ/
	IHsKYv/39WocOkpjSamTjR1HOlMh78qfDoj7EwFTJtp3HnZOhMyXBxXZpOVMpcBU
	ND/L0AnVyA+a/YF2FucRzJNSc/yjHl+QwZJdRCAtDIdlK0GLLv6gS8i+UCVdcg6b
	95pvf2BYHmzZ+ClI2MqrLhY/soqBCC+kFE/AZxBHZaN9qR90Z0vhCatFDy02Ayll
	rdFMLmjVOHIVpDCRu4q26TgKIFHgkUnVVFPeX3wEh1nQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gvhw6v5h5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:56:56 -0400 (EDT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1263902a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790207816; x=1790812616; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pPbYomhTT2HKyD1AGH3HV6e6wxtqMVr9ETs6pnPl2CQ=;
        b=hLi32EWP9dDifTq99PNTFjZbzhqJCeBPSSvGuMG2540rFeyRfkwbTBvKoB0wCRDWKA
         MK/dlmF09jjLRmvLgUU08/rFdSFIuemH3xdUEkYQxjQ+En4TJOdFMFm8TIBpvy/kIvVQ
         3jTVHX/09sW8zBr7/7VB+pDy5VICvlQjQMpxXcaKkFJvowyYkshkFtX2FTa9udFJLnqJ
         yteLO7uBjwGXCYIR/y6O2J+x/dquSOXqNQz3mrsefC3HC74p3XtJMTjX93JtuRvjPGpa
         MTY7vLdGDJd449SNwnTxm2g+cGcYAW+9YqGc625eGYTWmxtvLXvEmyQAboekr7BwjKYl
         /33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207816; x=1790812616;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pPbYomhTT2HKyD1AGH3HV6e6wxtqMVr9ETs6pnPl2CQ=;
        b=GyjMHI0s2E3y0G5zIlrFjgVkiirFtqUEVzn4UaOhlcbdRRMSMx0WRDP7+cg7ViHv/O
         2Xf52Z8S+t5DGIqPXeKLLbX4ROM6D24l6fYiHpTp/jqudB0RR4DXnpx0p1SmVkRnW5ll
         GxO3wDAjhW8z8w/A+2jBUV5idB8W+5TltMKQsCYh3UADrFAUHrtOGBHCpg+nS/K96zN4
         qI27RN2WRrw3kiUdDHltyu5ptJmiGRdNHG3UAMbWDWNuxj8fnlbaL4ktzot3Ec8P1utN
         U1BXzwi7Ilxpb67SVy4nYa7Fq39fy4bBJ4p4jDIn1sS/WttWhajCMjgewf/qpgcMvnEc
         ThXg==
X-Forwarded-Encrypted: i=1; AKwUvBzySPHPaX1UvVAgGvTMqVFVN/BgN6jcUFSyacmJRXo5bI7AfMwxXrE2eQo69f0EiSfqeONVK76oHwI=@vger.kernel.org
X-Gm-Message-State: AFuF++kfefpuvzOzLjJ0mhX+wiN/syu0u7n03SvTaT/pezJCV7zSPdxZ
	8H89Dnu9ae++9NUR+MrIdu6DXEx6BkODpB/CimMKVRVLmdJrjtUONJsaEQHScn1fEbhe4HLb5Jh
	AW77YRBwjfdzrMCSeiNoAWvLWh7OZY164viEGlhZokBAZCgDXboQcPHaTuseLTw3Nrg==
X-Gm-Gg: AYBFou0PaISBk8nx9rFUA5r4CPphoERweGgm/CmlLXIEe9MxLWShd4Pf+MjMB2A91H1
	/JPGk/cw6ZwOMrliCzQpyT59Rk2uIrCKIJ/6CSCAZ01eDbuPug85p/2mVd1q0bbtV/rh6BvnEw/
	K/xfLUTmWnO9vYvriO0LW0M/9NcE5PNEvR5F3Fdswt823vGrg7d22trqkY/9fuFD50+PzIDlVym
	924NV9ZSrhUdDEkX5gwJnN9+psClc1573uve40mD4TCMZ3xKBmuYX+xZrGxjxhEqX1m/eTi9gsP
	nLoqvKTSscbt21uIrZk+/Y4dHihBRDlsi8ct2hW5Yp0lS3R2SWXOFg7GUpAf7xsgHcpUMcyZ5X8
	DV16bqboLnsLnXCVhY6Ahfs4R27Kejp/xmVS+qAsRlpp4jQ==
X-Received: by 2002:a17:90b:4407:b0:39e:4c80:f681 with SMTP id 98e67ed59e1d1-3a098bb63f1mr509704a91.32.1790207815804;
        Wed, 23 Sep 2026 16:56:55 -0700 (PDT)
X-Received: by 2002:a17:90b:4407:b0:39e:4c80:f681 with SMTP id 98e67ed59e1d1-3a098bb63f1mr509688a91.32.1790207815308;
        Wed, 23 Sep 2026 16:56:55 -0700 (PDT)
Received: from [127.0.1.1] (RED-LION-HO.car2.Seattle1.Level3.net. [4.53.155.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976ca5f9sm1331613a91.14.2026.09.23.16.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:56:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v5 0/9] block device fixes for large block sizes,
 IOCB_NOWAIT, and direct I/O
Date: Wed, 23 Sep 2026 19:56:33 -0400
Message-Id: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADFntGoC/23Qyw7CIBAF0F8xrMXAQF+u/A/jgseg+KoBSzSm/
 y7VGGvj8mbm3EnmQSIGj5EsZw8SMPno23MOxXxGzE6dt0i9zZkAg5LVjFN9PFhM1PkbRlpVXHM
 juEStSSaXgK9BFuvNO8dO79Fch45hY+fjtQ33173Eh71PNfxWJ04ZVTU4U8jG2UquTHvsTtqrB
 dqODO0JRh7qiYfsBTjhJDOo0f7x4usb1ky8yJ6rAgBMibX65+XIw+Q1SWaPkF/mKo4Wm4nv+/4
 JJWYyVX0BAAA=
X-Change-ID: 20260801-blkdev-fixes-771b1c314ebb
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790207813; l=4099;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZiNOz2pyWd1hztFgQIT/fMRIRaCBoVisPLEJjghb3t4=;
 b=ISPsXBsQM+bYuJPjjnrmnOx3nBgMDp8Zy58dl5cUiIhNwb8Cdq/LdIiEN9axiDub2G3mmUZkP
 7SooStIFbtkDU+oNePb8DTuqvzMGO69oT+ML2GILU4jW9v6DppbMLsA
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfXxlos4azfkcuI
 SC6wDaAC23t3oGUppeU/1KHoQ33RGtxQkA350oycWPOYwJn96YjggchUmYGu4FVfFWW611ie438
 b0MY+Fv35xb89sMxFsFrRaCTM0YFYS53bov6NfbQRlNOrEJJJJrh
X-Proofpoint-ORIG-GUID: P2_XcqlTfo4YD3jh_YZCpfWmDjCBd_y8
X-Authority-Analysis: v=2.4 cv=HcaB3SE8 c=1 sm=1 tr=0 ts=6ab46748 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6aZ3Ysb2zzbY2sELL/OBJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=bC-a23v3AAAA:8 a=z3ezfp2eeGpP4QRtFEIA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX+jcViaBBs0CS
 FOkXSH4XvUJawjCoEA0as3oLhe8Gi0N2tS/HitkJLkG6cvfT6HWEd18i6IHm6BZWdhZR1cO+Xbo
 3fACW3b0YzfqpzmwcxFQj3U5jyJvr61NuPWfFQAee4zn+CyiYibhx5yDZ4feYj/ODdYvaVq6GMJ
 JSB+QWIXAbwY0ggTVAzLAmlqyxGjiCrSJN9eKv8MKX0JPEfzTqwC5/EXDeoTdEnj4QVJnCGQ4iX
 t5Mb3xumrFgtrhgJrmzcteOuda6WacEs7CbMvrG/c22XhfmGB2Bj3/+VZinxMQueQq/233YdQDd
 tEyxy1QRR2RbCEi6cIyRsqtydH8OgWVB/6vG7nI1G1/p6UcgWZEie1t9L/OK+W0KIKtcggbGV5H
 RFiSLGNj5MvBfO7viGUKr6h4Ezc3o36W/ePKsJGDWPG4fqANaJoUdozftLyFMX7fhHR8CuwFhdO
 sSTORKqCurM8alxno6Q==
X-Proofpoint-GUID: P2_XcqlTfo4YD3jh_YZCpfWmDjCBd_y8
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11914
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=10 spamscore=0 priorityscore=1501 impostorscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609230100

A set of independent fixes for the block device file operations. The
first two were found by Sashiko while reviewing the RWF_DONTCACHE series
[1]. The fourth and fifth were found by Sashiko's review of v1 of this
series, and the rest came from asking an LLM to find any similar or
related issues. Each issue has been reproduced, with the fixes resolving
the issues.

Patch 1 fixes silently lost mmap writes with CONFIG_BUFFER_HEAD=n.

Patches 2 and 3 take i_rwsem around the direct I/O write fallback and
the splice read path, which race set_blocksize() changing the mapping's
minimum folio order.

Patch 4 makes the buffered read path honor IOCB_NOWAIT instead of
blocking on i_rwsem.

Patch 5 makes IOCB_ATOMIC writes fail instead of tearing, and patch 6
stops the buffered fallback from retrying an atomic write. Block
devices can reject both paths into the fallback before submitting any
I/O, so we fail rather than issue a WARN() like ext4 does. Patch 7
makes iomap_file_buffered_write() reject IOCB_ATOMIC, so no other
buffered fallback can complete an atomic write either.

Patch 8 fixes leaked page pins in bio_iov_iter_align_down(), and patch
9 removes dead metadata handling in the async direct I/O path.

These issues are currently unlikely to be hit in practice due to the
specific configurations required to trigger them.

The reproducer for patch 1 is in blktests as block/048, and tests for
patches 2, 3 and 8 are posted at [2].

[1] https://lore.kernel.org/all/20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu/
[2] https://lore.kernel.org/linux-block/20260909-blkdev-fixes-tests-v1-0-1f8af8665d16@columbia.edu/

---
Changes in v5:
- Add tags from v4 (thanks Hannes, John, Christoph!).
- Patch 5: Use a common error label, per John.
- New patch 7: Reject IOCB_ATOMIC in iomap_file_buffered_write(), per
  John.
- Link to v4: https://patch.msgid.link/20260921-blkdev-fixes-v4-0-e2801f71ede9@columbia.edu

Changes in v4:
- Rebase onto block-7.3.
- Add tags from v3 (thanks Hannes, Shin'ichiro!).
- Split patch 5 into two patches, per John.
- Patch 5: Rename len variable to size, per John.
- Patch 5: Move the IOCB_NOWAIT check up too, per John.
- Patch 7: Expand the comment on counting the trimmed pages.
- Link to v3: https://patch.msgid.link/20260909-blkdev-fixes-v3-0-1a5222c6e8ad@columbia.edu

Changes in v3:
- Add tags from v2 (thanks Hannes, Christoph!).
- 5/7: Check for a short atomic pin in bio_iov_iter_get_pages() and
  return -EINVAL, per John. Dropped the tags.
- 6/7: Use bvec_unpin() for dropped bvecs.
- Link to v2: https://lore.kernel.org/r/20260828-blkdev-fixes-v2-0-32f3f40cebed@columbia.edu

Changes in v2:
- Rebase on current master.
- 1/7: Add Christoph's Reviewed-by and submit the reproducer to
  blktests.
- 2/7: Skip the buffered fallback for IOCB_NOWAIT direct writes, per
  Sashiko.
- 2/7: Change the Fixes: commit from c0e473a0d226 to 3c20917120ce
- 3/7 to 7/7: New patches.
- Link to v1: https://lore.kernel.org/r/20260802-blkdev-fixes-v1-0-a82fc549fd74@columbia.edu

---
Tal Zussman (9):
      block: use iomap_dirty_folio for block devices
      block: take i_rwsem for the direct I/O write fallback
      block: take i_rwsem for the splice read path
      block: honor IOCB_NOWAIT in the block device buffered read path
      block: fail a short atomic pin in bio_iov_iter_get_pages()
      block: don't fall back to buffered I/O for atomic writes
      iomap: reject atomic writes in iomap_file_buffered_write()
      block: unpin all pages of a bvec in bio_iov_iter_align_down()
      block: remove dead metadata handling from the async direct I/O path

 block/bio.c            | 85 +++++++++++++++++++++++++++++++++-----------------
 block/fops.c           | 76 +++++++++++++++++++++++++++++++-------------
 fs/iomap/buffered-io.c |  4 +++
 3 files changed, 115 insertions(+), 50 deletions(-)
---
base-commit: 9d2c70986bb7838c1c441a93bda415eecb52f3dd
change-id: 20260801-blkdev-fixes-771b1c314ebb

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

