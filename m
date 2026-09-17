Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEAB4B1CE3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641405; cv=none; b=V0BBnrvt7mxLiRvJ025N2MrCaCXNAAbfQrKEnmZrzT4R7UG1EAAscF68NXK/loDLoj8o+CbmuPNqioTf+PY/+swFq6rmljOw/zmyRz8MXsKZNYWF+osX2OymDEbKoUtnJGi7ZEzeQFbwEoxfLMJlMg1Li8RTpXBct9nCqdvB2sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641405; c=relaxed/simple;
	bh=nV86zUNbWb3UA3/89ZKnhczMM7UcyIXiD4hHYjU4bMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjITb45FQJBgJs0w1IommbcathGC/8Ub+X7LJfAN4ToikN7Hg+Kmmf3bEaCxAPV+ZL8plE207BBkXbA4I5UtfdZKLo5jpOvn0QyXZ39tJLXDKyvKFT6laIS7McxfDBBO06MfseL29Pxn69MFxOU14Yyhxw07XF0sdtc52Oyj4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWuv4kLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWuv4kLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8231F000FF;
	Thu, 17 Sep 2026 10:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641401;
	bh=9GG/6rRO8ZkDDycX2fVCooKfvr9RR5M6ENZmlKFvq/4=;
	h=From:To:Cc:Subject:Date;
	b=bWuv4kLjASFhwSQmzDYcv50rmshAJJrVYxg2OdKE4IEXmoaOsIgTDbhhzBX0xYCKP
	 I2O/WOFxG6dGM4rG7UW2YSY5U/l5YSPlD8rGZL0iSodLM9hnAEEfNVbBCVF0Ryynhz
	 d//uEmarZJ259WgBt5waPcHFtq6wWa+lYoH4Xi63tvyaOm/lH7GBUx3sqWzcVup2jj
	 MGAgcCiIMnDxKzSrLeZFIS5tGnzwKDIUgKt6LeUlCxCdyIAV02L3rgFrXPMhKKaHe7
	 8wXvxIXFWJVormcURpH8whqDZBV/6WWhoaP/VBK/T3ccRXb9DPNfNsc4IKXkAi3aRJ
	 Faw9xqcxXAQNA==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/3] Enable xfs error reporting to print out error codes
Date: Thu, 17 Sep 2026 12:35:45 +0200
Message-ID: <20260917103633.14703-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hello,

this is the V3 of this series addressing last round of reviews.

Darrich, I believe I addressed all your comments, could you please
double-check it? I kept your RwB.

Carlos Maiolino (3):
  xfs: add xfs_error_report the ability to display an error code
  xfs: enable xfs_trans_cancel() to report and error code
  xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

 fs/xfs/xfs_error.c         | 16 +++++++++++-----
 fs/xfs/xfs_error.h         |  9 +++++----
 fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
 fs/xfs/xfs_inode_item.c    |  3 ++-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_log_recover.c   |  3 ++-
 fs/xfs/xfs_trans.c         |  8 +++++---
 fs/xfs/xfs_trans.h         |  6 +++++-
 8 files changed, 37 insertions(+), 19 deletions(-)

-- 
2.55.0

