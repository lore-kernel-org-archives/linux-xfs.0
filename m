Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF2248F69;
	Wed, 15 Oct 2025 05:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760504494; cv=none; b=ukof6cdOTjngzjwwF3+3am0CzU7IEh6Cr2Rk9YAjFYVG2jHq0PW85gPFPd1etPxnZ5lW1a+Iudbzx6HLDbwng1XfF9sKF1RihoMSPk620aaWWIIus+9GtZ8Z/9h+XHkSGRvHQBbQoW5UbtEWnUSmHKsslB6r3cBYdQz970N+Tzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760504494; c=relaxed/simple;
	bh=tkkqzdE+2jTaS6c3g1mX89tuvXUv/s1bcsQMoCd3IDo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Bh+jxfloHq7XrFODWnwsPRl7YULguMF8a5YaCZc5bfIOcBd7k2+NYtGy0hxsg2eL+55zwro3YWvNa8C8SYiCqSCO3kcJuWgedtQQC9wdd652kgsyaHhcB191qXhQbgD7RL2rCyFIuRYp+wvLtpNXHD5ECe91aC9Vs9XuulMqbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhKow5BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhKow5BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7A2C4CEF8;
	Wed, 15 Oct 2025 05:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760504494;
	bh=tkkqzdE+2jTaS6c3g1mX89tuvXUv/s1bcsQMoCd3IDo=;
	h=Date:From:To:Cc:Subject:From;
	b=WhKow5BGNQPkiUGr+qdHzWvuah3Buz8+aKPQqC3m5oiKp4NFk01CcddXJuJKBl9cJ
	 ApAft+pAyBTvTBJbiUWN8Q0WhYudnUlGwPCCjvD2lV7XimsNCqa6e0bH90hpx0MgHM
	 JQYnnSJsQetEHi0GMXTk+oMo/iX4KUF2JcZO0FtV8H+smvkFVBds1rvunZxBd4nnX5
	 tfEWQH/kLfEe2u/GY/xa4Lrp2HcV0oBZd+fvPylYMDj1ZuZAhkqKQN0VBuShSoDRsP
	 UWav89dbaJjY28S3d1NETLkMgEfVnjipzM2jD3hsMj2t6FOpY1LSTXZbuWNSRkvPBT
	 BT/+7cdnp4L3w==
Date: Tue, 14 Oct 2025 22:01:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH v2 1/3] xfs: don't set bt_nr_sectors to a negative number
Message-ID: <20251015050133.GV6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
using a signed comparison.  This causes problems if bt_nr_sectors is
never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
because even daddr 0 can't pass the verifier test in that case.

Define an explicit max constant and set the initial bt_nr_sectors to a
positive value.

Found by xfs/422.

Cc: <stable@vger.kernel.org> # v6.18-rc1
Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h |    1 +
 fs/xfs/xfs_buf.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8fa7bdf59c9110..e25cd2a160f31c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
  */
 struct xfs_buf;
 
+#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
 #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965dc29..47edf3041631bb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1751,7 +1751,7 @@ xfs_init_buftarg(
 	const char			*descr)
 {
 	/* The maximum size of the buftarg is only known once the sb is read. */
-	btp->bt_nr_sectors = (xfs_daddr_t)-1;
+	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
 
 	/* Set up device logical sector size mask */
 	btp->bt_logical_sectorsize = logical_sectorsize;
