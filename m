Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24C3876DB
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682569; cv=none; b=b5cstueMw0c5P6HiBAvSmiRkrwbE8QO7g9XIsV0PKC6LS8BmHozyyabAKaOb5pc/AoqDeRPY29Bvme+xvQOAKfTSzBUEPQpvgE//2K9UbyQ8Dn9t60mgMIDnoEEkQuB0CP6dDQfM/m0NR870ZahYDDEDY/7P8qaQ3fxDahgrGY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682569; c=relaxed/simple;
	bh=3kSaZXC1CmOVkP4F/T95Zvg22FlLR4evYJps3NLvZ3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDPM5glRBMaV5MS79gxIOJ9Cs1PEzuSpn0EDobvF/Wo6aebLvB/kQ2s7/K8IK4UTWVvEZSLQ4/ypGUY4/aB9idgwEHy0HIZmHA3CPWbdwd1oTZD90UODW54lPJ5Y1bs/e3um7zEtovDJY/VX0aEA5iQYNFBPUw8f7ut4NdWnv90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4fzj8N1ydjz9v1Q;
	Mon, 20 Apr 2026 12:56:04 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v3 3/3] xfs: add a sysfs entry to enable write zeroes even if HW does not support it
Date: Mon, 20 Apr 2026 12:55:39 +0200
Message-ID: <20260420105539.3644999-4-p.raghav@samsung.com>
In-Reply-To: <20260420105539.3644999-1-p.raghav@samsung.com>
References: <20260420105539.3644999-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4fzj8N1ydjz9v1Q

From: Lukas Herbolt <lukas@herbolt.com>

Add a xfs sysfs entry that will not return ENOTSUPP for
FALLOC_FL_WRITE_ZEROES flag in fallocate even if the hardware does not
support deallocate on write zeroes. This is useful for testing this
feature independent of the HW underneath.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_file.c   |  3 ++-
 fs/xfs/xfs_sysctl.h |  1 +
 fs/xfs/xfs_sysfs.c  | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 99a02982154a..d70959a855db 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1388,7 +1388,8 @@ xfs_falloc_write_zeroes(
 	if (xfs_is_always_cow_inode(ip) ||
 	    !bdev_write_zeroes_unmap_sectors(
 		    xfs_inode_buftarg(XFS_I(inode))->bt_bdev))
-		return -EOPNOTSUPP;
+		if (!xfs_globals.allow_write_zero)
+			return -EOPNOTSUPP;
 
 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
 	if (error)
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index ed9d896079c1..ef46cfdfae43 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -86,6 +86,7 @@ struct xfs_globals {
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
 	bool	always_cow;		/* use COW fork for all overwrites */
+	bool    allow_write_zero;       /* Allow WRITE_ZERO on any HW */
 };
 extern struct xfs_globals	xfs_globals;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 676777064c2d..ed35f5919fbd 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -315,6 +315,30 @@ bload_node_slack_show(
 }
 XFS_SYSFS_ATTR_RW(bload_node_slack);
 
+static ssize_t
+allow_write_zero_store(
+       struct kobject  *kobject,
+       const char      *buf,
+       size_t          count)
+{
+       ssize_t         ret;
+
+       ret = kstrtobool(buf, &xfs_globals.allow_write_zero);
+       if (ret < 0)
+               return ret;
+       return count;
+}
+
+static ssize_t
+allow_write_zero_show(
+       struct kobject  *kobject,
+       char            *buf)
+{
+       return sysfs_emit(buf, "%d\n", xfs_globals.allow_write_zero);
+}
+XFS_SYSFS_ATTR_RW(allow_write_zero);
+
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
@@ -324,6 +348,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(larp),
 	ATTR_LIST(bload_leaf_slack),
 	ATTR_LIST(bload_node_slack),
+	ATTR_LIST(allow_write_zero),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_dbg);
-- 
2.51.2

