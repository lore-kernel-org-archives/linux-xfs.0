Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30ED10FD
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738573470; cv=none; b=SACS/9UpZ/GPVCd/B6r7g/ovVWvka6uoiPaxfy9H22iCQZwOuZHbTktdGqnEErTbBTsIsUCxPAd0CLqBL6Ada2QAjqBInv5diStnfbXcar7GxREsNqgfVTDEaTIwRjxqv+rSrZKoTWgTztQEWq13yAU5EX344w6v6LZt4xGWNRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738573470; c=relaxed/simple;
	bh=w1Cah0wh9wPURcPGAg2/kwc/yMfMFCVmjk8N6egi+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bi854yuR/05FstKqKlMQAN887LAOVqk/GgkwZ3cl23AZw2BseA7RDSH2wdzv7A5AiER6uzPZVsmMccEOnssFqXJ9Mqm2lCTof7xCZKYSr2Cfi8sGn3isOq4okqlrK97rs4cxrA9/92E7KtgCRpUiTXm0iN+PTqrXiB2GN+CDRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 5BF0A180F245;
	Mon,  3 Feb 2025 09:56:53 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id mEG9EdWEoGdxJQEAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 03 Feb 2025 09:56:53 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] RFE: Do not check NEEDSREPAIR if ro,norecovery mount.
Date: Mon,  3 Feb 2025 09:55:12 +0100
Message-ID: <20250203085513.79335-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
I disccussed this shortly with Eric Sandeen. I have came across 
corruption where xfs_repair fails and the only way how to get at
least some of the data is to use manually clear out the NEEDSREPAIR
flag. I do not think there is needs of checking if we are about
to mount the FS with norecovery,ro.

Lukas Herbolt (1):
  xfs: do not check NEEDSREPAIR if ro,norecovery mount.

 fs/xfs/xfs_super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.48.1

