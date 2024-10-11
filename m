Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A881F4706;
	Fri, 11 Oct 2024 03:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728616159; cv=none; b=WcdHZPNBlYug1LsKCVAeiuSwEJMoPm3OLZMaZSu/b8/o4ChRswqeGtRp+ODtuwrT71oCCA412f3yv/g1HzbfIZi3sThk4xk86c6bV/3ZmAHgdpFS/x6VWHRm9n/WXZ7puNpBurhye7D4nAeczyw5MPw/IZ6yPSApVGd8TMixV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728616159; c=relaxed/simple;
	bh=9O2GVPEucZDv7QahyEN2PAUsoIcZNzzHDZ/w1q4rxJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dgseQZNdICIWyH0TgEmRnWCdsNsQjFjzI69/O5atlJK5cFvhxldv5MVdVKEuR4h1lSEm7wVd7K16hUQwh4pfC8wA+YJ84sFFYnXVRvr1NJKMVqdE+zhuRwq19y0Xx2tvX1YRfbQ5KHI/Gn6qT0OJ1q9xTUc9Ck+Y731Aq1f0itk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Z6MU5fpL; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Z6MU5fpL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Jimxn
	Ltno1wlEXg2S3CZIrDg3U7f2ezu1aSJZxUj7fg=; b=Z6MU5fpLzCJPrjULwM876
	K/s3nDyjK6qFVGVCmZ9qfTCHE4zunbUB9AcCsMQq1GQ6I0fnwL/HKL2OeFW2gBUH
	IwVAEIyL+HlVborqE8Wn2JbZu64fYv8mrbNgwgiiC7Uzw7pbsGU3cevB5DLejqsY
	v7Z0rtcb1xwzJkyBNreFHY=
Received: from localhost.localdomain (unknown [111.48.69.246])
	by gzsmtp2 (Coremail) with SMTP id sSgvCgC3f0zRlghn9H9CBw--.22922S2;
	Fri, 11 Oct 2024 11:09:06 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chizhiling <chizhiling@kylinos.cn>
Subject: [PATCH] xfs_logprint: Fix super block buffer interpretation issue
Date: Fri, 11 Oct 2024 11:08:10 +0800
Message-Id: <20241011030810.1083636-1-chizhiling@163.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:sSgvCgC3f0zRlghn9H9CBw--.22922S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar48Wr1DKw4xuFyDZFWrXwb_yoW8AryfpF
	1fXaykGrZrA34aga13Zr40yw1rGwn7JFW7GrZ0yw1rAry5Jr4YkF9aka4Uu3sxWrWUJr1Y
	v345KFZYv3Zru3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jn9N3UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTwZ1nWcIk89C3wAAsP

From: chizhiling <chizhiling@kylinos.cn>

When using xfs_logprint to interpret the buffer of the super block, the
icount will always be 6360863066640355328 (0x5846534200001000). This is
because the offset of icount is incorrect, causing xfs_logprint to
misinterpret the MAGIC number as icount.
This patch fixes the offset value of the SB counters in xfs_logprint.

Before this patch:
icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0

After this patch:
icount: 10240  ifree: 4906  fdblks: 37  frext: 0

Signed-off-by: chizhiling <chizhiling@kylinos.cn>
---
 logprint/log_misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac34..21da5b8b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -288,13 +288,13 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 			/*
 			 * memmove because *ptr may not be 8-byte aligned
 			 */
-			memmove(&a, *ptr, sizeof(__be64));
-			memmove(&b, *ptr+8, sizeof(__be64));
+			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_icount), sizeof(__be64));
+			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_ifree), sizeof(__be64));
 			printf(_("icount: %llu  ifree: %llu  "),
 			       (unsigned long long) be64_to_cpu(a),
 			       (unsigned long long) be64_to_cpu(b));
-			memmove(&a, *ptr+16, sizeof(__be64));
-			memmove(&b, *ptr+24, sizeof(__be64));
+			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_fdblocks), sizeof(__be64));
+			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_frextents), sizeof(__be64));
 			printf(_("fdblks: %llu  frext: %llu\n"),
 			       (unsigned long long) be64_to_cpu(a),
 			       (unsigned long long) be64_to_cpu(b));
-- 
2.43.0

