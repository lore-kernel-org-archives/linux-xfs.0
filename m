Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884C362143
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 08:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770279988; cv=none; b=OvBpl3AZ8PQkyl/R1W6aOi4Ue5rwMw80h33YUYeJtyazpUzfdO+n11tBqqxEWZoIFVm8XvrKTqnvxEevO+ohqpKu5QVlVfly9Z6kkzfZfkj/lT2/UBqTauMbwx7cY8cH8Nvl08hD9J6RtRcNfDZC7hxdjhd3VuJSsdtrpkawXzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770279988; c=relaxed/simple;
	bh=K7nIw6rNzQwjwpKE1QeUzMMR63HhjMVy519yZbNT+Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk2Oqh8nNpBm1yIW6QSnItY3IXKv+4K28vPVVUKJVqcEDwu+05x7aTh7yNOpAhYCaOzvF+gaRWptUtJgrmKukxjRRWlCEeSQJhuFPbKjU9jAGQTW78J/gaDQUk0gC9EkZoOOad5M6SvivwdSsijBG3s17XSKSPiw/27LNnhx9b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N9ZXv4FU; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9ZXv4FU"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-124a635476fso1118295c88.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 00:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770279987; x=1770884787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PGKr7Z/I0ZG/rbif+5mFPobAZfXE5uXg7YjnSNGByQ=;
        b=N9ZXv4FUFQRaJQmauTj6yJwL5zyg92K7Kif5ujbmWbFhiC3LtagTPMocFyu/+OXzvZ
         aNBmcVy8CxD57rv1qgLRAFGrTC57P9f8tbQUK+yS0imYr6Ys3gA0rnbEvfzz4yIYHuNl
         NCqnmIfGfS8aHkJWCzBizdXUpM6x25YMFLshopARL+hC6b8GT4ZTBecw9fn2D3g3OHfg
         NLK4X7fMoQOUjAcvyp1aRk1dIPXEL16rcVGPXyVgjwTF7L00DKTheRJdhLSj9H9dgrq5
         +fUnFn6yPMWP141naetn1kVZDNmqvbqCKdAi4XE0ucFhY00yGo7RSM6/gXLJ5udof3YI
         n2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770279987; x=1770884787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9PGKr7Z/I0ZG/rbif+5mFPobAZfXE5uXg7YjnSNGByQ=;
        b=RhTSSUIHTdJTTB5Nz3ncl1FQCGOHaaYvT457038SxarYyp6EIwdUdkBEDsmkIdZhEx
         +UB5GiNZEClCHtYlj/vBOdXx5zXpnsh/ks+Fq9PK5kf9tbrRUDYR0LDzLnO6mLOlzUYv
         CIOCQh3Lm0YrFcHYCwIjeZtc/t8PVgJFE2B1fDbhQvvRkJRxhTiHpfMCLia5VNj4ZrIn
         DniFy9YRWmHkjUvHuEYALGghD+Y43qUk8F0dEXlI+oiRp5oXq1UhacI1Q5pX4cRlIuH2
         DhfWZd/xwEtB5FhcrJEbfBcz1+JShtq4lu5JLZbPdjHuU0kQmNwfsB1DBNGsqvMEupwk
         wu2w==
X-Gm-Message-State: AOJu0YzhoXIFxCAtjxyzelgUvEnxt0QBy8nd7XMnAn+fFP7Mc0M8xaR3
	SQGA42pN3t/HSjCcT/0kktbVmmDK88ZBdBcXBW9egnztZWmgcXGxeyqp
X-Gm-Gg: AZuq6aJsv7dZiIMGZA2rNhDQSnDBmhDvgZnOq2LLw1qErv1kw5SV8n6iQbAVipJRjT/
	hYl0aVzFGgIY1vl/E5Iwsmw6C6bsKeF9cdegaVyrzl/AhcAX8JmSL1/OTlpdptGqt71p5wOLf4n
	XAUjeGraFvHP2r37UCwtST9AIx1yxOZAuwYAOPouvqN1J1YR4riimO5v0dMPMjMRyC+7kvpSONr
	Pms66216E4jH99DnqzMSGT6s/dS0h+vpGquNXKr/O/Cm/fUXxXyy+hKUaUJRwzUqTG0nB9KBB0q
	zs9LANgPX5ZS4vCfaAi4qwlSZs/GRVNws9HO55KgYa9JgQqpBxT8qNdpeYVeJ94EbTT6kb8UhVE
	w0kUkgtpKNzkkpUtqv+OayunIXbxqBxLYWtd5ZXPq7PhZastvG47RPH+oznONskRrFeXXW72oJx
	TacAymAsbJhI4jfJr5aiIHWWU=
