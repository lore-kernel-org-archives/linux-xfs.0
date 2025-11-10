Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D221CC64
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781030; cv=none; b=d7sNCp2Je6WZK2UpFAkAglfbBTGaaLdHYJ44Nxiss2zlF6kXvniJ5P23R2MuY31NxMUUqTygPPzA4te+ZnuiGoREr9YdBB0PVSu+n2kX4Uk7i3FcIIKtRSOAgpDYyZhCv6W8a0kEeYF12DgAs90mX5G3QnR3oiFfzV/nT3+WRcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781030; c=relaxed/simple;
	bh=ucxIsh61qodcuLyo9RCHk4xsFuIYxZtO/n7gtxc1ZQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGPHlU7OWmff1IS47xgR8hoiWXS370xpNG+Vnc7baIKpZGVVs1SFwnHAhHiXnI72HGEAzT0hZDzUajxWi+TnwocvMKYi1V4LuyDy9NhJmG8oWtJddsV03MPtUemvTMb+H+PIUXDnHxk74Rgbz60CDMmNAhSnFvMiYwCNAnnUnL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z3B3WEYV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z3B3WEYV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rFTZOhuMo19KDIw+860xgRGZmeVvAo8PkW31iK8tH4E=; b=z3B3WEYVsK73L0pZHXRc6K9Bpc
	hS9wc0okePBW+t8U35gLn1hoUBM7X17NLCzeGxvpf2AUEql5YR/lpr4s8zdFkS8291GgvM9TUI3ee
	D4sFecPHm/JYz/KzGwIAuUWZTmesu8oPVcgctMZsn/iNLECPhOrYHpGMorStkMt6BNlo6eWjSN+oM
	ou8wT36wb953osnCOA2gp4DYWi0GygVD17net8UG03CPgQwsrj0XIh/31CaaoC1fld7Yj5JRJ4Fi6
	XIW5cupOyC9lr2O7LSWfl30l9ROKw7tjBaGQs4q1prUytMz7dSi2n7xYR9WlwiVAaxsAJ9YDBC03H
	zQmPHshw==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRs3-00000005US7-1PQB;
	Mon, 10 Nov 2025 13:23:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/18] xfs: make qi_dquots a 64-bit value
Date: Mon, 10 Nov 2025 14:22:54 +0100
Message-ID: <20251110132335.409466-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

qi_dquots counts all quotas in the file system, which can be up to
3 * UINT_MAX and overflow a 32-bit counter, but can't be negative.
Make qi_dquots a uint64_t, and saturate the value to UINT_MAX for
userspace reporting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.h       | 2 +-
 fs/xfs/xfs_quotaops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 35b64bc3a7a8..e88ed6ad0e65 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -57,7 +57,7 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
 	struct xfs_inode	*qi_dirip;	/* quota metadir */
 	struct list_lru		qi_lru;
-	int			qi_dquots;
+	uint64_t		qi_dquots;
 	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
 	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
 	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 4c7f7ce4fd2f..94fbe3d99ec7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -65,7 +65,7 @@ xfs_fs_get_quota_state(
 	memset(state, 0, sizeof(*state));
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
-	state->s_incoredqs = q->qi_dquots;
+	state->s_incoredqs = min_t(uint64_t, q->qi_dquots, UINT_MAX);
 	if (XFS_IS_UQUOTA_ON(mp))
 		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
 	if (XFS_IS_UQUOTA_ENFORCED(mp))
-- 
2.47.3

