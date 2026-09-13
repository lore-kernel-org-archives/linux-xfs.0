Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAD33101D0
	for <linux-xfs@vger.kernel.org>; Sun, 13 Sep 2026 11:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300087; cv=none; b=D3A0nI42hrNGuerqwD7VTCUZKqAMsG0ol1KKsc6yGIKThPc5zHfpYlIFIsHHZ9pYxC2h5Ye7qD2/RiOrf7CPXLMWpp9b3UMwo926tEapZFiEw6ex8YM5h25xT+mKk7zkGAHapYoqC9WSEP48J60IxvJ7T2H1HLJ1XZ6vecMCQ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300087; c=relaxed/simple;
	bh=Vcy3/JPS4PpmASyPCwcOoyW5ibRp31joRfYmtgfKEuc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ImyTwQt18lr9XHDGoGUtQO8F+70a+k8qjJH9kst7DTHC1b111Wjh9Qf0kCjcbAFaHX1mNu/RUmvU6AAukC3r1EQP5HcubBu++KCcbX/EhLlS0tQ0npzTfzRcD8Iz4DhJrXhBGk1Buju9CJBu/tVv02PxSuhnQXm/HoEjos4trqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVXSlzaH; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVXSlzaH"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4ae2dso884392a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 13 Sep 2026 04:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789300085; x=1789904885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YDUrtLaMT6jANi7+m/j0UcVZCw4+tagzNmCTTq6HPLc=;
        b=mVXSlzaHM+FBrpM3hxRWG+MrBpGjbOYTncS51k075OcAthmxu/E1YGPZOrnuvRHbVv
         N1CSggauDV3d03mS4nvjc70GKduMV+57e7M/3TbZScGZWAjrkT6RvSAkJC5ugBTwzwLQ
         JVpbLJRtaEvJ8DWB22H61AxUu334Bv3ZE7vITfGWtKL7QwQ03/1BamU6mzVNv8v0++v1
         3o8ZM4koKsdY62htwtrbHTBEJuUkBAtC3ftoqSTwtTgRNM07Vzj8h2Ot5m+i8tuZ/dbm
         iFtZV48cfK3GsLDScjL40PyiHiKy7RHWB1xne85psG0jtfkNtQOKX7N6gUIlDOkFwIkf
         Ty3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789300085; x=1789904885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YDUrtLaMT6jANi7+m/j0UcVZCw4+tagzNmCTTq6HPLc=;
        b=nd/E8Wm2o82d3iDbGSgBZX7RO3XCERk53bJM3G1138GuSfz8qmAYCuXizdDhAoqRYR
         BezC2QxhQwkL5u9Yz+oZJjU4+QE+xiGLroB6b4OWJ12q9X2qP+/m+7RvBTErTRyhLs6I
         ZsUW5xQMwEFe2hix+ZwyG1NVYYIdvgl8I9GUd+PnfbUXuZW/jhlsZvA33Xmxd/55GwuK
         u9KCW6ZKyq4HmWveNP2brEzHkDFqlpc+vKmva5e+wafaOWzYcCEyl1z+36ewB71A8g1t
         DK1RrF8VDreokSS86UfSeJHgUNNb9fMq4x+J8tax2JAKe9JyWrZ9k2RBHkGN3s1n7JvH
         sBYw==
X-Gm-Message-State: AFuF++meNxJ6XkJkO9+RkTO/rw+OiPWlpR3g2NNc1RIIldEXLzNAlVW+
	oY8nnaViZw4ms2+YKwk6dko+uo4yPr2kx3B7FOJEv3IRJworD4CCZuT7
