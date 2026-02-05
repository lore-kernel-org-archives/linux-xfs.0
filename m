Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073BE3624A8
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770279990; cv=none; b=Lyf8VL6rWkqidijakJpiKMWoESzRBRBPeSsuSnJdubbxnGWRgosPEDhy3wbSHugX7ukoPIHIwy8xWJT8J4X0lbssu3p5kJZPZMR908xvNmzYu3y4lG8mRjnxK7f38ulDJc04fed8+6dfhs431zKtWWTxAS9FlnfqzZ4mVduRf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770279990; c=relaxed/simple;
	bh=nto/KS4yj9hTqP4//CUBcGLjOjJ6dcZLzmsk0/gJRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGC33KDbYovhp57z7y3lxshdIvYy1ETv3GtLZXvUP1t1i5k/YnILdjkq9j+tnBa2euqYw2EPGXrg7jfAN/scll5Ba56y7el2MMECoSc0PFPLMHLGITYj/BuXpXDtror0iMfBdjJMfhB7bvNTqJmjP5cgMpLNB44JpzmPbeNgVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkEJzrI3; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkEJzrI3"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-11f36012fb2so866040c88.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 00:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770279989; x=1770884789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxigY4Bd4BItH6ZE5l5QW7c2gKFO50DqpY5KS0BPjNY=;
        b=JkEJzrI3nqHXV5B+KrdJgrnbiYuRFGXNWWEAfEg4MrHaGH68h8/jXX+wFVIIYffPr9
         mE/7p5ZSxilT4uoDtBiG1BB900svyCRspHlzNa3dkEdDBIlj6EVdr8a45bdA05T3M0R4
         pEFIqgH6Ej8/IIUURgttTO9/CIsWSRYknrluLceSnoDTFQ9VLnn8WRC9QhY0WjbMlc/H
         2y8pMcXK8A4fv+jml7gg+EiPTxzO5Sd5rv8+q6ZCdmfYYO36Rn9e9Y5xKhMkZtY4uXmp
         UTScDH/py4IjYMFiRQo8a3Ctnw1K9KO/RlgcLgDqk+SRLnttMqPSWdiyTBZH8p4TwN6e
         j69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770279989; x=1770884789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MxigY4Bd4BItH6ZE5l5QW7c2gKFO50DqpY5KS0BPjNY=;
        b=qU/+DpVATXEjqo77qx0ANl2GPYdiNnXjc/2g0stoPKUr0pCVdcTucsory20kT+ch7/
         6uHadLY4f3WKYDMjBljSXqo2gUkWd0EN3Ly+SbFlZrdMptZZzzE8vxe37/BBf/kd+7vc
         PzUQmDgfl66I+go4g6aGa9jeNrkBkONQWYTYcN5G445oRinHGSdnsCknE20HT7UgjO5l
         cpGlaolnR7E44uJyuoPTezKaydtpQPHss2/fUPglyKz1cQApaSY14ePEht7/2MtZLBqc
         DdTftphI/79vy6dqup+2kqINyi2PmXGD7TjvAWtGQCRyZiY9EFUY2NRIP9tWZ08cvloF
         O70w==
X-Gm-Message-State: AOJu0Yxc9dY5atYxzDtgg4JaM4miD3dHu6W8pLiVEGuFOZJdh8V2IdbL
	Bot07RWoUGLGvqgc2VcEFJSuc3V+46xDXdBuQjRkwL7mTsXBU5DqPKyWqXXHMg==
X-Gm-Gg: AZuq6aJxxhnHdpFQ/5gvRJwaYwmWdY0bvKhbO67Fn+7SN9sGyjoN8Exscrb6sO+WL89
	xSsQ/Wn+u4k8G2fBl53QgUGQxSingLRZOsrn0HKSJ1Def70p5+XurnGXXzkY8lqtWEjC5b7ppuJ
	aTrjaSgr8awd7o2px+7zOanfqNZ0dJO1yl8Pz486Hma8CWm+CpguJJZubI4q2c/TI7+mqpaNnUy
	cAYVJIabAFXgssvDZeyAFuMFoTDQr6yBEnD8cd8uOJZ2nedriFpuIbKJCyjqUT+Mr3rd2ReArSm
	Jr9ij+1e0Uf6IgphTRONK+b5r3BmnPxYkH9Zbun2JrKrZs4gK53Zi47JOvxQTWz0aOoU9PhOj7o
	gpgZZPAtr0QSHa/IcWw+0TV2StaP5g8ZFumvpppFLid4Wts1r88W4vvIq0aWkPVdIoFbzcPYGwB
	HQQiYtj6w3mII9SxHAIvzFEUM=
