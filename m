Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4FF173
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 01:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709687572; cv=none; b=dSYX9K5c9bhJS3RBFBMIPqL2pb8C6OBmjQj2x5h01U+WPoqApQTFxIbZZBws3+Wy9HRi40afz3puQAQdW2z9eYLy5/d6wLpe/0p7x3hlkXd4loth5qruJvSxrPsl2r2FaysH8liUSCS8hLWo4uwY9QrQnj61Mm/rvz/Y/QWjOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709687572; c=relaxed/simple;
	bh=VF0Ca8MKuASUTnNEdDN53Nle6v+I+ySKgQnOX/waSyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T9jbO/+zv/bP83WTMTPK7Dl1KzorMXK3CCe/XipdmWC1CRbyQ6Bm00KSXyNHPRN/TrleuR6DpyBS0uQb8T2UY/lxcuzkQvIPEvURvr7PKdlo96mNtsLdilmMOSbX3mmzUu+XglvXxCc6tgotWnUzoW5kIGj8Vb4NGx/6iyCn3q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EWrUog6M; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EWrUog6M"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5d8b276979aso4610219a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Mar 2024 17:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709687570; x=1710292370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+OK2SHEYpGCrPC0wLDxizUQGKAxaucke12EcNwuAgxI=;
        b=EWrUog6MVqktjLyclOtB+E1GG4v6MeNCOVX7ZPmGLptXB1ckMjigjECXOwiqXIE6/Q
         u4q0e3ttjYiwqJtjTxVBJ9QNLYJ++NSnqWRCSmsjIZnvqDFa4NO2oI9RN6HD4UjbqPwB
         SakXUmbgJexRYhAwm1wQDVDugso/QP7UeXGsiKjZ6BhXJGRLOXEbyp8eW9sMnPZdSHl0
         S6DtYi4RHpuJtnoJEcHEr4Tqh9vb/qAQ/3jYDyYtwNgjkuNjkhelvIxjxzsZTtg57u71
         aaC129R0DUdXqJ2P0kJr4wdRCPA67g93uSsJxHq/qaLzViCIqUzwQs+dy5Ifj7N5nxPE
         U4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709687570; x=1710292370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+OK2SHEYpGCrPC0wLDxizUQGKAxaucke12EcNwuAgxI=;
        b=hBH1dEXkkFS2gdFDE+RYn75znC0yAqCKGzGE8cmHg0c1hOL2ok+0lGOLwyNPHlFqsg
         PteRkSR92v2PHYPsSOCcaOIxx/iyYgGmuxDIm35OVsIOZH6gS1aYVx6IZClMZtDJghsF
         LUJhbhpXeKmBFIMMxQD0AQWdxhD2P0vXM64lPpUGqXrU4kyEHvvpbL8HlKCgEzD0bI/Q
         wg+VY5PVzVar3BL+Ysf4KcQL9TPeAEBvwxJvolWZ9AwYjnd0KrOpxG4PPC33cvOxnbOa
         52VCw9KlKZWUOEuqjinq/xqq6sACn790vyjVax8fooRJbKjkIp78d1Vl+n4Z6hw1Kt/4
         oQcw==
X-Gm-Message-State: AOJu0YykcNg+ng/h87v0hRRUXSWoXatkp/6VfjhCTtb1o0AY9DAEVgur
	tUg7NFsifkiB3B5X0YWTF6FziFZfmercQtjZ/a/sPtxJyNrmn9f9HGTrrkP29rh8w2Vdq7fatnG
	m
X-Google-Smtp-Source: AGHT+IFiel+ngwXJIQVw9vFcGb3CSnXlB7qJFqnnBNg+mg5SncE4223N214+fm5xCxrpNDMyv7absg==
X-Received: by 2002:a05:6a20:d395:b0:1a0:708a:4f6e with SMTP id iq21-20020a056a20d39500b001a0708a4f6emr3820278pzb.41.1709687569717;
        Tue, 05 Mar 2024 17:12:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id gk4-20020a17090b118400b0029b5f69830dsm2401606pjb.22.2024.03.05.17.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 17:12:49 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rhfpv-00FaiI-1Z;
	Wed, 06 Mar 2024 12:12:47 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rhfpu-00000006qXH-41Of;
	Wed, 06 Mar 2024 12:12:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH] xfs: shrink failure needs to hold AGI buffer
Date: Wed,  6 Mar 2024 12:12:46 +1100
Message-ID: <20240306011246.1631906-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
testing. The cause of the problem was the task running xfs_growfs
to shrink the filesystem. A failure occurred trying to remove the
free space from the btrees that the shrink would make disappear,
and that meant it ran the error handling for a partial failure.

This error path involves restoring the per-ag block reservations,
and that requires calculating the amount of space needed to be
reserved for the free inode btree. The growfs operation hung here:

[18679.536829]  down+0x71/0xa0
[18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
[18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
[18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
[18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]

trying to get the AGI lock. The AGI lock was held by a fstress task
trying to do an inode allocation, and it was waiting on the AGF
lock to allocate a new inode chunk on disk. Hence deadlock.

The fix for this is for the growfs code to hold the AGI over the
transaction roll it does in the error path. It already holds the AGF
locked across this, and that is what causes the lock order inversion
in the xfs_ag_resv_init() call.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index d728709054b2..dc1873f76bff 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -975,14 +975,23 @@ xfs_ag_shrink_space(
 
 	if (error) {
 		/*
-		 * if extent allocation fails, need to roll the transaction to
+		 * If extent allocation fails, need to roll the transaction to
 		 * ensure that the AGFL fixup has been committed anyway.
+		 *
+		 * We need to hold the AGF across the roll to ensure nothing can
+		 * access the AG for allocation until the shrink is fully
+		 * cleaned up. And due to the resetting of the AG block
+		 * reservation space needing to lock the AGI, we also have to
+		 * hold that so we don't get AGI/AGF lock order inversions in
+		 * the error handling path.
 		 */
 		xfs_trans_bhold(*tpp, agfbp);
+		xfs_trans_bhold(*tpp, agibp);
 		err2 = xfs_trans_roll(tpp);
 		if (err2)
 			return err2;
 		xfs_trans_bjoin(*tpp, agfbp);
+		xfs_trans_bjoin(*tpp, agibp);
 		goto resv_init_out;
 	}
 
-- 
2.43.0

