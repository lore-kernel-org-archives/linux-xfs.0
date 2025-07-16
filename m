Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B629AAFA;
	Wed, 16 Jul 2025 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752690152; cv=none; b=VFEv0aNdN/tZMcecXY9PDIiFaYlwUUYD0ueDcmdu3Sr68QXVVr2BSclgYfbMkibGeIgEm3sl2kYksZgGzbCAeIIVJOX0Om2gPYpqcAKDP4eXLiPDQslSX+9SaxVPBmHNkH8W6SRDd265iKHIm2u9O2p2Ja8EVI1N3vtuKCL98b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752690152; c=relaxed/simple;
	bh=0nl090ZOoinWZd1DwjTnbdyiFKG+e4UcxDg20wSOmbg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IFW3o41gn1NTHqCA/2Wm5wRTtFJRPOh1gbfkaydzzKoqcLLKARUBwSR6J7czzehmaS37VVES/FqNZKw1qHRZTUYZIDSUVonc0IlQ5zruwKbpaGziIwFtLjZS6yrijWcEr7LFu+Qli//49LpFKgzSZYlI1/Ejmnaefv9AVQhUqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=liNkbB/y; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="liNkbB/y"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-40a4de1753fso112858b6e.1;
        Wed, 16 Jul 2025 11:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752690150; x=1753294950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kviAVPIV6QiWJ6mSBU1RXU0icX9kGbvx4g3kYZu467c=;
        b=liNkbB/yUILBz6AZNSFCbyfMsjZZ3BQbmR1lMngd2I1uGTdbHCM1mWsOfeiushPryu
         l8Q5O6YvM/+SMU1ViumjeFJM2vXhm6lFgatZ+V++sy2JHQ37gAHCX4V12vPYWeZ3OfvO
         YjFKhYuQ6hbKjZs1AFClczKxZ/AaFEZQhSpspK/xEbd1SFVgO+/GUrljIXALkcTAtI65
         823/kQ7RdOD/UxJCQeuCmRsl+1t73ZTOZwCtFzwMrSU/WSboGsitOTXOZpGKnRBfRTOV
         pPc6YT3wVtpTB8OXMIph4/W1kjqKVfj3G+sgTrLwjO6p+ZdPRpigYGgZ1xDZeqj//bzA
         qRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752690150; x=1753294950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kviAVPIV6QiWJ6mSBU1RXU0icX9kGbvx4g3kYZu467c=;
        b=eQA+iwzlNO3wdnimEeJS9j+im4fnyOdfOFLCmJy5pB8TfwesmUr7uJ2SHfDd0N5TYW
         X9fwqxp9Ju8bW/nKBeYgGAEk+Wo2nwQIApGyyw4bf6KctRPIvBix41py8DUXQn/Berdn
         ZAYtno0CGuXRdyZ71C76TZa/uMpN9In5oarPKMM+LjCEMQbiiJNLnm4AHlw7I7CVPTuC
         RgEudNfv/3JiH7y/8FYrXtCrR0CvaSLvQmB+799STk+bj7JnK4Plj2+vgia/3AWxCTSV
         +nFPfRkFWA7Ee2MBvBTjJjGMykjV+qVz3XQne1o/Vo6SDvf1iwAadGwQZSLuOvNyxDXx
         AIcg==
X-Forwarded-Encrypted: i=1; AJvYcCVEjsCIVdnUW3BWBMEGlIPj6DOfVmlFsA8n5kAJD3Ygvm0hIgNM4sJRE4NgKzltkMADszJkDYzBRkBJ@vger.kernel.org, AJvYcCWtg3W+IsIL4kPbMW6pIS4wRuOYygj+y2DoL/IAs5tJNRxB6r8Uhn2P+LX8v25GD792ICtbVpies3mYfrU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT6AxgyhZAkUnGJ1HlK0ZsNpq8h54aZdcE8Hi3TdojIgsWFHzu
	u2pYkEQSJD2kkgvUO8O14Aai1m0pV9pHoibSXCWaMZzXj6sC2wMquJFZ