X-Received: by 2002:a05:7022:6ba2:b0:11b:923d:773f with SMTP id a92af1059eb24-126f4781428mr2526250c88.5.1770279989082;
        Thu, 05 Feb 2026 00:26:29 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503ecf4sm3903960c88.15.2026.02.05.00.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 00:26:28 -0800 (PST)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 2/2] xfs: take a breath in xfsaild()
Date: Thu,  5 Feb 2026 16:26:21 +0800
Message-ID: <20260205082621.2259895-3-alexjlzheng@tencent.com>
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

We noticed a softlockup like:

  crash> bt
  PID: 5153     TASK: ffff8960a7ca0000  CPU: 115  COMMAND: "xfsaild/dm-4"
   #0 [ffffc9001b1d4d58] machine_kexec at ffffffff9b086081
   #1 [ffffc9001b1d4db8] __crash_kexec at ffffffff9b20817a
   #2 [ffffc9001b1d4e78] panic at ffffffff9b107d8f
   #3 [ffffc9001b1d4ef8] watchdog_timer_fn at ffffffff9b243511
   #4 [ffffc9001b1d4f28] __hrtimer_run_queues at ffffffff9b1e62ff
   #5 [ffffc9001b1d4f80] hrtimer_interrupt at ffffffff9b1e73d4
   #6 [ffffc9001b1d4fd8] __sysvec_apic_timer_interrupt at ffffffff9b07bb29
   #7 [ffffc9001b1d4ff0] sysvec_apic_timer_interrupt at ffffffff9bd689f9
  --- <IRQ stack> ---
   #8 [ffffc90031cd3a18] asm_sysvec_apic_timer_interrupt at ffffffff9be00e86
      [exception RIP: part_in_flight+47]
      RIP: ffffffff9b67960f  RSP: ffffc90031cd3ac8  RFLAGS: 00000282
      RAX: 00000000000000a9  RBX: 00000000000c4645  RCX: 00000000000000f5
      RDX: ffffe89fffa36fe0  RSI: 0000000000000180  RDI: ffffffff9d1ae260
      RBP: ffff898083d30000   R8: 00000000000000a8   R9: 0000000000000000
      R10: ffff89808277d800  R11: 0000000000001000  R12: 0000000101a7d5be
      R13: 0000000000000000  R14: 0000000000001001  R15: 0000000000001001
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #9 [ffffc90031cd3ad8] update_io_ticks at ffffffff9b6602e4
  #10 [ffffc90031cd3b00] bdev_start_io_acct at ffffffff9b66031b
  #11 [ffffc90031cd3b20] dm_io_acct at ffffffffc18d7f98 [dm_mod]
  #12 [ffffc90031cd3b50] dm_submit_bio_remap at ffffffffc18d8195 [dm_mod]
  #13 [ffffc90031cd3b70] dm_split_and_process_bio at ffffffffc18d9799 [dm_mod]
  #14 [ffffc90031cd3be0] dm_submit_bio at ffffffffc18d9b07 [dm_mod]
  #15 [ffffc90031cd3c20] __submit_bio at ffffffff9b65f61c
  #16 [ffffc90031cd3c38] __submit_bio_noacct at ffffffff9b65f73e
  #17 [ffffc90031cd3c80] xfs_buf_ioapply_map at ffffffffc23df4ea [xfs]
  #18 [ffffc90031cd3ce0] _xfs_buf_ioapply at ffffffffc23df64f [xfs]
  #19 [ffffc90031cd3d50] __xfs_buf_submit at ffffffffc23df7b8 [xfs]
  #20 [ffffc90031cd3d70] xfs_buf_delwri_submit_buffers at ffffffffc23dffbd [xfs]
  #21 [ffffc90031cd3df8] xfsaild_push at ffffffffc24268e5 [xfs]
  #22 [ffffc90031cd3eb8] xfsaild at ffffffffc2426f88 [xfs]
  #23 [ffffc90031cd3ef8] kthread at ffffffff9b1378fc
  #24 [ffffc90031cd3f30] ret_from_fork at ffffffff9b042dd0
  #25 [ffffc90031cd3f50] ret_from_fork_asm at ffffffff9b007e2b

This patch adds cond_resched() to avoid softlockups similar to the one
described above.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 47edf3041631..f1f8595d5e40 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2026,6 +2026,8 @@ xfs_buf_delwri_submit_nowait(
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_list_del(bp);
 		xfs_buf_submit(bp);
+
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 
-- 
2.49.0

