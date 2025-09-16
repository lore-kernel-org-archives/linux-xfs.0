Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AD21CC4F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031009; cv=none; b=mCDei7oaEAbh2idy7oSo5ETF05L1jqSo+Zyp0yHNdJvTVxEKbh2KaCA/F1Hdxr57kGby4HH45xgZoOFrL28B6S7p4RMGcSFMKMF1COigNbTDbyjDFan9aSSgilEvwXED8F15uuDpC3QAlZ/Ab+QT5GfTeP8KfBCplUPYfOsyZPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031009; c=relaxed/simple;
	bh=MQcSMDdC/QTFfaHV06K5zE3weIsIYLkJI74tb1oypDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPFgif9oN/aHgwE8pyJM9nzZ/k2XtUfp1bFFHcXgCoAPzeVQSYl3RufZYJSeNT7LXUJFsX/ibmvMKpTySZhi5yFwmzLDEsvKWoFyPk+6fCX4+vyY4wLufThMKXgw0E7Os4StV8G/5fayW2in/qKPI0kYUMEcMYVlABESCm6zb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mA8g31oy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mA8g31oy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JjnP/VP+WIEawsYDCCHmwZJUMjSG9goFtDoUc2T4+ZM=; b=mA8g31oyEAvbXCAdInDze7AfdH
	fqbURnKMQ121x+vYKM5SvuL1AXN0dhwCEtRAaMYyZV30wUQMeoy+zhW0E1s/BygwqCCN5kGvKTTTd
	7aB1PQ49LtS1tM3qV2TkJyAUQryMOLkz+ZXjgBxCaLJmJ/Il6zfspW9HchhKj2a2REd8xPuIKqxn2
	ILNz2iV8Ng6+XnnJPmbZHstIwmCYsQHiiZ4K64GzAt8pCmwVObwyEwFYv+8PZpN/Q/7cJfsdLIIB6
	n6v+pnYhIbPgdo6XOAGF0aHPBl3lzZHfbpu5sCJrn2Fydja0VcSikeZgQIe1HeR8Sqi5wPU/J1IQs
	UttNcgjg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyWAp-000000080VK-2chV;
	Tue, 16 Sep 2025 13:56:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: remove l_iclog_heads
Date: Tue, 16 Sep 2025 06:56:31 -0700
Message-ID: <20250916135646.218644-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916135646.218644-1-hch@lst.de>
References: <20250916135646.218644-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

l_iclog_heads is only used in one place and can be trivially derived
from l_iclog_hsize by a single shift operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 11 +++--------
 fs/xfs/xfs_log_priv.h |  1 -
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a8e2539defbf..ca46cdef4ea4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1277,13 +1277,8 @@ xlog_get_iclog_buffer_size(
 
 	log->l_iclog_bufs = mp->m_logbufs;
 	log->l_iclog_size = mp->m_logbsize;
-
-	/*
-	 * # headers = size / 32k - one header holds cycles from 32k of data.
-	 */
-	log->l_iclog_heads =
-		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
-	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
+	/* combined size of the log record headers: */
+	log->l_iclog_hsize = DIV_ROUND_UP(mp->m_logbsize, XLOG_CYCLE_DATA_SIZE);
 }
 
 void
@@ -1534,7 +1529,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	for (i = 0; i < log->l_iclog_heads - 1; i++)
+	for (i = 0; i < (log->l_iclog_hsize >> BBSHIFT) - 1; i++)
 		rhead->h_ext[i].xh_cycle = cycle_lsn;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ac98ac71152d..17733ba7f251 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -406,7 +406,6 @@ struct xlog {
 	struct list_head	*l_buf_cancel_table;
 	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
-	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_bufs;	/* number of iclog buffers */
-- 
2.47.2

