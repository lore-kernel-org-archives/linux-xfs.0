Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DEE1197A7F;
	Thu, 16 Jan 2025 09:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018656; cv=none; b=D9HyNk80u6qhWf4r3liLejj5lRLQCtWOyP2Njp0eeeadk9oE++iW3fvng0iLef8/1jF8mDDqNFoeZY4wFHv05Y6cRqKnCBLdEvzITcdm41/cMYLeM2Q8qQ44ghoYkuPzVPN2gWVEIX5GZzw09XdW52PuoNgb5p9J7FBE1fdCAb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018656; c=relaxed/simple;
	bh=O5ornF5BgnVQpbi8z/ibFN+eop0j21Vrindf1ebLtjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kHg/T8lflPapw/X3MZsqIjS+/DJft8uY+K+s3xnAv8Xqa6F8soEyX2orZ3MmLG33woPC45CIwbyhLJ8Rf4qtZQdlt1/6KmYkxwzwaaum7549KmM/fxKMTn3xt99C31QFFNCen5XRExHBW3HFBGPF5KP8oHX7u2tzygPqYtMACjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UsQFeGoD; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UsQFeGoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=cQZ7J
	JVHmlG/sf06wZJr6CJHru1AMn9agI2xuZr/lVI=; b=UsQFeGoDhzZtXEQXXWWgf
	W5PRauRYIu7LNBLoT8JITk8fNlwvbFoKNvjxOoyBOq6xIkf2rNs2uvAvX4BQlTnm
	HlC7EtvVyorOCRhGofQBz5UGFbyBR3zniYVk7QSMWYoIR05PRP2+7uMj1baMvzk9
	LMhYPDOJ3v98G9m/H111c0=
Received: from chi-Redmi-Book.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDX6P3tzIhnVp0iGQ--.6546S2;
	Thu, 16 Jan 2025 17:10:06 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: djwong@kernel.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v5] xfs_logprint: Fix super block buffer interpretation issue
Date: Thu, 16 Jan 2025 17:09:39 +0800
Message-ID: <20250116090939.570792-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX6P3tzIhnVp0iGQ--.6546S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGry5ZFW7Jr1fur4rGF1kAFb_yoW5Kr1rpF
	1fKa4jqrZxZ34ag343ZrWjvwn5KwnxJrZrGrZFyr1rZr98AF1avrZrAa4rAFy5C3ykXF4Y
	yryYgFyq9r4DuFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jno7tUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBaxnWnWeIw5K1QAAAsy

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
---
 logprint/log_misc.c      | 17 +++++------------
 logprint/log_print_all.c | 22 ++++++++++------------
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac34..973bc90c 100644
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
+			       (unsigned long long) get_unaligned_be64(&dsb->sb_icount),
+			       (unsigned long long) get_unaligned_be64(&dsb->sb_ifree));
 			printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
+			       (unsigned long long) get_unaligned_be64(&dsb->sb_fdblocks),
+			       (unsigned long long) get_unaligned_be64(&dsb->sb_frextents));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index a4a5e41f..cd5fccce 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -91,22 +91,20 @@ xlog_recover_print_buffer(
 		len = item->ri_buf[i].i_len;
 		i++;
 		if (blkno == 0) { /* super block */
+			struct xfs_dsb  *dsb = (struct xfs_dsb *)p;
+
 			printf(_("	SUPER Block Buffer:\n"));
 			if (!print_buffer)
 				continue;
-		       printf(_("              icount:%llu ifree:%llu  "),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p)),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+8)));
-		       printf(_("fdblks:%llu  frext:%llu\n"),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+16)),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+24)));
+			printf(_("              icount:%llu ifree:%llu  "),
+				(unsigned long long) get_unaligned_be64(&dsb->sb_icount),
+				(unsigned long long) get_unaligned_be64(&dsb->sb_ifree));
+			printf(_("fdblks:%llu  frext:%llu\n"),
+				(unsigned long long) get_unaligned_be64(&dsb->sb_fdblocks),
+				(unsigned long long) get_unaligned_be64(&dsb->sb_frextents));
 			printf(_("		sunit:%u  swidth:%u\n"),
-			       be32_to_cpu(*(__be32 *)(p+56)),
-			       be32_to_cpu(*(__be32 *)(p+60)));
+				get_unaligned_be32(&dsb->sb_unit),
+				get_unaligned_be32(&dsb->sb_width));
 		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGI_MAGIC) {
 			int bucket, buckets;
 			agi = (xfs_agi_t *)p;
-- 
2.43.0

