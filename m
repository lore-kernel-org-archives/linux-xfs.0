Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B35298264
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 07:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527628; cv=none; b=bmF7RUWpDXHEsPirJ3/++/ZCXEdFfzwN5qIsk5dzCzTtMMH8GfiAZOdgKiT2o0fumN4wXQeKkMxvFPX+hFNuTTu5PHjQtG0cJbPDRbyz+IMzUIrPjluD22sNG/SyTHsrke0/Qp1fz1ZmNvnvGnObu/+3YGEAXNJuvnbeHiObERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527628; c=relaxed/simple;
	bh=mqr15H9f5G+K5AptXbVk8SX6o5W3vtyI/5yyGKBWcwU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p8C6vWfHCyWYE7ncjUAuF+Rtq/gAXarmNq4Fz5hLqsrAmHV1re3xFUMMhqp7/59wybtvaUcf5lXTEA1GySjcOkvNyR5KozG4FidbwGg1awG9LS8Z4d3n9bxvKC1HLwwgKnz2fYQ0BbD6bCJjOhX57ze574hD58p0OvaCv+U8AAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmVtPUlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmVtPUlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8BAC4CEE3;
	Thu,  3 Jul 2025 07:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751527628;
	bh=mqr15H9f5G+K5AptXbVk8SX6o5W3vtyI/5yyGKBWcwU=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=mmVtPUlrq9PG0DqpDU+FYP38ly0QKdIwiFTsKig+OockfSN/xgcRoD0dsXphkrlN9
	 FJFAIYreI+2TZfz3m5fdGetZO/OB3TLYGBuuGNN3PqwynJHwB6ETCPlOCUu+r4vVGt
	 ijqsGW0pVnXn8JrzSfpekwQ4GCu7QMa+38FOC/KPAc8oIdwubgc8w7UcGMFDRCy8IH
	 jUWFwRlpheTAWgOMqcl6FHDfbLXn3yNU3HzOGMi5aPjou97V86gmqLcGxm/MZSFTwy
	 AVZvS9GMpq4Zm0ZbxK1HfzE1MLlYHVrFLSYSOZXieF+MSkRkNXl9caim9eF8Q8Xq+y
	 i0Aae15BIVegw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
In-Reply-To: <20250625224957.1436116-2-david@fromorbit.com>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <20250625224957.1436116-2-david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: xfs_ifree_cluster vs
 xfs_iflush_shutdown_abort deadlock
Message-Id: <175152762746.887599.3611422272528112780.b4-ty@kernel.org>
Date: Thu, 03 Jul 2025 09:27:07 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 26 Jun 2025 08:48:54 +1000, Dave Chinner wrote:
> Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
> -> IFLUSHING, except for the last inode in the cluster that is
> triggering the free. In that case, the lock order is ILOCK ->
> cluster buffer -> IFLUSHING.
> 
> xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
> so this can safely run concurrently with xfs_ifree_cluster().
> 
> [...]

Applied to for-next, thanks!

[1/7] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
      commit: 09234a632be42573d9743ac5ff6773622d233ad0
[2/7] xfs: catch stale AGF/AGF metadata
      commit: db6a2274162de615ff74b927d38942fe3134d298
[3/7] xfs: avoid dquot buffer pin deadlock
      commit: d62016b1a2df24c8608fe83cd3ae8090412881b3
[4/7] xfs: add tracepoints for stale pinned inode state debug
      commit: fc48627b9c22f4d18651ca72ba171952d7a26004
[5/7] xfs: rearrange code in xfs_buf_item.c
      commit: d2fe5c4c8d25999862d615f616aea7befdd62799
[6/7] xfs: factor out stale buffer item completion
      commit: 816c330b605c3f4813c0dc0ab5af5cce17ff06b3
[7/7] xfs: fix unmount hang with unflushable inodes stuck in the AIL
      commit: 7b5f775be14ac1532c049022feadcfe44769566d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

