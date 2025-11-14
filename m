Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3992D6E67;
	Fri, 14 Nov 2025 05:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099590; cv=none; b=ntmVBf4jTfVTtrnEtV/rdFi3Rnqwye1LLCgMp9Xd9XljvmZXM67olNEK4nnnxq3A0u1topedTONYynLLobvg8wiWJii0plclNhmSrGUwm1JmWGJM4dOZvLInP156Pvy4o+nb/n0NGHXvOEW/0gHcfDHfJPX+5IwnYdkiFmikhko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099590; c=relaxed/simple;
	bh=HFr6L/n8a7iykF1R7QOMuk73YRekUx6uAV4SHvK4Mzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0rh5w4Nl0SjZ6I46XqJDrK5KspE/fLluwFIf8ILz+xXrPUQO0ThzibkjEqitJTPVeimqOJHO5PwANMrwGsl3dUFOOCuXK3Q99Ijfu5748a+DOCoPXwcn6dFi2v6AxhQ/4HRUk76asGPN+LjtaZYAmj1ju+jHlWe1UNRjDxJwQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eCMsib40; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eCMsib40"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IyTHp2sCE+KxV+ZxJhq3HeGOoozSdMBlPH6nCY/+NCo=; b=eCMsib40Sx3KIo16pTtxX934/B
	XkDo5q9KZ7GFLi2pVl4GvUD1c4hS1eNmLxAjiBKuNS6kAE3eDJM9Qlz4PC76vaUJw8iSyILFL6XFD
	KF+LQALC5h0KJK/xR4NrLybhbbeXk+8nqRLR37tPH5NIYNvLZvoA9kXvB08DUT20gA9uF3n4zSh4S
	6etm01LOYAqn+mvn4rLu47KMZkPqBo/qltNi7sBaWqzLBHMX1sScZsxZzSBjeakhH/s/E0MKb0Hn6
	YGjdTHu51ubZqxQJC5Pt74WxAo3lTP8Xji8GV+Kw/1asOHN5vXvAdiRVGaNoYLi83n99wIw5SIke2
	jVr8oTAg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJmk7-0000000Bc3S-2bjR;
	Fri, 14 Nov 2025 05:53:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] xfs: work around sparse context tracking in xfs_qm_dquot_isolate
Date: Fri, 14 Nov 2025 06:52:25 +0100
Message-ID: <20251114055249.1517520-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114055249.1517520-1-hch@lst.de>
References: <20251114055249.1517520-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

sparse gets confused by the goto after spin_trylock:

fs/xfs/xfs_qm.c:486:33: warning: context imbalance in 'xfs_qm_dquot_isolate' - different lock contexts for basic block

work around this by duplicating the trivial amount of code after the
label.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 95be67ac6eb4..66d25ac9600b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -422,8 +422,11 @@ xfs_qm_dquot_isolate(
 	struct xfs_qm_isolate	*isol = arg;
 	enum lru_status		ret = LRU_SKIP;
 
-	if (!spin_trylock(&dqp->q_lockref.lock))
-		goto out_miss_busy;
+	if (!spin_trylock(&dqp->q_lockref.lock)) {
+		trace_xfs_dqreclaim_busy(dqp);
+		XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
+		return LRU_SKIP;
+	}
 
 	/*
 	 * If something else is freeing this dquot and hasn't yet removed it
@@ -482,7 +485,6 @@ xfs_qm_dquot_isolate(
 
 out_miss_unlock:
 	spin_unlock(&dqp->q_lockref.lock);
-out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
 	return ret;
-- 
2.47.3

