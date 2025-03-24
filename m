Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BD32620C9
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742840490; cv=none; b=fMKGiCtXT6zxteU6fRJY5Ya9gw+Y15fy3H/l+ifE+YkPYG/rAl2WbXZULMlBmzfuC1Fzv7T7DhKQCYIQ2gS3tg1eJF+Ar+F9EjBCnoFSq/nXQbCjLQnwSlhr3laUpUuac6GoP6Yw8/bx/hKsGovxp896+0Qxb2Sojaez3zJvRus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742840490; c=relaxed/simple;
	bh=WaumVtaHSvXq01xEN1qoS679vUs5/q3b9y5l+SrYX0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bm2/4c44cSD/rMOY0sRL2o0LXonJC67RDrlYOXo6saxWw9IL7PMaePmIEXX8oDDGbtQXLz/KO0ZGKLNNXtGGLScIFkhWznozzuFRvam7LzbXx6vEFVnH/MuoD7Z+JA1tqPrgJiE001RJ4BvAVWz4Qwqfb90SVe3hlKRVpnLQ8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iRa0n12C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRa0n12C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742840488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l1rEAa+tT/wRzdsIz23KpFHx0F1q62IAClS/KkTrISs=;
	b=iRa0n12ChnbT8b/Ft4n7t2+CEsBB8XeNlYq1bLuiMkEiAZFnera5kOp0l9doevyz1LHCWo
	9rg9F0XW98zKe6fyzw+K1LaHxdqv1vlt0LcljtLLlXaBZwF389xTqrMrg4ljYpiGEcbTST
	choY+81mHWSoWqnLEBImXZOHTzCKgfM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-y4J8mpaXOmmETLFr6C4i1A-1; Mon, 24 Mar 2025 14:21:26 -0400
X-MC-Unique: y4J8mpaXOmmETLFr6C4i1A-1
X-Mimecast-MFC-AGG-ID: y4J8mpaXOmmETLFr6C4i1A_1742840486
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d5a9e7dd5aso12696805ab.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 11:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742840485; x=1743445285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1rEAa+tT/wRzdsIz23KpFHx0F1q62IAClS/KkTrISs=;
        b=hQLJqvYNvxJ6v1QSHatOrlvqUSKQq3u+7UXvxv6QZ4fh0NBmxJUg/QIaDsRj9a+8Cz
         L+9vW2Qc0RKVzANcLrQdrdAyAAcrPfINiT83zu8eCWwmGWIbIiXtFdwiaeimYgiGzbU5
         jAiDIkD1XIbEZV53mlVcy0VB88XxvVwrMJVuhRUT3WLIHq7AeQhr9PABiqTFfhWbbXDN
         /8szL3zB2V0CMMLJoPpCcu+oVCxdYvaCA9bkhy4jDemIchxtOHDGZDXPwC15xFAiolqV
         4Z8epQzqpCCKwYmI0TiWY8ZMckJSzxEz0s2TktrKC8ophEorqFa6CRNK0BMoyEzfdZzN
         wdLA==
X-Gm-Message-State: AOJu0YwEfeBIZQBR6S/H7Um1EjPtZwmDgxfSEiRomFgjBxxju07BG9hi
	O0MHENlBVlgKdX4kUHlcv77tT4uRJwiuH8d8SfKQzra0xRsApwA+3p3/g+RMG+Tm6OC1BHr0rYZ
	QCewt7jRFM1Tn9T7IaFMd3EildZbu5ajlGuhvTbmz/L/n/6N9aAuGGTHoDhsFfdX2kAT6u9rh5x
	yYTRb2vS7Ch0g00iRh1uebLy+qfmClG0bCacW3EciItA==
X-Gm-Gg: ASbGncsy3vijfe38WPRDTYDYrujryia5a+nRwCFn08ugeBIn+fYn7ZDM8YUnYbHhZuT
	FfVsFmEgQJvAut+rS6/c7Ml3aPx63LcRXgQ+XxXP8B0G3pdE582Lhi57aDUDVef2u5oUoLiytiE
	7s+Q9J0WxGnJeESmO6tbOR0HlBw2Zn3RCl6p5vCje9kcuVm/vU73HdOXTYD+cU1eU6n81c8pgkA
	jcS4LuqzIsqAVvP8nLgT6rdFHepyHod1qcS31it5jl+Uoxyv2MKJ7oCyv5Nozc0lwWRq8Mo/ODV
	aLZ6sW2W/1dRIyeaZDd6ft65DOKTSi/VfYobzVqBX9jRVrBg6ZEx8IxUng==
X-Received: by 2002:a05:6e02:12c4:b0:3d3:fa0a:7242 with SMTP id e9e14a558f8ab-3d5960f27eemr114131495ab.9.1742840485568;
        Mon, 24 Mar 2025 11:21:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw1WZDnx1DYGk2VJNxCvFDPew/ffoUrLIM04mhVSCFzei22R6u5YCBQmM7C2rLdXvL9zjbAg==
X-Received: by 2002:a05:6e02:12c4:b0:3d3:fa0a:7242 with SMTP id e9e14a558f8ab-3d5960f27eemr114131275ab.9.1742840485020;
        Mon, 24 Mar 2025 11:21:25 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbed2504sm1943153173.145.2025.03.24.11.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 11:21:24 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net,
	djwong@kernel.org,
	hch@infradead.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH] xfs_repair: fix link counts update following repair of a bad block
Date: Mon, 24 Mar 2025 13:20:45 -0500
Message-ID: <20250324182044.832214-2-bodonnel@redhat.com>
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
 repair/phase6.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 9cffbb1f4510..b0175326ea4a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2404,6 +2404,10 @@ longform_dir2_entry_check(
 
 		/* check v5 metadata */
 		if (xfs_has_crc(mp)) {
+			longform_dir2_entry_check_data(mp, ip, num_illegal,
+				need_dot,
+				irec, ino_offset, bp, hashtab,
+				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
@@ -2416,9 +2420,6 @@ longform_dir2_entry_check(
 			}
 		}
 
-		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-				irec, ino_offset, bp, hashtab,
-				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
 		if (fmt == XFS_DIR2_FMT_BLOCK)
 			break;
 
-- 
2.49.0

