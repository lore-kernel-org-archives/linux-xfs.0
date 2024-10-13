Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F7A231C9E;
	Sun, 13 Oct 2024 04:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728793851; cv=none; b=Wusodh9Rp/HSLOhIph5P7KuIKpEguXvfn4UJUF4gea5beevsU2j/urXgifbTsYZj5sMpfBoDUAgeihMG/yXZBbghH5/Xn9ZnwwrMgcO87ssFb4KPw4NohZGQNhNoSlarOPgskSUkwYsvUYPzDsNsUyuPAofB0mJyMKtgij+yCI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728793851; c=relaxed/simple;
	bh=A3BKBAnCPA0tubQ1UAdfs8rsJbJXWkufPlL2gVFHBdI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ebbgnwu7GYcdoDPjwSTWRPPB1kH2VUoVDWlO9Pvb3jEAhcAq/WkmlE8+CezGkEx0/9MAHmBxFkf9qaoGEtXy1Nxx6lpWiTeH3SzLAHeFIA36iZ2n2nCBUJ8QFGW/ZpU9FUUyvpLmtU1DmoVLxPPgrxui6EemH5KggD3wpqm/HwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=O1zX8XQG; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="O1zX8XQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=xMJGo
	IeC3UwqZh4cNC+vA6EmeWp/mpW1QiXEt8r0F1w=; b=O1zX8XQGnt6bbH8/gRUNs
	l3yGIQPtA5cSOOJnyCW7JRq0mXyEtcvydWlN7J1Xx7AYvIDMBBfTUcTHx8t20LFb
	i4a0gDkit3pfqJqoBDuj+jHfDd2hzbXyXq5zRlbdDFbF8XAHW7gMMU8b9tHJ7vdk
	FdSs5kY92w90GDXN/Sh4OU=
Received: from localhost.localdomain (unknown [111.48.69.246])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCHD3fPTAtnUXk3Aw--.27618S2;
	Sun, 13 Oct 2024 12:30:08 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4] xfs_logprint: Fix super block buffer interpretation issue
Date: Sun, 13 Oct 2024 12:29:52 +0800
Message-Id: <20241013042952.2367585-1-chizhiling@163.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHD3fPTAtnUXk3Aw--.27618S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar48Wr1kJry8Wr4UtF15twb_yoW8uFyDpF
	1fGa4UXrZxA343K3y7ZrWjywn5G3s3Jr9rGrsFyr1rZr98Aa1avrW7Ca4ruFW5GrWkJF4Y
	vryYgr90vw4q937anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jouWdUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxl3nWcLPWStTQAAsp

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
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac34..803e4d2f 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		if (be32_to_cpu(head->oh_len) < 4*8) {
 			printf(_("Out of space\n"));
 		} else {
-			__be64		 a, b;
+			struct xfs_dsb	*dsb = (struct xfs_dsb *) *ptr;
 
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
+			       (unsigned long long) get_unaligned_be64(dsb->sb_icount),
+			       (unsigned long long) get_unaligned_be64(dsb->sb_ifree));
 			printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
+			       (unsigned long long) get_unaligned_be64(dsb->sb_fdblocks),
+			       (unsigned long long) get_unaligned_be64(dsb->sb_frextents));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-- 

2.43.0

