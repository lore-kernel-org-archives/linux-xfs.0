Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6323E51E8;
	Tue,  6 Oct 2026 08:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276985; cv=none; b=GwL+muryo3fxJSoW6fFGfIQYcvGJi+4CHMkQzesUgqc5oFB9IahoE2PY+ik+ZnC0wJBgTdstRqRNHfMby3Hj+/xGyXitK7FGKjQHlnrKVOm91jxsg5abRG/44kHx5hgCM6Ndor9p8U2aqsKXhxkmI0fXdl6bXtnCyG1HpWLQMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276985; c=relaxed/simple;
	bh=a/nC6AoWY9sqs8/tC82X1ipL6PtFUR3e4NgiqH43KbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CljlQaqT0eavVatjV+zpS6ybOusw20Bhv513UmJo/18LFQWi5iGLotwGKznCR95/EYd3uYC12QYfM+/o8zpjc/7cvSumIP+YNEuxiKtGNAyO4ONOdYnJ7SWINY0xnv23f8gnrTaiAmkeKUQ5bfBeXseJUMCfDcU7EivuABh3YMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSDP8yB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSDP8yB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970C31F00898;
	Tue,  6 Oct 2026 08:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276984;
	bh=9y22LD/+qePQCXLtOMGMMoPRhgQQSeA8domJHzKLADc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSDP8yB03tX9/OtTXwNp8GyHq9bwh7p+QcPNKg1uzPl3jmSPyoR8POlNlDendoy+O
	 VMc1TQ9TAA0Z5ZKLb+17NzIaYpZFe21V2qOTOvqNJP6cJWBpnQdKq57q91zqvBGqga
	 2bm9tBOu37d11ty7wjlNUjey2ZlnTxvgcrTTJGWp59P9HsJ4ajXh3TihxHzYtaid1+
	 3QTcIo/5LiE8xyQq7VV+xA2R1l4MPcMTGtYWS8jBt6eNF5n1c+e5EcnCdB2IsrPUx1
	 AXFs34/69XUTl+rXtMX/oqgUEMVV4FShCdFEALk6RFEjl7Ub3zvuD8BiSLL8dgDMZC
	 38Iev+urxSxnw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 05/21] fstests: add _require_fanotify_function
Date: Tue,  6 Oct 2026 16:55:31 +0800
Message-ID: <16d1b43e27ee01742eb6a431d99a738c0696a94f.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fanotify support may not be compiled into the kernel. Add
_require_fanotify_function to skip tests when fanotify is disabled.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index b9481ba8ab55..0fcc1a614ad1 100644
--- a/common/rc
+++ b/common/rc
@@ -6384,6 +6384,13 @@ _require_max_file_range_blocks()
 	esac
 }
 
+_require_fanotify_function()
+{
+        if $FSNOTIFYWAIT_PROG 2>&1 | grep -q "Function not implemented"; then
+                _notrun "Need CONFIG_FANOTIFY and CONFIG_FANOTIFY_ACCESS_PERMISSIONS to be enabled"
+        fi
+}
+
 _require_fanotify_ioerrors()
 {
 	local x
-- 
2.43.0

