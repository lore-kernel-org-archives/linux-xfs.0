Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740D191F6F;
	Mon, 23 Dec 2024 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734946656; cv=none; b=BR1GRdQt9puDwXsIze+u87j33ONEOPpo9ytXun1C77czHtLR49SJUenkltElDUxqPDEf3g/witJQdRREZ9k0ofvJJSTCjMUeQo7awK/l2nfPnNomDZ+c+UPUaYFbtn+sIa+G7x8iVG9nnHqUyWAq+BRqnaBonQbJ2LVf9DGsd9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734946656; c=relaxed/simple;
	bh=/KnTsk7S6Yu76H9hXrO4DVhCEzN86bu6m7tbJlL2Pkw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c9ADyvY42qUXwf2uwVjXETy/jwtQEY8t8diyZWCr4us8R7dUVHlfm3TDyK8zO1ZIQxcvJygcO06Yw15DxpQoyP3MPHnRjyhImuwbHLOLwFQ3Wc4GlscmbIPutQr/E+9wrKnqd25y8UgqQ2Noe+CaaIm1WL41Uwrz9moBXojjSi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HGuEAXHQ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGuEAXHQ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-725f2f79ed9so3104176b3a.2;
        Mon, 23 Dec 2024 01:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734946654; x=1735551454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ESfG79+PcZuH+MzC4lH8jD2aPNHGINgHLlNjUVjw7c=;
        b=HGuEAXHQ8aY6SxXHkzxzl/8yLAZ6/1iEChkr+1o+KqecP5QgpDzjyakmVSk2RCIrIt
         rHZXy+ySXYmmP1XId8KkosC6Mo8xUKlaQvv6ltw6wgq7tleMncbHkMeixKxAFQ4u7xt5
         s+5SwDA3sa4rapJRCmiYSE4y3P5QEUoiR5UKX3BEcsKwHi82UHIDsHVO+9JxtztA3ufN
         L+viQusAW+/2ukP0rVMJd0ykFHdLYoIbt23TtDfnREgBwxYX8Sl4yXUwtpbETdk5GaM9
         +SZrSiwbHdJWM/4nsIgtaThoANtSnc7tX5YOkNWMIBpfm6tcK6rZQuxzWaLMdsZSZapE
         iusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734946654; x=1735551454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ESfG79+PcZuH+MzC4lH8jD2aPNHGINgHLlNjUVjw7c=;
        b=i53p0XP6GIPr8ZzBnGK1nhyd4BvgugGfby9FaDV7l+2k560k4s8LPnSpPgyfvA7svz
         i2czU/3b4ltAOss2JwzybG72qMGZdVCOKYNQEvKUYDHpzsps2ZFH8XaKvnqvWO5Fj4ML
         tu7i9oKly5fbksmyFQE/rM9hxgDOEHGQ0hqK0pcXF1XjFzIv67wmnk1zrwV9QNxYag5w
         nXD4dDhP/Mrg587N/Z/7RTUaIOwq+tSm999OXRYNSWPccuISWhNkz3tVlEBn5pVQI7QG
         XgFaQ8Z8KJCOgitvBd6zb2SEYAipKr9iXiVPpujlZuxu4Jd533Ky4mgTxmUr5CjegB4H
         2LDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv3Bh1Hl2aK6/a6rVyB+kCRCLgr7a8liR3q6LM2UOL2jFQoQBICns36sBE9tur3/+X3Oh+kqVyypIWfJQ=@vger.kernel.org, AJvYcCVX8p3uq6oLhf4evdf44gfVcyIZ6H34mj/gRmJNivVbCp9MNjdigYyUmrySLU+mvxLGwIhGmh5VxknY@vger.kernel.org
X-Gm-Message-State: AOJu0YwdC+/L03lR7p6VFmNuCfFpXFZxpuC7+H6tC/mvlfk3+RRnH/wQ
	unQQfHyt0lw+XgftpbjH54Wuk0/s9mHwGMZ/h8kcwwmQYAaZ1o9FQdawQKYL83U=
X-Gm-Gg: ASbGncs+Q0Rl7/GPlbnk312PRYO/LMl1JgvRZ195gqFgT/CqFXnGp643zjblTcLE63Q
	vXlPyJSvMsmJpz0oCFLu0q1laEKUth3Tvc3IB1l+OvKOLhv0/HrDCxU1Gk8XboJ4QSczVYzN6bX
	C8KbHQOlFIL/4RjL7ROaZokdZ0G85vbAJe77cazvCyXL6vgJohYOFpEAqYDdtI1UUJHfGWXEVUw
	/uNmML8SR8s9oQjeKarz47arpTB+U1+x5eZaQjC9e1HM3kMm4m7SIfyQLnjRrG0XDcYSBjOA0c/
	11zbBwk=
