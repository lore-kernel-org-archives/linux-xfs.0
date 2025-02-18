Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2394222CBF3
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866431; cv=none; b=eXpOCrIZ1cg7BRDjd88GtrO1JuRNj5wP5UbXSUeKrN6OS6wBz7/FheePq86r45aOooAyMTY1LkEUoeDaLklLK1RNg7GlIRXk5IWqa7PwnuDBOOeUQB6D9FTaSGcR5JwzJCzpMh90mPFG/bfe5uH0PBpvX+34IoTXLmR5cHifQR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866431; c=relaxed/simple;
	bh=D0AvWTo8yMH1iQjDo7+was6klsYOBuBCA//bCluYxmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDSVNv3jInZGfZ0yJ+ZXsT/MdTGqL0ekElE9HsdVNYwSxUDiZPM+ZnuPqog4pUT2/FK1HRzlIRDmHyUkwVosgVj7eBAWryWAm35FHrsw2FbgoIYTNeK6oSPMtdMpVv0+X2OXFUI+LjPAisd7SMm5F4CIM0ZIB0bV2NBrL0ULjBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E0+myo1/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E0+myo1/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QUTwTCOner/UAZVqFE+3JUmlqfID/Nq+OSHyYmmIGXI=; b=E0+myo1/CeZdAuz0MRZoKvVJqv
	2O6u/5OD+clGa8DAsbuowxGcay1KvdbjU5GDQFQjxo9Wb84LKMNoTsZqyJmKfBK5tFwCz4ZMHGCBD
	ts9YoBvK1fPDFUApcq2aAL6CqoSkzQrg5HjtYdsA36woU9UKSAcnto0zILnMiXrMQ9v4f/e0DqSZs
	ZIfCX70gyobHkoAvtj8azHUddsKWxipsmWYEKWGIcZeyn/eYnwZYNsZUqqWEnOLnwrhyDPmK/C7SF
	QThbU9/2VwBX2QrUTQVf1LLK38pRc6B+5yHd4VbqBne9OEYqedVaC1z+e3gfl8gOsO5EPUbqJgYsE
	tOQqH69g==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjl-00000007Cox-14xJ;
	Tue, 18 Feb 2025 08:13:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 37/45] xfs: disable rt quotas for zoned file systems
Date: Tue, 18 Feb 2025 09:10:40 +0100
Message-ID: <20250218081153.3889537-38-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

They'll need a little more work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e1ba5af6250f..417439b58785 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1711,7 +1711,8 @@ xfs_qm_mount_quotas(
 	 * immediately.  We only support rtquota if rtgroups are enabled to
 	 * avoid problems with older kernels.
 	 */
-	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
+	if (mp->m_sb.sb_rextents &&
+	    (!xfs_has_rtgroups(mp) || xfs_has_zoned(mp))) {
 		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
 		mp->m_qflags = 0;
 		goto write_changes;
-- 
2.45.2

