Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D7331A7E
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786462060; cv=none; b=p27r8TXJCIKcG3pRNg2JTdQIG1NU/KEmEmHFQuBUO3GRQin9v2FDdO+NjFHj5KfJUHoSszoP+awX2Bg1nzSL1n7JHkVqNGy8p81mONqeD5Pd7ebQtG44+OLdUL2vIFMSXURktP6bzXHxGyyHFqHPElFP+eUcPnT3lWFOXCTCeuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786462060; c=relaxed/simple;
	bh=fo5Rh+MaFKDVfsDQQNWvL5zGPGPyMcaLOVrlpWhATgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SYFlDX7G1Ot28/6XJ9/9YUoj/SMjNyQkQHXL/wxVLaVTWA4Srokzh1Fx6Ljn2UCUi436IGJ6xuXa1cyEJRAKehItdUl4YTugZaNQBvSA4WxYS20gc5A5gu3gRAgBPKJYwWCWRnP9mjB2BXw47p/00MWHR/I806EqJV1F0u9JbEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gqRpjTmX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qUT1Krws; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqRpjTmX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qUT1Krws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786462058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IdvSwCeY4NdtA+mq9zclySiPc8pPZgwi8xAktxMwpRM=;
	b=gqRpjTmXNWb7aXe+sGP1beMNGmA+WCeBubtDFWxU3ON7uIaCrGGR6qtXqo6L+t1IOi66gP
	KtEUWc8vJYEVCf+/R3yiuC49yf/+N2EfOIsCetDVrl7K1F7PflsvVl79ANa19yJSDgKG3x
	25Q+WwqfuknJk3HaEHEvzjvHp+Ub4z8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-bCL54_w6MuudOV9ncXWG0g-1; Tue, 11 Aug 2026 11:27:37 -0400
X-MC-Unique: bCL54_w6MuudOV9ncXWG0g-1
X-Mimecast-MFC-AGG-ID: bCL54_w6MuudOV9ncXWG0g_1786462056
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfca8558d2so329135ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 08:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786462056; x=1787066856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IdvSwCeY4NdtA+mq9zclySiPc8pPZgwi8xAktxMwpRM=;
        b=qUT1KrwsZSr4oHnZ9JUlIi94IljM7n6r+siMfYv0IegzLhWlAF6C16e+ocnvYVCShM
         DTFii+9vP6ds+gJnFVOWK33m78XGn2GuRSYHVCo8CjPZDp9bIPnmDdp2ZyddDTSBUjPa
         3V0TfTqgejoETtFkn7fYvwH5w4ouEXkjxCDk5vP9AGoz8gJwcAjC5APQ0dkCSxClfrt0
         f0WrAZZ0JB1mOJ2fFzGwQci98xKa3CqYDaoPXcvc5PEn7YqCqC0HgT8N0KPszyKjfxBi
         2fUNBxtY0l0PYvgSaie9UXMSYmPkQoZILin2bICeEaukrQTTnpko3xrV92uHwPcJe1Ig
         dYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462056; x=1787066856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IdvSwCeY4NdtA+mq9zclySiPc8pPZgwi8xAktxMwpRM=;
        b=OoiNFptWP+svw3VGtcShQEB6/wGFCT4Ttzxg0kZigAkOoUNq0HJDPJvy8WW4VSdIkd
         9S7Lk8j1kxQPSJ6gSPGvDHYOaSF6oPpvJAkpfUumLOTLzbLY5TBKaPPpP7/AqMJ0EZxy
         ljw8yFbjyzWGm3DEz6kHH95FPgZa8lf2N49XMpR8ScRIg/Gd/DVC3ih6MVOV8GM8cNZN
         lMaMlB/gF3hDONNatFxEjRIYNQvfqzsN5eXYNlbVUHkU52Zcy8DpCPFUIOi9BohVrkGv
         ecfqyQ0cuX1sbk7wyNqgCy+bxH/sOH7IQCo/UL7tMrvt8Ufy0lwdPA+t5eHD9QU9rci0
         IUBQ==
X-Gm-Message-State: AOJu0YxgTEj6Ut/Zp35mdYc+q7tsKIib7YJKbWy8jf2nUeH3DISZ9djJ
	TDb5SyqUYOgdpQM2z4ALu/jB4xTu97+nMPKvMnb8bxhg1iv229f+1bCtBoE4BBVchK28FXuL9AM
	zjP8OWVCg6jm5WjEiitGJcOdeSJNtc3W1dsDHcAF7KnOsnUroy6SGirXrhM1N5iNjzbXwVl61iZ
	pvJyS3sL1n01WHnbM6lREq6JvQUhsC9KDXAHSn9O8rZwy+3Q==
