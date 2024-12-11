Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4B01F0E23
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907520; cv=none; b=s6TsLwNK92o82cw8f8qempo7wWbgAeBLf0O2Vuq0TuemklaybYUIEeEB5gK3V4ICuKbuXC6E2oXaVNZ+6RehvLtgp/l+ZKjCuK8HOu7mtigJwVbVaNZkEONQWgSl4KwXem/vnA3U6xSc46mBE6W/Occ3dYB8h84CGfyQahZTeng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907520; c=relaxed/simple;
	bh=Mv6BWzJlKByUEmRl4qbszg6YcXIFdX7V4m/9t+n3ZvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNemZjVopdslbLS4C3WZOeTRXDjzqr55UX4YK9uGMk34EApgK2rRBu988jxafs6UcH8nt9Jb9ZR6+iCfrkC2wDZWKjOYWZxSmhbKh2TJouQ0qx9z40AGFqHP0MLJk8U8gkhnt66xozSldhVmhkF2cr5FkNbNALqSCMvr1La1kdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4lgoPY/h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4lgoPY/h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=G6PM3csPxkLUzsfFKBcP3wgjf6ABUehnqIO59Mifqos=; b=4lgoPY/hRCcbIkDaq4vDYZ0nxn
	q3vyJ46qs/VdtOvU+Hn0sGeUsQ04qXwYsFZZMxVDUxICC5fHjTFHLRoenn4YUetsBnUWhN3r5lfvV
	ioDL1uNCxLMrEx28lI5CJnVGdxHk9FaelbX65mJHrWwCUR/GSoK/pIaaN31Dl8UeVPJ10FD9sjHph
	mq4n60lTrAkUZFvOg0L/nRxUgluz4cbyaw8G1eSecoDIhsKh9kbZEEEuzYwypGN3NMV3DZiKkCc40
	j/E5HLISWMQrJZJjvM+DLoWkzdETkRXV2PjpAajuWKXQKxViXO5/OdaU81szTqT15InOOrqCoMwp/
	pe4GqC8A==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIYI-0000000EJWv-0pqo;
	Wed, 11 Dec 2024 08:58:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 42/43] xfs: wire up the show_stats super operation
Date: Wed, 11 Dec 2024 09:55:07 +0100
Message-ID: <20241211085636.1380516-43-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The show_stats option allows a file system to dump plain text statistic
on a per-mount basis into /proc/*/mountstats.  Wire up a no-op version
which will grow useful information for zoned file systems later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d2f2fa26c487..47468623fdc6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1238,6 +1238,14 @@ xfs_fs_shutdown(
 	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REMOVED);
 }
 
+static int
+xfs_fs_show_stats(
+	struct seq_file		*m,
+	struct dentry		*root)
+{
+	return 0;
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1252,6 +1260,7 @@ static const struct super_operations xfs_super_operations = {
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
+	.show_stats		= xfs_fs_show_stats,
 };
 
 static int
-- 
2.45.2

