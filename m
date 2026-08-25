Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0796355F49;
	Tue, 25 Aug 2026 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636075; cv=none; b=OAHNpB8VgLPVygItkB0Awj40yNXMLdPCY1eN6ZtgfzoDNyrZMJ6ABsgkn1Uc8B+s1EYL5Vzi6taJqzx5Msr+Ud6GkkdgymfX6twk5R0N8oG6NSxoc6eZi6/88N6pruN03rWZ11BYCwO6WKTfxGH/lKiqLjwyLaBp8HK4vDnyxqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636075; c=relaxed/simple;
	bh=xosjd8POVziHY/e6pi1DkCienoJqe3AoSfiHvTSq6Eo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=YlfXnZnsuw5bIE/tcGJ12lKmvs6S6to0REGm1+w8rkn3PgmYHgaDd44j43lKfunwlvAF7la7D/7gOqVsxGo3WciS2M4eZ2PIgjc15WA/Dmu3pHGZ23xE/ragIKrcJJkouI5YfMVbZGL+YiPiGguUddkiCCEhJ0WsBOlEg9FwGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPPIjULD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPPIjULD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39D401F000E9;
	Tue, 25 Aug 2026 05:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636074;
	bh=O4LpFGFJz3NF5a85bqMNsl01nWM41Q1CE5gFqlmPjE4=;
	h=Date:Subject:From:To:Cc;
	b=iPPIjULDFICY215mUJpz6gw8Zr82uNiBMaMdrMMzOH8PmYUvjka1jPQobDJu1Pdzf
	 1sdB3jhAaXUqnZw1FCnRd6EkVOarjg2y4npsrRiJG9THo6/P2shpavnIHpK7298wvV
	 3a8HMbDydB00TXcOsNg88SamCn/vf6EVIlzxH4h6WIihYIVb+D6Kl3xriARbdWZ+td
	 HMI+hu4l2jlET8NyXevcl+TSQrcBUo8b6rJE8GHb9PeD8Td4Ya88l3Ci0IyP5W3xkD
	 r5pSX01C1AaWI9bSLUhkVRCTBZeDl50uv//aDkhk1yU49n8eN51NI2NCbVizOOPowL
	 53ksLtXX377Ug==
Date: Mon, 24 Aug 2026 22:34:33 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's an eighth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-8
---
Commits in this patchset:
 * xfs: always set xfs_healthmon::first_event when inserting at front of list
 * xfs: check healthmon outbuffer space correctly
 * xfs: bump lost_prev_errors if we lose even the healthmon lost event
 * xfs: report nonexistent parents as a filesystem corruption
 * xfs: destroy seen inode bitmap when we fail to add a dirpath
---
 fs/xfs/scrub/trace.h          |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.c        |   31 +++++++++++++++++++++++++++++--
 fs/xfs/scrub/dirtree_repair.c |    1 +
 fs/xfs/xfs_healthmon.c        |   23 +++++++++++++++++------
 4 files changed, 80 insertions(+), 8 deletions(-)