X-Gm-Gg: ASbGncvTCFilXl6zrQR9WHYvbIkIGAi1cTwDao/uw3Q81lzB8ZvUseqVI/cVuMu1aVO
	Mw2tmEn7pd203x5N/bWXugEiBuTf9xsm0KNBwEtvkjJncs/+aCuqb5Gk27KZ3geITSMUZZw0r36
	mNT9IUgGmJxh3OesntCXhutzcIhG2QaxzQYStz9J9INTrgOkXWwtCWJdR6n6TmONUAukNmo0ZDS
	ml6D9ajNBmHeO3Ei8QCQVu3SG1e21NIPg5IbTPuN+ttGTofBF68hL21gmm3WoHvIu0op6KLxJtq
	8YeVJ74jCboi4ne7o9FJZuec88ikfwegD/N9QUkd8me8rKIKZfS712KQAaaVVeDBd+se2lnnuFr
	k8UrHYsdM
X-Google-Smtp-Source: AGHT+IFx9+UvCZpBpSMindy2yzPwVLH4FcTuwv6wnARoO6WOcLt4gVPyFH4qADi0Hk7H9lfiXsliUg==
X-Received: by 2002:a05:6808:15a8:b0:408:fe75:419f with SMTP id 5614622812f47-41e28c748b2mr426539b6e.13.1752690150075;
        Wed, 16 Jul 2025 11:22:30 -0700 (PDT)
Received: from fedora ([2804:14c:64:af90::1000])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-613d9f14472sm2317697eaf.29.2025.07.16.11.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 11:22:29 -0700 (PDT)
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] xfs: Replace strncpy with strscpy
Date: Wed, 16 Jul 2025 15:20:37 -0300
Message-ID: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `strncpy` function is deprecated for NUL-terminated strings as
explained in the "strncpy() on NUL-terminated strings" section of
Documentation/process/deprecated.rst.

In `xrep_symlink_salvage_inline()`, the `target_buf` (which is `sc->buf`)
is intended to hold a NUL-terminated symlink path. The original code
used `strncpy(target_buf, ifp->if_data, nr)`, where `nr` is the maximum
number of bytes to copy. This approach is problematic because `strncpy()`
does not guarantee NUL-termination if the source string is truncated
exactly at `nr` bytes, which can lead to out-of-bounds read issues
if the buffer is later treated as a NUL-terminated string.
Evidence from `fs/xfs/scrub/symlink.c` (e.g., `strnlen(sc->buf,
XFS_SYMLINK_MAXLEN)`) confirms that `sc->buf` is indeed expected to be
NUL-terminated. Furthermore, `sc->buf` is allocated with
`kvzalloc(XFS_SYMLINK_MAXLEN + 1, ...)`, explicitly reserving space for
the NUL terminator.

`strscpy()` is the proper replacement because it guarantees NUL-termination
of the destination buffer, correctly handles the copy limit, and aligns
with current kernel string-copying best practices.
Other recommended functions like `strscpy_pad()`, `memcpy()`, or
`memcpy_and_pad()` were not used because:
- `strscpy_pad()` would unnecessarily zero-pad the entire buffer beyond the
  NUL terminator, which is not required as the function returns `nr` bytes.
- `memcpy()` and `memcpy_and_pad()` do not guarantee NUL-termination, which
  is critical given `target_buf` is used as a NUL-terminated string.

This change improves code safety and clarity by using a safer function for
string copying.

Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
---
 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 953ce7be78dc..ce21c7f0ef54 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
 		return 0;
 
 	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
-	strncpy(target_buf, ifp->if_data, nr);
+	strscpy(target_buf, ifp->if_data, XFS_SYMLINK_MAXLEN + 1);
 	return nr;
 }
 
-- 
2.50.0

