Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A91BA894
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670214; cv=none; b=Gs8gmUU/7vQVjP6JYf9Dv13zobIYCTeJFizgVxxf4L2HUnMZHpmKFWyanQWNNElWyPTYZQSZib1n/0p2XYodkuDGoIPhXO3Qo+Eb+DDFIFsbY7Iv6eJV6XEpVacJoTFF34Ijxk+JliFqGxyWgfRAwl7esz+RPY6O+6/rzRBzFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670214; c=relaxed/simple;
	bh=eY7zT2BNZN5Itz4NCkaUgCVtr4k9pMT4ju0kohFyxQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4DcW9WT7whaKxkibR/OfKVAvITfrEZZwk9Q8NrPi6gsZevvgbFLSrBhNJFTC02sq9mLQi1/ybho8WkefdKb0pjn+CZyuSWoSXxVEqOYaiTFG6IHdUMJhL8X8Hr4fnCSDxliyYMJLJlcTrAmeIIuHl4nYaledtTnzpRMizEj6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=YfSM9md/; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="YfSM9md/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=F7VA5xYVaYa/zzeOoKJ8TZUld/dtA0ml2dDfS7eaNm8=; b=YfSM9md/mNirupfVYkSstbMmqZ
	VAJfGMA3oNlYaCaw1Qb1sb2BoGF1+u0tAslqbuJmIM/AFMZuY3KBucACsHcrA6VLn6FlmolQ4OOZR
	Qrgx7VylyWnCIz6/I/Mbjw/6EvWHn+HxwJv+0jBQIiHo1zH1M+oQ6SPjWphFQ51hN1GiBLAbx+qmP
	J1wTvvgmb95oRNDfnEItLboxQ+xUnFHcr2QYROOTI8E7azmWmGiD6M86BEvyHwgVQD9BknhD2+Rqn
	hYxKX12gvKVhxD7JBItQ9JPq157A7QKOlJ/BzP+g3xNY7dl1fj7ZS6pHTBrzrc+rGnFzePPneMxFd
	p21aqHcg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnQ-00B7VF-Jj; Wed, 18 Sep 2024 14:36:44 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 3/6] debian: Prevent recreating the orig tarball
Date: Wed, 18 Sep 2024 16:36:15 +0200
Message-ID: <20240918143640.29981-4-bage@debian.org>
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

