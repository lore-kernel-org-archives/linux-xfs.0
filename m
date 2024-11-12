Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5F1292CE
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 22:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449970; cv=none; b=NCY0xu4vTEpjqVaVsNlXg0+UWAeZEE0TTSdAA6iKf+2C4TbAFaoASu0gOcKYA9PiEuSaN8LTtKFdqbpNArWJPbwWr8k6zWh0cEflxdpSc4P8qhwTMc38fS4UnK1BrLRpOlHnmYSbaXPx1gfMqdOV45wWVCmF23KsyVNHu1nZU7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449970; c=relaxed/simple;
	bh=UahsPdezhKfe1FeRYKBw9nkhAEVrxSDhaIHvglDUEuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgcbTmpQQYCLZRuLg/1CbY8tbAAHgLMWJ6QOK0AcMkvXD7gVkhYDeC8CvlS5/PXRGdo+O6VtciiYVZX2ehvn4YZKWXyGO+aRwhUqT+26kakb0X2wH4UYmk3LxKaWpnjs4sE6CAqKX7Ep1mhZ2ZHbZxk0sZYsC47ztk9S/j7MtZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kfdcOoXE; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kfdcOoXE"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-720be27db74so89007b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731449965; x=1732054765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLQEA5U2rjQCoFu4hmUmY2uxE5Fxmi3WuoV1ejBhXa8=;
        b=kfdcOoXEDST5fJsd9oPYaF3hFVxVEu9lXriR+sJbINVBYhwF4NDhJC3WY5ZyRsyOOP
         lIhP6X7tAbvhfb6AtQYGC+uQNJTnsi7Kgg2XpMDkRplwtzGPV/MUzjKv/GKCQokQtjk4
         Ub9+Lzsc4J4HNYZuwLABvS2FJF0f8mCYAY3K+dtap0BoLgwpMzphvzLwnzzgefSD2a+V
         OKwDsqvxKNe3gzVmqkFEwcLmVd5H8jaMlGiheqcAoxdtdgWKKuWnUfPvNCw1HTO4m13f
         oSxSV5tAfSmZwJgcW1b/Q3dRmvbAx/Xs/kxQ39iJneKwooU3T84Cmm3bDELDu3ULlNFi
         lwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731449965; x=1732054765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLQEA5U2rjQCoFu4hmUmY2uxE5Fxmi3WuoV1ejBhXa8=;
        b=SXQjT9PIc4WlaryWi5Iy4LVAHmZmIbeNMPc/eCg+xXZ04pw4s3Ix8xXt43Qja+9dFK
         Vr958grSxF3TA6RKRwjv286j/rQ/0gbxfcJ08sxEpSW4QMbKPqBR4cxxJ1ZfqiZZHS39
         O0NZREYQ/hsVgAwgZYTDLLs4B4i3JoFH/xqR7DnBdS5fct8Crz+NoCYiE+p8kS1nN8e5
         E6v0+nA8QV83dgTRjkwPg6tWk8aXz5FcXKHjmx+fpM7ZNh2R+MhpBdy0kRY15IIyPMBc
         jpS6HRGCEJBhs5GZ2oN8yDb8Ohqr67EpRp271hS6t9HMRrI7oAPL1hXcTMW5MiGlDPY0
         H8Yg==
X-Gm-Message-State: AOJu0YzE9ob9M2+FiBK3cvjXiJBwiW3FG8R9YVyMC/SGWeOXaMp2fjJZ
	I7I6+hx38IBPOoqA6zTdxwqKkCvr4LavrMshHE7kbt8lFpZE+snfeVDoHU+btVbSluBEjlN3XK2
	9
X-Google-Smtp-Source: AGHT+IGxL1cQaPbiFcFVXjYr/PEXFHJt2qgqsMSy6YXL5rnWxAhTn+LmG95UCuNNR/fMXSAGbMBD6w==
X-Received: by 2002:a05:6a00:22ce:b0:71e:76dc:10f7 with SMTP id d2e1a72fcca58-72413f7c7c3mr27948697b3a.4.1731449965053;
        Tue, 12 Nov 2024 14:19:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72407a571a8sm11732967b3a.195.2024.11.12.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 14:19:24 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1tAzEH-00Doot-0h;
	Wed, 13 Nov 2024 09:19:21 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1tAzEH-00000004e82-2os8;
	Wed, 13 Nov 2024 09:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 2/3] xfs: delalloc and quota softlimit timers are incoherent
