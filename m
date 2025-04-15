Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570042DFA36
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744729324; cv=none; b=OTICJG7675Uk/CogZe1bOmR5ik6f2u6s6RxTIsedPZn3RfJh0owq2Ks+DRjieTPm4zC/oriT/4xzRkipCHSPmRftXs65Pc9Ccq1Y8Kwq9VO9L3h8wXW4rFCawXo1TohS4UZ1WlQ9yzzlu0oSa+t8HaB003Yzo34g7F1kJVyRGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744729324; c=relaxed/simple;
	bh=VjqyPY8whPGBCb9wQ04Jae9JgzVZLKUpnQoQVz00EZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TtVpoEJb2h6+bbblETQIZUwWbPS1G+FSzEgZrOV1EUGODLoFyHs7As6KS+AzwKoIu3rq+uStPU4VY+kjCr5Aikq4OpUECrfkn7iMOLEtL3oLRSU89Tc1/rkTB9yAsv6xZlxsg595bS7h0iuc+NnRWCwsFF5jX1+vYy7+1jZc0cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BtkVYyay; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtkVYyay"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744729321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oyMXW36hck8BlguZdqG4Q3/NYBTrzxevsxkVebqb+1Y=;
	b=BtkVYyaynX3RDorBW7wnorXiL1f+DGguegSDT4m1kvqdlfG0ZIWyL9H4WwLClW/bS6AWW9
	0e40FhV+gLQ+M2xTWuvCqeqtKL00T5bsuylPHcMUqd91vH4utqM4SXbG/WzRjqNW8siZAb
	Hzv61M2FoOYHvrS/FsZiaOu4VIt+TkA=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-GTslOKhKO5Kp8Raeao9Qyg-1; Tue, 15 Apr 2025 11:02:00 -0400
X-MC-Unique: GTslOKhKO5Kp8Raeao9Qyg-1
X-Mimecast-MFC-AGG-ID: GTslOKhKO5Kp8Raeao9Qyg_1744729319
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d6e10f4b85so100052835ab.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 08:02:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744729319; x=1745334119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oyMXW36hck8BlguZdqG4Q3/NYBTrzxevsxkVebqb+1Y=;
        b=JhET4/rhqONVzFCE7m3mZist5hjAGpcwdt/swcrhgfn7mYXtn36kvu+eJaYQbC2uoR
         k9unfIR/xe8Nyy/uBinl543wtVlwYhvVFJnc78oCyJg00GkaYipAfHyI96GYPKUjajZg
         Tsztt9D0RMg9tncfnIxUIC8Fy3YJudLX8nw5H1GW6P6bS8lGoucGF72mzU4UHkXXKWX1
         V25BaFvtpEuGCTDjWmzcYN6umIo4KXLvA2n7TXMuxiwc3fc+/8viTdd18nFYQM9rTcLy
         bUvblKGOPC4CfgNGX0hImVAIp9jMvn7bFvopnGanBry9Zlt+VtPfNVvAFn4ry43gVAQj
         jTQw==
X-Gm-Message-State: AOJu0YyxlkCM5E69+E1uEBcLs3CTIFa37KPKOzraQpeXfGrnTkeY9Rl7
	Op0spS6xS/xgmmEKV2fdBlDnpM/6CFprtQD1oPNamdFfHjDyKCoYhH4FsMpZAHDwFsP35j90beM
	frUXI0O3aghhPpEskM2pGxdoHP/vhLBLUsWEZmhTAwObOModYs4hevVGphmxG3tTCC0rxJ7/PGM
	wYH5WG02USuXS9A0lvemU7eMm1+hG0HfoNV2Uq9m31JA==
X-Gm-Gg: ASbGncsO6dTK1myO1XXNxvn38sy3ZBM7nDBSej1yT1PQUXHZrUK7u9X4cz09bQa/47Q
	sbVlg8gKDN19r6vd50GjOOBWd+O4+V315L/Lhvho3PbijzbcePvLE1yxlMjy+k7pPzUyuGsBmo1
	nKDN6HoHCg2/ZDU4+1bEdDSe8kqFJqsWs5iEw52UkoCrFIUN4eaCH6wHAF4VETabPz6q6ZBPPi9
	R4r5Mif0cqaqRRHj0VWYjakZhvVkQFalNNdP4uYTMIrPJOuPSRCN94lxWTT7Ha1eHvjvVUIfbMs
	FpsvMLxe539y84CxJhaF7fQz1bYzAQcsnzLUHbaZZ0q+A2XURXLTMw==
X-Received: by 2002:a05:6e02:349c:b0:3d4:3db1:77ae with SMTP id e9e14a558f8ab-3d7ec26b69fmr205251075ab.18.1744729318877;
        Tue, 15 Apr 2025 08:01:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKz8Lvtihth4KakxDzKIT1HCi+A9si7TY9vuCFYDdbv/T/ksUrZjTTJ9RARq0KwMyFOmCTvQ==
X-Received: by 2002:a05:6e02:349c:b0:3d4:3db1:77ae with SMTP id e9e14a558f8ab-3d7ec26b69fmr205250645ab.18.1744729318430;
        Tue, 15 Apr 2025 08:01:58 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505d161e8sm3205884173.30.2025.04.15.08.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 08:01:57 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net,
	djwong@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2] xfs_repair: fix link counts update following repair of a bad block
Date: Tue, 15 Apr 2025 10:01:04 -0500
Message-ID: <20250415150103.63316-2-bodonnel@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill O'Donnell <bodonnel@redhat.com>

Updating nlinks, following repair of a bad block needs a bit of work.
In unique cases, 2 runs of xfs_repair is needed to adjust the count to
the proper value. This patch modifies location of longform_dir2_entry_check,
moving longform_dir2_entry_check_data to run after the check_dir3_header
error check. This results in the hashtab to be correctly filled and those
entries don't end up in lost+found, and nlinks is properly adjusted on the
first xfs_repair pass.

Suggested-by: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
v2: add logic to cover shortform directory.


 repair/phase6.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index dbc090a54139..8fc1c3896d2b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2426,6 +2426,23 @@ longform_dir2_entry_check(
 
 		/* check v5 metadata */
 		if (xfs_has_crc(mp)) {
+			longform_dir2_entry_check_data(mp, ip, num_illegal,
+				need_dot,
+				irec, ino_offset, bp, hashtab,
+				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
+			error = check_dir3_header(mp, bp, ino);
+			if (error) {
+				fixit++;
+				if (fmt == XFS_DIR2_FMT_BLOCK)
+					goto out_fix;
+
+				libxfs_buf_relse(bp);
+				bp = NULL;
+				continue;
+			}
+		}
+		else {
+			/* No crc. Directory appears to be shortform. */
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
@@ -2438,9 +2455,6 @@ longform_dir2_entry_check(
 			}
 		}
 
-		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-				irec, ino_offset, bp, hashtab,
-				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
 		if (fmt == XFS_DIR2_FMT_BLOCK)
 			break;
 
-- 
2.49.0

