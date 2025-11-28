Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A821D5B0
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311480; cv=none; b=rvn2YBC7lPOcHrkPLfiwKouyJdsd5Eq8127fDx6tHngYsKxWXyj+orIXxVuicJr3vrifvJDdZ8v3LWR6n76U2JkyExzK2pyb2alhOh72SLYEoSMj4Wv69APmdoum/Raqh4UkNrAKEncjYUVUuf1qycHL7CY5sWw60DC3IyOTqhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311480; c=relaxed/simple;
	bh=+FmSRK8jGbPF0o6bi/e/ZZ3FwEar9ceefl1wv9ECpYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liTVXlmVrCBYvELpJFC4nfKPMJVj+HrrXti98JmzNx88fz2jAMWV19Kwz05LnGF/ExRul/U6LpfVdFWyt0e+lvoof1Zqe+3HI3M31m0agcBJvs/iPhoqZ3ufbZLWZOMHF8FCC07z3vN5z5jxTkeySU3S3SMdxMCupvo3gIsmjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ax536AEm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ax536AEm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zg8Y9XUls39jw7+kb+OnNpfyeqC4Zd0u9Neapw26tKA=; b=ax536AEmpyzct5QBipo9RQKO1C
	H28y//LaAP3NMg+xvy+2O3t/tOUC0CwEckayjPacglgITuF6fJePtf0uI0UFEq8PHLCGaC2OFQzJC
	SncEJ2Lk17Ieiw4TrnhW7Bfuqiqye+xL1YKjH53YNvTq6HjUdSo4IFj3W6r1WZbQ4Snvp0p6m97fQ
	yTHcQT+llLZOQSb+pNDz43AN6eKOoB3UqQUl6hhqGAXpPzaOtJCXHR/JkA4xWczUvqQsE5Pcr0ZLr
	745S2F7YMSdhtK93kbLLLu/LFB+feR6DmoN2N6uFofEl1KsHbGAPCWEnlzb3avVZwCvrwCaZcetl9
	f75GVBNA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0k-000000002cR-1py5;
	Fri, 28 Nov 2025 06:31:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/25] logprint: cleanup xlog_print_trans_qoff
Date: Fri, 28 Nov 2025 07:29:46 +0100
Message-ID: <20251128063007.1495036-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Re-indent, drop typedefs and invert a conditional to allow for an early
return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 533f57bdfc36..227a0c84644f 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -510,23 +510,22 @@ xlog_print_trans_buffer(
 }
 
 static int
-xlog_print_trans_qoff(char **ptr, uint len)
+xlog_print_trans_qoff(
+	char			**ptr,
+	uint			len)
 {
-    xfs_qoff_logformat_t *f;
-    xfs_qoff_logformat_t lbuf;
+	struct xfs_qoff_logformat qlf;
 
-    memmove(&lbuf, *ptr, min(sizeof(xfs_qoff_logformat_t), len));
-    f = &lbuf;
-    *ptr += len;
-    if (len >= sizeof(xfs_qoff_logformat_t)) {
-	printf(_("QOFF:  #regs: %d    flags: 0x%x\n"), f->qf_size, f->qf_flags);
+	memmove(&qlf, *ptr, min(sizeof(qlf), len));
+	*ptr += len;
+	if (len < sizeof(qlf)) {
+		printf(_("QOFF: Not enough data to decode further\n"));
+		return 1;
+	}
+	printf(_("QOFF:  #regs: %d    flags: 0x%x\n"),
+			qlf.qf_size, qlf.qf_flags);
 	return 0;
-    } else {
-	printf(_("QOFF: Not enough data to decode further\n"));
-	return 1;
-    }
-}	/* xlog_print_trans_qoff */
-
+}
 
 static void
 xlog_print_trans_inode_core(
-- 
2.47.3

