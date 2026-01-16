Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F545BE3
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559926; cv=none; b=VrHAHsY2iYV/qR1SQKRn4DS8bhDVQGwLnRiHcD16wqOpfaEVRCs709fK7yG3sQDrjaS997QxxsS6Vbcyft4UMtYMkAuZrQCxQUfqxvT1caaJUQC0eh3FRST4SsEns7LbLughn5rRbE76iu3Bp7J4VoQSQ9yMtxwT61+LCNI5hfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559926; c=relaxed/simple;
	bh=vxe3YSGKuh9t+2W4RTSSctyt26GnszB1HlTmaKR0sB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fz84kq9bdF89xX8pPwSVbbRqNbx9hgR3ZWJzxB4jC3tARcYW7sOksFJteLEtM3DtJQf7lJS5sc/RgHLu8pYdNwPx/wHh070mD3KytQ5KMW05VRHyi3GBrb6kqxjPHk1poaQPw52WxHETsOT3b4OxX0uIK5S16Dy4FGdliJzqszY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lB8IFrjj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lB8IFrjj"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0a8c2e822so4376575ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 02:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768559924; x=1769164724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+i8LifWaQjstrS9f0xASmccedHvV90/Nkvbc1a1srHA=;
        b=lB8IFrjjNxgpAp9zHrChdQ6cPL0PoEVLmrMa8nFoHCm4kjpBjEaoLez98Wg7iT66oJ
         XTFPgY043jb69mKWJ/BIE+qa2heCgd7nh+bQyef6avo3o2iCy8Yox0t2iLvlKX/8OqtL
         IolVdagoHy5H6zV4dMNBWl9XDIn1yv0SQywfVSX+9zRdJ22sRfXxI8chTSx3RXWNXorN
         jzgdMKkiVDZ7oOPUIG2LHyOw6ry5VASXxXqOE99fLgVlm2QixnVU3Y8pGamyDbYcWdzR
         /H3hr64EwTFGmQOp5sm4tSIwtHV1zhe4KCGMKniiAuhtozwA9eFDa7VZnS0JuQVykRkv
         mSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768559924; x=1769164724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+i8LifWaQjstrS9f0xASmccedHvV90/Nkvbc1a1srHA=;
        b=j+ez5f96NPEHFDthpfiWEDOk2UvEI5hohD3oV2GzyuYnxe3HxoHAQtreZuV6fFIyTv
         VyepomDHnAm0OMjdSVLfufn+2pKhnfQBquFC5x5iEDRmpPLdqP7oTR0OzNofOC0bBI27
         qLVhOHktr+zvJxtWHPVdoK3NIDFu87oaAU1oOTcT9rM8M7ZAuaz4rNzTivLUgqfQpC11
         +ojtzbRhxii2mEdHBa9DemOEcG/51L9EHEg5RQu4beA1K028ajMp8pcQ8T2y3ESGXkax
         k52RkYbi/HiNQlLYKOlz7OProO3XF1WDoMIJzFUjZuRAi95S4JXgJxvIXtXlBhj/OC8n
         EZSA==
X-Gm-Message-State: AOJu0YyN82oXANFFStl+6soQtNgJl7sHS51ehVLk3BrNdPTVAXG/j28Z
	q6+PvNA+vNJnpYEVr4S1K57JqertLu1dD1sJq9YRlmlbDxuhTF0zsRDyidx9KF4a
X-Gm-Gg: AY/fxX6TP4fzfCfF1hC1LKIbavGBXuG8szHnKAPQdiYHRBATAbeFC+8KlTVYAnoIstm
	jg5ISyLn35l4ZK3lSmnMNobZjT5sTAWntOV9pYC+21yC+QTb5AAYbTBtEnmMWlFZwIJ+uEh2HYw
	XvXDcIxCUzcLtsxdkNUc7kz3RRwsCoLMew2Jo7rLh6J/zeiH2AlwRou7xEzhx4UcVyBsFnj76Op
	/B/j/46c/8tPqfUm6IS8if7Vhpte6N9GxAEUqb5+jq9z72Y7Dl13infKrspvE4uPtHmGdY8ut9I
	JLQoe4PEBUXfFv4Q8AZZlVGYIDlXsJR1dRTpeKUlpNWwNw/L6cSAgnf6DnMTdKP3RlE06Id3Hoq
	ODnW61G/Ieevvov934nqmdILaM5HFxz25FD01W6X/eicH6VNa8f+p9e+9ZQn6XCnfrkMOgOpakK
	Pgo7ql7EydkB5F3+kOExy1izSRUbw=
X-Received: by 2002:a17:902:f54f:b0:29f:6ca:a35b with SMTP id d9443c01a7336-2a71752768fmr18383855ad.1.1768559924214;
        Fri, 16 Jan 2026 02:38:44 -0800 (PST)
Received: from 5423825QM00166.mioffice.cn ([43.224.245.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190c9ee9sm17923915ad.22.2026.01.16.02.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 02:38:43 -0800 (PST)
From: Wenwu Hou <hwenwur@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	dchinner@redhat.com,
	Wenwu Hou <hwenwur@gmail.com>
Subject: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Date: Fri, 16 Jan 2026 18:38:07 +0800
Message-ID: <20260116103807.109738-1-hwenwur@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memalloc_nofs_save() and memalloc_nofs_restore() calls are
incorrectly paired in xfs_trans_roll.

Call path:
xfs_trans_alloc()
    __xfs_trans_alloc()
	// tp->t_pflags = memalloc_nofs_save();
	xfs_trans_set_context()
...
xfs_defer_trans_roll()
    xfs_trans_roll()
        xfs_trans_dup()
            // old_tp->t_pflags = 0;
            xfs_trans_switch_context()
        __xfs_trans_commit()
            xfs_trans_free()
                // memalloc_nofs_restore(tp->t_pflags);
                xfs_trans_clear_context()

The code passes 0 to memalloc_nofs_restore() when committing the original
transaction, but memalloc_nofs_restore() should always receive the
flags returned from the paired memalloc_nofs_save() call.

Before commit 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}"),
calling memalloc_nofs_restore(0) would unset the PF_MEMALLOC_NOFS flag,
which could cause memory allocation deadlocks[1].
Fortunately, after that commit, memalloc_nofs_restore(0) does nothing,
so this issue is currently harmless.

Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
Link: https://lore.kernel.org/linux-xfs/20251104131857.1587584-1-leo.lilong@huawei.com [1]
Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
---
 fs/xfs/xfs_trans.c | 3 +--
 fs/xfs/xfs_trans.h | 9 ---------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..d2ab296a52bc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -124,8 +124,6 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 
-	xfs_trans_switch_context(tp, ntp);
-
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
 
@@ -1043,6 +1041,7 @@ xfs_trans_roll(
 	 * locked be logged in the prior and the next transactions.
 	 */
 	tp = *tpp;
+	xfs_trans_set_context(tp);
 	error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7fb860f645a3..f7fcb95afe41 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -278,13 +278,4 @@ xfs_trans_clear_context(
 	memalloc_nofs_restore(tp->t_pflags);
 }
 
-static inline void
-xfs_trans_switch_context(
-	struct xfs_trans	*old_tp,
-	struct xfs_trans	*new_tp)
-{
-	new_tp->t_pflags = old_tp->t_pflags;
-	old_tp->t_pflags = 0;
-}
-
 #endif	/* __XFS_TRANS_H__ */
-- 
2.43.0

