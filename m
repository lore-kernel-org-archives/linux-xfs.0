Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D677317C
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711386587; cv=none; b=PMBpkuAUs8TyafVRJbTXqaEfL0YvPDzHyY1IBtUyVUiPA41iVaT85FR0VGIbTM5ONrbOEUSMLWPcJsa5rlU4S/VcGebkNJqAaAjLCB6w0q4Fgh3maQeRjeGkTFHpHcpvLD1EXpzic19VgzeyO37lE4EJ9XgkgD80BDlOhP5vwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711386587; c=relaxed/simple;
	bh=aiBjmgkxmkioQ3K2jq9QSCfsmDHoaljtojpY/p0yI+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ya/vOJqLP9OgGoASXV7nhJH7VJXJBDfYiww+ikMXfbxI7lfCYE87TDd1K0U9OtOZ5/wGBuO8lmV8XTxSHdKJa3y+qIQCB9rEw20oMRDjAvHXhRsnFQIuFHsIJ+xgVqkHtBHKOzTGKCbC8rcyVJri3OhoSoEpZbTciXDYF4E91lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dIpo5oFW; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIpo5oFW"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e73e8bdea2so3742839b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 10:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711386585; x=1711991385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gqFUMTifKvt9ryk6UeH5doQ9Lm1OFketGhDSr8G24bo=;
        b=dIpo5oFWkWetmxW5PpBzfkV6oqYNzJKzE5GrXOEOJFc23aSwugYJ6xVBJfq9IQ/MYi
         eYKybaPQ1nRLB0KbS+kqtRT43ggetJhIUh10Og9TbR+lh4IczQChGIiFAOFc1i46tTna
         ftCfmzAvZ/nnHpfJeLyCSDPXUwL7URLi4ZaKEna/JqySAaliDrNr3sk/JGoqdWWOe+La
         9bLVloPcy5EoMq031oN8HOxdmBw+qCzywchZr5wNBgy3BB+Q56Wa55LG8hOJTksg3acg
         a9zeIvUwIn6VBmH1KBRD92wpaQhSWSZgSkOVDaCvq4h4txWgJDvdRxBTK0tVEEX5wFEA
         AoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711386585; x=1711991385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqFUMTifKvt9ryk6UeH5doQ9Lm1OFketGhDSr8G24bo=;
        b=QERmcv32CZ/eySxGhWRuXndTgBJTZ71dyy3LYjHBsXWPF52XTM4vTBl0luMD5DuWQO
         8chPkIai5ev1n6rNSDlqPXFIt1g3nc0vw/aAXthDwQOqjEIwqw8r2AjFCqMe8nqGUh4h
         KR/7rOYqEmKGmwT1Vgj9H3hXskwbgf1b76NkP7da2hkxUp1FfJSYvwkhJKM8RAxtsTg7
         HrubdqDBiKKiqi6hccOYmjAUEuz7lsjXUZJ3X2WiSON9qPpit24KpD8+6WpUm0r9suH9
         5tSQ0EChC4Q5odlZbu6V63wBOjaVM9R6In+tLPL7TWTMS3S8klZQvFXstq5yVT1BLV1g
         LoDg==
X-Gm-Message-State: AOJu0YwpyLYMAcwuyF0H6QbFTONpNtlaRoo3SudvdY2kYBk2t+cGziU3
	qfjsVd1FP9phHSOdkz7lo9krO41W1op36ucKBORr8SrdugcogXkNSCZ1Rxv5
X-Google-Smtp-Source: AGHT+IE6K1i8JrFkSd5sicdCATeFw25tKWmrTs6I6d1CtMG1insnHmI9Wjf5V5Hsa0ycyECooTr2Vg==
X-Received: by 2002:a05:6a00:2d20:b0:6ea:9117:bc61 with SMTP id fa32-20020a056a002d2000b006ea9117bc61mr10548932pfb.20.1711386584835;
        Mon, 25 Mar 2024 10:09:44 -0700 (PDT)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9d80:4380::5eba])
        by smtp.gmail.com with ESMTPSA id y4-20020aa78044000000b006e592a2d073sm4281688pfm.161.2024.03.25.10.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 10:09:44 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] include libgen.h for basename API prototype
Date: Mon, 25 Mar 2024 10:09:41 -0700
Message-ID: <20240325170941.3279129-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

basename prototype has been removed from string.h from latest musl [1]
compilers e.g. clang-18 flags the absense of prototype as error. therefore
include libgen.h for providing it.

[1] https://git.musl-libc.org/cgit/musl/commit/?id=725e17ed6dff4d0cd22487bb64470881e86a92e7

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 common/main.c    | 1 +
 invutil/invidx.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/common/main.c b/common/main.c
index 1db07d4..ca3b7d4 100644
--- a/common/main.c
+++ b/common/main.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <libgen.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5874e8d..c4e2e21 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <libgen.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <unistd.h>
-- 
2.44.0