X-Received: by 2002:a05:7022:62b:b0:11b:a36d:a7f7 with SMTP id a92af1059eb24-126f478dac4mr2133180c88.16.1770279987205;
        Thu, 05 Feb 2026 00:26:27 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503ecf4sm3903960c88.15.2026.02.05.00.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 00:26:26 -0800 (PST)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 1/2] xfs: take a breath in xlog_ioend_work()
Date: Thu,  5 Feb 2026 16:26:20 +0800
Message-ID: <20260205082621.2259895-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260205082621.2259895-1-alexjlzheng@tencent.com>
References: <20260205082621.2259895-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

The xlog_ioend_work() function contains several nested loops with
fairly complex operations, which may leads to:

  PID: 2604722  TASK: ffff88c08306b1c0  CPU: 263  COMMAND: "kworker/263:0H"
   #0 [ffffc9001cbf8d58] machine_kexec at ffffffff9d086081
   #1 [ffffc9001cbf8db8] __crash_kexec at ffffffff9d20817a
   #2 [ffffc9001cbf8e78] panic at ffffffff9d107d8f
   #3 [ffffc9001cbf8ef8] watchdog_timer_fn at ffffffff9d243511
   #4 [ffffc9001cbf8f28] __hrtimer_run_queues at ffffffff9d1e62ff
   #5 [ffffc9001cbf8f80] hrtimer_interrupt at ffffffff9d1e73d4
   #6 [ffffc9001cbf8fd8] __sysvec_apic_timer_interrupt at ffffffff9d07bb29
   #7 [ffffc9001cbf8ff0] sysvec_apic_timer_interrupt at ffffffff9dd689f9
  --- <IRQ stack> ---
   #8 [ffffc900460a7c28] asm_sysvec_apic_timer_interrupt at ffffffff9de00e86
      [exception RIP: slab_free_freelist_hook.constprop.0+107]
      RIP: ffffffff9d3ef74b  RSP: ffffc900460a7cd0  RFLAGS: 00000286
      RAX: ffff89ea4de06b00  RBX: ffff89ea4de06a00  RCX: ffff89ea4de06a00
      RDX: 0000000000000100  RSI: ffffc900460a7d28  RDI: ffff888100044c80
      RBP: ffff888100044c80   R8: 0000000000000000   R9: ffffffffc21e8500
      R10: ffff88c867e93200  R11: 0000000000000001  R12: ffff89ea4de06a00
      R13: ffffc900460a7d28  R14: ffff89ea4de06a00  R15: ffffc900460a7d30
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #9 [ffffc900460a7d18] __kmem_cache_free at ffffffff9d3f65a0
  #10 [ffffc900460a7d70] xlog_cil_committed at ffffffffc21e85af [xfs]
  #11 [ffffc900460a7da0] xlog_cil_process_committed at ffffffffc21e9747 [xfs]
  #12 [ffffc900460a7dd0] xlog_state_do_iclog_callbacks at ffffffffc21e41eb [xfs]
  #13 [ffffc900460a7e28] xlog_state_do_callback at ffffffffc21e436f [xfs]
  #14 [ffffc900460a7e50] xlog_ioend_work at ffffffffc21e6e1c [xfs]
  #15 [ffffc900460a7e70] process_one_work at ffffffff9d12de69
  #16 [ffffc900460a7ea8] worker_thread at ffffffff9d12e79b
  #17 [ffffc900460a7ef8] kthread at ffffffff9d1378fc
  #18 [ffffc900460a7f30] ret_from_fork at ffffffff9d042dd0
  #19 [ffffc900460a7f50] ret_from_fork_asm at ffffffff9d007e2b

This patch adds cond_resched() to avoid softlockups similar to the one
described above.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_log_cil.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 778ac47adb8c..c51c24f98acc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -843,6 +843,8 @@ xlog_cil_ail_insert(
 					LOG_ITEM_BATCH_SIZE, ctx->start_lsn);
 			i = 0;
 		}
+
+		cond_resched();
 	}
 
 	/* make sure we insert the remainder! */
@@ -925,6 +927,7 @@ xlog_cil_process_committed(
 			struct xfs_cil_ctx, iclog_entry))) {
 		list_del(&ctx->iclog_entry);
 		xlog_cil_committed(ctx);
+		cond_resched();
 	}
 }
 
-- 
2.49.0

