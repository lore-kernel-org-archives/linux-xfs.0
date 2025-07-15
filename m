Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56AA1D5CFB
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582732; cv=none; b=MKCL7POPqf49nEbPGK7d6QHPwVOYt/SpIJkwyMQS6rfWyYontbHgVMu6ElWyDuVAMK6CtBkgBWyvBH/OBd1Rtpfdwjh5nTG1oVjNN8PsrL7ll7ex80ctiv3/xbEqd5jp9Vp/zqrw+g13KL2fdjVdEujb5puCt8xrV/+3Tr3EwyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582732; c=relaxed/simple;
	bh=ivqZNb8VNMuiYW4icd2MqpmXJAPusZaLruR5WD19Bfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i28TMbZU39fe3fVozv7epvm4jhBjogpbB1p36r+lr5Uh7IqSHtYySqqO20ykl0OURQGRcxNYWaJI8yEWgxTWZ1CA+shtVVD5w8NyjR/zjV/2ndSzkHKnCvmdBC4fopSfx2ZWG+vKjTLUje2nJ5BJg/O/olrjbKfIgmcOu3D1iqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MrFu8UuI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MrFu8UuI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VqxtxMr/mGdS+MhDaVQqRPYvuDK7FAAhgIKZgnBRf/U=; b=MrFu8UuImGz2opAdM47CRHijfZ
	Vfgl2SsLrU7zkkLdziEmlTmn0+xKlTFLQeArTItkV5/782iYY1iTLcnjMGoXGkmckRA/94Zim3tVh
	INu9T7TaaFigFrixUt6Ud2GUh0/I2t7sLgic92UKK7L20V+kFErqUABkZme+JpIOE/zu1k0Nzg5LN
	TfyZ+nGbD/Dkv1SLSWwZ0lED2aPayNNCv7XEQDAPsyPpCN7HC7qcX6iclfzK5UUmonkSZ4aVqMAFx
	w/1KE8ikVIWoBcUzI5V10saKWrDWpaODmIwgIYmh7At41YyrufmfQta8pdByWlS/KJLuvqR0uhp0v
	R5K/NVMw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepN-000000054vR-3ggJ;
	Tue, 15 Jul 2025 12:32:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/18] xfs: regularize iclog space accounting in xlog_write_partial
Date: Tue, 15 Jul 2025 14:30:19 +0200
Message-ID: <20250715123125.1945534-15-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xlog_write_partial splits a log region over multiple iclogs, it
has to include the continuation ophder in the length requested for the
new iclog.  Currently is simply adds that to the request, which makes
the accounting of the used space below look slightly different from the
other users of iclog space that decrement it.  To prepare for more code
sharing, adding the ophdr size to the len variable before the call to
xlog_write_get_more_iclog_space and then decrement it later.

This changes the contents of len when xlog_write_get_more_iclog_space
returns an error, but as nothing looks at len in that case the
difference doesn't matter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 15fc7cac6da3..19f5521405bf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2079,10 +2079,10 @@ xlog_write_partial(
 			 * consumes hasn't been accounted to the lv we are
 			 * writing.
 			 */
+			*len += sizeof(struct xlog_op_header);
 			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset,
-					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt);
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt);
 			if (error)
 				return error;
 
@@ -2095,6 +2095,7 @@ xlog_write_partial(
 			ticket->t_curr_res -= sizeof(struct xlog_op_header);
 			*log_offset += sizeof(struct xlog_op_header);
 			*data_cnt += sizeof(struct xlog_op_header);
+			*len -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
-- 
2.47.2

