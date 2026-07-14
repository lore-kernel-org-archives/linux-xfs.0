Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F2A36A033;
	Tue, 14 Jul 2026 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009044; cv=none; b=arQqcJZmjjSI3ZML9LTXsXydUCY+cJH0xAMtJy8P3kL11T+e7XqrUyamfXd0gmqyWfFguGbH7u3K3qN22Cb21IPkCCcZTKBoCExm8He+lqEhXJZRVcms5ddBLG/c+mE6pehkiaKuTGpimKiZKqRvIrG5IfQZVazxgV7XUbDTWOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009044; c=relaxed/simple;
	bh=XEet/Yhf5u+Dah0mMfPPmN2UrgcXmKkMJom1pIG6asc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=eNpv3q0cabubpKitvFBSPb6uecOtjeJbuvPpMSQaFAzuL4utSqjDcx5Owplv2kuu8d23x5aAjJHyJW7IBrq0UGa3FHB/m/vANujZ3xUj6bqQDNp6e34cu9Aa7vSVViIxTmxpno1QK6FhNL7NnWOpunuqLlfX4Wh8twPdQqhrFhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebEQkADR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebEQkADR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 639C71F000E9;
	Tue, 14 Jul 2026 06:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009043;
	bh=/mwz+MuzSS8mjqhjss8aYLDK/ZKmFw0IGY09/TVcqfo=;
	h=Date:Subject:From:To:Cc;
	b=ebEQkADRaylu333yHNGA8Pvw77UX9o2ybnvRgUhwTj9IeDMjUvZgsn51XEwpkfs+m
	 AdplLaToJ2H0irECimJRLnLqzMl3LtP9fg2X/ZsTcnNoKTa9IJd3e3Rcn6kdBuIt7C
	 8JS33cLrm5hDHkyucEjUoFoqqvRiIR25E/D0RIxF5QcnF78CJwYtnC+0LCR0WP3VFU
	 U78jM6r1rfUV+2sA3aBYHSBXs0LNVIXw80skO0KOQxxuHNI/O5zElCE/QO8GAJXA83
	 yxzJWL5iNPAhO5yrn+7IzXzlUrn8GbqVFWFo5G77vQ7r7zki5AMPjQOu7LR+/xv87Z
	 tsF5Ws23BZpDQ==
Date: Mon, 13 Jul 2026 23:04:02 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a second batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-2
---
Commits in this patchset:
 * xfs: set xfarray killable sort correctly
 * xfs: fix off-by-one error when calling xchk_xref_has_rt_owner
 * xfs: handle non-inode owners for rtrmap record checking
 * xfs: fully check the parent handle when it points to the rootdir
 * xfs: clamp timestamp nanoseconds correctly
 * xfs: don't zap bmbt forks if they are MAXLEVELS tall
---
 fs/xfs/scrub/scrub.h        |    6 +++---
 fs/xfs/scrub/dirtree.c      |   16 ++++++++--------
 fs/xfs/scrub/inode_repair.c |    4 ++--
 fs/xfs/scrub/rtbitmap.c     |    2 +-
 fs/xfs/scrub/rtrmap.c       |    6 ++++++
 fs/xfs/scrub/xfarray.c      |    3 +--
 6 files changed, 21 insertions(+), 16 deletions(-)

