Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9B72356D2;
	Tue,  6 May 2025 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746494634; cv=none; b=ESPbiTjvecSuWU4sDq5lMIrbFWCQdIqRjOkzAnwumtLy4kvTMtjYyU6kCY4ygl76snERbdOBevOEocDAtBN3P8oNWsX1Nd8PyqBvMImUfIOPWp7Jyz/c9Ldui5MbMJZNtnDrLh3R5IECgeyN+xb2P2LiBtKv76VwxwUs41Qm7Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746494634; c=relaxed/simple;
	bh=ZMOTkC6P71qPe4BzgMQMENfuFisNKiG1ouPs/kk/x/I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kGJagZX9E4wreGgrLa8ovsmE8qx1gbwRcPhJBZq+qROWohoo7FImxQmWmSOISLFR0QLG4ijeOdZirvYTF2fX+coa8MLzd5o5aF99PUwyOovwN8PMEcKbDITqx/1xc5DDFxNF9kyDDFxxnnXmlYEufHwW1GPwnuQNaVQhcYQtuNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zs0zB5f9FzYQtwH;
	Tue,  6 May 2025 09:23:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2BD441A07BB;
	Tue,  6 May 2025 09:23:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl+lZBlouX4_Lg--.26089S4;
	Tue, 06 May 2025 09:23:49 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: chandan.babu@oracle.com,
	djwong@kernel.org,
	dchinner@redhat.com,
	osandov@fb.com,
	john.g.garry@oracle.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wozizhi@huawei.com,
	yangerkun@huawei.com,
	leo.lilong@huawei.com
Subject: [PATCH] xfs: Remove deprecated xfs_bufd sysctl parameters
Date: Tue,  6 May 2025 09:15:40 +0800
Message-Id: <20250506011540.285147-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl+lZBlouX4_Lg--.26089S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww45KFWUKF1UWryxWry7trb_yoW8AF1Dpr
	s7Gw12kr1DGry8ZFn3JF4UKa1FvryIkF409rs7ArsrXwn7Ar9rWF10krWfAayYvwsIvr4f
	Wr1DGry8XwsxJFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU10PfPUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit 64af7a6ea5a4 ("xfs: remove deprecated sysctls") removed the
deprecated xfsbufd-related sysctl interface, but forgot to delete the
corresponding parameters: "xfs_buf_timer" and "xfs_buf_age".

This patch removes those parameters and makes no other changes.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_globals.c | 2 --
 fs/xfs/xfs_sysctl.h  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f18fec0adf66..f6f628c01feb 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -23,8 +23,6 @@ xfs_param_t xfs_params = {
 	.inherit_sync	= {	0,		1,		1	},
 	.inherit_nodump	= {	0,		1,		1	},
 	.inherit_noatim = {	0,		1,		1	},
-	.xfs_buf_timer	= {	100/2,		1*100,		30*100	},
-	.xfs_buf_age	= {	1*100,		15*100,		7200*100},
 	.inherit_nosym	= {	0,		0,		1	},
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 276696a07040..51646f066c4f 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -29,8 +29,6 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
 	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
 	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
-	xfs_sysctl_val_t xfs_buf_timer;	/* Interval between xfsbufd wakeups. */
-	xfs_sysctl_val_t xfs_buf_age;	/* Metadata buffer age before flush. */
 	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
-- 
2.39.2

