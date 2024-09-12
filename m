Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FE618C033
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126709; cv=none; b=IrzXmuqkiqtrLdh8PgJVzfumm8Ypgm5d9DbGAHQAmlXjna/5kGrk/Xa+Z4nxKbhBJYiUDo31Zpr+lNgUVMxMTr3nFdmGtxk+2WCG8M2hMJiwRMo9Z8jQy/cm+hTtLwpbf0OrzKNVI0vvOlDZanrbXYV/NxVmx2R9dH0FdIlEnY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126709; c=relaxed/simple;
	bh=AMrvU2g/hzFiAMUqzkBWozvQ7AuiantcQMne44njR7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0FJxml8TGR1jAheE9Yj53P+DnOORRIcK+HamUO1NysN8wX7a+2u0ug4EPUlLqK2EpYeAWvBEQS/OPz6pO5aTLGjW/Z97ExUbCSWlmPR75fmx7HJDGZUr054PL5nKlEvcNI1YjDi3uWQ4xOo9qe/WVerii9ryqsjTkF9f8peMAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Gma/S1Fg; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Gma/S1Fg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=54tjG9EAi82hYxgblnNVavy1R65gOHwf0Qd4xCoYibY=; b=Gma/S1Fg3euBZu048gAOJqJakh
	m5V00CV/yaQyZ13pQStQ1zm/3Acqwvc4qWAlqX/24Imj+x3SiRQyJZUi0NTAoYMbMdhTtNUhxP9OE
	n713+2hw/8zTHm++uuFEPCBJWGOcN77FPVNlFBiUNDIOP7lrUNfLCMe847NjIZ6Lwf7weUAKl9x2F
	ygLL0MWz1sUayXwifRvCsSyEQ1aFj6N2pizaHEKIg+LXFBQph5E/vr0K5AAMMXX415HZN7pw8NHJv
	aSM7vGx8csfdfyUOWiJ1/HN2uzR9Z2iacF6udBl7oNQwKaCPbw44k1goizWbAfdwlIClru4pemJ31
	hQhOBBrw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1soe8X-005cqi-7F; Thu, 12 Sep 2024 07:21:04 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 3/6] debian: Prevent recreating the orig tarball
Date: Thu, 12 Sep 2024 09:20:50 +0200
Message-ID: <20240912072059.913-4-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912072059.913-1-bage@debian.org>
References: <20240912072059.913-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/rules | 1 -
 1 file changed, 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index c3fbcd26..98dafcab 100755
--- a/debian/rules
+++ b/debian/rules
@@ -103,7 +103,6 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) -C . install
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
-	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
-- 
2.45.2

