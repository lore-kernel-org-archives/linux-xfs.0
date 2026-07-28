Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDCE14BF92
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 02:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205399; cv=none; b=Vm9yxdKHdqZviIlHddf//yzFX3lmYvdQjZbLwnls31UKdpIavVEmZyEkyZCCrc7h0dKQFioJsP2sw1NFhlCqfRXHr+vQZ45LU5umP5U/TsvaXIV8O6Johz3XHGuVyRi0RMdffd6kARkqvL2gPBw2u5LNjmaR9p0ATzNCHxhvSMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205399; c=relaxed/simple;
	bh=4+PNToQ0P1ufcozGR2WIvvV9Qbs36GVV+YUjtcQ1E0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FntK2JA+tg7kjsNfcYaM1uECIpjJ7AuiXDk2ukmhOrqsBdqJvwdX2Lv1E724RbOQ1vQpt+X2gJ6N+EcAZTY9N4dk4KKYu0GH8ichENG1/5Dg/VLPf6Wcv8PPCrbKyqTbsbhBG5ys/+9dcnVBzvb67nNpJKlASeJAIOj28tS5+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lgoGUdOs; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgoGUdOs"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso2673464a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 19:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785205398; x=1785810198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cbQyvDgv29JlNpT12GPIHTmAjrSEhbRccdxDK/svQ+g=;
        b=lgoGUdOsJsZjmcx33OxhFKUprkClNOd0eqUjV5G7dyIZI1gTNuxauC8Pn7nfTddrJJ
         kgZx73xctLyT0m5+xYing7twZSDvFRTKEFRIGvSTnAnPUL6OIyBkXlZazTxSUUdURal/
         Yow9zHrYtzO+U648qOnScuGxBNe2Tks9zaGPtXMLCyVg5liOOnjhZO+x8sZ0k1uja63r
         SsIgimOEZHY9AgMIBG4LCeIqTt57a8D+h4YjWdlFl8G1sl+5mO/gwcMO6BRMT5Y384bT
         kPDQMhsUCJfIrIZyK2vl9yA5sYUJJIrQBGhtqIUXmZc9K/CC1Jzxh1401dsaHf8g1+Wr
         C4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785205398; x=1785810198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cbQyvDgv29JlNpT12GPIHTmAjrSEhbRccdxDK/svQ+g=;
        b=U6TZH0buak9QzyJ68eZ+pJiQnK8u3cJ0Xm0avayvsP/x50P2RZLKFM5GeCAu7q5pBO
         3kBdMo0ysVltk9nYi6P8S/wojKU0fV3r+aGOWA/XElglf/brz3sA3KkRnIIbY1T0GVLq
         XDeI6k2qwdGj8f1hg4KhS3gZN+zC9Yk7mDLsFe2ILf/1LukKSoTpLItRYo0TmorLJfGZ
         W0ZznKOsnuODTbzKOGddr12rvXPMidLMnbMoPYNheaMioVNAip8OcaOjKstaWVz86Y1F
         8AlDoXKf6RaFYxIs47BQzTRNu9WYg5TRk5oAq8p/6d3h7bV1Vr+3PnTD5DzwEkpgxP1U
         q6jQ==
X-Forwarded-Encrypted: i=1; AHgh+RoVlIl3Z0LoQ2sWKmSQ8vwX4OagmN6680eYADFqemC7e24EIGD7LjfHbOx28Tw6YbtWeG0QMpxqtMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhO4/yfbqxUSedL/i6EWHcE/OtpOakuPGXTRzIswjgNiYu4cHe
	0WyVqlWmktxbRnUrkw6SjEvlnbQ2H83heoe/nFvUZLitBh7aoj9fZVU9
X-Gm-Gg: AR+sD12s8ip58ixCyRzaCfnEJmzOnyizCR7/WCg+Vb7YBVr5n//qIbcfZGUArzC5HWF
	2mxH6kttAVV3rhC/Ukd2Kazl7SQlg6FSTPEzKgzqbnfCsgdYsXM2P/nLVNHhRsaGyQwHdniqhHn
	jqhc+I3vmezfM7ZVxUyMoERqQrujF2E4SJ9xvyaLCZb+z3WPDneItmKMBDNmAATQXPPoYWa2GMs
	f29pWGuFmgPcUdBbEBBhvG40XImurcApsVwPmXgaF2CteE43XLgaVFl+ym4cHj+S9fJ2sfAsf6a
	y75ik6HLiwb3vZESaJ5j8OPjmlL610IIUDyYNaS34AdMMABmlytsu1Ay67C3F3GJOSRQKBeHRxz
	oLnQAA5OS1qWLVZwiePf1bN4VEEIf7r3uaTvVnNJhU8AwQQdAf/L7RCOoJcTXiFaIvb58Gwhvko
	NDyy8SuHZbqcq2EPI6iDAAFPq13Uh+Vhx3knK56MnM1bfiUdQLmpvd/o0=
X-Received: by 2002:a17:90b:3e4c:b0:36a:8240:2477 with SMTP id 98e67ed59e1d1-38f6a4763admr429909a91.19.1785205397711;
        Mon, 27 Jul 2026 19:23:17 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6412a118sm543437a91.8.2026.07.27.19.23.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Jul 2026 19:23:17 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org,
	djwong@kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH v2] xfs: fix exchange-range reflink flag clearing issue with  INO1_WRITTEN
Date: Tue, 28 Jul 2026 10:23:03 +0800
Message-ID: <20260728022310.99955-1-jiapenglin@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Cc: <stable@vger.kernel.org> # v6.10
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index dcd0bd0b13b4..3efed37cb98a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -959,6 +959,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	if (hweight32(reflink_state) != 1)
 		return false;
 	if (req->startoff1 != 0 || req->startoff2 != 0)
-- 
2.50.1 (Apple Git-155)

