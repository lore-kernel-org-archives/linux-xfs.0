Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617916;
	b=tVBCgETXyD2FFgskxylj/jH7iSfkwxwYxDyYkrT1OriJw9JtF5teH/DK+ACQv/x2OJIN
	 UH18iZeMdcanEeKDn0hiYYHnLEz2slFodcQjDc1LuFLpi3ur4yv1FQtCFlPTfS04fsdZ6
	 UUHMepT5LJn46X3QIj/sMZaV0mR9v4lxRKnJrI8LJS/Fu/nsQUEuii94ivJLh3uw8T1a2
	 0L+go7w8TAMPXMOoxBHmo4RbJUdJqccaFMseNWbr4zffktW+/l1zvRoK07jMt0AVLneAl
	 SUOSoAdzhu8vhe/kOEtI4F9ZxYs7L8Qv5Et2wKSVXIjMo+mB0qPqZaFTRXMYHZIH1fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617916;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=IRmyG/EN5GmIkHkvz9FN6VfhUo4W3XKl3pVQJxKdjnc=;
	b=nhoyj53zt+knDJJ63mkWS57rGWj9tUMALcucLKnp3eg5wFDiQI8gFRHjZV6T9hZvpTPB
	 Sj2NMD1j+LKTiOzFEUSzbriP3A++Er8bGquFYSSe4EEmeoxtMKphx7Ug8Z+giYNt4jNJz
	 +AqjuSFpz9829Mg2GRGVMO2Yf3qujjcOZtb2l9743SgoctweLIA1EhkH/Qs0RvPZHhrR6
	 5YkBXWTgwgret2JkXtwbhxf+gzB6e7vQnDhScumuGzKrd3Ps7YetsfxKvTFeoLp1tNhIK
	 Rn7veDmMzPNeOpKi5dZntjUu2Cjy2637Yh/Hd5mC+yZoCuaN5+pTQkuQrfpfVG5i6Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LgTmUmwS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFBE606A329
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECFBE606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LgTmUmwS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IRmyG/EN5GmIkHkvz9FN6VfhUo4W3XKl3pVQJxKdjnc=; b=LgTmUmwSyxmkdaK5Q4uDsfd+lj
	3q8N0MwJjatwdJo66LLcMQ8G1q/l3xdJr5e0VLYQbH9mG6Xiew61AD/9IpoCFHtppgKa0DZXLRGuS
	aAW41a+d04eCBSX8MNEAFkXWiqobfkIfyzCC3pFjJn9xVhU3BsZEfKif32PIySzrBsxpCHk5B02T6
	xdTMTxUnkQN511cWB/qq1i0iNg8IlCvdrvOLgfYtm10P6pWr/az722jVRAZ8sTm55Y4ME+pKY3dEJ
	rZGX7b7xumLJ/qguKM3IWI/5YoMy1yXKAhyp+R/UIqVmH2ANlpzOmHaGeX2Prdxlucb+guhll0v9L
	P0EPNscA==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEFG-0000000ADv0-41kz;
	Wed, 25 Nov 2026 14:45:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: improve an assert in xlog_format_commit
Date: Wed, 25 Nov 2026 15:42:32 +0100
Message-ID: <20261125144430.728485-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Buffer usage in the log vec is tracked by lv_buf_used, so assert on that.
lv_bytes can be slightly smaller due to rounding, so this makes the
assert more exact.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ec49fc5d03bf..f8ca67a63763 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -485,7 +485,7 @@ xlog_format_commit(
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
+	ASSERT((void *)lv->lv_buf + lv->lv_buf_used <=
 		(void *)lv + lv->lv_alloc_size);
 
 	lfb->idx++;
-- 
2.53.0

