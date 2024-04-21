Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20692D29B;
	Sun, 21 Apr 2024 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713685803; cv=none; b=K7NiR+0d5t+lLWzd9lryRPSfml/CXeWv2S5qngytBxir3wqJ+2jTDqmDgiHDpgLVyqTbhMBlh42drYi1SyZc7cRlCeOSiHAMEIRRIR0n7a0uOA2SdwD/fTdX/w5m06bAbalUY2vjlvHhwULxkIFJFkx93sOb/7vr0mr395UzlwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713685803; c=relaxed/simple;
	bh=2rHvtM1klJH1UpFbkaRl/HGdHUXWdzgJzOYsbm5BhXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzbM5RkKB481T03ClqhOlaCQyEIpcWivT9GXmfvQrLumJqgIGbpwQZAGjnAHxTQ1vZvcwumFGfCljY8VWGzvawMhEBh4yXHeLRzLGl7ne4YPhhfmOQY3iexLRGtGeeQu5tPY912Z0ugRGrXhBr88K2yJzOSqy7rU4PZDXJOl490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kD4tOURL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kD4tOURL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e3f17c6491so27050425ad.2;
        Sun, 21 Apr 2024 00:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713685800; x=1714290600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjy/MMhs9zj8FJiLvdOVKVPhZVA+vCWcjSMVWLygDr8=;
        b=kD4tOURLZtH5paRBL8xqrXVimI1HhWo4O+r+9hnuAG4QlQPh4E7KC64LtTNfi/Bwku
         S5qYov6VRer1M7iqt6AjX5m6xUKVtupEcgZ1j29Qql3YWOR9vs94uUEw7+bscVyu6md2
         vix32vt8EKuAP8eT3G8hiA24DlCgd6fM6e0g/g1XTCtrfl92zDhRHD+Qo8rrj15OJOJs
         CQ04PDvn19s9O3FvbG/8TxgVHHyHDC+P5monodbJSKWjg98kcZ1hzGLqqLPASVZ+lmmB
         u+yes9EywIUG/VDE7HlVCQuLeZQ5vvigvOaV+9QMY/lvdJsVU31GBa+nRfnCZTfDqMeS
         9/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713685800; x=1714290600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjy/MMhs9zj8FJiLvdOVKVPhZVA+vCWcjSMVWLygDr8=;
        b=YqhLXYYXjLC1VlL68Ogu/K+t7UwZ+R1zpm5Gu6gbLM58w1v8Euo2q0LwUK22LcdZgn
         K9DNfmZYnFEFA43mhb/BJngJshsNYo+xlBg7JOltYnDXqUAOgcSyDyL+BeMLOkvs0Sk2
         z/espBdZm8QC6oTtvhq1StofU89YNiMBkC7MMdVoxFSWY3Inp/CFLKQAT1Ymx6tgV8RZ
         bMTV9a3WbOtbLrw1+ZhqUjHbuDMIckF82rpxYSat1NUsgsTF+ABw6CQcvFrSOzGFrNBE
         h0P7Q9QbwTuEFdry/L3fwPHYAkbKoKYIqdhpAwAOe+IoNkzct7vV3pYY2yQkXXukDBGo
         HHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaUkYsc0pbdxmWkGRiwqqANUEFCLe/flI34F1uDzB5Y3TNtqhUEUT3t9RKQdRrOraWj7ZYvOSQquKp+9Nxv5xFRvIDobKe
X-Gm-Message-State: AOJu0Yw0VeAYbTxnLYaqmqb8irW1OjadkI+Rmhk3cliQGHzX1Tdvd7BW
	5Vfl9+UUXoHDOYoY44KkoP7H+wpMfhMdM63BZjH3O2TKAAEGPMnvQqd8Tw==
X-Google-Smtp-Source: AGHT+IEmFkljeitmm0D2Wl8R9Xbt7U9fOFmyJVo2MOMxJ9eHI/REplF9MtCpsYzZmXyka9mDBxoZuA==
X-Received: by 2002:a17:902:d4c5:b0:1e5:2883:6ff6 with SMTP id o5-20020a170902d4c500b001e528836ff6mr7610265plg.11.1713685800385;
        Sun, 21 Apr 2024 00:50:00 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.85.139])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902820200b001e042dc5202sm5944695pln.80.2024.04.21.00.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 00:49:59 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] xfs: Add cond_resched to xfs_defer_finish_noroll
Date: Sun, 21 Apr 2024 13:19:44 +0530
Message-ID: <0bfaf740a2d10cc846616ae05963491316850c52.1713674899.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713674898.git.ritesh.list@gmail.com>
References: <cover.1713674898.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An async dio write to a sparse file can generate a lot of extents
and when we unlink this file (using rm), the kernel can be busy in umapping
and freeing those extents as part of transaction processing.
Add cond_resched() in xfs_defer_finish_noroll() to avoid soft lockups
messages. Here is a call trace of such soft lockup.

watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [rm:81335]
CPU: 1 PID: 81335 Comm: rm Kdump: loaded Tainted: G             L X    5.14.21-150500.53-default
NIP [c00800001b174768] xfs_extent_busy_trim+0xc0/0x2a0 [xfs]
LR [c00800001b1746f4] xfs_extent_busy_trim+0x4c/0x2a0 [xfs]
Call Trace:
 0xc0000000a8268340 (unreliable)
 xfs_alloc_compute_aligned+0x5c/0x150 [xfs]
 xfs_alloc_ag_vextent_size+0x1dc/0x8c0 [xfs]
 xfs_alloc_ag_vextent+0x17c/0x1c0 [xfs]
 xfs_alloc_fix_freelist+0x274/0x4b0 [xfs]
 xfs_free_extent_fix_freelist+0x84/0xe0 [xfs]
 __xfs_free_extent+0xa0/0x240 [xfs]
 xfs_trans_free_extent+0x6c/0x140 [xfs]
 xfs_defer_finish_noroll+0x2b0/0x650 [xfs]
 xfs_inactive_truncate+0xe8/0x140 [xfs]
 xfs_fs_destroy_inode+0xdc/0x320 [xfs]
 destroy_inode+0x6c/0xc0
 do_unlinkat+0x1fc/0x410
 sys_unlinkat+0x58/0xb0
 system_call_exception+0x15c/0x330
 system_call_common+0xec/0x250


Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
cc: stable@vger.kernel.org
cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c13276095cc0..cb185b97447d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -705,6 +705,7 @@ xfs_defer_finish_noroll(
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		cond_resched();
 	}

 	/* Requeue the paused items in the outgoing transaction. */
--
2.44.0

