Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7681BA899
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670214; cv=none; b=ACGtA9FmOyGrSKgooGqoYPcuxS1ZSJm9v3esM//lKAhsrrRrNfJZvLA5e16Ik4lXnvqIYYH/TdcSUbH1wJTA7twtgkBrJKIbjTeVfy97JiPnewc6aTeFI7d+F+Tzc/F7/ETnkWyXmk+KJ2dLToq0dH6RF7PEfkcGFEg2mSylAWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670214; c=relaxed/simple;
	bh=N9UTrbEemOediUMCqKHtMKeXJPbDKeu8r1+2OHXp0KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igk2lS9j5L52eXz100NSdDqIVAtFlNVKayDUnWn9XVQb4k+A1k8iiraOUy0KCfgYBZy5lNvm9I5It7HKLaxRrHZoXnRpqhrhEr+CK4n9b1QTLceUfLgcn9ho2hbzBOqoLAh1vM3yoCNuwLcIR9IxJuDiKoZdWx3t6FQidOpnZfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=i4hE29Z1; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="i4hE29Z1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rwXC/nitC5e3o4Agg8rpmTQAgDktB76vaVEZZVcp3Dc=; b=i4hE29Z1Wx/PXnCIzewayjE0UN
	fN4+Tsc38ZdjABCbNveU2ZVxIKVzXh9xa1NFobrXj4t3rvl5cxOTsFoLJKCmjFDHfwdmekkHHpwoa
	AWTYp4O7b1oYSMt3hVgrZiu+LC2TUUe7RGcXfCvGbpvaaThvTV/E/3otDdjFwLhRF29Jk4o1NYDDg
	BKIv6FN6vMQpfIdj88+rJ6ug2ncBQ/M2m2s1oCUfQD4/VI8QcUhSAp74KrFD9nlDme1M7nAuhW4ZY
	Uz/XFLP4q/YQPnGHYczAFptQqwbtEbvgAWhFupzJgc4ImZmP2yLlv7Os5K6iL1Hyphw2D/6P+wyJ4
	TAQK2Xow==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnS-00B7VF-DS; Wed, 18 Sep 2024 14:36:46 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 6/6] debian: Correct the day-of-week on 2024-09-04
Date: Wed, 18 Sep 2024 16:36:18 +0200
Message-ID: <20240918143640.29981-7-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918143640.29981-1-bage@debian.org>
References: <20240918143640.29981-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

