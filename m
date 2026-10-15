Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17064AD7FB;
	Thu, 15 Oct 2026 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792051369; cv=none; b=j4y8iw2e8EsgALcaBNh25GaLmUz2U6gWLPFJK6NJCJBzY+trdfWQsy4gsQW6V8OmRH2F0/dMl6ubC9mmHx1PcYsPRphwXsD3PKtzZkX5y+c28/BLIOGPYsG08iIZIC8dCUvjaJARFvEb92/b9f1rZFiq7wblE1vQEwUDNEofspE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792051369; c=relaxed/simple;
	bh=TbYg1VTiD1UEEO/d4dClCaNPHQwEu329pFow9Nnf4Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sVfXEnpoGEcTXqVbc5OBor9ExbohlqavYqe3Ug0Fr1v4CngsCjcIUu9vNSdPEFaXTn8fGQVCjooyDXZtNRxOIYWOFfIcC4fFTIYHU0F6iIfXMEB0o8y3I6kdu0H86EFA4MIXQDU1w+KVJYnnLWhonJRboXV5oKRC8k1yCB/lb9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XoBL5jbx; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XoBL5jbx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cq
	/MdyqyAlLfkajn/GEbXJjDzR7rtOrjoZXmiCtnRaQ=; b=XoBL5jbxC2BXbzCUkG
	Hj/BQr70JEe7QRYZvbttGMBMNc90iLawCeXIExFFzDvr/nK/hNpogRMs8HkI/Swb
	hlVWwK6EXCj18RRGTHoIp5lTKL5h8j3yKm0msxnRcTYTuNWzzynRT4v7R6C+sQrd
	hHTVSAR7y4Z8C0LX2bePFPZdM=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3VxqSiNBqbM7YAA--.26764S2;
	Thu, 15 Oct 2026 16:02:27 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v1] xfs: set healthmon mount cookie before publishing it
Date: Thu, 15 Oct 2026 16:02:25 +0800
Message-ID: <20261015080225.45215-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3VxqSiNBqbM7YAA--.26764S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF47urW5Zr1fZr45JFWDJwb_yoW8Ar18pF
	ZxZ3s0kryvyry0vFsrJ3Wvyay7Jw4rCr1UKrn8Ww1fZw45JwnYvF9rKw4ag3W5ArZ2gF18
	ZrWaqwn2qa98AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UwF4iUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4BMV+GrQiJP7bQAA3p

xfs_ioc_health_monitor() allocates the healthmon object with kzalloc(), so
mount_cookie starts as zero.  zero is also DETACHED_MOUNT_COOKIE, but
xfs_healthmon_attach() publishes hm through mp->m_healthmon before storing
the mount cookie.  A concurrent reporter can therefore acquire hm from
xfs_healthmon_get(), see the detached cookie in xfs_healthmon_push(), and
drop the event even though the monitor is being attached.

This is reachable by racing XFS_IOC_HEALTH_MONITOR with an operation
that reports a health event, such as a filesystem shutdown.  Initialize
the mount cookie before making hm visible through the RCU pointer so
reporters always observe an attached monitor.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
Cc: stable@vger.kernel.org
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 fs/xfs/xfs_healthmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 2bdd747f1ead..05d6f0494139 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -114,8 +114,8 @@ xfs_healthmon_attach(
 	}
 
 	refcount_inc(&hm->ref);
-	rcu_assign_pointer(mp->m_healthmon, hm);
 	hm->mount_cookie = (uintptr_t)mp->m_super;
+	rcu_assign_pointer(mp->m_healthmon, hm);
 	spin_unlock(&xfs_healthmon_lock);
 
 	return 0;
-- 
2.43.0

