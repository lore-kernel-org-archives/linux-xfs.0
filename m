Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F233CF69C
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 21:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778795529; cv=none; b=Id+TFK9iu1ScyyNJMjQOTEMkQGBrTX9XLnevjMSWJaZW+1wCArmYQuUOjeqePgERQTE2V0GSOGUhZG+ycMZxGgnwP4WdxJgctkd7ZXkIqZ92qadaCsfmzP5mkyQfjzzE4QiFJpTp0ra6ISTyqweWiesKPgMzJDYAt2ORyZvtPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778795529; c=relaxed/simple;
	bh=LhYeH/mJ2rWshbCTnCkimmhXW5yvpSfYzhx+I0SXhZs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rjVem8EKgSUfsj8mPqrNDsHZuJhk3vYUM7LTvf+HdiFrABqShm9d8++BY1cR7bK3RJeKJxwLvlFoT8YVx/RIvJpO8vjQ/xu5e9Cb7Su2gCtXoDfm2HPV6q7pYmWgJZE81EO3W/zu99uWmmw17jswjJK4NbX6flq5z+DajBDwT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GlIkRig6; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GlIkRig6"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgaxn1544846
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=gL3IniCxmcO+YyN31TeP7KDvS2
	7s+0s8k2VEJ0rAxzM=; b=GlIkRig6oRPwq2PsSM5jFH4ymDLopdQUub4Tf4MZHK
	siDypWLzIoVUvvSDqMzeleNX7JsjyD2f6DlVDUig3883ZLex09fNgfsdwOUMSoJQ
	vqbMp2Lu7Tddd+AdJZcMO3a92s8D7Mv1xiLSIkdH7DySTxMPzrjz6YY/1RvB3w9C
	eORw3QK4rEH+JsxhKQ32UsoMJGoB0wL7QpzqKx7QZ50fPdcCAuS163EvqLmONH+1
	YkR/CsCtP/LkAOE/6GBLhZq/ww9kUsjOI0eRaGp2wstvAEtjOgr/vjn4mp8F1p2L
	9R5Kvxn7jQVE5VeNDMVWNYaNwLiXGk9UyfWWUQ0Vk48Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m25hds4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:49 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90d5e856e17so920450585a.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795509; x=1779400309;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL3IniCxmcO+YyN31TeP7KDvS27s+0s8k2VEJ0rAxzM=;
        b=Q/tm8QMcREzcpqcSiI6bO0f+zSaQKJ1MfQN8DWasZKwI4hcWxxaLH5/akAIB+mI1fm
         JpFQK01jx4BML+J+tVZzfet1r4uHUVKPCo67QxvW7XZ2zT6yyFoJtsOLB2nHFsZEowfZ
         u2JeojH+dwMbpxVKZyE+VBduRCU/i2OaF0S4RuNlaSPaQGLGFSX0bbcRdqFTi6gPBOSq
         LP+HO1BU18A8lzKIvg5T0d9i4onE8kF+Ij4TkFKvZ6pSW9L1Oc0faQ813A1UmEAHjqVR
         GrvZetk+F1mt1RH46QvYTZw/4vbWQkq/Xd8El+15zoRlLdQqXJX3jX4x8HhcOjFbjHhE
         ZZrw==
X-Forwarded-Encrypted: i=1; AFNElJ/W4JoKd+Q8cdKcnlOAPJW5f/zc9U/L6LsVA3mkKwhh+M2+2/Ng439vIg0IVQWtKjZEQiQx5iQTq84=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxol7wo33we341ddh22fLr+KggPwdvWY0l8pSFSYnVTEe0kFJ8G
	SNxE02s2gM/OXeEtUJJOlgdcKDMeRQCK+bwcvwS2g4CIrov6FtRid1vtlCBqXUl80sLh+sbhWHo
	JE3VRU7dUVN0y3vJOpg2VEuUiLVPj5oQ/seVglpPnJGXSJjmFVdloDES1vA==
X-Gm-Gg: Acq92OEjM5klvf6x3OLmhcZuhv0tojfE3RfOXJc9qsDiwPcxMqf4wA3M6++YygYlOxn
	Iz+n//u/dXvwNyGrdnhcpP/iD3wWXJpscKjMebpsXlzE9WoDeWYCMDKo9wQ1YwcY+tmaXREaeSd
	a65IzF/XMM7Jf1V93Gk5yQQsrUuuElUsdCxSHF8128+WD80K/8XH1PxrFwRqrc59KzL0/W8YsTF
	K7j9QLUZVXonY/au++mqybE21SPSkyFr4Sow65Z4BqDbU+joREWIar2a+wwlrwcoTsTZR6y7ruU
	nHoHDbRcL1FeNpdXKS1il/4xtZBzXDhQZTJV3PYyI+1FlKSNxC7cGwi0JDA0B69GAyDDqZG0b95
	SZEIe8WvqJybksipbH0XkBfmBxhRCgZLY
