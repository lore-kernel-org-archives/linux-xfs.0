Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C773922B64B;
	Fri, 25 Oct 2024 02:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729823637; cv=none; b=NXngTizHd+sw23UmanF4fE5DIj2l2L2HHlFeVd5L/9OlMhhfSfCbaZgiA4zYBqFobamk8w+JdhLsahbr0xvC8NZJuf8hBYKUF69TGwT96RkbzyHLg7VyMHO1I89tBmk9A+bfg8jb9j+fau37kL793wVuVCcM3R4EZLpvRqFnSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729823637; c=relaxed/simple;
	bh=Dxy+NMTSpb+CMX43FySawO667J6fQoNRWNne0khqdWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kRZeB5+wIoaMtrVcQV49HrgpvNMDNNUCFeWHqPtLW+KX1uYGbm4mZAYWQncmt8Iy+p7V3mL6kYuzuoc7Iq7UwBKw8IXeyJejk4oRQG8M66B/Jbbs9RwmYaGlvoxb3vM+u6nJuQkR2ZyjwtEGGMK6rMIdsVNSorN/KeoUfHTudl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pCcmI1/p; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pCcmI1/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=DMZWI
	w4jz3ayVYs49ZK9iVJIjwfzQsBjk8JXYbXvwv8=; b=pCcmI1/p9AkPkGEAsB5ic
	BRc/zLJJuZmOL/bXymPAs9TvDl7f2nUInCqoQzgzhJ+UFQRgQackn0BlVOLf0l3s
	7rUgeX7vfjOQNoleck1+3zOWkTHsCYJtLCd71ViJ5EOqA/m0x51fgDq+cgrcazz6
	GitY5pqSAaeS/bb/QivGRs=
Received: from chi-Lenovo-XiaoXin-Air-13-Pro.. (unknown [223.104.40.93])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD336N_AxtndGQFAA--.1765S2;
	Fri, 25 Oct 2024 10:33:35 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH] xfs: Reduce unnecessary searches when searching for the best extents
Date: Fri, 25 Oct 2024 10:33:20 +0800
Message-ID: <20241025023320.591468-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgD336N_AxtndGQFAA--.1765S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4kWFW5Jw1UAF47AF1UKFg_yoW8XFWfpr
	say3W0kws8Xw4fWr9rWws2q347Cwn7Wr4jqFZY9ry3A3Z8GF13Kr92krWj93W7ZrZ5W3Wr
	urs2yrW8Aw4YgaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnF4_UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawaDnWca-EqewQAAsn

From: Chi Zhiling <chizhiling@kylinos.cn>

Recently, we found that the CPU spent a lot of time in
xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
spaces.

The reason is that we conducted much extra searching for extents that
could not yield a better result, and these searches would cost a lot of
time when there were millions of extents to search through. Even if we
get the same result length, we don't switch our choice to the new one,
so we can definitely terminate the search early.

Since the result length cannot exceed the found length, when the found
length equals the best result length we already have, we can conclude
the search.

We did a test in that filesystem:
[root@localhost ~]# xfs_db -c freesp /dev/vdb
   from      to extents  blocks    pct
      1       1     215     215   0.01
      2       3  994476 1988952  99.99

Before this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0) * 15597.94 us |  }

After this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0)   19.176 us    |  }

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 04f64cf9777e..22bdbb3e9980 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1923,7 +1923,7 @@ xfs_alloc_ag_vextent_size(
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
-			if (flen < bestrlen)
+			if (flen <= bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);
-- 
2.43.0