X-Google-Smtp-Source: AGHT+IFNR9qlTjlg1dNX4yr0XncX12ZUapQS/RnzWqqWQRakIntoz3bYLo0a/Ae2eSipeQPvkIeiuw==
X-Received: by 2002:a05:6a00:8089:b0:728:f337:a721 with SMTP id d2e1a72fcca58-72abdd7bc30mr14348300b3a.7.1734946654066;
        Mon, 23 Dec 2024 01:37:34 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8315b8sm7466943b3a.56.2024.12.23.01.37.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Dec 2024 01:37:33 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH] hung_task: fix missing hung task detection for kthread in TASK_WAKEKILL state
Date: Mon, 23 Dec 2024 17:37:22 +0800
Message-Id: <20241223093722.78570-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We recently encountered an XFS deadlock issue, which is a known problem
resolved in the upstream kernel [0]. During the analysis of this issue, I
observed that a kernel thread in the TASK_WAKEKILL state could not be
detected as a hung task by the hung_task detector. The details are as
follows:

Using the following command, I identified nine tasks stuck in the D state:

$ ps -eLo state,comm,tid,wchan  | grep ^D
D java            4177339 xfs_buf_lock
D kworker/93:3+xf 3025535 xfs_buf_lock
D kworker/87:0+xf 3426612 xfs_extent_busy_flush
D kworker/85:0+xf 3479378 xfs_buf_lock
D kworker/91:1+xf 3584478 xfs_buf_lock
D kworker/80:3+xf 3655680 xfs_buf_lock
D kworker/89:0+xf 3671691 xfs_buf_lock
D kworker/84:1+xf 3708397 xfs_buf_lock
D kworker/81:1+xf 4005763 xfs_buf_lock

However, the hung_task detector only reported eight of these tasks:

[3108840.650652] INFO: task java:4177339 blocked for more than 247779 seconds.
[3108840.654197] INFO: task kworker/93:3:3025535 blocked for more than 248427 seconds.
[3108840.657711] INFO: task kworker/85:0:3479378 blocked for more than 247836 seconds.
[3108840.661483] INFO: task kworker/91:1:3584478 blocked for more than 249638 seconds.
[3108840.664871] INFO: task kworker/80:3:3655680 blocked for more than 249638 seconds.
[3108840.668495] INFO: task kworker/89:0:3671691 blocked for more than 249047 seconds.
[3108840.672418] INFO: task kworker/84:1:3708397 blocked for more than 247836 seconds.
[3108840.676175] INFO: task kworker/81:1:4005763 blocked for more than 247836 seconds.

Task 3426612, although in the D state, was not reported as a hung task.

I confirmed that task 3426612 remained in the D (disk sleep) state and
experienced no context switches over a long period:

$ cat /proc/3426612/status | grep -E "State:|ctxt_switches:";   \
  sleep 60; echo "----"; \
  cat /proc/3426612/status | grep -E "State:|ctxt_switches:"
State:  D (disk sleep)
voluntary_ctxt_switches:        7516
nonvoluntary_ctxt_switches:     0
----
State:  D (disk sleep)
voluntary_ctxt_switches:        7516
nonvoluntary_ctxt_switches:     0

The system's hung_task detector settings were configured as follows:

  kernel.hung_task_timeout_secs = 28
  kernel.hung_task_warnings = -1

The issue lies in the handling of task state in the XFS code. Specifically,
the thread in question (3426612) was set to the TASK_KILLABLE state in
xfs_extent_busy_flush():

  xfs_extent_busy_flush
    prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);

When a task is in the TASK_WAKEKILL state (a subset of TASK_KILLABLE), the
hung_task detector ignores it, as it assumes such tasks can be terminated.
However, in this case, the kernel thread cannot be killed, meaning it
effectively becomes a hung task.

To address this issue, the hung_task detector should report the kthreads in
the TASK_WAKEKILL state.

Link: https://lore.kernel.org/linux-xfs/20230620002021.1038067-5-david@fromorbit.com/ [0]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 kernel/hung_task.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index c18717189f32..ed63fd84ce2e 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -220,8 +220,9 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 		 */
 		state = READ_ONCE(t->__state);
 		if ((state & TASK_UNINTERRUPTIBLE) &&
+		    (t->flags & PF_KTHREAD ||
 		    !(state & TASK_WAKEKILL) &&
-		    !(state & TASK_NOLOAD))
+		    !(state & TASK_NOLOAD)))
 			check_hung_task(t, timeout);
 	}
  unlock:
-- 
2.43.5

