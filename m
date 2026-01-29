Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4BB30C378
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712893; cv=none; b=hIQU5+awcpHmzozFkJs0V5fEhW35+ioyvk3a0DW0MYIz6C4wy54giGAEaoDy4yl9Uw8c3hZFcT7xAFeYoYpufkvhcBzHsOENM0OGjh8XnPcX5qmtNqNNwT1SD5LA+qrFbPxfBy7p61bjdrQ3uB/MPLskO+Dh/luC5hqq9q9mUz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712893; c=relaxed/simple;
	bh=Aw2wHVrexoVZGyhk0clT+2VM4+EmOe0HDf/6rdCKoyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TviaeObPvkal1axeG9/6sKAARFSG/KoUxmzlGQzCd8NUwrAxPX7EbE5BydxfHuVBBQweIOglfeeQnAD61oQ1E7DW86un/1eVou2QhD3uUEnMHSKlb7uc4en3do0P/G8fsEAsIgOfsm9EzzXzqYSIOVY1/yFuHv6jINR6z8b9rlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDAeG+N2; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDAeG+N2"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5013d163e2fso14567891cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 10:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769712889; x=1770317689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CTj4HpTxAxVEHWIobCBR+N5vCDEK+9mJIye5sdZ5jcc=;
        b=UDAeG+N24OlON+D/eOO2AEu2She99jjb4a/w2AZTHCiH6JyndieJuuRk6yLPxU4WNP
         dLVPm7iHO1MFWLWPssuhIC9AbUn3NaHE646tQQP6siWiQx7Zd8aGdFr+LB9SwC541dqq
         ZRz7RwGYKqGzF82Vj6UAYdS48kDxcTwy8sAepwsg9qHz5tPp1xrob50TiedOpCVmB3ev
         jhKkHXu3NcmK8IiaKNyWuCX+cTm6/F0r5LPIqa/ZaSOcmQu960LVcggSbE3JN6DCMXdv
         RviN4rBWS39LaiaPJj/hsfHIDV2POncJxsVqRNVfsbMtsh1HX/L6m2NbYIgEHf9fQksM
         2Jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769712889; x=1770317689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTj4HpTxAxVEHWIobCBR+N5vCDEK+9mJIye5sdZ5jcc=;
        b=JYtYcjvcNJ1CjsdhoL9OjAx/dtZUkHxFG0AIJpmgeiQ7mRIZv0LMp1CF6uhjBAnNCF
         l/JO0p6ibSgqf7zdx3e3J4UVW6xYnAuBhPijOuQoM60cYgvjZOKb9v3cCg5i09GzoJey
         vQ4BSxlwBtRIoudjW8KsMqxF952ck2bK4ADh83Isg5wS3V1k1HsIJStMLIBzBLIjCxWR
         wH/agecF1xakkcUyn3GnqAgH9zKmUvKkeYzWYq9ooY6iJdqFWsCY+qLxujLmH6MIb0Ej
         24PLYkqCl+mVimVheh13ta+os7LZVMO4GUzFGx2Oyd4x33FbYyBJCT37vwKFwPIV//pj
         m+Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWtPyhL/dAk/U/V28PyCUjMDmAJ2JwQKNUrochx3N1zMBeZ0YNUFVuHDkn2GKyI4p6qEEdD50vLJEE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5je4nje21OKAMw4zYZUNGZkNNjucuylAB4SFZrTSDzCdXMAZq
	hoEJom8ISrnfC1mpcyP/+AnX+73OOPX4jzMDAsJ2/gLR2oV86W5M0kEz
