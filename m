Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E069D207217;
	Fri, 11 Oct 2024 07:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633265; cv=none; b=JbEG9xroHKsR4O6yOV951jCueCVMKPozOMsxYLv/2FS2X5UJVVLUq/EfVcAcY4guTUY0iyGs+SoXLYpghfroDdC29uH5tYMHWSgdRgX2LubXSI0tBRSdi5JHXR8/nbjVitaJTAefs3J2GVeAj79fLWJNuTLabRSj9n65xQ2cL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633265; c=relaxed/simple;
	bh=6JeQyd0c8h6RtBAMrBtN4DSbkr16wXNlaw/MAJzuD2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hcIKz5tzz09PRyFZaTdFJXBmed0bUBlWl9oN5Rk7dfubv+iikfGhfo434mxXPnm3UdftLt4RfxJo1WqdONRx0aoJlTN8irijK6f4C0hatDQW+zdd4KdH5vyjiGEeyOxf6bfAyyAxNr66pgdbYY3eOpojNy0gXfG4laY1xtg+tPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZQw6tHqR; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZQw6tHqR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=U/CVm
	t5l+frEnKIs1+WGrJXGajHa4xlTG6NHk14H6D4=; b=ZQw6tHqR199s8wqNxExcP
	rBhMAORisON7XtHoQb94QxkJRMs5tTgBPgCZMGSVgr2RfYYwId/SbTYSxWGXjVO8
	6dOBACI12pHdGxqhMy9yvzO5gZq6QCCw1a60+ravLNZFGrr8EWXnBqdwVXna6ltT
	tnsnOSPMmuiZ2mmSer12n4=
Received: from localhost.localdomain (unknown [111.48.69.246])
	by gzsmtp1 (Coremail) with SMTP id sCgvCgA3yzug2Qhnj5xYAQ--.57305S2;
	Fri, 11 Oct 2024 15:54:09 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v2] xfs_logprint: Fix super block buffer interpretation issue
Date: Fri, 11 Oct 2024 15:52:53 +0800
Message-Id: <20241011075253.2369053-1-chizhiling@163.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:sCgvCgA3yzug2Qhnj5xYAQ--.57305S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar48Wr1DKw4xuw1ruF13CFg_yoW8Zr48pF
	1Sga47XrZxZ34Yg3y7ZrWjvw4rGwn3Jr9rGrsFyr1rZr98Ar4Yvr9xua48AFy5GrWDtFs0
	v345Kr909w4Du37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeYL9UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTwh1nWcIzY7lhAAAsi

From: Chi Zhiling <chizhiling@kylinos.cn>

When using xfs_logprint to interpret the buffer of the super block, the
icount will always be 6360863066640355328 (0x5846534200001000). This is
because the offset of icount is incorrect, causing xfs_logprint to
misinterpret the MAGIC number as icount.
This patch fixes the offset value of the SB counters in xfs_logprint.

Before this patch:
icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0

After this patch:
icount: 10240  ifree: 4906  fdblks: 37  frext: 0

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 logprint/log_misc.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac34..0da92744 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		if (be32_to_cpu(head->oh_len) < 4*8) {
 			printf(_("Out of space\n"));
 		} else {
-			__be64		 a, b;
+			struct xfs_dsb *dsb = (struct xfs_dsb *) *ptr;
 
 			printf("\n");
-			/*
-			 * memmove because *ptr may not be 8-byte aligned
-			 */
-			memmove(&a, *ptr, sizeof(__be64));
-			memmove(&b, *ptr+8, sizeof(__be64));
 			printf(_("icount: %llu  ifree: %llu  "),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
-			memmove(&a, *ptr+16, sizeof(__be64));
-			memmove(&b, *ptr+24, sizeof(__be64));
+			       (unsigned long long) be64_to_cpu(dsb->sb_icount),
+			       (unsigned long long) be64_to_cpu(dsb->sb_ifree));
 			printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
+			       (unsigned long long) be64_to_cpu(dsb->sb_fdblocks),
+			       (unsigned long long) be64_to_cpu(dsb->sb_frextents));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-- 
2.43.0

