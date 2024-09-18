Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA8A1BA886
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670213; cv=none; b=jBGokZ8cv9EHfmv5V2XdvAsTVqKfv6q9tJE/w+a8etTfsVXQWN6/aqWsyVDzbOy2zS/rMi0mZhCHocKxr59QlXeWTRKBJw2+kPnHjb78pv80813fY9997Ht2ooP7x/IHuP+5niuRpHPjS56z+Wp2e1l5vUgQ0zf3WuX6/WrU4Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670213; c=relaxed/simple;
	bh=5Lmrge2FRLMR1Idv9U6kGYvYjFkPXKOjytpn5lRal0w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/lUQ6m16OfsBaTOnyO13zrQ0JRg3SxC++SsK9I0IlkwcYl9S6BiD/X8hdPS//o84BEGrIu6alvkjX+sBP1tCqeKstCIcDMfoK6jYbqc8wdnHQnVTJI1cL5g0M9WOJxxQO8J5DNMkyB+ed1Plu6U583HDZqufIsTDcCLarXkRxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=UBxqWFvo; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="UBxqWFvo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Abv7hhrk7eVgGnlO/chZPG60OHaRx3vOteGPG1aHDsc=; b=UBxqWFvovJfqaL+146PwMdeld8
	N3gYYtZNzMeKx0rt7UZ1WoP9GFZjlAaR20EOwSGIj0OP78RWaZsRu16PXss6cK/gPeJ3WwfU4x9rm
	RhMPoQpwHLBFdD0ySVe4AkLCW/J3wGaqX82RNUName0L62rNWLqHsQRqsJi7tU5nJ2pK/4l+DvYpz
	QRiL9rSGsYJnzbCYhPsnzGxEuJKNudGA3rp1jVAr7tiVR998ftqE8ZcMrEOL15sSaD3r/kXyBvJVw
	FfNjREGC1po0eAWPszI5PMlLmhs11vY4EQ5Aki6Ecu7nkZ5FOC9IfSaTSYypMQHrDjn6OpzYCptC9
	bxl/zLpQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnP-00B7VF-NN; Wed, 18 Sep 2024 14:36:43 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH v2 0/6] debian: Debian and Ubuntu archive changes
Date: Wed, 18 Sep 2024 16:36:12 +0200
Message-ID: <20240918143640.29981-1-bage@debian.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Hi,

I am forwarding all the changes that are in the Debian and Ubuntu
archives with a major structural change in the debian/rules file,
which gets the package to a more modern dh-based build flavor.

v2: Let the package build on releases that do not have systemd-dev

Bastian Germann (6):
  debian: Update debhelper-compat level
  debian: Update public release key
  debian: Prevent recreating the orig tarball
  debian: Add Build-Depends on pkg with systemd.pc
  debian: Modernize build script
  debian: Correct the day-of-week on 2024-09-04

 debian/changelog                |   2 +-
 debian/compat                   |   2 +-
 debian/control                  |   2 +-
 debian/rules                    |  81 ++++++++----------------
 debian/upstream/signing-key.asc | 106 ++++++++++++++------------------
 5 files changed, 75 insertions(+), 118 deletions(-)

-- 
2.45.2