X-Received: by 2002:a05:620a:459e:b0:8cd:b617:6522 with SMTP id af79cd13be357-911cdc43821mr248438185a.29.1778795509210;
        Thu, 14 May 2026 14:51:49 -0700 (PDT)
X-Received: by 2002:a05:620a:459e:b0:8cd:b617:6522 with SMTP id af79cd13be357-911cdc43821mr248432785a.29.1778795508692;
        Thu, 14 May 2026 14:51:48 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v6 0/4] block: enable RWF_DONTCACHE for block devices
Date: Thu, 14 May 2026 17:51:13 -0400
Message-Id: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANFDBmoC/3XQTWrDMBAF4KsErasy0ugvXfUeJQt5NKpFU7vYi
 UkJvnvlbBIcd/kG3sfwrmLkofAo3nZXMfBUxtJ3NbiXnaA2dp8sS6pZaNAOtAqyOX7J1HcnitS
 yRAwKMSUwlkXt/Aycy+XmfRxqbst46offGz+p5fqfNCmpZI7JOW85e5XfqT+ev5sSXzmdxYJN+
 gHQdg1oCdID+0im9iFsAPgI+DWAFaCEsCdKNrgtwNwBfP7ALIBprEuNwezMBmDvgIGnDWwFIEM
 A0hD3br3BPM9/sZsVarEBAAA=
X-Change-ID: 20260218-blk-dontcache-338133dd045e
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=7017;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=LhYeH/mJ2rWshbCTnCkimmhXW5yvpSfYzhx+I0SXhZs=;
 b=FnFs0Q/bkJsVMU4mvf5tEHoM0rAglLF1PocraE3Zcd5SE85JgeordHVq0IsksElTq+sqwEiSZ
 0MWzs20e5wZDOZX1xp4P852lxKsWm4p1BAGxJyaoCSsVIV2cTFmU0qx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JOcLdcKb c=1 sm=1 tr=0 ts=6a0643f5 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=MODqGFHVcVHO9IVmJf8A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: 7kOlvBnMiz2MD8JbMafLhf4qSKHkyHcl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX159OyONA+saw
 wQR6LyghPjRXrRM7l8pdO/wL4dtsFJUd7HxFpOYoT8rHUWpnJsnBzKvYE2PLBlzCVVZzYGaJBt2
 q3k15AB54JvLbxA0oVz5B4rVyVRZiSiBX5TqIETyIOOnziMPfs9qMhmKUTwYuu4dFBF62jdyvbm
 /ld/9pchaydPh3qAJz0kkCAs+9P9Dv2gl0r/J5q9G7aIStB/ZXwXy0b8bQCRdn/7PS8QMr06AeO
 Lx7cLdrawsnOjs2VtPBz1PEsTFG8Mrq84zOBPR2794KP6Jix/MwabLt2CjYuby6lbjnqgiwJnrv
 IPGDJyaV+mt+Q8ASrUMNl3MZ+a6v/iLfc7T3U/BkWVFMaIma0wOvKPNFUGAbNZv5awuZvbSCAbk
 TN6yKiJnII/Cy0u4rhsHmeUcb6nd8e5BClMWdpBl950eeeGpA+1ApdBBd3GNHJ96iMdyIgUJNop
 /Byj4iwrsE5bAQ2UFew==
X-Proofpoint-ORIG-GUID: 7kOlvBnMiz2MD8JbMafLhf4qSKHkyHcl
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 priorityscore=1501 suspectscore=0
 bulkscore=10 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216

Add support for using RWF_DONTCACHE with block devices.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context. To fix this, we defer
dropbehind invalidation to task context. Add infrastructure that lets
bi_end_io callbacks run from a worker, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     upfront that the callback needs task context, as in the dropbehind
     writeback paths.

  2. bio_complete_in_task(), a helper that callbacks can invoke from
     bi_end_io() when the decision to defer is dynamic, as in iomap
     fserror reporting.

These queue the bio to a per-CPU batch and schedule a delayed work item
to do bio completion.

Patch 1 adds the block layer task-context completion infrastructure,
with both the flag and the procedural helper. This builds on top of
suggestions by Matthew and Christoph: the procedural helper and
bio_in_atomic() come from Christoph's "bio completion in task
enhancements / experiments" series [1].

