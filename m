Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0148348C3F5
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585311; cv=none; b=JSAfupESFsDqGKAY0NLZsThd7UjAA4cWaBINhPzqAvKe+WbBtMlqC2+WtfEak5DfvIVBDq9rxVlnufNmX/LSKwQucso8rlLatQ9XXRk5KvvrHaAYCPBbFCsHmCqQcVMN65azHTCGmSnBmZZErmM0rdXH31kvQZhWi8E2sSn2GkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585311; c=relaxed/simple;
	bh=Ey2hy8K/mrzadOeyZYpxv3qyfibND4LeYr26gtOxh+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6weXpYz9QBOqaDLDR9bed7Ho5bJNU6oUSLf8oGxWtpMNqS4oOzXZi2uP+vfgE60fQok6qCDghZazN5qA5sMKYZ5u2qpBYhHOR+x0c/GqNCZeVd4FIwb2aKp66C2zG43jFmY30mAXKQPYkFnXAgiyhbNFUEqYNJKbpYGR2bR7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgB8Ja6d; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgB8Ja6d"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ce364488dso7445835e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 01:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790585308; x=1791190108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qfms4UXVhjSqsa81KPLQziFui0MDs7rXtnItEtK8nrE=;
        b=dgB8Ja6dZcDGE3OTgonQFIaLWVP69Eh7kQOrmG7zGLPE5PnzTO/Tyq2v0pkDvr0O6P
         vZWeoNTViydt7ay2KU/09STOA/3GcRbaDBi+qCPB4dEvgL+Gp8z/0ytgt50QONo5/to/
         Ze3rhKc004Fmc9okb/W4IMp3ANbZvjOpjFbX6qLlHMem/Gtk4qP9J2Q1YocAjzwgm484
         5YbpVEP8WRx6Zu4wC/uK3nKRG0MblDi+cGRxDJ4+uGPsW+9suGnX+c8RKR7y73G4GLP1
         YXrVMJgqp4Le+5aFe08ttcIyt7OpXSDMjjifJBa12ic84MAt8FymOx1sLFKW0n+dVkK+
         hQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790585308; x=1791190108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qfms4UXVhjSqsa81KPLQziFui0MDs7rXtnItEtK8nrE=;
        b=BReLO18lLsF4Hirai2+O4wcoLLEqu0LBIc16SNZ+uAfAZm6q0iNdz/ZZKeVqHik2WD
         GB4Cyx8ny0scOyefBb2eJmazZEru7Ee3AWU/eLwBgxl2ZVzwROAVyj3OakhqkDDc9vED
         OJ6dbxL1q38aFxDhqim13gVfcZ8JrjhUfU7xaFXw3IuywF1Wnp+8dF3d69/GW1w4fVkg
         RgEfK2MzhE3Qpn7XaQLcCct+3yMA8DKytyHj6xQ/PWPthNK8ES9l2Q+H9euszuJ29F9Q
         51I1UvHJX3yeUn9lHRGzmyV/kxrbMXVgKefiFVQ2H4v5eoijcidj9LGhTCFrZdsBaVTi
         LJrg==
X-Forwarded-Encrypted: i=1; AKwUvByXYwk++iQmGbcDvNNlll/+Gij1obCSuZPTxjdCD7ni8pkjClby6AY0gRGO6Ypp9cGsv729x7JQ9mQ=@vger.kernel.org
X-Gm-Message-State: AFuF++moYCqyJobJtlCkNQ3/JDLFNkoxcwgNkQZXwK/h0iUnsIHMLvBd
	MDwW4vMnxFpAz0oDNJXYz07JqPs9pEoKedxcmmy69vCiRXixnwNa22yx
X-Gm-Gg: AYBFou0iXCBPHMBZkRuWI/lUHrkRdn6Ne/wEH4n6YMl0kchBFfNah9r0+vYZEMoy62N
	U2cwHPNtJKllQXnQ2/nIN4NJgOrQhcqC9RxPEfI+mW7Mj14F9B82d3zyDZNMi3adVmLJOmIlCx+
	RhTPX7vTUpwAO4t5mr/N2kOApfm8LGb3hzWeaEij4SpCC6Y/JtY+jU7+yGqWr2TAyLXZb9rYH1U
	YMCyVbcLQ/jPWCx2pq6x7nLJfrEmPhTgg4/8NrSj9SXrORrqRlM59YijmvJ4KfzhQRJoxFLVWv4
	Us2T8pSvbl8f/f39XH284t8ItQaHoYGMPmDlA9q8JBZnmIO2Y5A5UdCz3FBhUSSCrIkHX53Q2D8
	PH4tTY2CH1o9qZfdmjsgK/jDL1x0n0Ekrutb+5Xvn88UeV8NQ63RVqHEjQWTmsqyd63+o9FO7/n
	8y1Cim8b3qI/jVMn4FzmcQJCxnii+j9ye0B4Tv+AiHa4Mi6oLtVcanBOwLQbuDX8Cvz794BqV8i
	kfl7aP23HWG9JkmKgsD91EfK5aewfKgdNb6nPuXt+CkRa5qml/C2KRjgK8MB5X9m56cZhI1ebXP
	p1Y4
X-Received: by 2002:a05:600c:8b28:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-49ffbad2d56mr92693445e9.17.1790585307816;
        Mon, 28 Sep 2026 01:48:27 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017652d1sm182584705e9.5.2026.09.28.01.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:48:27 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/4] xfs: add an error tag to inject a ->writeback_submit() failure
Date: Mon, 28 Sep 2026 10:48:07 +0200
Message-ID: <6c05aee81af9264ce6c19a436bc3503ecdab1e45.1790342457.git.parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790342457.git.parri.andrea@gmail.com>
References: <cover.1790342457.git.parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only in-tree way for xfs_writeback_submit() to fail is a failing
xfs_reflink_convert_cow(), which requires a shared (reflinked) CoW
extent.  There was previously no way to exercise that failure path
from userspace, which made it hard to write an xfstest for it, e.g.
for "iomap: don't resubmit an ioend after ->writeback_submit()
failed".

Add XFS_ERRTAG_WB_COW_CONVERT_ERROR to force xfs_reflink_convert_cow()
to fail with -EIO, so that ->writeback_submit() failure and its
callers' error handling can be exercised with error injection alone,
without needing a corrupted or racy COW fork.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 6 ++++--
 fs/xfs/xfs_reflink.c         | 5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6de207fed2d89..a1955b7773e1f 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -75,7 +75,8 @@
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
 #define XFS_ERRTAG_ZONE_RESET				47
-#define XFS_ERRTAG_MAX					48
+#define XFS_ERRTAG_WB_COW_CONVERT_ERROR			48
+#define XFS_ERRTAG_MAX					49
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -137,7 +138,8 @@ XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
 XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
-XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1) \
+XFS_ERRTAG(WB_COW_CONVERT_ERROR, wb_cow_convert_error,	1)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4801361366359..104542b10d9e0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -34,6 +34,8 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_metafile.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -346,6 +348,9 @@ xfs_reflink_convert_cow(
 
 	ASSERT(count != 0);
 
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_WB_COW_CONVERT_ERROR))
+		return -EIO;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
2.53.0

