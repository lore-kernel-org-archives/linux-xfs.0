Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77BBA923
	for <linux-xfs@vger.kernel.org>; Fri, 20 Jun 2025 07:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750403301; cv=none; b=P1a0PQMmkDWHUfpjagAQtqLYq1cPWJP5Z5JP0agYfTOEvmlxX7/iGObdEKfPHAbzYvb6mxwCfVyoHLhEq3pChBftQl56FxzqBVMEurE2G0QvR+hU0/X/ewi9PZoRrhXbMN0BmEc0vA/1YXg8XZipwFe4txjODXw6/vvPBuvF1Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750403301; c=relaxed/simple;
	bh=umgLHsRgkXmVL/mrL02uC8Wte2b2wubvmFPh9H0pdyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e4rHOpb0e9fjrOZ8+FKWeDibjWWGJwq2jS6oMEB5PwEqQYujreoAnHQKe8eykF1eFj3XR/dAsmXzP8+UtcShV4btbkOH10J6ogcod3cO8jW+kScKIqA1rlyocCZpE7tpqf4alr9qgx5EV7IOjS2WEnwxDi0t3VpzmwvqrH16j1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuVaCq5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuVaCq5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEBAC4CEE3;
	Fri, 20 Jun 2025 07:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750403301;
	bh=umgLHsRgkXmVL/mrL02uC8Wte2b2wubvmFPh9H0pdyA=;
	h=From:To:Cc:Subject:Date:From;
	b=MuVaCq5zO0o2MFuC+GWYHbP0NNdneWVQC0y8q958OpNy7XebJiNLesJCPj60TDRCS
	 2fhiWbBckXjDUkTNVcbOdR5phs0dUo49jSEFsD93SdvCPahsKsua9tq6xXW9e9o0ki
	 fVti5W6ncJyS6xfyMs5djrR+8lsUs4H0a/GsJTq8Q/BMtd60IKMgSW12rD+a/TaQbg
	 wUX9Y3xQtpoOMftXbE57iEwQ2LrTbBqyO8DDG8VAQdcgZTgAnqAJYAgWbJ55O15eJN
	 oLXvtmrRcmANwWUjWgLjWefJ8MPOMyMCilKyHzebAvxAXOetBXl7tZNNZOIHmxtYe1
	 +4V8SvikFL/Vg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 0/2] xfs: iclog small cleanup
Date: Fri, 20 Jun 2025 09:07:58 +0200
Message-ID: <20250620070813.919516-1-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

I noticed that the iclogs circular ring could be simplified by replacing
the current infra-structure with the list_head framework. As a bonus,
another typedef goes away.

I've been testing this successfully on xfstests with no apparent issues

Carlos Maiolino (2):
  xfs: replace iclogs circular list with a list_head
  xfs: kill xlog_in_core_2_t typedef

 fs/xfs/libxfs/xfs_log_format.h |   4 +-
 fs/xfs/xfs_log.c               | 136 ++++++++++++++-------------------
 fs/xfs/xfs_log_cil.c           |  13 +++-
 fs/xfs/xfs_log_priv.h          |  13 ++--
 fs/xfs/xfs_log_recover.c       |   2 +-
 5 files changed, 76 insertions(+), 92 deletions(-)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
2.49.0