[Christoph, I put you down as Suggested-by for this patch. Let me know
if you'd like it to be Co-authored-by with your sign-off.]

Patch 2 wires BIO_COMPLETE_IN_TASK into iomap writeback for dropbehind
folios, removes IOMAP_IOEND_DONTCACHE, and removes the DONTCACHE
workqueue deferral from XFS.

Patch 3 sets up DONTCACHE support for buffer-head-based I/O by setting
BIO_COMPLETE_IN_TASK in submit_bh_wbc() for the CONFIG_BUFFER_HEAD
path.

Patch 4 enables RWF_DONTCACHE for block devices based on the previous
support. This support is useful for databases that operate on raw block
devices, among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap parition (~1GB) in a memcg of size
244MB to force reclaim pressure.

Results:

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        1098.6          1609.0
   2        1270.3          1506.6
   3        1093.3          1576.5
   4        1141.8          2393.9
   5        1365.3          2793.8
   6        1324.6          2065.9
   7         879.6          1920.7
   8        1434.1          1662.4
   9        1184.9          1857.9
  10        1166.4          1702.8
  11        1161.4          1653.4
  12        1086.9          1555.4
  13        1198.5          1718.9
  14        1111.9          1752.2
----  ------------  --------------
 avg        1173.7          1828.8  (+56%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         692.4          9297.7
   2        4810.8          9342.8
   3        5221.7          2955.2
   4         396.7          8488.3
   5        7249.2          9249.3
   6        6695.4          1376.2
   7         122.9          9125.8
   8        5486.5          9414.7
   9        6921.5          8743.5
  10          27.9          8997.8
----  ------------  --------------
 avg        3762.5          7699.1  (+105%)

[1]: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/

---
Changes in v6:
- Remove RFC tag
- Rebase on v7.1-rc3.
- 1/4: Revert to using a bio_list, per Jens.
- 1/4: Restructure and simplify work function loop.
- 1/4: Expose both the flag and procedural version, in order to allow
  static and dynamic deferral decisions, per conversation with Matthew
  and Christoph at LSFMM.
- 1/4: Use bio_in_atomic() predicate, per Christoph.
- 1/4: Use the CPU hot-unplug protocol from mm/vmstat.c, to take into
  account use of delayed_work.
- 1/4: Mark the workqueue WQ_PERCPU.
- 1/4: Add comments.
- 3/4 and 4/4: Split into two patches, per Christoph.
- 3/4: Drop the cont_write_begin() change. Block devices don't go
  through cont_write_begin(), so it was out of scope and was left over
  from v1.
- Link to v5: https://lore.kernel.org/r/20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu

Changes in v5:
- 1/3: Replace local_lock + bio_list with struct llist, per Dave.
- 1/3: Use delayed_work with 1-jiffie delay, per Dave.
- 1/3: Add dedicated workqueue to avoid deadlocks, per Christoph.
- 1/3: Restructure work function as do/while loop and only schedule work
  originally when the list was previously empty, per Jens.
- 2/3: Delete IOMAP_IOEND_DONTCACHE and its NOMERGE entry, per Matthew
  and Christoph.
- Link to v4: https://lore.kernel.org/r/20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu

Changes in v4:
- 1/3: Move dropbehind deferral from folio-level to bio-level using
  BIO_COMPLETE_IN_TASK, per Matthew and Jan.
- 1/3: Work function yields on need_resched() to avoid hogging the CPU,
  per Jan.
- 2/3: New patch. Set BIO_COMPLETE_IN_TASK on iomap writeback bios for
  DONTCACHE folios, removing the need for XFS-specific workqueue
  deferral.
- 3/3: Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() for buffer_head
  path.
- 3/3: Update commit message to mention CONFIG_BUFFER_HEAD=n path.
- Link to v3: https://lore.kernel.org/r/20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu

Changes in v3:
- 1/2: Convert dropbehind deferral to per-CPU folio_batches protected by
  local_lock using per-CPU work items, to reduce contention, per Jens.
- 1/2: Call folio_end_dropbehind_irq() directly from
  folio_end_writeback(), per Jens.
- 1/2: Add CPU hotplug dead callback to drain the departing CPU's folio
  batch.
- 2/2: Introduce block_write_begin_iocb(), per Christoph.
- 2/2: Dropped R-b due to changes.
- Link to v2: https://lore.kernel.org/r/20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu

Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (4):
      block: add task-context bio completion infrastructure
      iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      buffer: add dropbehind writeback support
      block: enable RWF_DONTCACHE for block devices

 block/bio.c                 | 147 +++++++++++++++++++++++++++++++++++++++++++-
 block/fops.c                |   5 +-
 fs/buffer.c                 |  19 +++++-
 fs/iomap/ioend.c            |   5 +-
 fs/xfs/xfs_aops.c           |   4 --
 include/linux/bio.h         |  32 ++++++++++
 include/linux/blk_types.h   |   1 +
 include/linux/buffer_head.h |   3 +
 include/linux/iomap.h       |   5 +-
 9 files changed, 206 insertions(+), 15 deletions(-)
---
base-commit: 695fee9be55747935d0a7b58f3d1fb83397a8b4f
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>

