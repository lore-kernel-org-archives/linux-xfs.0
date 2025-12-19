Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CAF2C030E
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766135821; cv=none; b=QAEJCUfc65zaXokmGVH2UJyoXqpEl+EQCt/fISCbQqub7pyHPKrfpPYOaDrXAYuq42x9ETCvUbZGFrw5ctLCue5LUTfxO4iYH/6+jOpDxlUnqchg8qo8rbd8hlFOQx2XWpwc1cXskLJ8aViIZRdWsW+D6YeTufTQCMEUR13cAFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766135821; c=relaxed/simple;
	bh=cItz+iAG0FV0aM6TLLSafUzs0rR6lMs/Isav1Ngn13M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FcSQusuKV2ljB+DBkgVRq1iY7ey8HHx83cTwvj9bAvzPufmF2a2a5wq5ew7ESS0ZpbkGtrR/FtHHwi2rrnhesEYd5zx4VQZf3RBuvCLjQieb0L2pN07xpn0AaacEKUG5CRONT4FllAInIpfHZGXs914MkqFN1XUZA7zZBrl70DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJwqfIeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJwqfIeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F80C4CEF1;
	Fri, 19 Dec 2025 09:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766135821;
	bh=cItz+iAG0FV0aM6TLLSafUzs0rR6lMs/Isav1Ngn13M=;
	h=From:To:Cc:Subject:Date:From;
	b=UJwqfIeVoWvC6NyWh/N64tlsV8ZsS/oJCo6s0DP5Co9/rgyIrifcevkoNk9jeJuyR
	 LYbfjvgdUMSpNRi5J/TqEQQpCK5ZdG0ZeJc+A1fPZz+7NgMSOLwNXGN/48mftNoo5P
	 CT2mrx+lxIAEuo+V3rigfWf5yX4X/dk0wmzZN6+Ha61BcTTvf6+y8PSR51nJT9KEUO
	 cr5iVjuDHvkSNzm6ccnOUc90XsE/eV9CBPAt4NpncLzcCidDAKeoy+1Kc3aJ6GeLkR
	 rxbxHDIxmRWSpM3fT2uUS5OCuVPrRFXwds/lmHKRCYwEWiDvzzCC3NHAIcvEF/iioj
	 LkjNxQMsyHvpQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 0/3] Enable cached zone report
Date: Fri, 19 Dec 2025 18:12:29 +0900
Message-ID: <20251219091232.529097-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable cached zone report to speed up mkfs and repair. Cached zone
report support was introduced in the kernel with version 6.19-rc1.
This was co-developped with Christoph.

Damien Le Moal (3):
  libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
  mkfs: use cached report zone
  repair: use cached report zone

 libxfs/topology.h | 8 ++++++++
 mkfs/xfs_mkfs.c   | 7 ++++++-
 repair/zoned.c    | 7 ++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.52.0