X-Gm-Gg: AYBFou2QNWoL6+ziGRH7PGWNKKF5CCs5fySxgd4CpQbtnAqhT5zFz1FcRzzZE9xs+3/
	Q4vUC3k/Xz14WcgMW6DeQllW4Q0HtTfNac3jPgHjUPILpylefpqwACXdn5rIkrpbZ6vSRiswB1Y
	5LhznjPynxs1EKfMatR04YzT0M/3ww+wv0q3iQ3HMNpWOgWpPyAANLM2fiKEQnx8F43VmpxqHZa
	JkpPcis4KT4IlW82hLiSL7zFIZiZDDyEkJRcixL+Ps56Zp/GmtQECdDnXOTEApeHFA0KvRd54kI
	v1ljntm5WNkOFWRilzLwQXInd9h6ioprwfSSTklgXbUYf0CadGP+5PPZ49R37ea6HNFjGntsjBv
	ryj0KHGTRZdvPxPMRpPrtPDRcEOEEjhh1XYKbs6gnmPoyo0KvY3BqVEpXJiZ2FSS2W7boqz/Uoz
	0yAH1iKWP7PJY2K3zinsC6Wsk+ikHtYPqK7OIvLpp7aT4suhvQ9DBDPzCVHRSSjr9B9Qtrgyuz0
	ju3yT4hn/nMmGGWf2sJ6NtyFmTZZZfd
X-Received: by 2002:a05:6a21:3292:b0:3d3:aec2:4dc7 with SMTP id adf61e73a8af0-3daed38c33amr22231241637.19.1789300085539;
        Sun, 13 Sep 2026 04:48:05 -0700 (PDT)
Received: from 192.168.50.3 ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c652ab37sm3526331a12.11.2026.09.13.04.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 04:48:04 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chandan Babu R <chandanrlinux@gmail.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	co+af981e62f5c7171a@bugs.sh,
	stable@vger.kernel.org
Subject: [PATCH] xfs: validate buffer log item before reordering
Date: Sun, 13 Sep 2026 19:45:30 +0800
Message-ID: <20260913114528.842015-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log recovery reorders transaction items before buffer item pass1 validates
the format of region 0.  A corrupt log can therefore supply a four-byte
region containing only blf_type and blf_size.  xlog_recover_buf_reorder()
then reads blf_flags immediately past the allocation:

  BUG: KASAN: slab-out-of-bounds in xlog_recover_buf_reorder
  Read of size 2 at addr ffff88800e40e364 by task poc/133
  Call Trace:
   kasan_report mm/kasan/report.c:595
   xlog_recover_buf_reorder fs/xfs/xfs_buf_item_recover.c:164
   xlog_recover_reorder_trans fs/xfs/xfs_log_recover.c:1929
   xlog_recover_commit_trans fs/xfs/xfs_log_recover.c:2053
   xlog_recovery_process_trans fs/xfs/xfs_log_recover.c:2319
   xlog_recover_process_data fs/xfs/xfs_log_recover.c:2510
   xlog_do_recovery_pass fs/xfs/xfs_log_recover.c:3253
   xlog_do_log_recovery fs/xfs/xfs_log_recover.c:3340
   xlog_do_recover fs/xfs/xfs_log_recover.c:3377
   xlog_recover fs/xfs/xfs_log_recover.c:3502
   xfs_log_mount fs/xfs/xfs_log.c:617
   xfs_mountfs fs/xfs/xfs_mount.c:1031
  The buggy address is located 0 bytes to the right of
  allocated 4-byte region [ffff88800e40e360, ffff88800e40e364)

Validate region 0 before inspecting the flags.  Keep a malformed item on
the regular item list so that xlog_recover_buf_commit_pass1() reports the
corrupt log through the existing error path.

Fixes: 86ffa471d9ce ("xfs: refactor log recovery item sorting into a generic dispatch structure")
Reported-by: co+af981e62f5c7171a@bugs.sh
Closes: https://lore.kernel.org/all/aqZALi7GdVprcNOh@cronus.toxiclabs.cc/
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 57929f115055..70e69ec731ac 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -161,6 +161,10 @@ xlog_recover_buf_reorder(
 {
 	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
 
+	/* A short region 0 is rejected by xlog_recover_buf_commit_pass1. */
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0]))
+		return XLOG_REORDER_ITEM_LIST;
+
 	if (buf_f->blf_flags & XFS_BLF_CANCEL)
 		return XLOG_REORDER_CANCEL_LIST;
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
-- 
2.55.0

