Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD95238D27
	for <linux-xfs@vger.kernel.org>; Sat, 17 Jan 2026 06:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768632801; cv=none; b=OWIO5jml75F94jnSEc3NKs0Ykj6C70H/5tyDFpdgzH5qj1nKx3w497RAB2oJlXbACuO+AQ9yydggDk9+Nwr2EXlXZWPIEUkRjhZPLFaQRkxRRTv1XMuqYIPUgMM+MJdB/ujltK6B0AFMZFTbQtNTOMNVTdJx6DURRk+456nY7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768632801; c=relaxed/simple;
	bh=FQ/qq5KMxmdZdm2S7ODZUYhaQMrFdtI1ATUBACChUUk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CnvjSQUOnBf6SgyLC3IrOXa33gS5VrDtweHR+shh9OUuneI+NqMCifZNFEA/sm/TccngARQUYTOT0sHAun3+KrV/YZcY2Nlf/lFeBEp4donoLq2bWwypC/3L9kFMdRcCJW573mzOLnmohslEGl4tKfDTzar8g17O4UHs67pPF1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZJyCbOm; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZJyCbOm"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b90db89b09so185900b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 22:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768632799; x=1769237599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iNPthM/2J3s6u6G74sY618LrTm9RqvGIDJ93kLM8Zfc=;
        b=UZJyCbOmV+WKFYGfMkjZP1i6wK2kcTWNvvgLVebrh2JBYV8urKHRKixzTGz9S5ooYR
         6vyqb7ciUBgRqWGOduucYiZkEdoJ3ZMxzdFnifcAfT8omfImeKFPX9xUVZWCZqhO+JYh
         ys5CpFatrojIzn7xEEJ0pH17rw3NpF3IO6a/nb+cbQnsgDpSLMo9CR+R7cGe+TXN9gSR
         Zzv2qKFgqIaYOZRVtwnq+q6kS4Aghqh3PLI8MxgOY8Bohp2FHZpg7duCtM4Sm6ji3aDE
         sN9LVjNaAcdDXRh9UiYLfKYMi6b6Yci0ON9Gto7S8UVKOIH4ISaTL5qYwd1+l5Wrjg7E
         YX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768632799; x=1769237599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNPthM/2J3s6u6G74sY618LrTm9RqvGIDJ93kLM8Zfc=;
        b=DapajX2Lu4kbkKbV9rAukoSuCClleJBd/VYKXg8BxPqBV6N7GCABHZNCEVPXtYo8dE
         1LmNpes9Q/65yYFEMyktlPjp1cAVsXWNk6htd441ykaZzc5Fzd6t0JBGvyspm1QUOfEM
         bjGTN7/OMlMITA5y3ieypQGgsp7Q9FYkEdbHp5LUwIP2H04oSMguuhkjARFjqo8AOPEM
         8/OVH0FL57avqgiz6ZYS4Lb6n2SXRORlfZvk0D6RUEH7eeyRNIPD+tuqbwaORb2IbDIi
         vHCeiWoHpXm/GKsFRkMm0xMiT01mtQSCl4gJGyHDK1OqEwqQuI3PL3q+cg3nF2S0eA4A
         W0iQ==
X-Gm-Message-State: AOJu0YzbLfrcusQPxxvn6WIOwOgdCTAeFcPKY21Vk1WcqdUA2oepDem3
	S6EC1VMFcqbH1/mHNipXwcDWM8xMVA7Nmf/oul7HR37QxZy1JlRdsuPBcoHFY3YWVlQ=
X-Gm-Gg: AY/fxX5BF0/F6uj+F6aUrHRDmoQ6zORmP3BRKAsdPNx5GpkJtOhkApu05aHtkB81Voc
	/Z8CwuFNGMksAnaMV2xtj8U+R99UmGrSfNKwzfF8npLDZ9n8zB6cRJc3VH1E2y79JJPfDJFfxFB
	QnXb7+05FXiJ06JXWBmfXJCsQf8AiGk9vXJKWIbP0RMAYN8ubn5R2Z3zBSpp554yuY00B3/2r6X
	zo+DcwUNXl5gO1t9MBWWNyIVqKvMB8xHFcXMPhWb0r5M4PeVZ8xmfiW9tBbSxqlzh9yDO3KuLIl
	4TzAicAh5XRKEkMhbvHx/Oy6e/qBGiXhOywoxgKDp+qj37d/TKHckWjXFZSw1/HlQl8070tGvDS
	5y/cpCuJOmRSlbSChb5lXCznCwvbaGEi/+6Kp4/dVug/LRwAoh5izNfH3zoSmHrGRslPDZoPisp
	3cAfcMli1QrlWXPY1sEH5/i/Oh5V488ooRXBgZY7HWP/8V
X-Received: by 2002:a17:90b:4f8b:b0:341:8bda:f04b with SMTP id 98e67ed59e1d1-35272fcef56mr3055763a91.7.1768632799338;
        Fri, 16 Jan 2026 22:53:19 -0800 (PST)
Received: from LAPTOP-FNOERNUQ.localdomain ([2a12:f8c6:d99:e7b2:15ff:4df2:c898:8bf4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352741cc52asm1758122a91.3.2026.01.16.22.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 22:53:18 -0800 (PST)
From: Wenwu Hou <hwenwur@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	dchinner@redhat.com,
	hch@infradead.org,
	Wenwu Hou <hwenwur@gmail.com>
Subject: [PATCH v2] xfs: fix incorrect context handling in xfs_trans_roll
Date: Sat, 17 Jan 2026 14:52:43 +0800
Message-Id: <20260117065243.42955-1-hwenwur@gmail.com>
X-Mailer: git-send-email 2.39.5
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
v2: add comment from Christoph Hellwig

 fs/xfs/xfs_trans.c | 8 ++++++--
 fs/xfs/xfs_trans.h | 9 ---------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..dbe92bf9f031 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -124,8 +124,6 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 
-	xfs_trans_switch_context(tp, ntp);
-
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
 
@@ -1043,6 +1041,12 @@ xfs_trans_roll(
 	 * locked be logged in the prior and the next transactions.
 	 */
 	tp = *tpp;
+	/*
+	 * __xfs_trans_commit cleared the NOFS flag by calling into
+	 * xfs_trans_free.  Set it again here before doing memory
+	 * allocations.
+	 */
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
2.39.5

