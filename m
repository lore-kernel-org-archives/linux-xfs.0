Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBAD2D7DD3
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763676; cv=none; b=GLTBaxTdk+5ll44FkMnO23DZVwpYeWq4OUhiaOC/t4CbArsjZVmEIfQVbde7JOEopkI/RbCy5UFccQex1dxIBFFBbieQbrUd+ELRyKprvhcyTUuR0xo504o0rkBalJm1J9t9lSO7xOEYW728ZEYyGEkMSCEO3E1D53HFIdUt1w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763676; c=relaxed/simple;
	bh=vm8NV2d8LJIcKI7ifYBoGVhjfEMQyaj0Gt4olgGZ5/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNPnLoxCqWlh9wga5Ia6F6Yd6UKNvAfXlQtmxOVnaT11AVJM3QXA5tTdk5Ok8oZ42mE6K+TsvYRWGEAWhzn0o5/3NlMw7xgZ8/hcFAXgSD4HXBpkyIGY9gAwnnEfQxHYblYCx4Ry3uLyh+PKaIFxnuZIWGpY715uMr9+vUuSOeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipL7EubV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipL7EubV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF99C4CEF7;
	Tue, 17 Mar 2026 16:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773763676;
	bh=vm8NV2d8LJIcKI7ifYBoGVhjfEMQyaj0Gt4olgGZ5/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipL7EubVqZ4U22oVlIewAnbEz4ceP275MKpjZnYYYFennSZO+Waw/W9D0/EwAmxwZ
	 SinuwlBYKhibo1qNnCubhkTibS599a+VYR800L2KxME/dsaY6tkVh4rNXjoirP5CRt
	 P3sNTasFo8ACHwV6cjZ9EeKYMpDigfGgJASFUysuuUxNAFW9QzOiLk01Oqf5Wv1G4b
	 TCi+zOs7F32U3kTtNq1p6bPkfRYSOmoN16n6Qa774xjzkwSqMkWDVt29r1aDPET8s0
	 fLsB1VJhsOMEgfpGs+l7xgMNsfZUCCmUXcs+SwqypEq/1I4ZLQuTqqo5K3WtIkCx7o
	 ntmzDp7ob9YbQ==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v2 1/2] fsr: package function should check for negative errors
Date: Tue, 17 Mar 2026 17:07:39 +0100
Message-ID: <20260317160750.186873-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317160750.186873-1-cem@kernel.org>
References: <20260317160750.186873-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

xfrog_defragrange as most other functions from libfrog return
a negative error value, while xfs_fsr's packfile(), expects
a positive error value.

Whenever xfrog_defragrange fails, the switch case always falls into the
default clausule, making the error message pointless.

Update packfile() to switch between negative errors.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	Change packfile() to check for negative error values
	instead of changing the return sign from xfrog_defragrange().

 fsr/xfs_fsr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8845ff172fcb..aa2a10839314 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1463,17 +1463,17 @@ packfile(
 	switch (error) {
 		case 0:
 			break;
-	case ENOTSUP:
+	case -ENOTSUP:
 		if (vflag || dflag)
 			fsrprintf(_("%s: file type not supported\n"), fname);
 		break;
-	case EFAULT:
+	case -EFAULT:
 		/* The file has changed since we started the copy */
 		if (vflag || dflag)
 			fsrprintf(_("%s: file modified defrag aborted\n"),
 					fname);
 		break;
-	case EBUSY:
+	case -EBUSY:
 		/* Timestamp has changed or mmap'ed file */
 		if (vflag || dflag)
 			fsrprintf(_("%s: file busy\n"), fname);
-- 
2.53.0

