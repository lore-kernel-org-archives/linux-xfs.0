Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6E330337
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769787761; cv=none; b=KGM9UZFpjZMiEwhfNBPOh/MSjMPFvxCt6bfxFcA4i7+VnsHX3OzAllMfMSdnLxh2EthvFMmVGbA/JhBoaFaKhBmsQ7prgfZCnJYTMIaUbXzlH6tLKxrPCsjYF6OH2oe9/OAiNYJmyNGTVJK4+7JCHFFm4jZkNE5CFZyVHTpm/7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769787761; c=relaxed/simple;
	bh=TmU2CI91+CKnD1d7i9FTmah+L2Qa3QAstkk72rpQ6BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGxuhfpc42St/HRc1AEN21vYbgYIQynRVvsmnUARV+rjCvPidFXgnxZ1zSk30P+NEz/0TV/0VaIidoqB7nx8Vui9pBsNESPP7cEhqbTRAGhaGTpBs/h9ety/RcXIZjooOSVAGEZt2FHI/ar1po2ZicNZr9CxiZxqMoqM8hY2ggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 58BF2180F2D5;
	Fri, 30 Jan 2026 16:42:25 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 6oFZDmHRfGnyPBkAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 30 Jan 2026 16:42:25 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] xfs: Use xarray to track SB UUIDs instead of plain array.
Date: Fri, 30 Jan 2026 16:42:06 +0100
Message-ID: <20260130154206.1368034-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
It was discussed in previous thread [1]. Some older kernels (pre v6.12),
complained doing allocation over 2xPAGE_SIZE in krealloc when mounting over
512 unique XFS. 

The warning was removed in v6.12, but Christoph suggested to start using
xrarray instead of plain array. So here it is.


[1]
 - https://lore.kernel.org/linux-xfs/aPhjZ4sfHngyJRQK@infradead.org/

Lukas Herbolt (1):
  xfs: Use xarray to track SB UUIDs instead of plain array.

 fs/xfs/xfs_mount.c | 87 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_mount.h |  3 +-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 46 insertions(+), 46 deletions(-)


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.52.0

