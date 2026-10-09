Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E183A5431
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564622; cv=none; b=XWKlxDTTxAza0YWJLnh8Ax9ElvL1FkYMLifwyr3jWPRzju++jUZ1OKLHekcjY49SRQkNBz4nBazANsocZdwvT/+/1OKQVYKF11akLHPeYQKAkXv6YziA7N79sGfgTzRFiX31m7yZGtJpnjOY2Z1VRSJVNGjvfffqQyIokX7hLf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564622; c=relaxed/simple;
	bh=JF6s8qbTTePX822mM29KsuR4mH18TBbEc536oN0csNw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=se8VfB0Rl0zr8pBNlRSbiFWEMpBmmLJqSNos9LRPy3Dc31/As77yABtoPAskdJon9GqGUx2QBymhtokFU2NIuw00lL0PKfPgbdoxJfTdGgOVC8d0PvaPrIhCvAsziMBde/HE16lQ9ptyZTdL4o6KqPchNlgephT1xNBudziSD8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Dpde/sm/; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=s8osUtyC; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Dpde/sm/";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="s8osUtyC"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYHtn1242617
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=5O/hboigZvBqAzLbHkmcV76M/u
	wEBHnwXTN6so0C9To=; b=Dpde/sm/s0LoY5N92Pw49EXt6XD9QdyHJ4lfDxfvJs
	aC7Ks5XgLh7r3lXoGuAPQi8l8mPIIuuORLRA2kDZ90nHbAQTNSUK6HXhK0ieL3IA
	06cftOnYsyp3MbuI/LKpLqImMKNguAFjd52dcXcv5kzlBzy9PCdkoj5xQHqfLRPP
	2/5E+VJw/epwXmkqw4Cfy1emQtLvtBEObgR42uktaiPhzSO4txMMNWngospHl6hX
	oyLfn7C4eMBhw/1bOQYQrThGMRIgN2WxeHm8s/0KjVheS5wPnvOGzePUV4l+gLZQ
	2soEo0BwaYF5sOyNqPWHpCqsnHXKefk6ZDvamDhsXP5g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h6we3kd12-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:19 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5347732a495so56987151cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564618; x=1792169418; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5O/hboigZvBqAzLbHkmcV76M/uwEBHnwXTN6so0C9To=;
        b=s8osUtyCRAGUV+UN5Zv0bSAhfNBWY2ADoMdwGrn4u5sFhRFbx2wWg4b3FcBvysyZr6
         geNGflLzAkEpKDgq4CpT1uS6sZzyz41GltzpgyPcmb8rbAq6+g8ZFmgkzw6KxeL+BtI4
         KsGueZpQcSmxgxIIFBnY9v46ncoINgMFETcvFkywTdbUnnC03itkEcQaTsJvo8oVfWxL
         m82r5PvbLOEyRSB76E4YsrTxSxyhetaMZHBjRxza8631YZZHekRAmpdS20d8bt4NM/PZ
         sJ2BR2QZraGNP2VBIllNyd4YYdTsyfNqaXX6+XQ/Rcz4543rKd0IIG4M8eIqPP8IdJuF
         wE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564618; x=1792169418;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5O/hboigZvBqAzLbHkmcV76M/uwEBHnwXTN6so0C9To=;
        b=naGOwcEgkkts92sDKXSyPUjA2AKXXVwJyrvJn2cOffRl+SVU3yZJ9VXVzaQw8HT7/2
         OcMNUyUN6JehC5k1l4YHogTRIQONCM1sML1z40fP7QGtH2JMU4n21tjjwOtoeL5DbulH
         hhYyF8Fax4s75WO4EL6Rea66pDupfTHoh8JutjGYT6vXrBHUTZF81s2mzc4Cie3egUzl
         /4A5pHE5yUnK3EaJi2u4q3RTQILqqXVjEZjLRAT3wmRJO+SoTdEuLWzjVF8PNw/wYmy/
         Ha7DfF64aea8kCs634FZTC0GAXnYj84VYsssIUqq4Fc/HrldB59BZtKrIIM4vfDdhqDC
         QBFg==
X-Forwarded-Encrypted: i=1; AKwUvBwJhCk19/lJkdD1i1TnBj3RcgC324NQzxv/hSP7uquXCaYbkdrUe8tQ1ncrKVh3G9wwni8Kw6v4fjo=@vger.kernel.org
X-Gm-Message-State: AFuF++mpITj9NfCV90/yCZmensIB7mrFHm91bc68eDO+bvdZtb36kjga
	HXrI2x1mXX7FRLodVyN+m8mqZRK22oNui2pdg02sVJbQuI0/YtokYaOteuEemzU4KxD0dKVaxMN
	yaNdV4RTo4LoRse3LJMk4YVyPnRhPkUH74Svu1B6IQjVOa/4ZuGcGY76+6g==