X-Gm-Gg: AZuq6aLyU9CcaC+ueO4R6L2VN33pEwSL6Nmu6YqU7WFK/WpPNTw9YYJic++yk8gcN/o
	dXgXHb60DYP5//zUQdalzURYB6zLUES9bbwUHjSqT3/rvRIlrOClJxywqNOh+crBcV1SvAKI+Ya
	7kkQUJJEDVvTf2DKZ2r1U9J+T1+4bVp8SCzCmM0g66Ly6qED4/VSXkDT/0c3qjzUFBw+YgmwRok
	wzOXZAqiwxG5B5yVcpMmiKdxdmsCLbP1XMXp9gLHzJy3r7V7+ThtQogrlkW/P4A2jU1xpDXMy3y
	FZtVkXx1UKC97L8OAJBWmC9+dSirwodiueFetQ86y8/t6n/hV99quimKPUr68luC6TjVdTHTyOy
	F5OEutbjHd0Hn204Wza9V7kvp9DD6e7Klwqp5Dz8z5UsmOaDvQVEkZgeo7s3L1I+P2PwfR8g+LY
	6PpbErbjhZ/1jt/o6Q7Dlv1z7R/Xbo+jY=
X-Received: by 2002:a05:622a:11cd:b0:501:52c9:f19e with SMTP id d75a77b69052e-505d22751c1mr5050921cf.41.1769712889125;
        Thu, 29 Jan 2026 10:54:49 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d375eb4dsm43363356d6.46.2026.01.29.10.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 10:54:48 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org
Cc: chandanbabu@kernel.org,
	djwong@kernel.org,
	bfoster@redhat.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6] xfs: validate log record version against superblock log version
Date: Thu, 29 Jan 2026 13:50:21 -0500
Message-ID: <20260129185020.679674-2-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot creates a fuzzed record where xfs_has_logv2() but the
xlog_rec_header h_version != XLOG_VERSION_2. This causes a
KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by adding a check to xlog_valid_rec_header() to abort journal
recovery if the xlog_rec_header h_version does not match the super
block log version.

A file system with a version 2 log will only ever set
XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
there is any mismatch, either the journal or the superblock has been
corrupted and therefore we abort processing with a -EFSCORRUPTED error
immediately.

Also, refactor the structure of the validity checks for better
readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
the condition that failed, the file and line number it is
located at, then dumps the stack. This gives us everything we need
to know about the failure if we do a single validity check per
XFS_IS_CORRUPT().

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changelog
v1 -> v2: 
- reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
v2 -> v3: 
- abort journal recovery if the xlog_rec_header h_version does not 
match the super block log version
v3 -> v4: 
- refactor for readability
v4 -> v5:
- stop pretending h_version is a bitmap, remove check using
XLOG_VERSION_OKBITS
v5 -> v6:
- added Reviewed-by tags

It seems that this patch has fallen through the cracks, so I have
resend'd with the Reviewed-by tags.
Link to original thread:
https://lore.kernel.org/all/20251112141032.2000891-3-rpthibeault@gmail.com/

 fs/xfs/xfs_log_recover.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 03e42c7dab56..e9a3e21af34a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2953,18 +2953,23 @@ xlog_valid_rec_header(
 	xfs_daddr_t		blkno,
 	int			bufsize)
 {
+	struct xfs_mount	*mp = log->l_mp;
+	u32			h_version = be32_to_cpu(rhead->h_version);
 	int			hlen;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
+	if (XFS_IS_CORRUPT(mp,
 			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
 		return -EFSCORRUPTED;
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   (!rhead->h_version ||
-			   (be32_to_cpu(rhead->h_version) &
-			    (~XLOG_VERSION_OKBITS))))) {
-		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
-			__func__, be32_to_cpu(rhead->h_version));
-		return -EFSCORRUPTED;
+
+	/*
+	 * The log version must match the superblock
+	 */
+	if (xfs_has_logv2(mp)) {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
+			return -EFSCORRUPTED;
+	} else {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
+			return -EFSCORRUPTED;
 	}
 
 	/*
@@ -2972,12 +2977,12 @@ xlog_valid_rec_header(
 	 * and h_len must not be greater than LR buffer size.
 	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
+	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
 		return -EFSCORRUPTED;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   blkno > log->l_logBBsize || blkno > INT_MAX))
+	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
+
 	return 0;
 }
 
-- 
2.43.0

