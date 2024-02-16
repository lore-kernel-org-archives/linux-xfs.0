Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C802130E32
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 17:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708102959; cv=none; b=P9reBQAN7JnfJXS5gY4M/mkKY5jd0bOVeik/IBuFDGPVYUFUvkIS8aRWmujS9AQ4xCjeXhHh687QNPReXflFhrSI9TUGdaWAmBJyJADZUm18K6JyD5/Jp1LgFEwOFXX/8NMh4w65PshEQ2jDKXcoAhVkJeqq+vWxizKmijG/dxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708102959; c=relaxed/simple;
	bh=7fukXA61clSkbaSJEeq7od3Qf5URX9g8+yVnCCSJGPI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GqUqIlaELwJg0JYTOLmAJnpog8073H4A+doNLy1yKabD2l97ifC26jH9OaRWfeZln1LegSZo2xyVn1ffMsB8ngl40ZXQnqEbM0/uww6WTMenvNmL51WF3GN2ZqFTxbyocY4zjklzBuc+fAkCTzpm4eXGdA1bpX5SULzRPSIwG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3YAYwUNd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3YAYwUNd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=aUjKrMwKv6+iLyO9Up0lsgGhGOJ+4zhhSv/aY1lWtME=; b=3YAYwUNdvY6GoAOFyI/Qw3kuYc
	aD2FoGAzqoT7rQjixVKmRhZBtUDOzapAWt9ZRcJJKSq6zgugiz/p7fny0rwJgJaiX/Q3r78hDd9nO
	p9nJrbrc7j76vgF25xYpJvJfle7kPQQ1v58x03ljIn7tleOwwntGlVcgQqFQQO2woRGD4JTkIAQzZ
	ED1EBKyUJu+2ZzxEEk0rtyiCKmR2S4kFcD2XJWZlcDtcXUqjzAzxmM+qUMndyFZCYwoP5rbzOMOnF
	U0Oh4qDE22FWBpWl1/7dZ9w539p+iQU/f+3CgOktwNkDtD04vI669XS3EN+L6zNCSw2QUX6Wx+5Lg
	xqOH+iJw==;
Received: from [129.253.240.71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rb1be-000000035fI-3elJ;
	Fri, 16 Feb 2024 17:02:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: dchinner@redhat.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use kvfree for buf in xfs_ioc_getbmap
Date: Fri, 16 Feb 2024 18:02:30 +0100
Message-Id: <20240216170230.2468445-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this the kernel crashes in kfree for files with a sufficiently
large number of extents.

Fixes: d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7eeebcb6b9250b..7c35d764409720 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1506,7 +1506,7 @@ xfs_ioc_getbmap(
 
 	error = 0;
 out_free_buf:
-	kfree(buf);
+	kvfree(buf);
 	return error;
 }
 
-- 
2.39.2