Date: Wed, 13 Nov 2024 09:05:15 +1100
Message-ID: <20241112221920.1105007-3-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112221920.1105007-1-david@fromorbit.com>
References: <20241112221920.1105007-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Supriya Wickrematillake <sup@sgi.com>

I've been seeing this failure on during xfs/050 recently:

 XFS: Assertion failed: dst->d_spc_timer != 0, file: fs/xfs/xfs_qm_syscalls.c, line: 435
....
 Call Trace:
  <TASK>
  xfs_qm_scall_getquota_fill_qc+0x2a2/0x2b0
  xfs_qm_scall_getquota_next+0x69/0xa0
  xfs_fs_get_nextdqblk+0x62/0xf0
  quota_getnextxquota+0xbf/0x320
  do_quotactl+0x1a1/0x410
  __se_sys_quotactl+0x126/0x310
  __x64_sys_quotactl+0x21/0x30
  x64_sys_call+0x2819/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

It turns out that the _qmount call has silently been failing to
unmount and mount the filesystem, so when the softlimit is pushed
past with a buffered write, it is not getting synced to disk before
the next quota report is being run.

Hence when the quota report runs, we have 300 blocks of delalloc
data on an inode, with a soft limit of 200 blocks. XFS dquots
account delalloc reservations as used space, hence the dquot is over
the soft limit.

However, we don't update the soft limit timers until we do a
transactional update of the dquot. That is, the dquot sits over the
soft limit without a softlimit timer being started until writeback
occurs and the allocation modifies the dquot and we call
xfs_qm_adjust_dqtimers() from xfs_trans_apply_dquot_deltas() in
xfs_trans_commit() context.

This isn't really a problem, except for this debug code in
xfs_qm_scall_getquota_fill_qc():

#ifdef DEBUG
        if (xfs_dquot_is_enforced(dqp) && dqp->q_id != 0) {
                if ((dst->d_space > dst->d_spc_softlimit) &&
                    (dst->d_spc_softlimit > 0)) {
                        ASSERT(dst->d_spc_timer != 0);
                }
....

It asserts taht if the used block count is over the soft limit,
it *must* have a soft limit timer running. This is clearly not
the case, because we haven't committed the delalloc space to disk
yet. Hence the soft limit is only exceeded temporarily in memory
(which isn't an issue) and we start the timer the moment we exceed
the soft limit in journalled metadata.

This debug was introduced in:

commit 0d5ad8383061fbc0a9804fbb98218750000fe032
Author: Supriya Wickrematillake <sup@sgi.com>
Date:   Wed May 15 22:44:44 1996 +0000

    initial checkin
    quotactl syscall functions.

The very first quota support commit back in 1996. This is zero-day
debug for Irix and, as it turns out, a zero-day bug in the debug
code because the delalloc code on Irix didn't update the softlimit
timers, either.

IOWs, this issue has been in the code for 28 years.

We obviously don't care if soft limit timers are a bit rubbery when
we have delalloc reservations in memory. Production systems running
quota reports have been exposed to this situation for 28 years and
nobody has noticed it, so the debug code is essentially worthless at
this point in time.

We also have the on-disk dquot verifiers checking that the soft
limit timer is running whenever the dquot is over the soft limit
before we write it to disk and after we read it from disk. These
aren't firing, so it is clear the issue is purely a temporary
in-memory incoherency that I never would have noticed had the test
not silently failed to unmount the filesystem.

Hence I'm simply going to trash this runtime debug because it isn't
useful in the slightest for catching quota bugs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 4eda50ae2d1c..0c78f30fa4a3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -427,19 +427,6 @@ xfs_qm_scall_getquota_fill_qc(
 		dst->d_ino_timer = 0;
 		dst->d_rt_spc_timer = 0;
 	}
-
-#ifdef DEBUG
-	if (xfs_dquot_is_enforced(dqp) && dqp->q_id != 0) {
-		if ((dst->d_space > dst->d_spc_softlimit) &&
-		    (dst->d_spc_softlimit > 0)) {
-			ASSERT(dst->d_spc_timer != 0);
-		}
-		if ((dst->d_ino_count > dqp->q_ino.softlimit) &&
-		    (dqp->q_ino.softlimit > 0)) {
-			ASSERT(dst->d_ino_timer != 0);
-		}
-	}
-#endif
 }
 
 /* Return the quota information for the dquot matching id. */
-- 
2.45.2

