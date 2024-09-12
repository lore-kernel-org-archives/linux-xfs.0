Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A20F18C92D
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126705; cv=none; b=D5WC6Bt9/B0iwP8v0k45PU4JQ854fayCatcwozjnewYEG1Ftta2/gGmfDlXnCLimX0DhGg28N8PiHH3RlXNs5HTLshZYzQrr8BAo1LnPSeDdNGziKQdyJnLKFf2lAjkGHwVFAopVCoMuFiranPTrHO/bcFD7S4ULPee/SXkYuy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126705; c=relaxed/simple;
	bh=zv8FlXkApm/6+aieah+Fctfu6hPlPZHXRIJ3hVKzFyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIGH1hUrKss7Whs71CsJtMOfUY3sAcfpACasVLPhIq40Y8q/EZsTtxVJbiECfwOy1DTW12eSnZzbx7rRKjs42xbkNZMlXQf8hS6bXPq/5m3YA8w56bgyDeWLO0qclTpEiiCUFukXpPixQp15mr9DYp3fXk2SZzd0xkJQyFzqrd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=NmU+sMvZ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="NmU+sMvZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=NtnneFsy22GAB+GBHEZSUKwjEqcF3sVcSSbAkgvuLo0=; b=NmU+sMvZ7lKj7BtuZ9NTd44cZ9
	6bPLg/x84MPp7Ec+Vny5/90tHcKkGIXqPAkvsp/NvRiVPORTnCo1d3TO0rfwVmOckevmKqHTv+NR2
	ivEyht4SGs+9yMqS0rTv0rsoYX/a5kmmEQuuR3mP+YRp33UP7jaRP6c+yHjhzAtZMiSWDlhLAeGwr
	D1kHZ4gC0mXjWKeknILRb22nBrBOhOqKstgCmV1TIgPueFzXUiKwtqBmitYyorvDqiWowr4IqF8Mq
	wKOnh809VunJ1LmZV1mH6izSwcgQgTCM6BkNdFJdtpx94bnF06SdrWqloBoRdukmTaeXCaYk3c7HM
	c3hMkcdA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1soe8Z-005cqi-25; Thu, 12 Sep 2024 07:21:06 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 6/6] debian: Correct the day-of-week on 2024-09-04
Date: Thu, 12 Sep 2024 09:20:53 +0200
Message-ID: <20240912072059.913-7-bage@debian.org>
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
 debian/changelog | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index cf7fcb4c..82d4a488 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -2,7 +2,7 @@ xfsprogs (6.10.1-1) unstable; urgency=low
 
   * New upstream release
 
- -- Nathan Scott <nathans@debian.org>  Mon, 04 Sep 2024 14:00:00 +0100
+ -- Nathan Scott <nathans@debian.org>  Wed, 04 Sep 2024 14:00:00 +0100
 
 xfsprogs (6.10.0-1) unstable; urgency=low
 
-- 
2.45.2

