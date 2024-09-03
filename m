Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CEB1D27A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 06:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725345656; cv=none; b=DqyrK0gmXih93aViZOoBtEQ/pLonLe55cx2UVNhbDX//FCiQcC3lFA+qkXkfQv/73YXGwdCOC+zRKvtwX0Onq7G7ZXiD+Z7muX/WbUa+Sy1+JDNaYL1FL5paw7erbfCNLILUzjd2tuetAm9hXCkKNa+oBzdxK7QpetHVnl6j5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725345656; c=relaxed/simple;
	bh=1edUmqWbMpLbijpV5kGjHx4XFowJsoRgN0vVk9x1GKE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YieD3ttN+WG5NSjzHb2iQfveW4qf3lHh9Hcfyf/erE02M3XHU6uzbN7OXp2HQmDp8OT3ugNoplzl8LESQcuZckhJVzJBtpEKQwkI4jp0aZLBmzpU8pFb1ygGsmNHdrBbEYhbybF8KEmKrY2L31nL+zQurSJee0MjYu7LyIDgMDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QZfFzZ4X; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZfFzZ4X"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f3f163e379so79636151fa.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Sep 2024 23:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725345652; x=1725950452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/eTXevqBuZWtPi5UXMuQAciXdRbvMt+r78M3vIscSiE=;
        b=QZfFzZ4Xkv9QPfZu6olQCX+a/lfS7CG+TNKWTWwGxcdNHiXmE1Y7TzTiUp6hj+dinq
         mA3gXIH4eLUzAKZsTSgBMs8ZKW1kBUhCp+UHhBTgNgHL5XLM2j7V489vk0pou24NVvZ+
         sUhb7HaQcU8vcmQYttOLRzXvvZvR13JoFaTQV0IrkJ871dDhObeEC8lD0nYKPHEUJOob
         RwTaIwbuTVH4fsNMh+9VyRctaLUN8Mrjeg3eS4mZ5ieDGfXY5kMUjif21eASnEyXzuGd
         3yn5pvw/NCmJWDJFZ83SKjFnuSBFDjwySmTV8qwUT0yuZhz0aOZmiuhspSkAczCD3HWE
         I1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725345652; x=1725950452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/eTXevqBuZWtPi5UXMuQAciXdRbvMt+r78M3vIscSiE=;
        b=Fj5tu7YjNiTikPZOA6fqkJGn4DdUvB3FX7J+JzBKLWT/jTtquFmXv+WI8NJPTSYQ3p
         /d+wj3lPVyVP0g4eEZwrUZaNA8OUFzQOa5nfsjcIBRISGPRox/aQrKpGD1TxBPOZxBU3
         sXbMAU3dRJHv5lIiFJ6Fv5KF17bQy0jXyCPqJSLasctCbDSB1kIwurJsnOJAw63F1efA
         9ChvBQO+/9QeeOW+oVd6t9vXaJKdF6cfM7N7OH+kX4+Omue9TSWiNsecDyti6DvN3HJd
         8Jf812lM7ZG5jIB0TQBAFxMCg6QtK7iW80Qfp1txLCNEHXHvcQX2qu0Tl45lgmzTuV3D
         o88Q==
X-Gm-Message-State: AOJu0YyrnBswbvdn9nn5L5qo+o20iXbjYs8akCX3kC8Hn2tHO/I30Lv8
	Zccdre01gS3V4hB+eMAVyFp1lN7e8yLeiBN3UaRHwMpcm5ty6Rz+HoguDhEv
X-Google-Smtp-Source: AGHT+IEZ4/qQCMi1V1f+f4HvIRK8iwyUnExLwJkfR8LEVfMSxWZE4EgcFeBJVNjT+TpDaqmqcnhm2w==
X-Received: by 2002:a2e:a993:0:b0:2f3:eca4:7c32 with SMTP id 38308e7fff4ca-2f61089355emr151712821fa.38.1725345651411;
        Mon, 02 Sep 2024 23:40:51 -0700 (PDT)
Received: from gentoo-musl-test.lxd ([45.250.247.85])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a8988feb0fcsm642123866b.45.2024.09.02.23.40.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 23:40:51 -0700 (PDT)
From: Brahmajit Das <brahmajit.xyz@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/1] xfsdump: Mimic GNU basename() API for non-glibc library e.g. musl
Date: Tue,  3 Sep 2024 06:39:18 +0000
Message-ID: <20240903064014.176173-1-brahmajit.xyz@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

musl only provides POSIX version of basename and it has also removed
providing it via string.h header [1] which now results in compile errors
with newer compilers e.g. clang-18

[1] https://git.musl-libc.org/cgit/musl/commit/?id=725e17ed6dff4d0cd22487bb64470881e86a92e7

Please also reffer: https://bugs.gentoo.org/937495

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
---
 common/main.c    | 3 +++
 invutil/invidx.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/common/main.c b/common/main.c
index 6141ffb..107d335 100644
--- a/common/main.c
+++ b/common/main.c
@@ -77,6 +77,9 @@
 #define MINSTACKSZ	0x02000000
 #define MAXSTACKSZ	0x08000000
 
+#if !defined(__GLIBC__)
+#define basename(src) (strrchr(src, '/') ? strrchr(src, '/') + 1 : src)
+#endif
 
 /* declarations of externally defined global symbols *************************/
 
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5874e8d..942f16f 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -41,6 +41,10 @@
 #include "stobj.h"
 #include "timeutil.h"
 
+#if !defined(__GLIBC__)
+#define basename(src) (strrchr(src, '/') ? strrchr(src, '/') + 1 : src)
+#endif
+
 invidx_fileinfo_t *invidx_file;
 int invidx_numfiles;
 
-- 
2.46.0

