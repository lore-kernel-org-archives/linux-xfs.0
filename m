Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259F8342510
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971221; cv=none; b=m87x78vQFiRauiLbFtkCVOr38MATlrXFMbL8awgH791QGw6NsW4A7USpx88gSskOhBiCN5zLBjykbxVRPT1E4V2oVVZyQzPJkPu4hBgwHTOz07nEW+dXC/fglbA+CGA2sj0g9fVnTEpFYsrNgau8UuVazFm1FpYRAVIicWcK1ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971221; c=relaxed/simple;
	bh=Hdg0pEQHqsOIcitnOeiVFs2R8K6qvrLR1Sx2RtWVQFg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=uW74pKdwlN6T7hrwOFHbqYcyz+kRSB34b2JlZiS6lf18ygp/WyIzo+5cFJn3+iLtzcfvTR6Ps1fSiiu562mQCmmToCjJTyAea9JuZiSUXNs7H4EAZkRHTy9mgSJhj2anP8sry8uyPuId+B6iN0iWGeet0hFLnnKDFGqgi+hu9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJEg75lH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJEg75lH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD7C51F000FF;
	Mon, 21 Sep 2026 06:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971219;
	bh=vJYZjq0hlslgiZz6TJyv1rjinm1NW/Vh/1wsQASMYWY=;
	h=Date:Subject:From:To:Cc;
	b=dJEg75lHDrEr1vt1jzl61UN9psSX6xVxci4BtW4+bD637hGbRj60lORozNRS0wnel
	 +ElG7IkXQBRA9M5cjd+7csCfRTLlS1CVPHHWdWJ/4zZ28nF5Vrqf1yuPyNq84Fxzdf
	 FoCr0JMH4XK8Z0WdBCk0V1lIgCC7FpswHKpYXBIxMWhoRgl5Dew/cIQZqnDhDO1wQv
	 TMAzpvSStQazjY7oUntRK0JYeZ/OLWAC4ksXnou0aPXibEFgLjiTA+XNHqRlp3oYFV
	 p1KWxdni1h1e+V97CmWAYXNVQOUA2RXp6S/FdEcLCt3KbQNblCNtkZZFQtFZrkpwCs
	 5UFt61skVCNEQ==
Date: Sun, 20 Sep 2026 23:13:39 -0700
Subject: [PATCHSET 1/2] xfsprogs: various bug fixes for 7.3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series contains miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs_scrub: terminate systemd services if the sysadmin unmounts
 * mkfs: allow disabling quota flags
 * xfs_quota: fix XFS_GETQSTAT parameter pointer
---
 mkfs/xfs_mkfs.c                   |   42 ++++++++++++++++++++++++++-----------
 quota/state.c                     |    2 +-
 scrub/xfs_scrub@.service.in       |    3 +++
 scrub/xfs_scrub_media@.service.in |    3 +++
 4 files changed, 37 insertions(+), 13 deletions(-)