X-Gm-Gg: AR+sD13UQRO784Ad+kD2hBf0TwO9Plm4nKnLrFeVGEKNn4o1MjnhvflCj2prVByMC6i
	0ReGSEEkAvLxI2e4mKE8/YAzAWaaPxfnsvCvh1cj3xyuTfqmrS4aUuz3ZKroURZeEGcVZYA7Nrm
	iUQhCvsMzJL3nXgt3YBt55MQb09qHWZwMV7eIE0sPY4ij7gRZqtQ5T4046yzGxSec+71xdvNqwA
	qKljgsO3C/Fr3DSQk7s3Mfx4XeWoNkMqAvdpbPUI0rbXquPe0HyLr1NUeQ/IPgETYOwSLCo//P6
	N6Sxq8T1F+WcWW4A+7gyFUv+ETKtKiwcNhg+U26cY8Lpuga3tdJQLjkOWAk767+Hjh1Hhw4eUz5
	5rX50eRJhKp8=
X-Received: by 2002:a17:902:c403:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d3177bbd85mr43271535ad.6.1786462055652;
        Tue, 11 Aug 2026 08:27:35 -0700 (PDT)
X-Received: by 2002:a17:902:c403:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d3177bbd85mr43270935ad.6.1786462055014;
        Tue, 11 Aug 2026 08:27:35 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b1b:d900:266e:8be8:569:ffa6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf628e2aasm590811eec.14.2026.08.11.08.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:27:33 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfs: flag panicking tests as dangerous
Date: Wed, 12 Aug 2026 01:27:04 +1000
Message-ID: <20260811152705.2813177-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs/649 can derail test runs as its not flagged as dangerous.
Fix that and pick up other tests that can also BUG or hang.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
Note: xfs/270 mentions a potential hang/panic, but its unclear if that's
likely or expected. If not then we shouldn't flag it, thoughts?
---
 tests/xfs/051 | 2 +-
 tests/xfs/081 | 2 +-
 tests/xfs/270 | 2 +-
 tests/xfs/306 | 2 +-
 tests/xfs/311 | 2 +-
 tests/xfs/431 | 2 +-
 tests/xfs/649 | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/xfs/051 b/tests/xfs/051
index 95c89bbab..a46959375 100755
--- a/tests/xfs/051
+++ b/tests/xfs/051
@@ -9,7 +9,7 @@
 # causes BUG() errors or a panic.
 #
 . ./common/preamble
-_begin_fstest shutdown auto log metadata
+_begin_fstest shutdown auto log metadata dangerous
 
 _cleanup()
 {
diff --git a/tests/xfs/081 b/tests/xfs/081
index 14c0d13e5..6f85bd8a6 100755
--- a/tests/xfs/081
+++ b/tests/xfs/081
@@ -13,7 +13,7 @@
 # removexattr will hang.
 #
 . ./common/preamble
-_begin_fstest auto quick attr
+_begin_fstest auto quick attr dangerous
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/270 b/tests/xfs/270
index d3bce386a..71430dd15 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -10,7 +10,7 @@
 # ro-compat features), and this case is the regression testcase.
 #
 . ./common/preamble
-_begin_fstest auto quick mount
+_begin_fstest auto quick mount dangerous
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/306 b/tests/xfs/306
index d48b75363..8430aea84 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -13,7 +13,7 @@
 # CIL (i.e., when the log is subsequently flushed).
 #
 . ./common/preamble
-_begin_fstest auto quick punch
+_begin_fstest auto quick punch dangerous
 
 # Import common functions.
 
diff --git a/tests/xfs/311 b/tests/xfs/311
index 8b806fc29..766d8bad4 100755
--- a/tests/xfs/311
+++ b/tests/xfs/311
@@ -11,7 +11,7 @@
 # panic.
 #
 . ./common/preamble
-_begin_fstest auto quick
+_begin_fstest auto quick dangerous
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/431 b/tests/xfs/431
index 9764d2437..5fb76ccd1 100755
--- a/tests/xfs/431
+++ b/tests/xfs/431
@@ -12,7 +12,7 @@
 # See CVE-2017-14340 for more information.
 #
 . ./common/preamble
-_begin_fstest auto quick
+_begin_fstest auto quick dangerous
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/649 b/tests/xfs/649
index 56277c629..2f735fb0e 100755
--- a/tests/xfs/649
+++ b/tests/xfs/649
@@ -23,7 +23,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick attr
+_begin_fstest auto quick attr dangerous
 
 _fixed_by_kernel_commit ae668cd567a6 \
 	"xfs: do not propagate ENODATA disk errors into xattr code"
-- 
2.52.0

