Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C824C1AC8A7;
	Tue, 24 Sep 2024 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203152; cv=none; b=SARsqzO4JK0ZQo4ZSDMfMcPeToZHI22/Mx4oZirNTD0RaV2ExnJQ+X/1Hpa4OFvHhBx+IAvFGB6XumbxsftjOWji3356mlbglr/DiPmx+XnwIUlWDKypgsYVgiSpKd4HwWFnOYENmai/UeV3H9zVmVaPu7bkzk7L/zxEXUzSDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203152; c=relaxed/simple;
	bh=6NBdnA7+RA8YF9keQxng4kuQgB6muPfTAlauOj+vvww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfWidPY71DtI+67psMPivhZ2sO6l/2AFBIeyZem4FIQo+0zdsqiZ24Z09bi6D3OFV6P9CpEg4fGnsmVL3wmnqORwrwS2OeesOCGQY+aH4kCStk+BXPuUOjIgf0RMkd9OO6/0qn+0nbAb122GZFgGSkjCdBdOChlqYq8gmmpU1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXF0olw1; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXF0olw1"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d889ba25f7so4010564a91.0;
        Tue, 24 Sep 2024 11:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203150; x=1727807950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phA2n2FlmmGiuLSoXgdaGz08N8wCi6ROxDoyreR8NGU=;
        b=GXF0olw1NCYww3ZTl7Myoj2aspe/K+9nenMlB+CfhPl3y2VFNsO1aIEu324f93naGZ
         mPy/q/e1ifcuXR3adeeucr/EI1FcDSXkm0kUz3qKF7CVfuyuQmmYSYXkWeaSsI+LSV17
         PPo8t2Zg4yypahuFqfuNm7lbU73LfibcXzBGzVMI9vlEkxKF3GZ/4v3Rildpw4cGJPqW
         OuH8LFqPkH6Wtm5pa7rXmca8gkAIzPwue7b2LYzY8JW05trL4VSF0PAC5I3vNC1TeQwY
         FOaBLajoHq9FYqn0ow8RiawNrA97A+y+HmPOeEybmK2H2zuAeUbEMaLXqwBq+gx3v5Mj
         bs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203150; x=1727807950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phA2n2FlmmGiuLSoXgdaGz08N8wCi6ROxDoyreR8NGU=;
        b=doPTLbVdQEVJRYFGb7Dhv86Zk1x0CcyAtiLv3YvV9dgkj5oTutA3d2n2c3dq7XG/QN
         xSoslTwvuGUujwvQpPjWqxvEPAbtseo7kFGFVgJfvwcIEu1cx44uofiAo6gZVf90AAOz
         7gK9MGEbRX786FIMgpv6jxpWPzFv7f5Mf5G39XWXXrCM+JI5TRzkjP+KVFuusLjGrUq6
         /Oe25E/X+Sn/ZGMlteHQfFRzrU4oIICe0LTHPvevAefEYTLskcJhoF2CoTahb7w7lkcb
         ZIbwX6+Cl3uTDtKA7oBvwRX9lvSwaltwL2w2AL0kSjb0wSSTFLDtSILsbWMvuvuUmfLz
         PoOg==
X-Gm-Message-State: AOJu0YwknhfglnvMVNIBHHqJdnApA5uPhlarKTGVUoovm+jtjI5IZXG6
	NlGF4BNVWyPnjHiU7F986jjvm7ldLqi52lN4koIcejOPGgA7KjYdTrL4wHcy
X-Google-Smtp-Source: AGHT+IHlOVr9A/RaqRigDxamW+bSnRSqNf/iOSlH/EtNDwQ7fxgFuNiUCpiXSBG6eVc9TGdU/hoFxA==
X-Received: by 2002:a17:90a:2dc6:b0:2d3:bd32:fc7d with SMTP id 98e67ed59e1d1-2e06aff48f6mr76668a91.39.1727203149753;
        Tue, 24 Sep 2024 11:39:09 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:09 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 09/26] xfs: quotacheck failure can race with background inode inactivation
Date: Tue, 24 Sep 2024 11:38:34 -0700
Message-ID: <20240924183851.1901667-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 0c7273e494dd5121e20e160cb2f047a593ee14a8 ]

The background inode inactivation can attached dquots to inodes, but
this can race with a foreground quotacheck failure that leads to
disabling quotas and freeing the mp->m_quotainfo structure. The
background inode inactivation then tries to allocate a quota, tries
to dereference mp->m_quotainfo, and crashes like so:

XFS (loop1): Quotacheck: Unsuccessful (Error -5): Disabling quotas.
xfs filesystem being mounted at /root/syzkaller.qCVHXV/0/file0 supports timestamps until 2038 (0x7fffffff)
BUG: kernel NULL pointer dereference, address: 00000000000002a8
....
CPU: 0 PID: 161 Comm: kworker/0:4 Not tainted 6.2.0-c9c3395d5e3d #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: xfs-inodegc/loop1 xfs_inodegc_worker
RIP: 0010:xfs_dquot_alloc+0x95/0x1e0
....
Call Trace:
 <TASK>
 xfs_qm_dqread+0x46/0x440
 xfs_qm_dqget_inode+0x154/0x500
 xfs_qm_dqattach_one+0x142/0x3c0
 xfs_qm_dqattach_locked+0x14a/0x170
 xfs_qm_dqattach+0x52/0x80
 xfs_inactive+0x186/0x340
 xfs_inodegc_worker+0xd3/0x430
 process_one_work+0x3b1/0x960
 worker_thread+0x52/0x660
 kthread+0x161/0x1a0
 ret_from_fork+0x29/0x50
 </TASK>
....

Prevent this race by flushing all the queued background inode
inactivations pending before purging all the cached dquots when
quotacheck fails.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_qm.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ff53d40a2dae..f51960d7dcbd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1321,15 +1321,14 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error) {
-		/*
-		 * The inode walk may have partially populated the dquot
-		 * caches.  We must purge them before disabling quota and
-		 * tearing down the quotainfo, or else the dquots will leak.
-		 */
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+
+	/*
+	 * On error, the inode walk may have partially populated the dquot
+	 * caches.  We must purge them before disabling quota and tearing down
+	 * the quotainfo, or else the dquots will leak.
+	 */
+	if (error)
+		goto error_purge;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
@@ -1363,10 +1362,8 @@ xfs_qm_quotacheck(
 	 * and turn quotaoff. The dquots won't be attached to any of the inodes
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
-	if (error) {
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+	if (error)
+		goto error_purge;
 
 	/*
 	 * If one type of quotas is off, then it will lose its
@@ -1376,7 +1373,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
- error_return:
+error_return:
 	xfs_buf_delwri_cancel(&buffer_list);
 
 	if (error) {
@@ -1395,6 +1392,21 @@ xfs_qm_quotacheck(
 	} else
 		xfs_notice(mp, "Quotacheck: Done.");
 	return error;
+
+error_purge:
+	/*
+	 * On error, we may have inodes queued for inactivation. This may try
+	 * to attach dquots to the inode before running cleanup operations on
+	 * the inode and this can race with the xfs_qm_destroy_quotainfo() call
+	 * below that frees mp->m_quotainfo. To avoid this race, flush all the
+	 * pending inodegc operations before we purge the dquots from memory,
+	 * ensuring that background inactivation is idle whilst we turn off
+	 * quotas.
+	 */
+	xfs_inodegc_flush(mp);
+	xfs_qm_dqpurge_all(mp);
+	goto error_return;
+
 }
 
 /*
-- 
2.46.0.792.g87dc391469-goog

