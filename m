Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0C041D129;
	Fri,  4 Sep 2026 06:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502439; cv=none; b=BJ+aVyIRg7V+mrhVfsaClf18F2j2BIqhwD+ZN63wUDIecoPAyTmtQheoxXW9UVxbBKk8QgPiEYFPBCqE/EVGDIrsul7AucW5ei2uRBoOY1k0wRoYnaws5SFXUELUui7Gb0YrZNlNCvkjBDj10aB9tonWQwlAcuZFcYHj5PsNi1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502439; c=relaxed/simple;
	bh=Uo8y5tBNeUT0HdTgXThhfh+pf1xWUKH9ljEhliaSqj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0YRMbmtsDkMYglcbW0iFeFr4ijbYr0vsJtgi696zUwAk/1HCawdHzRC6w9WcB/m5QGUXRJpI8ARnOWNXl6bE8HNn0yKMgWsRx2HlGTzErIt8wAXI4bHLxr8vvtzmLPrtMCkAaFlf7fGBl9Gj42YlIAGpPy1sIDeo3BOnXIKTVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbmNT411KzKHMWM;
	Fri,  4 Sep 2026 14:12:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6AD224056D;
	Fri,  4 Sep 2026 14:13:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbwqeYZpqTb3FAg--.50434S5;
	Fri, 04 Sep 2026 14:13:52 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: cem@kernel.org,
	dgc@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 1/5] xfs: remove unused xlog_assign_tail_lsn declarations
Date: Fri,  4 Sep 2026 14:06:44 +0800
Message-ID: <20260904060648.1966130-2-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
References: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHbwqeYZpqTb3FAg--.50434S5
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW7Jw4xGr43CrWkXryrJFb_yoWkCFb_Aa
	18tr1I9w48tryfAF18C34IgFn8JrWIkwnxG3yFy3ZIkw1DJ3WFyw1qvr1aqrZ09rnrJFyf
	Xr1DKr45tryvyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
	W8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UR89tUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit 0dcd5a10d987 ("xfs: l_last_sync_lsn is really AIL state") moved log
tail tracking entirely into the AIL and removed the implementations of
xlog_assign_tail_lsn() and xlog_assign_tail_lsn_locked(). The prototypes
for these two functions were left behind in xfs_log.h and no longer refer
to anything.

Remove the dangling declarations.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_log.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index ca66429bf6c9..f715695e8fcb 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -105,8 +105,6 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	xfs_log_mount_cancel(struct xfs_mount *);
-xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	xfs_log_space_wake(struct xfs_mount *mp);
 int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
 			struct xlog_ticket **ticket, bool permanent);
-- 
2.52.0

