Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6932D486E45
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329952; cv=none; b=WlKduDa5QtlNZbeXGrE/95tuTUwWS3Vf8UB2krczU/bhZhGiIJYSbrz48be4cb+42WqCYxBExGM9gkTMWRLWRJHBD9sS3yNwQCkd+LfRKILyoaq0EtI7DkNI6JvEaXASSjFqCfM6JnmQSCKSiKwvOGR1i+ZC+Dw7xVv2GDd05ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329952; c=relaxed/simple;
	bh=ay/4n1U2I7TFhTCKKg8wgXxwxXPEFiuyeLEdikSZZ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN1qaL3oqE+ifVOsjspKCJJGrQCRFpzXOt/F5TZywpKSWXEhzmmcBg7uSUXHOm6FXsrOdu9gpXOJlIKk40bh8ojNkpjruZyJusClX8kBvYaCFfDKCNMbTtT7KX1gukXCcK/XT5J5WzgT01r+/bFwEEPMEcr+REHJ7siOy/MXFMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k8SYmz5S; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k8SYmz5S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SQlYRFv9Dpw7RPbN9ilROdOVFgudZbiSQv//XTbFnRs=; b=k8SYmz5SIoHQ8q7yXx0n+2rjzM
	SHTyy2o8F27nXPUB8eKth/e7dqiS3hsR+CREWq/JolAvMioJsmJgRg9/FFiUxHQKxLh8iCKfJQ+JO
	wIy1B67C2uS2Gy40mjOzlcxxCyhEO8gzoPU3XH+OvLYbQHGtVuFQogdrW8P2bwR2WVT1QqnSiYYWi
	z3Z3yRf0NiyZO2Y9AEDAejCE0y/Pd4TXkzM/ZCfAI3AALFFnGLZxrG+c6a7/Y8oGHtdWRbFvwEy4C
	cdaoaJIC6ycLg6zUuDcB4iTbtZHGT3kIwhkdqBoHvJuJf+83wrMVmfY8Aztq4XddYiw+IrNahItDJ
	vP33tfQg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3sG-00000004N37-0TNA;
	Wed, 29 Jul 2026 12:59:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] copy: log the error number when failing to write
Date: Wed, 29 Jul 2026 14:58:56 +0200
Message-ID: <20260729125902.2281706-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729125902.2281706-1-hch@lst.de>
References: <20260729125902.2281706-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Log the string form of the errno value to help debugging a failed write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3ba9a07e4469..ad18ceb1ac1b 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -891,8 +891,8 @@ main(int argc, char **argv)
 			off -= XFS_MAX_SECTORSIZE;
 			len = pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off);
 			if (len < 0) {
-				do_log(_("%s:  failed to write last block\n"),
-					progname);
+				do_log(_("%s:  failed to write last block: %s\n"),
+					progname, strerror(errno));
 				do_log(_("\tIs target \"%s\" too small?\n"),
 					target[i].name);
 				die_perror();
-- 
2.53.0

