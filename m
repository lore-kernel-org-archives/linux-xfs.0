Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364EB51AFC3
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866244; cv=none; b=gzh3VqbJ942RYL9xziKa00Mvi+JQcMrMFBqMbAE5JTlwEwn4UXrmFkjM/8fAeuGVnI++eYTldnFGQo91CpgsmPs2O8co6rwQAt73JPDd93DyjcnbxzS4s2U3P0jFbRyxria8PJFjOMrAqQZmZjh927MOSk5TTwX/WZbSM+sgv3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866244; c=relaxed/simple;
	bh=02ycDkwoPsG/bt2iNBw4mY3EnJQBVFI5ezaihxrf3c0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=MlLm6EtGjEooBgmxtUJhS3juGqiimHpdtscc+Wh/pv1eSshVmd9adfKU04ZweW5pe61Nmf5tdaDLoHXgBndgLMYjYUmsiYRHt4KKkfLQDvI5QRATLMNOf14/j2OtL1l7xJfdWeVL6CDN0q3fung1AL6oHh5Yt3TRgPuzTbgdfYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIIz/kK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIIz/kK1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B221B1F000FF;
	Thu,  1 Oct 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866242;
	bh=M8VVMDcC0bVeQitq1VzUA/8JFx/2Z9/gKvtdjru6L94=;
	h=Date:Subject:From:To:Cc;
	b=NIIz/kK1b9kN5jWH+wBW/thBPc0odiyu7pPstejjj65bYPseU5tBx0VuKiubYndzb
	 CWvYq9BfygRJ7eyiKcz/H8ZT+oyImt1MS3RZg5dgYbWE8m7Ady5VWtgDIWDtFAlQW6
	 35NL1m1EeFMfpK9SbLyGLcfJckuZ56fKbCFxW9UE5+FQjLeXFAAN7kwzwVXg+xtn/b
	 aIeIK1YvP8nUUwGsBEmpmVzJ4chOO3tml/6htNLAYjNqGQoLhCvDW/LtUB625lhiWd
	 YjYwnC5EJJV/keD9qPB4Yr8u/FpctWDFNah3e41Y7RbRMbXDdWMSvu1TR9lEIm6bPb
	 WDxRkiXOtNBww==
Date: Thu, 01 Oct 2026 07:50:42 -0700
Subject: [PATCHSET v2] xfs_healer: fix a user-reported bug
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, 1149571@bugs.debian.org, biebl@debian.org,
 hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This bugfix series corrects a couple of problems in xfs_healer that
were found by a Debian user.

v2: fix xfd_open callsite's use of error return values in addition to
    fixing the reported problem, per maintainer

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=healer-fixes
---
Commits in this patchset:
 * xfs_healer: correct xfd_ API usage
 * xfs_healer: fail earlier on non-xfs filesystems
---
 healer/xfs_healer.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

