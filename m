Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBA73DD847
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281573; cv=none; b=cqIc8/nEteAdUIhAkheI59D9okx7AllY3KqhMG2nSrvQwMS4TvVUagX4Xdk16sFgHyDhNl1aRvDOBLeidQRPWr0mmPLyE65fSsZcQnssKuTjrkvtQR7MHpASVBqM87ijL0NjUa8H9mWLyoqddigvRSsTf0hlM1tIFnXSc8WSl4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281573; c=relaxed/simple;
	bh=YTqApCUQINxvm0m2TAmIipS0Yh1sBFMOGSNZbk63np4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aICTnN6/LU/SZ0AIuc2x/RqcZmpIL6jFk5sCEfZECp5q32cexA8e/BZNFms5WzCfL2N4KD2vj56pAzfzs9M36+mTguiNL7plGHZwDwpAarXVKYdEoC+ea0h5DSBGPFYYWYOFR0QGq7PCaJnqEDp3cbpIuWWpGxPC1YuI2jxjZ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvcavEB6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvcavEB6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so5900645e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2026 03:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791281570; x=1791886370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i2wau8FdTTNEOYjhhKWh1ewIyMk2T5QlJDbdCDrZN8g=;
        b=IvcavEB6vvanb/ZloXUQEQWTmODkn4Maa/C3YDJl0ZIpmzuyMz2yc4o4S2cNbNMGrs
         4pSbyDvzqCOQsNFvkE1vSABq1NvDFCZYEI1Xp7b1+LPDeCT34AO6FG06HXPZNWmwABnK
         W0OunuPbLgfZUu93WZI0lJmIPvbQKs6mCuFyFtcbIPalYH3hSF6ikWIqh490dHHuGeFF
         4NzVjxjSaQy1gLDwNUTsQjS5JjpUFq8MeK2J+RbQymqCNwMs8eLjQ11FxhB8S2Efg/hW
         9pXu93z9c8s/FprQfFdegWVbCx6smslr9NcklgWkxX+il5X57zDTbpPODiQSkzoVNUps
         LIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791281570; x=1791886370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i2wau8FdTTNEOYjhhKWh1ewIyMk2T5QlJDbdCDrZN8g=;
        b=z3/YMVUEavuqudRsI4oOV9vNZr/ULK5EQt48PaJqDYyBYgao6Ds+9JHt6n3m4nGQDV
         WHS9h2H1d7bPikIXnOSkmO59uavoowLWJlh/VQifPxMS77FVnGZZYgt3lmvQej93cfn0
         3jorSdF3kqLYHO1Wrvlxs69Th7HL8fLMdC6uelGsPFRTYng/hLBu3jjUMectbLZ6Lnm9
         ZEG7smNcobhlWqvR4h+CjtGTk84uZ0OjVR8mhhuDeiz4EYTqsNe0hnl0mFcU7TocxaGY
         PJBKnx+1bJEA2KNug2zlNT4RLfe4zn/dElkx1pWqG+VeW+Yv3ZOOSVZp7Kj3kikN999b
         R+fw==
X-Gm-Message-State: AFuF++nj2diem9E8ASFdWfYMTysqmubaxlSYM5NtFWRuX6dFCzV6UOyy
	dCmvcoQe1w2uNzF7RGiDldTiP1Bzkkka97VQNif39yTPVenOgil+L5R9O7ALYQ==
X-Gm-Gg: AYBFou0OG2nlz41iYJvlujPbAM+v9Fo+0pMb1mB5fJYu6c8xnbV7LJS9xSgqb3GMQXH
	0wL5SDblvyetagYS7YPnruV9xGji0msmtCQhLBEZjZCbGuAWhi/RLe127pUDOPd4JkrSegO2ZI2
	NEIp92zto4y0aNGUCFeaCecb++cqoOmJMauO9OGZkei1FvVzhbCsDaNiGUWYetI4RA5snHQ9B0J
	6JqOZ/6wFZFGQ6s0I0TlBLAo+Vl64xcB8x9woK2I+ANc6FT0oOx/WNAwcZZ+Cf6CvjVSIusMVua
	4XKiFoeW95yfNg5nacTJlCFIFypukKZdjugnvHKpwbzYv+WiYIQSZ992PprrcEV8OsUuPSIqoMt
	9URgQYa93NV5YE8E2bR4j0zti7WxJVCOccYe3v/iLn2LURGh66pj+NmIIGaBj5m6QHkkUqrVu84
	7dhEmKuziTm1ArhmB8LqFhl2gPVNd+WEvsPXZ83aYozfQQvacMicFBg5W8032ss82RRYpnBGV1J
	NzfYyvnnawZs9wm6r6z7XA=
X-Received: by 2002:a05:600c:310f:b0:49f:e941:d6e with SMTP id 5b1f17b1804b1-4a17b54f960mr16427955e9.21.1791281570055;
        Tue, 06 Oct 2026 03:12:50 -0700 (PDT)
Received: from zenbook (90-182-211-1.rcp.o2.cz. [90.182.211.1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1776cfe45sm64369305e9.1.2026.10.06.03.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 03:12:49 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [xfsprogs] mkfs: fixup memory leak on exit
Date: Tue,  6 Oct 2026 12:12:33 +0200
Message-ID: <20261006101232.357124-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

When running mkfs.xfs with addrsan enabled, the following is reported:

```
==27832==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 9 byte(s) in 1 object(s) allocated from:
    #0 0x7fe6db2e8ac4 in strdup (/lib64/libasan.so.8+0xe8ac4) (BuildId: 5395ec74f54d9ec7bf97c06583dd39a96c230822)
    #1 0x0000004175ce in getstr <blah>/mkfs/xfs_mkfs.c:1767

SUMMARY: AddressSanitizer: 9 byte(s) leaked in 1 allocation(s).
```

Thus, gracefully clean up these string allocation on exit to address the above.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 mkfs/xfs_mkfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 334367b8..fec43987 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6503,5 +6503,8 @@ main(
 		exit(1);
 
 	libxfs_destroy(&xi);
+	free(cli.xi->data.name);
+	free(cli.xi->log.name);
+	free(cli.xi->rt.name);
 	return 0;
 }
-- 
2.55.0

