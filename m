Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E115E5D5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093749; cv=none; b=S2J4C1zSLoD1qD7HUd702CSnPItRlaPzWsHKygm2maM+3ddPZ19PWLwLdzOLr3z2bajzXdeapUy3TYdbfDp6mO0wvJLsfWH4cxAPiYpZi1UQ97XB5koOMibDKlKpmwKTDyxwkbYoPSRPqF9vWcGH8ibinZSelUmNDVi7vSL72OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093749; c=relaxed/simple;
	bh=keM1ljnnPeIAbQ0bORlCquMqcu2A3JvF81NTWSeARB8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjatdqEcxqBWiF32LGMc7V+jsaE3SLKjmnMrIiZl9VI0dwJpKvQsAez34dRhFs5sn+uz+PmW3lDdQYGoH+o6+cqUgqyPNYMLEBPM+n7XpT5GsiYHeMU2UktIZg41rKjvB/Fsri0/RHJqx+9MtiGXfHF3a8bYZFnanxN9E4jzOvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JEEUNs0W; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JEEUNs0W"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so4338358a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093747; x=1712698547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPxyqSpZNKM8dOHMT3TpHef2/D/uXnXA//lmszRzxHc=;
        b=JEEUNs0WOWLdH2NjtHZTSKvmZyVECAGjh80DEldSujhaEOvKktHMa665RgUvdO4YGb
         Zt5Th++23Pa/qT9NGzVIompLqdYmUGR1+ru4c/C4xLqEsxry+hyxlx9NN/CoNTG9tbSW
         hEB4lC6Twfgc2bj8gyXq5dyGl6K2R9zQRlXDXSe7vxOWeaaI0t3q49EcyA1bntDrXYXp
         zE4bAFF2ykXAlSMSDhuHgHGQkWHudyNItcBJg1jyra+zGgZZrqT5rHFyt85pDblrXVOS
         8RXn09hYOXMZRCDzGuaAnI36e81sf7FluA98LEFSKxneiLjeU9KNax4qXtHbOGPTdwUP
         7vHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093747; x=1712698547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPxyqSpZNKM8dOHMT3TpHef2/D/uXnXA//lmszRzxHc=;
        b=MfyqhMPSuFlIT1xq/SR37uUHM4cD9BtVxduvxh9OcS3qwox39Gv+iAp6RvbCeuekHB
         aZelRMJ9Yy9OywSMjdN9S6iH/uN0UVCI7yzwmH6FUXFxFV4h0YRec9tdp1z4U8fhyhUt
         6BJzkiIWKczZTqw2erhQ4kVdOLhSsNvAcBj+K4j/Cc23h6JefYXwiFJ8CwA8SyZEJExg
         sk4uLYI0kKrRYGE7TqoWq55P47WCEaZ2vlP7gCAIbCyknexZ8frgncITHpx9Q5B+OzFP
         6jvzRmEEpNVYEr/iuwA51YqzhCaGZxsj3wg5rtH18SGwFaIOE7bk/keN+Nim0ZICOPgO
         e64A==
X-Gm-Message-State: AOJu0Ywi1PlRBo4o5Doj8UeUWJRD7R1yOts6Qt+dgR6yyo0DdY3sm62U
	aE7b5yFqF7n9bohUhU/TiBZxDl5snhatlwQLfzQQ9BlTYmRsPInDLkxpONhBttm+2XAk/QE2Vfi
	R
X-Google-Smtp-Source: AGHT+IGLp7lvzOPTORGgzg+6weQ88RHwDTJXqg4JT4fQeDXUWBccTu73SWug8Q+xty/NLqXF/EcYjQ==
X-Received: by 2002:a17:90a:4216:b0:2a0:33c2:997e with SMTP id o22-20020a17090a421600b002a033c2997emr11700401pjg.41.1712093746935;
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id j23-20020a17090a841700b0029c5ed2c9b3sm10263086pjn.21.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n73-0G
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052FS-2UvG
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: fix CIL sparse lock context warnings
Date: Wed,  3 Apr 2024 08:28:28 +1100
Message-ID: <20240402213541.1199959-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402213541.1199959-1-david@fromorbit.com>
References: <20240402213541.1199959-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Sparse reports:

fs/xfs/xfs_log_cil.c:1127:1: warning: context imbalance in 'xlog_cil_push_work' - different lock contexts for basic block
fs/xfs/xfs_log_cil.c:1380:1: warning: context imbalance in 'xlog_cil_push_background' - wrong count at exit
fs/xfs/xfs_log_cil.c:1623:9: warning: context imbalance in 'xlog_cil_commit' - unexpected unlock

xlog_cil_push_background() has a locking annotations for an rw_sem.
Sparse does not track lock contexts for rw_sems, so the
annotation generates false warnings. Remove the annotation.

xlog_wait_on_iclog() drops the log->l_ic_loglock. The function has a
sparse annotation, but the prototype in xfs_log_priv.h does not.
Hence the warning from xlog_cil_push_work() which calls
xlog_wait_on_iclog(). Add the missing annotation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 2 +-
 fs/xfs/xfs_log_priv.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 73f5b7f628f4..f51cbc6405c1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1378,7 +1378,7 @@ xlog_cil_push_work(
  */
 static void
 xlog_cil_push_background(
-	struct xlog	*log) __releases(cil->xc_ctx_lock)
+	struct xlog	*log)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 	int		space_used = atomic_read(&cil->xc_ctx->space_used);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e30c06ec20e3..c39956c41374 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -623,7 +623,8 @@ xlog_wait(
 	remove_wait_queue(wq, &wait);
 }
 
-int xlog_wait_on_iclog(struct xlog_in_core *iclog);
+int xlog_wait_on_iclog(struct xlog_in_core *iclog)
+		__releases(iclog->ic_log->l_icloglock);
 
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
-- 
2.43.0

