Received: from shadowice.org (shadowice.org [95.216.8.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1957242D89
	for <linux-xfs@vger.kernel.org>; Sat,  9 Aug 2025 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.8.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754761216; cv=none; b=oYXsWMEcMd3M+b1X7AXhcfYQ0+uDhvhJA0wf32vRFIQhcO1i6bzcl00yBHgsCxLwNAORtf0Qa7ldIwSMRDHa3hreiJmWnjCvFt+J1r0dDepA3H98uzhPf6yXCqnTK8lYaaLu0CZ/OK4GXSrxWXsrurgdKr560HcXD0J0xnBa9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754761216; c=relaxed/simple;
	bh=GGZIL3SbaOKDOoVghci21IwvG4AT6WgutIaRd/xUAtc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=PSwECypOE2ctEtEIrVJwKZz8qNgfTqr9hymK+jeBm/E0/jB+WBo8oyBFZVK5s11WdrLRZCoykYDUHHzb15LS4QtI6npVtP/ELMKv5gORvLm+FiXbXm21uhBHQ8uJ78mxwCNwKn8ECYWXDlHX6JopA51vsDJnnVtXRfxhSdB0cU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev; spf=none smtp.mailfrom=nixdorf.dev; dkim=fail (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b=vFI7lRLc reason="key not found in DNS"; arc=none smtp.client-ip=95.216.8.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=nixdorf.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=nixdorf.dev header.i=@nixdorf.dev header.b="vFI7lRLc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=GGZIL3SbaOKD
	OoVghci21IwvG4AT6WgutIaRd/xUAtc=; h=cc:to:date:subject:from;
	d=nixdorf.dev; b=vFI7lRLcbtA2ezNgJOxreuTkRvNjf22C8AxTZWcU7VChJuWiikN0f
	6Hbx+fNIBW1deH7+gjnanYtQ0NU45UE9HrMo/KQbqidRk+MgBI7jPJBJ+0bHVMVwmqmfcY
	zuMFagV8kZ1YyDmhdx3A5N7/ba3GtV3GKVsqtfGmRLZ4f9aE=
Received: from [127.0.0.1] (p5b09f668.dip0.t-ipconnect.de [91.9.246.104])
	by shadowice.org (OpenSMTPD) with ESMTPSA id 8c674f53 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 9 Aug 2025 19:13:29 +0200 (CEST)
From: Johannes Nixdorf <johannes@nixdorf.dev>
Subject: [PATCH 0/2] xfsprogs: Fix compiling against musl libc
Date: Sat, 09 Aug 2025 19:13:06 +0200
Message-Id: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKKBl2gC/x2LQQqAIBAAvyJ7TlChyL4SHUTXWigLlyIQ/550H
 GamAGMmZJhEgYwPMZ2pge4E+M2lFSWFxmCU6dWorDxu3mWkF1laqwflogs+RGjDlfEXrZ+XWj/
 wUBXFXAAAAA==
X-Change-ID: 20250809-musl-fixes-99160afadcdf
To: XFS Development Team <linux-xfs@vger.kernel.org>
Cc: Johannes Nixdorf <johannes@nixdorf.dev>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754759609; l=1240;
 i=johannes@nixdorf.dev; s=20250722; h=from:subject:message-id;
 bh=GGZIL3SbaOKDOoVghci21IwvG4AT6WgutIaRd/xUAtc=;
 b=ppD8X0YBltICh5yRuIeHeKvG2z5V3qbhAJy3Zf8q4ZUlmKIDzHeztERVpu+pD7Y2dHDPuxPDp
 f6Zh0FEf4dEByrrV+Z6Mp3sEDE01uA7Fr92O8Cj4x4KDaeK/3b9zmIm
X-Developer-Key: i=johannes@nixdorf.dev; a=ed25519;
 pk=6Mv9a34ZxWm/f3K6MdzLRKgty83xawuXPS5bMkbLzWs=

The musl libc statx interface is provided independently from the
kernel headers, so not all defines from the kernel header (here:
STATX__RESERVED) are exported, and checking linux/stat.h as in the
current configure test checking for newest additions to struct statx
will not provide a result that is consistent with the actual code
using the libc interface.

On Alpine Linux this is already fixed by providing the defines
OVERRIDE_SYSTEM_STATX and STATX__RESERVED manually instead of fixing
up the autodetection (OVERRIDE_SYSTEM_STATX) and providing a fallback
(STATX__RESERVED) [1].

[1]: https://gitlab.alpinelinux.org/alpine/aports/-/blob/8ff6aa1e459a75b66375f56269fce43ca2c2f9bf/main/xfsprogs/APKBUILD#L27

Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>
---
Johannes Nixdorf (2):
      configure: Base NEED_INTERNAL_STATX on libc headers first
      libfrog: Define STATX__RESERVED if not provided by the system

 libfrog/statx.h       |  5 ++++-
 m4/package_libcdev.m4 | 10 +++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)
---
base-commit: 854665693e6770c0730c1354871f08d01be6a333
change-id: 20250809-musl-fixes-99160afadcdf

Best regards,
-- 
Johannes Nixdorf <johannes@nixdorf.dev>

