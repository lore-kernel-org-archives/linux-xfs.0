Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB5C39182E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782813977; cv=none; b=UhYstdamEDoTNMsjkeM4q77seZh03SZGHcQ2b6qvDfWeLo6/Hg8/nfHbU/UV7PKaZuuffQhHoD2ASlQgi/174MlEOczlYa3AuQIiWDnhUZpdqHu3Gao6fVL2alOeS+zoadGnmlw/DqkpDxmvMRRFLliveHBOiafjZeStHnl5X54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782813977; c=relaxed/simple;
	bh=gGQAAIyoD+h7Z9llH2gkofmyWJfpV6p3d7RJw6eTTPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGOh7/abDGf9tPUWqbN4sAob/z9wbAZasYILQhQswcgqAq+EKg4R7OG5+uhziSqDyV70yHZrqKQlU9jdcueazHu1ZSFN4x/7qF1yH/iym6FW1y44WTaJSYGhpirA0b8TOhfCfdhmk3+HrUFY/Y9oabqY94PNTzwRL1LKG0uP+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=La8v0TyG; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="La8v0TyG"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493a7bd27c2so19628895e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 03:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782813974; x=1783418774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mtwliPDiq/xVOyMkLB16zfgx4HPYeHz9vWwy4071LTQ=;
        b=La8v0TyGyU1+S5DtP1r3uZKe5jaL9yAsZNs2/O5nDUZaNlJxF3oXnStG3vWZOD9JRY
         DaRIA40HLcLkW/SR3dFSLfHKImNoMDmWcaugm93KAG2LBUe2Y16PxMtFFXqtNLwvqU+W
         +WBP23ZcCE8rLiEeTvuUEHKIM8YoCL5FlD33262Pt0a/SwGH6ScdrfOT9HJS2wJsVkBc
         HNeJjLsHtVeXMiAD7XsPRKgVzZI83jlPj8HmAGxc9YDL3vlR0jIejTGcmrDOnJAUsRJI
         ARHAm56CfTwrAA5V7yYmWma6Fpgtpwc5jRui3En+V+ujsQdwSwctwWYyuU+o+mzvOTFP
         qQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782813974; x=1783418774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtwliPDiq/xVOyMkLB16zfgx4HPYeHz9vWwy4071LTQ=;
        b=so05loP/OqDudQJZCjO4NHAjypBR+BC1lenp8GmN6Xvsi8K5+pFRfJRpcUbhk5x/l0
         9u39JlzV+qYPCiB1pb265BkLnaM4PXknBdmeOJI8DvF5iA6A9SbL+Vd1zTRtQ0SteEap
         +c/v2xRNMC7BKmeiKBg3kmJtang7zSxHdhyRcniKiQw4hh4U/DaQjnfN91ufY9hRNK1G
         B17mjENTq/H7AHCfs+BjAHem5B4Hw2dOo39t5/kHr0EBTJBfaYdXN13puI/qAwSXizbh
         g2c5ZNQw/+WEYkiI1ahdGv5fpjWJnxaeZUmOvqtKFhqDQgi5ux/n71fIFX7dOPXkwRJ7
         e5NA==
X-Forwarded-Encrypted: i=1; AFNElJ8aWedXlXGcwCq1nIOTIReVDD7SYgwiKvslT2SdI5ipVii3SiMsf/1rUf1dPobu3y1BCx+MWz9wB3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwTtXXn6rxmHS45Ninx+EZRPCRayGD2f/I5ucyIxo+c+SrDg3m
	9llGJHc6ZtP4JqKyE0zMgoss14TyuCIOETdqQUZJm8+XLrrTuZIJGVQZ
X-Gm-Gg: AfdE7ckx/XmcW6Xs6ZgmGp8ezxCn4BUn/989hBLF1hWXFM+CQxhOqJxkfs6vIrbAouD
	82p4UoIh2FeFOqrlTu96GT/9BAZ3nUGELdLRtw4eW0y1aGBg0LlZyBbeqLlvKCNaWH5QWGYBTJt
	/IxDZCFxl8rFq9uM6l4nO6I1twRSSnfmQ4F8uF8SuSOwqmJW5MNexgOmgrlagT2lrJS2ndfgYqU
	AGLDGk5EJGejbug3bvlL8Ev3Ajx53un+VgCiK8u0OPidWqHQgN6U9tPdKkTrdPdw9BIqJT44orv
	XJPED2NWM4Fkg5eoS9ZZZwW/hVriJ4AixSCEzikuh3rSTL5ErI3NogVZz8xI5VhWUeH6Us982tj
	8mU4/jU2Mnczt+IARw9fOWSz3PvtvGgC872XA8s7+FnpLyf/WaILTJ38kz2Pzk7lXe6bjmwjs6f
	IyOe5ZAEz/RpT5Mqe1GpNqQRw7vw==
X-Received: by 2002:a05:600c:6290:b0:492:5030:5e7b with SMTP id 5b1f17b1804b1-493b8288851mr43492795e9.10.1782813973931;
        Tue, 30 Jun 2026 03:06:13 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8d0afacsm63712565e9.12.2026.06.30.03.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 03:06:13 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH v2] xfs: use null daddr for unset first bad log block
Date: Tue, 30 Jun 2026 12:06:07 +0200
Message-ID: <20260630100607.7150-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_do_recovery_pass() may return before setting first_bad.  The caller
must distinguish that case from an error at a valid log block, including
block zero after the log wraps.

Initialize first_bad to XFS_BUF_DADDR_NULL and test it explicitly before
treating the error as a torn write.

Fixes: 7088c4136fa1 ("xfs: detect and trim torn writes during log recovery")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
Changes in v2:
- Use XFS_BUF_DADDR_NULL instead of zero as the unset sentinel.
- Test the sentinel explicitly before handling a torn write.

 fs/xfs/xfs_log_recover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..5f984bf5698a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1028,7 +1028,7 @@ xlog_verify_head(
 {
 	struct xlog_rec_header	*tmp_rhead;
 	char			*tmp_buffer;
-	xfs_daddr_t		first_bad;
+	xfs_daddr_t		first_bad = XFS_BUF_DADDR_NULL;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
 	int			error;
@@ -1057,7 +1057,8 @@ xlog_verify_head(
 	 */
 	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
-	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
+	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) &&
+	    first_bad != XFS_BUF_DADDR_NULL) {
 		/*
 		 * We've hit a potential torn write. Reset the error and warn
 		 * about it.
@@ -3575,4 +3576,3 @@ xlog_recover_cancel(
 	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
-
-- 
2.54.0
