Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB260DDA8;
	Sat, 12 Oct 2024 01:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728698041; cv=none; b=tvt+Gr8nfl6Js/hk3qUscdhwv49tMigunvNW9IcQnmo7uYTMxZRhuyWH3oTCvRtYIsCmuT5Vx5GZbeFr6kCtXLjCLEoMFWLOJn9XTmVMlqvXr5LSSFe59Md3kKEVegEAtJNkm8Nr6Ch+kA9F19Ktx/TEo5NnkFOLcvQv44IiAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728698041; c=relaxed/simple;
	bh=pTo9MTWv0QsKaFyXt4UL/Xq5ps9nXBmmaRoAwXWw0o4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KxZtv0nqRuTKMDSQ1AX1mLUA7M3ZS8wTgsUXsVaZTdgKm5EpqOPZwjyzdMj+EkIb0hiWuMJlFvfAmFWtbZNxJ6aY0womjXZgKXye6WUjklWOiHJ6h/qzNRs+MEkag5j3nZqEUyNY04/oCzakY9F/XhbqAmPrecXQ9ZBAOu4MpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YNdubWUF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YNdubWUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NOty4
	fg+Ho7VaI0cQHA/jory4kn7TXlj/j4VXAzH1Ak=; b=YNdubWUFSuGPCHvX+eynp
	v8Z6hxu5AH4cq5p2AaM0Z8JxY+6lUWhYGfEAiyH6FmkEKvWC1oFgWDPr5WV8SHqe
	LS7GP1Ia0DavKw+9Y4wF3Gyj9Xlih3gNomU+GOgoEM/1VoTOEMtD/aiOlvuobWty
	z91ft/iZNfnMU7AZTPSoPc=
Received: from localhost.localdomain (unknown [111.48.69.246])
	by gzsmtp1 (Coremail) with SMTP id sCgvCgAHRFWf1glnqnpaAA--.15848S2;
	Sat, 12 Oct 2024 09:53:37 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3] xfs_logprint: Fix super block buffer interpretation issue
Date: Sat, 12 Oct 2024 09:52:35 +0800
Message-Id: <20241012015235.1706690-1-chizhiling@163.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:sCgvCgAHRFWf1glnqnpaAA--.15848S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar48Wr1kJr1fGw45XF4rAFb_yoW8Zw4xpF
	1Sgay7XrZxZ34Yg3y7ZrWjvw4rKwn3Jr9rGrZFyr1rZr98Ar4Yvr9xua48uFW5GrWDtFs0
	v345KryY9w4Dua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeYL9UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBoRd2nWcJzyV4AwAAsi

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac34..e366f8f5 100644
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

