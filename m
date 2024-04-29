Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906026FCB
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714374132; cv=none; b=GIJ1lOu1kyU0cWEnI6veqFnV+nKvlO4FrcmO9F97ma1l4mlOs8ZCaMM8Fvyz/1gWFWR+qjY8PbmEDMcZK70CRMMeQy7pm8zd23uler18dFaxNcWrZ1ozE5IdHIJcQ6GY3zoHVpRp06+A0kIc1DWtwVuD2dB4q3HLDCUniTLA2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714374132; c=relaxed/simple;
	bh=kv9+l8KiZPmIB3GWDoZs6OfhV7wZsTv0FGiSa1LJh7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jQE9n41OEc0pRtGqdqBtU84AXmBOKsFTqQzByE0WqA6pZoz3UtfwRdu8upzgemnKOBiAqZjQYWb3kPwvdhLB6wtQbwVkmfn96bKVY5b+wiw0rPvTH1+dsjpJNzv0jG4VTpDQLCt3D3QO7y+h8ka0PNVp8cHt82K+k/Qllddk97A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BHo58upj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BHo58upj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eFaN4LxkoQAcU5NYapxY0X23FSjB2BY5OmKj6k3Pfbg=; b=BHo58upj8O8v734lYHq6TmivA2
	XZOQSF8idaKhO68uATNjFY3JjYv9v+cCCCmSspVYTbR+/BA5BilVofe74pcIdmIS+ccHNmBH6FsHN
	jNaVHh4+AWSqgoQdkz3s8KC0m+GJ/5O6YYGpe5raj+7TmzsSuGk9h4ClWMHYpwKOPu52bmr5yDJNd
	KrowJe/uTCsj52/ZmPqVKqAcDn1fnpk5XZq7vM2cyOfJJixPuDxEKlQsrKT2EFi5FnUIZoE4OO605
	K+4OSSdJw7I9OYa7bTOcabau4E/0ovIAHwKE4tCW7SYPwVSy8xPWV/bcWlqWbe6ZtRuTnxDdko/ks
	hfOUCbiA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1L1d-00000001kN3-2Q1H;
	Mon, 29 Apr 2024 07:02:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: clean up buffer allocation in xlog_do_recovery_pass
Date: Mon, 29 Apr 2024 09:02:00 +0200
Message-Id: <20240429070200.1586537-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429070200.1586537-1-hch@lst.de>
References: <20240429070200.1586537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Merge the initial xlog_alloc_buffer calls, and pass the variable
designating the length that is initialized to 1 above instead of passing
the open coded 1 directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d73bec65f93b46..d2e8b903945741 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3010,6 +3010,10 @@ xlog_do_recovery_pass(
 	for (i = 0; i < XLOG_RHASH_SIZE; i++)
 		INIT_HLIST_HEAD(&rhash[i]);
 
+	hbp = xlog_alloc_buffer(log, hblks);
+	if (!hbp)
+		return -ENOMEM;
+
 	/*
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
@@ -3020,10 +3024,6 @@ xlog_do_recovery_pass(
 		 * iclog header and extract the header size from it.  Get a
 		 * new hbp that is the correct size.
 		 */
-		hbp = xlog_alloc_buffer(log, 1);
-		if (!hbp)
-			return -ENOMEM;
-
 		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
 		if (error)
 			goto bread_err1;
@@ -3071,16 +3071,15 @@ xlog_do_recovery_pass(
 			if (hblks > 1) {
 				kvfree(hbp);
 				hbp = xlog_alloc_buffer(log, hblks);
+				if (!hbp)
+					return -ENOMEM;
 			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
 
-	if (!hbp)
-		return -ENOMEM;
 	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
 	if (!dbp) {
 		kvfree(hbp);
-- 
2.39.2

