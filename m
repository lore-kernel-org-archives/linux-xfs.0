Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE543E9C9
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782750341; cv=none; b=J37VTOzwTo7PHC6qaKKTgfdof6B6R1WBai/OayvrvIgZpEePXOQGc5Yvf7If04heavDmGYkSjw5FTF9YTBTPBvU+NLRg1n0oSaBc3ejLMvZQ7ft4RtULLaq2g2Ragp35WzYsWbedfv2tfEwBhkFIeSDmovGc+Fmu6w17pVmJQYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782750341; c=relaxed/simple;
	bh=FSbXsk9nYud7GNJfxUx33nl7TSBYNPrmEM3HP9ykP70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GmOvSTiYpl/h0G7Uu7PsY3c0Oo0Q3jEANoIXyKEy2eARS7QtiWCSzyu4tSTmc/FHsI7bAC4fnDx1tBaYKzfGvnf3QOfayOBsYHKoD0eNX3W4cZN3fH0qrMMsqrilfg8YP31sfTbP6DeLA6PicD8QNqzTx09S6OrGPQ1dDG71nhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FAdpIkPu; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FAdpIkPu"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30e9eefa268so4575856eec.1
        for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 09:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782750336; x=1783355136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ped8crXUgzRgDMVrWKYLKANErXeLFarPuPkdA8Dgxc=;
        b=FAdpIkPuSeZczc68NLsyAHVqe7Mkd2q3XIKDcKdiVqdOFxWKCcwPRoqS1rTz0i4P5C
         kL858l/l8bzUPOnowYcXJmGutBcQ4UF6LyLezsABE3HzwRSiDhkVARLHm8pg5bJ+GyLQ
         2Zv9sl1bSWV+U0FRWvSg5rrNfl61dBo9FbtH+RBTpqBC470rJ4+x9KNkxPYVEZqGpZI6
         aM5PBjfMyRElC0hhqITHnb/IrTRq1bS6cVRFJntoNdq1ujDU0kI2IxpEkWjtmFvwUdqo
         9QFRenUCrspg284vhz5Kg15mpg5pAOk5wsFl5do398zp4FAlqvejpCIfVassb/CIiKXs
         jJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782750336; x=1783355136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Ped8crXUgzRgDMVrWKYLKANErXeLFarPuPkdA8Dgxc=;
        b=YkRE9ZnygdpKxuQimtelW4F4Iz6+rPKncrYlU9kQG4CnuGEKLxtBTc71fiBPADYwxT
         pc5FB/hGvBfB24WMxwMuOsC404i8SCa0AstQDKyzPnhHbCq0ZYgFHLehcqhHRIuRJIFK
         guyiCAZCqJo95AmvWOCFWN9Ax6yAuaptn20GP6fC3M8ST41GPEPSXU85IvcOhay0beQN
         P6JRD65fSnblSZxTw/aulFvASIl+XH3jQzHi9xa6k7rg9ZBOEeAJM6DdOoOfrBWAihZX
         HXx4Qarlsu7NTkr2E+o3O85sP8K/Ea0cwuBx8hWPOJTnolmhBo2iRERk6+n57DwGhGR5
         js3A==
X-Gm-Message-State: AOJu0Yx50IG9zwWCo4nkIXGAsO3FwQJjHY4f4MvoOKzJwKyfwYX4t1ec
	Tp5/d/T7zFej5LEo+I4HmFl7LKG7ohtwpprrjx19vZeiFT8KGNa3dCvrxERJZVrT
X-Gm-Gg: AfdE7cn5RKRDDpjh70HlITRdxBA4Dg8KPwbdPBwtV5MzONa13d82PIYSpFeEY6ENBg8
	Zac65TSFYIf4NhrQvTfB+HHbgYcJDe1gSAQdJJANRJRv+YJX/c5CQmMY9FveX0YpO2qTJrWU4ru
	6seLPUK7mf/5Fyg2p3aaqfaH9Sgu6uUrqstmcSJ/Z6TS4jxkzGb1uShMlPoqrhQ4wnGwS8l8o4i
	pkJqVI42+QomfFqSyR/9wQWjqAaeBs7NdGpVVNGsDa2mgrhrrCdq6IFsG2xko9eFOZrRqjrUk44
	2p4guDlzSZI9E5QN8aj1Z7JS1qOGXdpX7dEJi8+TYQ0XBcbs08m8Vm3UqXSYtBH6Lhm3el0lCgt
	Q0bGs+UEsU/6C6Tw281nQu+mSy1Ij8l8ehtPVPIwIcrS/TdryTCoHbrgRpDrqPpVc1kSbVM9FBF
	88FKFREIL8oMruTa51C4OBQ7XlwOYnhxnO1Dc/3N8ewmYEsLWOPH9cUINUIA==
X-Received: by 2002:a05:7301:9c83:b0:2ef:8b91:212 with SMTP id 5a478bee46e88-30ee128cd28mr114888eec.14.1782750335620;
        Mon, 29 Jun 2026 09:25:35 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm47191041eec.20.2026.06.29.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:25:35 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] xfs: fail recovery on a committed log item with no regions
Date: Mon, 29 Jun 2026 09:24:53 -0700
Message-ID: <20260629162452.2566242-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_add_to_trans() turns the first op of a transaction into a
recovery item.  If that op is a bare transaction header
(len == sizeof(struct xfs_trans_header)), xlog_recover_add_item() adds
an item but attaches no region, so it sits on r_itemq with ri_cnt == 0
and ri_buf == NULL.

When the following op is a commit, xlog_recover_reorder_trans() runs
ITEM_TYPE() on each item to look up its ops vector.  ITEM_TYPE() reads
*(unsigned short *)item->ri_buf[0].iov_base, which faults on the
NULL ri_buf.  The commit handlers dereference ri_buf[0] too, so reorder
is the first place that trips over it.

This is reachable at mount time from a crafted image whose log holds the
op sequence START_TRANS / bare-header / COMMIT_TRANS:

 Oops: general protection fault, probably for non-canonical address
       0xdffffc0000000000
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
 Call Trace:
  xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2043)
  xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2308)
  xlog_recover_process_ophdr (fs/xfs/xfs_log_recover.c:2454)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2501)
  xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3244)
  xlog_recover (fs/xfs/xfs_log_recover.c:3493)
  xfs_log_mount (fs/xfs/xfs_log.c:618)
  xfs_mountfs (fs/xfs/xfs_mount.c:1034)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1938)
  get_tree_bdev_flags (fs/super.c:1635)
  vfs_get_tree (fs/super.c:1695)
  path_mount (fs/namespace.c:4161)
  __x64_sys_mount (fs/namespace.c:4367)

xfs_log_recover.c:1836 is the ITEM_TYPE() dereference inside
xlog_find_item_ops().

A committed item always has at least its format descriptor in ri_buf[0],
so an item with no regions means the log is corrupt.  Reject it with
-EFSCORRUPTED, like the unrecognised item type just below.

Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..ccff436612ee 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1906,6 +1906,18 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
+		/* corrupt log: an item with no regions has a NULL ri_buf */
+		if (!item->ri_cnt || !item->ri_buf) {
+			xfs_warn(log->l_mp,
+				"%s: committed log item has no regions",
+				__func__);
+			ASSERT(0);
+			if (!list_empty(&sort_list))
+				list_splice_init(&sort_list, &trans->r_itemq);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
 		item->ri_ops = xlog_find_item_ops(item);
 		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,
-- 
2.43.0

