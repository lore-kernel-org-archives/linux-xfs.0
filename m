Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632BD303A22
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781067; cv=none; b=PciPwvCLz7o27SJLyPMPwcwl0Z0qMAb+JecVoR8yZJ0KI7lFXrs7rY3LLKw4rdU5khBoKlf60CwULCLzkT0pTncQChzzpVua0R9F4pG0KnnhH1AVwxxX6OOfWZvSJSZZGCk5JeWL5VzzRSuWJYI8UGXdowJF4OI9PTIYqwslCRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781067; c=relaxed/simple;
	bh=MekcR691gyD7Y4TDqHSDMiNTp0fs215psDbivfZw0Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB5cjA0rtlE44SlIiU/AAWMnieR8vq9XPAIW66oIziU4H4vaVnOpnqoXrQUOd+2NgTVAWriEHaW+AwzkToOVrb5S89/T6e3ahvuwscPI1XHaA1FRQ3ldMC2/4JJUKn5nc6IYQibYUFZSII974yWWzdHA/EdPIba3ATLS40wR4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CXjxYpHJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CXjxYpHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VzNo3kcgAARwidM19Ng9pB7Sbf3XWtGHaIOFtxN0H2U=; b=CXjxYpHJwus7OhkuhbXufEOgeW
	vAICkHJMAB/70PL6lwTH+92wTD1DPUCDBR58GpB2o+3PHPSEP0r2hcuGx546ZZ5xfbKGZlGz4gFqe
	9zf5wX5yPFQG0WDGDGJopO1s9SKwKlySEgS64tSVTTD7YrhkD8Kb4kOtpy41VSgU4P29/xerOizxB
	wR/iaxyfuc2wvnPPSF2MP04AlvWjEOQGv0GwkXABkwGOQvjyF00li34TcoiOmVV8BhFfJ9i3IoNbg
	khw3tDVihYhsH5aXy8J0D6fQmqHgeobMF83yIbG3R5pPQftVt+xzDgFhmZ57eZd6rzw/Ew02QZEHR
	v9JO9Xag==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsf-00000005UUa-2FST;
	Mon, 10 Nov 2025 13:24:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 11/18] xfs: remove q_qlock locking in xfs_qm_scall_setqlim
Date: Mon, 10 Nov 2025 14:23:03 +0100
Message-ID: <20251110132335.409466-12-hch@lst.de>
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

q_type can't change for an existing dquot, so there is no need for
the locking here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm_syscalls.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 6c8924780d7a..022e2179c06b 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -302,9 +302,7 @@ xfs_qm_scall_setqlim(
 		return error;
 	}
 
-	mutex_lock(&dqp->q_qlock);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
-	mutex_unlock(&dqp->q_qlock);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
 	if (error)
-- 
2.47.3

