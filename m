Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0322186E2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Aug 2025 20:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756671961; cv=none; b=i3h7BLgCFVNP7DCX4EgmxjqNG5vQzmCE12DxLmV0YZRst8kidhBPclkPCg0HSJcH3HcmIB+GzxtRc+0RWJAz5DGz4hu3STbUqE1vFTAw7Ca0wvuVj6DAlTfN9omXaPPFT6IFirSv0c7zGEeVrzCs3PrgMJsY0Z5dInbVyGQ6/PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756671961; c=relaxed/simple;
	bh=o6djq53XBSaJt9RnlTL0mlVvSPyj9WheRZXvyi/L02I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mQlLldnU+d4S6S2h0lnIlRcjNqiKTUscIte0St6ba90DK3QCZQbEn4fQxY7PJFFwCcC3z0AQPe9XFBqutPmAHOQTzsZWVb1ntnm8I3h8icTCqWChYK2y87a5rydKl0Ru86evyY9xDTK9HZB2kIhOsTFulRW8M3VXJXXGRDlEqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tukqong+; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tukqong+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CWtoccsXwfuDTCCzGRPvGSPgRfy/7s3PXifW1K/fwmQ=; b=tukqong+5YopzBZLIQqlyZ1lMx
	T0bF42SKO2K+WzKLQXUvP/kALVoEbD+BsyX1n56fGrG8E82TOjPt5Rnwh778yI2rz5cQx7fjQxLrD
	LptgBOHoxBlRF7NHd5+jpprJaWggmWbc+TWEbS3DEws72Z5gMChaJOveo28WyT6IJoQciD7SeyhlT
	edfvhEcoQkuwKblrgMHMNl2r3MSjC6/pl4vUQ9YtgrvICLhiCy4TBfNDXJVkuNA0czJZiBbqGq5q1
	J/f6AJjE8mBvdekQ11MjdtC4r+nfdvK7tjUtE/d/E/rdCGqTmdfpuMej5vGh174LhQr1KT7a4vdHI
	pwy8H9wA==;
Received: from authenticated user
	by stravinsky.debian.org with utf8esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1usocZ-000Hxb-EZ; Sun, 31 Aug 2025 20:25:51 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH] xfs_scrub_all: Replace deprecated datetime.utcnow
Date: Sun, 31 Aug 2025 22:25:15 +0200
Message-ID: <20250831202547.2407-1-bage@debian.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Python 3.12 has deprecated datetime.datetime.utcnow. Replace it with
datetime.datetime.now with timezone object.

Closes: #1112588
Signed-off-by: Bastian Germann <bage@debian.org>
---
 scrub/xfs_scrub_all.py.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index 515cc144..a94b1b71 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -496,8 +496,7 @@ def scan_interval(string):
 def utcnow():
 	'''Create a representation of the time right now, in UTC.'''
 
-	dt = datetime.utcnow()
-	return dt.replace(tzinfo = timezone.utc)
+	return datetime.now(timezone.utc)
 
 def enable_automatic_media_scan(args):
 	'''Decide if we enable media scanning automatically.'''
