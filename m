Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25961EA65;
	Fri, 24 Jan 2025 03:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737689018; cv=none; b=ASEH2ZMvDE/ZOvV8ssbrVjL/vymC7U+FoZInDPZdQz7HucV+IPPXdluhRuBqUjd20u0tEuSDB+D37rfzmocqaxeFMoV66y6CnO05risHZARHTg5y14JQU3rTGWFwRSpy6vhRVpo+AdjUAIbn0afqcAA0uMyeidkzE9/mgTZjrTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737689018; c=relaxed/simple;
	bh=qkx0Gk7rjTf1YfSHOoHWCjI1qBWj8j+cUch7mzNw6Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o1kw7WRUZqmSJDf1xHPGkGcUWg7nkMsD2YI36LMSNbbUt1pbQU2ESREHtieQaLp/y2XH5zArZ7xWdY0MIEgDOGVyR3SZ3xk17kdQ1o0WXngjdsepg69zFEx6nf4Hw65etEdJdRO02tTLIrRKl+IHQ/xEllpfWPPb/M19+zFEq4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [220.197.230.228])
	by APP-01 (Coremail) with SMTP id qwCowAAnVPunB5NnFf8YCQ--.21568S2;
	Fri, 24 Jan 2025 11:23:24 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
Date: Fri, 24 Jan 2025 11:22:28 +0800
Message-ID: <20250124032228.587-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnVPunB5NnFf8YCQ--.21568S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyfXFyDKrW3AryDXw1xAFb_yoWDJrX_ta
	1vkr4xWa12y3y7Aws3Ar9YyFnIkanrKFsxXay8ta9xtryUGF1kKr4vyFZayr9rW3Za9F95
	Gw1Durs3tFy7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUehL0UU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRAMA2eSg5HFqwABse

In xfs_dax_write_iomap_end(), directly return the result of
xfs_reflink_cancel_cow_range() when !written, ensuring proper
error propagation and improving code robustness.

Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
Cc: <stable@vger.kernel.org> # v6.0
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/xfs/xfs_iomap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 50fa3ef89f6c..d61460309a78 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -976,10 +976,8 @@ xfs_dax_write_iomap_end(
 	if (!xfs_is_cow_inode(ip))
 		return 0;
 
-	if (!written) {
-		xfs_reflink_cancel_cow_range(ip, pos, length, true);
-		return 0;
-	}
+	if (!written)
+		return xfs_reflink_cancel_cow_range(ip, pos, length, true);
 
 	return xfs_reflink_end_cow(ip, pos, written);
 }
-- 
2.42.0.windows.2

