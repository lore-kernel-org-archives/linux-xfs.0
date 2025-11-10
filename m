Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5D73101D3
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781028; cv=none; b=m35+E/e4u3YaVz2pIZZldy/c2V/uMtpt/my9cZDLENI9OTEASmaOnVoQ55winrh/rpbcZt04bHfOeEsWgiLapifBfgggeFJupV/6u2ukFFSmaWF4kQUYMPPIMJ/0jPEipPUBuTpUv8g+zd+5SqXR4f96TrcMWE9lwbYzcAUSF2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781028; c=relaxed/simple;
	bh=OhkKME1HMgFBu+RJwOEVL3W8QtcLcfxW0H4PEWAZ0IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB70rKxzmvTnESYu1W5eJt2oLQ+qoqaxwaq+N8RYUYa4jMS3JMrxeje7bhdJdfhAt0pqqW91mXyVmt/hRbyE62YrhUgL5qqKqrejM2jMDchi4Z0DfdGsbHnGpguOOKix9ysr5FeDfcicTrQzuOtSeGm4FYKAopdxqZ6Xqx8VUm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XIUs550x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XIUs550x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jcJxqU6nJquqPHTLQZ6C9tDxvHBigzWQ+OJeNJwiHaI=; b=XIUs550xDh7FgTvSOR4Ts0Vl7X
	lQc4tR92hJeeG4lJwfymR8jAvaV4TmKFF4DzQzz453TugWBQAwnWmcVCg8iR0Vmh8Uw10H9oCKEt5
	XH3po52hUlXmvY0Ip2QRgKKZfvQeQfdqBCEYMYUZDWRPeAtI2fhn2MdSpDoJmF3V7KEg60/i9LyUA
	HEht7U+Nx4DnYlqfdjMScYB33z5lMQW1HL2e87aAddDH3H/c94zaGKVQlgY99mOkLkiH9JaICcgmI
	9OnmCdXK1wU2JDjtHx15XIuqTddyNRfBxYYnwPYOmNWMdQCTS7DzQlqw4/hh5e+E3OIQwP9eTt6yP
	gM3PUmaQ==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRs0-00000005URw-0lcb;
	Mon, 10 Nov 2025 13:23:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 01/18] xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails
Date: Mon, 10 Nov 2025 14:22:53 +0100
Message-ID: <20251110132335.409466-2-hch@lst.de>
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

xfs_qm_quotacheck_dqadjust acquired the dquot through xfs_qm_dqget,
which means it owns a reference and holds q_qlock.  Both need to
be dropped on an error exit.

Fixes: ca378189fdfa ("xfs: convert quotacheck to attach dquot buffers")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 23ba84ec919a..18a19947bbdb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1318,7 +1318,7 @@ xfs_qm_quotacheck_dqadjust(
 
 	error = xfs_dquot_attach_buf(NULL, dqp);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	trace_xfs_dqadjust(dqp);
 
@@ -1348,8 +1348,9 @@ xfs_qm_quotacheck_dqadjust(
 	}
 
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
+out_unlock:
 	xfs_qm_dqput(dqp);
-	return 0;
+	return error;
 }
 
 /*
-- 
2.47.3

