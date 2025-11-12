Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840B2877F1
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762957220; cv=none; b=MZ92Bjy0qOA14n1Smj1y96b75o24KTviJ1Fjhbd94xnST4/SsMoowVlLFFNfFZ1UShWLSt2VUzaj2YkNZWvhorRAiy5grxQ4/LUXBkIIodBV/z2EKMICNRt8W+Obtw2fFCAx0YdiR7f+sIbZ1XCCv60JhFaR2dMHhM7eSG2Zpq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762957220; c=relaxed/simple;
	bh=PLEsEAFhjPh2pioJvZvoAHlFGMw3+0W/MvVkutfYANE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qxTRtSha1pkYhYvZwgxV0y/tIvn8WnQzY/J8awQw2XZnDNBZYkff6y79yQ5Ef5kkBkSgYKoWBd8o6LbPo1dBDCwJUQ9YgAe4rcYKFqn3fzjT6JHmBwup5Ee5TAA609JGHidrKm9LL9XYVStXadqAw0kc7UanAVw2a8V9pcQAHgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xmb+KeaI; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xmb+KeaI"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b22a30986fso87669585a.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 06:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762957216; x=1763562016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=23Yna8J3d3mh9gPmuO4K36N9DnURcSnrYweW3R/KSeg=;
        b=Xmb+KeaIata+2GuSfT5pWgt7616+mGmfA9/5lpVvqMk3jftOZ4BXDmisrbRVSY6ffy
         DGDauS0V6u8p0y7D4CBaSpRoNFPamiYDX9XmELpQJ/QDpsy0R+7LFgkVsPPO+mCk7m2c
         foldaqKnqI3ygbwTW7OByzQYQAk6WeI7Dm9AYYFE7hYpDxL1zw8q+E4LvLpp0s8Z5GhO
         zfclY68WLagXpChGp1mUwMgLvoJSV0O+erL4YL9yrqsosY2TwtcRdFYn4EZhv02n5Ivl
         mbYj+v/hEQ86ItA9lmyrtVDe3qyNbqYsYQE42C/oeS/BX5ziy3bDeZxMZ8sSNPTp077A
         jNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762957216; x=1763562016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23Yna8J3d3mh9gPmuO4K36N9DnURcSnrYweW3R/KSeg=;
        b=IcV8lPBo3e/Hs/HJat670Rlx8CWnG/aYD2pM99yCuvl5kecqkCrnTbkRNn8okaqgfj
         /MZQA8OTcstWGfFhpnZHvtoTdsBFECIU8jpz3OFtVlV7Ney1oDqjEH47vOLf3GFj/rx5
         2nahfmpuitpfEznh872UIdQdcJiBBs9GV3zeyU40dXvBJGT+Pho2XEXTF7wF3aLUkP+u
         5kCbJaMPjI0jz2H0DEptyqAg/oM2jN0znJwro6KwoiOkBQYR6sNOH8oEIrHSrA1kji3P
         9ZgurzZsjqGKgABOye6qtIiHHViJr2kVJ5AcMXKS78ejkBMj/zxvNz3rQsBPflqu8vPw
         wQaQ==
X-Gm-Message-State: AOJu0Yy2/B9ESg6xUlWAx7fw9E+m+v+xZ2hHIwAOYbKlxVC1lONqlp0q
	5nxuLBO/hJ38n6XYGEv2P/fXnYHSXTTWa/tcIn1k0elMEM4/5kThZUVs
X-Gm-Gg: ASbGncsTExsCIQ011fnEGwDEgaXiFKCMQGT8SvviHe0XoGDn+OLbPM7fVkN5jVHZrdF
	m27Ar3paveLnan4qPeXyrHDwP1YKaWh6yNlodJw1SgLDajRwq4t2FKpfNdHahYLmZwBiEMeX96b
	A0B5PdI8Pn1SW/XICsaixYnJqaWDqtArHk9caA6fs1+PTyu/2GlwfyY6bxwvo581Repi+OoJYeW
	2tYMOqDr7854kmrceThXlEhXD2cLDkLmwuOPm94QZsPJq+lJ1l70y4wyIF6Ke7b3k3+ARWtq4iM
	qmSAFVCioA6MB/JQeiH0L2d1fl7b1QO6y1gJEyFNaXJ3dBQAJt9MJUuYM/8IboAynaBDgiy/1N1
	8snYOXHz8h+LmY/82dEYtSydEkjOf6xgp1DlWcPclkVER1OYtrDmpVQAJ9lxUGRrrAUcOIxRlW3
	9NNXVyo99SRJbzj5RUdvKe
X-Google-Smtp-Source: AGHT+IE//gkdyNvrQQM5f0E3fJn6m5YN9A3KpABhw9zY72kYOdyBFwY0fArMYvrWnTVYGlxGj7DiIA==
X-Received: by 2002:a05:620a:458c:b0:8a1:87f8:6632 with SMTP id af79cd13be357-8b29b77a7fdmr423471885a.32.1762957216282;
        Wed, 12 Nov 2025 06:20:16 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29a84ae06sm202417785a.12.2025.11.12.06.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 06:20:15 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org,
	bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Subject: [PATCH] xfs: ensure log recovery buffer is resized to avoid OOB
Date: Wed, 12 Nov 2025 09:10:34 -0500
Message-ID: <20251112141032.2000891-3-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In xlog_do_recovery_pass(),
commit 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
added a fix to take the corrected h_size (from the xfsprogs bug
workaround) into consideration for the log recovery buffer calculation.
Without it, we would still allocate the buffer based on the incorrect
on-disk size.

However, in a scenario similar to 45cf976008dd, syzbot creates a fuzzed
record where xfs_has_logv2() but the xlog_rec_header h_version !=
XLOG_VERSION_2. Meaning, we skip the log recover buffer calculation
fix and allocate the buffer based on the incorrect on-disk size. Hence,
a KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by removing the check for xlog_rec_header h_version, since the code
is already within the if(xfs_has_logv2) path. The CRC checksum will
reject the bad record anyway, this fix is to ensure we can read the
entire buffer without an OOB.

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
---

Can xfs_has_logv2() and xlog_rec_header h_version ever disagree?

From my understanding, whenever the h_version is set (e.g. in
xlog_add_record()), it is set to 2 when xfs_has_logv2(), and 1
otherwise.

 fs/xfs/xfs_log_recover.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..08d7b25c4ab1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3064,8 +3064,7 @@ xlog_do_recovery_pass(
 		 * still allocate the buffer based on the incorrect on-disk
 		 * size.
 		 */
-		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
-		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+		if (h_size > XLOG_HEADER_CYCLE_SIZE) {
 			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
 			if (hblks > 1) {
 				kvfree(hbp);
-- 
2.43.0

