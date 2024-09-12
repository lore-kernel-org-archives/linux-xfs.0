Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22AC18FDAB
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126717; cv=none; b=iRQ5mw9zIso+H7Px1e05Ksq74HbS2VgcNL1OIQ3YZxhD58bxxg06bbT0EM3rd6BYEVXEdpIVS2aN2kOV+ZnlN2akCapyz+m/RYOl1OMfLRLwtKEvTQS3S+1KtI5K6QTArB8tV9HExQy96imZKqdHGauOXXUPYwNVxf9F++wbMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126717; c=relaxed/simple;
	bh=fqBxynk4Es3e74L0eg4okwsb6TAncM3I+/iswBmor/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cAx1tTx/ToSbCacboyFRI18OyOfcmM7DnSFThxUiELOr3PEwjgx3iJpz/Q4ZFJ9f5txjeIfwbvj9b84HKNo7hMrkc0T4DvxNFOvoOpDOTQGmXFk8vEWXJRNhQ2dIXxOXUVrH9UMCrLc7R5ktyCuleKDkoWVzxFvhjbC6FhYdTxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=mgpXrN8h; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="mgpXrN8h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DR3RQQKXaJRcRLHbqR0gmR++mUyDXKynHRIn1o1u4TE=; b=mgpXrN8h7PiflGMmadsr1OBua4
	CBfGSrEsOwQpsdAL1fyTfUzJppTNNaGbmx6+KbSqK+OPahlJx1msW2n0/ujIe+ey/4zkeQi9d80Q8
	1KyaVznZIyGtwpoUMa7eVGK1WDEr/4YkwKaH+lbyO3ae1UTGowgokt0spKgJRl3in8YBGBbepXM2U
	Fe7D5YoVDtNGDXq3dJNEIxDxHI9COgIfZR35NH9EP1yjBcTZ5Qw12/ympA9O2AkxuFGub8eW4Npj5
	6lLq5TBBEK8afHgnw0w0oxTDnYHuY23t0Y//X3NgOEBY8jkg1c/ick1NF3wOn8sLRB/YioZNM4E+b
	Qq7BWlwQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1soe8W-005cqi-0v; Thu, 12 Sep 2024 07:21:03 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 0/6] debian: Debian and Ubuntu archive changes
Date: Thu, 12 Sep 2024 09:20:47 +0200
Message-ID: <20240912072059.913-1-bage@debian.org>
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

Bastian Germann (6):
  debian: Update debhelper-compat level
  debian: Update public release key
  debian: Prevent recreating the orig tarball
  debian: Add Build-Depends: systemd-dev
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