X-Gm-Gg: AYBFou0bnqrHS/GySYVC87o9F5zlO7IpNtBciCNHNwGRD6QgazunAg66NrYwFtixBvq
	3DD+l6RtFI+NeaQ9fbajyi17VEAzjf1GYx1G959KGoz3+K7jf8jBQpl9Rmi4/mWiX9xWCAcHx3B
	FsCBB3eIhuqR3oW7T6bXBQZYzApegYJKKn5QqZyQzBsmJ9mmCTSSebW0pBnXZq9G5+Lrn9XhRXA
	aydBBwrAhXmwQyWtFGvUb2iWni7bBk9YYf6GhOl+TxcgCHpvG3eu+zjZhBYO5qIcLegDl1mWdah
	kAHIxvAqI1uXqTSpi5e77BNQfDpQA0QXYS0GWMqe9jR6Qst9CAOPmHa3YTjGKNkQm7IXzSAFtuW
	dqHT+rczUlJevKpLirFe76oWOOhDNk8UwWBWS6Kmor5kFHKw=
X-Received: by 2002:ac8:5f49:0:b0:535:70b3:fa06 with SMTP id d75a77b69052e-535a62612b8mr27667231cf.34.1791564618438;
        Fri, 09 Oct 2026 09:50:18 -0700 (PDT)
X-Received: by 2002:ac8:5f49:0:b0:535:70b3:fa06 with SMTP id d75a77b69052e-535a62612b8mr27666741cf.34.1791564617824;
        Fri, 09 Oct 2026 09:50:17 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v6 0/9] block device fixes for large block sizes,
 IOCB_NOWAIT, and direct I/O
Date: Fri, 09 Oct 2026 12:50:08 -0400
Message-Id: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEAbyWoC/23QTW7DIBAF4KtErEsEA8bQVe9RdcHPkJCmcWVi1
 Cry3YNTVXWRl08z3xtpbiTjmDCT592NjFhSTsOlBvW0I/5oLwekKdRMgIFimnHqzu8BC43pCzP
 te+64F1yic6SSzxEfgype335yntwJ/XXpWDaOKV+H8ftxr/Bl77ca/lcXThm1GqLvpImhly9+O
 E8fLtk9hoks7QVWHnTjoXoBUUTJPDoMG178ecNM40X13HYA4BVqu+XlykPzmiKrR6gviz3HgGb
 Dd2svGt9Vrw0qFpRCJ3Tj53m+A6qGsK29AQAA
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
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=4400;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JF6s8qbTTePX822mM29KsuR4mH18TBbEc536oN0csNw=;
 b=4T3IvPSeuowhSS6xdpm10yiXeIGJdrr/FDWL4GRG8Y2XY60aQsIqj+jHJn3dqyGHJNYuvpiat
 YjO7rAiQoOBAg9wtSdfo/kSvDJCppXU2WYRZalHF3fT0kUMxRYr+OQf
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: NUz6B0sU4aFX-fa7o3PNZhhv2av9iM6J
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX7uFopVxONfd/
 3+lohqLzYQgnOewN3E++IzZQTxs80zkMDIRh+5BLugggiQY07xeMKn3OyVSjfOKJTijYZBm/Bsy
 gYzV1nCkTlC2jQ8Uf/NtLZ7w8nwZJ+77AC+fJ2lAldEOnreb2x/+
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfXwt8FVQCp0zOD
 iX+n/9qJ++ymymbxJ+zOIm6L9WYXhqMZyrKCMSem3l7iowm+W9L8Hrw2r3Ai9ftn6VyUqW8EfJK
 17aXuZLLfiiyHJKf4KH+t8MvIAXSb0/k+DNiryhB6vMiUM0YhQE40SoneepkT9GxkTK3ZI1jfEm
 du9MWSFHWyvnDTS3TEjKKg2d5fU0EgO5sn/fNj3Xpae3hZDQerIQwUAKtbjBzFS8+ektsxzOW+A
 OmsbpEz+2G1+InuoDlednI05x/WPSRr2w1WXB2op0TXlFM6Za6xmHP7FCrMJlqHK005EIz62aXw
 r63nQfP7vydS0CCKeYNn0PZBUWpjQvKkont/Y5/R5INc6En9RKmiBX7VuqK5dz/KO1IA2WCqDlf
 Xo3yUJtuwTHLGQWMOCLYZAS/dD70jRsXHHGzfchY0BOO7Nrru+9j8PsCs2BD4QTWSNHBEmQuMbD
 qo82wiUcSYNNdRfUVqw==
X-Authority-Analysis: v=2.4 cv=eYio7LEH c=1 sm=1 tr=0 ts=6ac91b4b cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=bC-a23v3AAAA:8 a=z3ezfp2eeGpP4QRtFEIA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: NUz6B0sU4aFX-fa7o3PNZhhv2av9iM6J
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090067

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
Changes in v6:
- Rebase onto for-7.4/block.
- Add tags from v5 (thanks Hannes, John!)
- Patch 2: Adapt the IOCB_NOWAIT short-write return to the new
  FUA-aware need_sync handling, due to the rebase.
- Link to v5: https://patch.msgid.link/20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu

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
 block/fops.c           | 78 ++++++++++++++++++++++++++++++++-------------
 fs/iomap/buffered-io.c |  4 +++
 3 files changed, 117 insertions(+), 50 deletions(-)
---
base-commit: 69ae59173a5668d015ab2733c8628ed542f00ccc
change-id: 20260801-blkdev-fixes-771b1c314ebb

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

