Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D6E3ED13A
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778085478; cv=none; b=RqhyMqorkP52kJatKacEfVPaDlEmouJDcumCtOl15XKN2QttWxx04CzfkNqK2dQ2k5n9JvTHdK6G4pitohRMedKP/vYhL+vNxbgRivj9KyixEmE1nLI0M5L1RdDccrc6163lf/Gqq7Cs0hMS8Vo+R7Ywl1AoTke9oB9UgXQqb58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778085478; c=relaxed/simple;
	bh=BiDULfpSXzqFNiqzNFOouxWydTWf6mbSpNyUmhFQxSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RV4WokWFxjh/FhoUWvG4ty8mbEnr8lZS626mcCh/aGYnTdB68OxvCOM2cWNc8st5NgemnovGaGTfF0L3W9IiYst1hT3uie50D48My8libpi+C7LGUQ6v7fhIeCob+bWNaD2xKpMVOyXgXdxRkqBl9A2z0T825LLN+8YfATuYpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKTd0SkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKTd0SkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D020C2BCB0;
	Wed,  6 May 2026 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085478;
	bh=BiDULfpSXzqFNiqzNFOouxWydTWf6mbSpNyUmhFQxSQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZKTd0SkOzv/5uI3hoFNcZu/pzstvnWRr/7hs8Zz/1R8eqwpxShxC5kVMzkEvWPHWK
	 sJK/qsBJZpKvAG87tLIxFSAiGthg/4QWbsIrVFBqxKM7Qseac5/OUDbEidadXCyZLw
	 1DEkefImDE9d18N2xt59v42+Hj1xQiTS2sjZsQwLypwzZXOz4yfCJ+c47903DY9Dna
	 mKsVyU/LdNHKm6+gxu+WRc6WagXfX2xCCw2zC1LJ+SSeVsoLz9vZXTMxpjVb7WYNJl
	 Jor81MQOZmFmQJPUgDcxQciDlJIbSLwVwg8Zamu9/tPROAKvxwtkwgH+KQTmo1bVqt
	 j//QQqeoPWHBg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/2] xfsdump: improve tooling
Date: Wed,  6 May 2026 18:37:42 +0200
Message-ID: <20260506163746.1083845-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

First patch fixes Makefile for systems with read-only system packages.
The second patch copy-pastes release.sh from xfsprogs-dev repository
with a few minor improvements (I will send these for xfsprogs too).

xfsdump git tree:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsdump-dev.git/log/?h=better-release

Andrey

Andrey Albershteyn (2):
  xfsdump: fix permissions on files installed by libtoolize
  xfsdump: update release.sh

 Makefile                  |   3 +
 release.sh                | 197 +++++++++++++++++++++++++++++++++++---
 tools/git-contributors.py | 168 ++++++++++++++++++++++++++++++++
 3 files changed, 354 insertions(+), 14 deletions(-)
 create mode 100755 tools/git-contributors.py

-- 
2.51.2

