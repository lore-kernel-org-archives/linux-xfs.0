Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7139E4028E2
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186785; cv=none; b=kZ7uYwevAfiIwSjUT5QQ2HnuLud3qbBH+dvhiR7nU4RSVPejSbkIkCMlKJObYv4vHmt62BaSMXsjvuG3AdUk9usWbcKTWVmHTgVHkvdYtHCisNzpJP97h7LRiC5WgrOqEpbQTgGsdtLHyNKUmV88xamBZwVSjAYfjTAxQCCpQaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186785; c=relaxed/simple;
	bh=RSyDSjyxjlrDUvByk/O0vGlZQr/9nH+N1CqknN9QfWs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjXLCkVxW02xclQ6LejFxHT+fpJTKZByVftjB/3Z13985lccciPIvOrq+AyffIxPRgz/yWpLJvVsi7S7ispj+6MtpZHotleVx/t15nEghKz4H6MwB19PmDlTyNX2LhAHd89mkmcYJ9wuwQYpjaVYxbFO8V79qush0K8HMXn8IVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYg7u6Va; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYg7u6Va"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 492BA1F00893;
	Thu, 11 Jun 2026 14:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186784;
	bh=SmYJHQOhmpRd9zTMcZZOqqi8zU6SzK5ySYbHh5PuU+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EYg7u6Va3R8Hc1XKHcIIZHTE/uoragrKvBMMzkkq4H+jn2qDvKhVqUMQDu59fIlqB
	 6iNpr/4X8c2okSaSz0JmpeEhs6ywsbBuEnYzKJcsYlr/tLRXpd0vqTMdwebx7T3Qgy
	 81h7NpjrrWRNCATIA3u65wymuK3gD96+kCOy3GFmzL1qdhBXYrlSVgbIYXIxnd5Mgn
	 +hfw+57yrA5HUF5mo85LhqSb8/T3RxKCVA4JM7lDDbLem6ncSEPJKgeJpe7GJK9i4S
	 dAOXx1k5JRWSC0XhQzMu31eL8BfULAylfQVTGWs7OKOlLYX3UCD+Z+7p4bdtWkx5q9
	 EPq68vMRKWnFg==
Date: Thu, 11 Jun 2026 07:06:23 -0700
Subject: [PATCH 6/6] xfs_healer: allow AF_UNIX socket access for xfs_healer
 instances
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661353.728615.8408589793793380068.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When xfs_healer cannot fix a filesystem problem on its own,
run_full_repair function tries to start an xfs_scrub service instance to
scan the entire filesystem.  Unfortunately, as Codex points out, the
service definition for xfs_healer instances doesn't allow AF_UNIX
sockets, so that will fail.  Relax the security posture so that we can
do that.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 88825fe0de0df2 ("xfs_healer: create a per-mount background monitoring service")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer@.service.in |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
index 53f89cf9c4333d..fd1aaf20e20bfd 100644
--- a/healer/xfs_healer@.service.in
+++ b/healer/xfs_healer@.service.in
@@ -55,10 +55,10 @@ PrivateDevices=true
 # by our sandboxing.  healer doesn't care about project ids anyway.
 InaccessiblePaths=-/etc/projects
 
-# No network access
+# No network access except for systemd service bus for initiating full scans
 PrivateNetwork=true
 ProtectHostname=true
-RestrictAddressFamilies=none
+RestrictAddressFamilies=AF_UNIX
 IPAddressDeny=any
 
 # Don't let the program mess with the kernel configuration at all

