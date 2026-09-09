Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00CD23C4F3;
	Wed,  9 Sep 2026 06:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933772; cv=none; b=aCYshGyXd71OX1+Y3r9XImO7kGqElRilOZa7Nya9KHtxs2n9XEo1fbC21quWDpid7Q21VZv4lduAcy3qnwMCpZspZeHjG3VB76MPrfMR4SkY/1sKa4G6rRAfcdxYsVRLWdiNiPJKX8DgrLs9/1NzCPjeHSzIrqqCdgIELPQcyGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933772; c=relaxed/simple;
	bh=JDG4tJ3Q3YdoOoNeTt+HXP2MmqStTXKcx0FiJvY2SPY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=VYR/Pb2ZuV+cvMFJIZO5vkmiDuf2k/no0KM5MRlbf2VJan8J5reJrFvzXukYCDaKqaWd6a8r0yO1sJ7/EknaEm+u+sGFftE3wV6kSoxXBkujf90AHb8SCoG5niQzUxeEk3fthBYeaI6AiawA193+gaCK5dpIHepIflnyeuIJh3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iN97APRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iN97APRx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BA721F00A3E;
	Wed,  9 Sep 2026 06:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933771;
	bh=kkpvFFFtuUjS6DM1M9pl2zRaBgvSuXkTaQs94dcMjAU=;
	h=Date:Subject:From:To:Cc;
	b=iN97APRxejT00/dwOPhHQ+ekqIy0CyzJoQde7N80G+7ZV6WSCE+MppKwkreJbnMmg
	 fH2rm866jyEYZX3ylCPUDUSyzSBUHtvwmvv6mRnjr+h5yxchgzdKmqDe9xEyWOwvF2
	 ybMlyKtBnoci64BDBisX6Bdm8HpaFV+mGNCdldBs1Ji33N9Q3MXRqO0IMAA0knxbEN
	 4rwVLYpCBjJIYOVfAaHF5lC2cHiySrzeAuiYuoWC01Ty4Ym23F8L/Lag1wRYiGQfhQ
	 JwLRhWvWkHr+IIi9kv4a/WdvhrOzewH46uJh2pWjeMta89aedaZFh3+HcDdWZxVxlB
	 jvepP7/0mXqjA==
Date: Tue, 08 Sep 2026 23:02:51 -0700
Subject: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 11
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's an eleventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-11
---
Commits in this patchset:
 * xfs: snapshot scrub stats when rendering them
 * xfs: report healthy filesystem events in scrub stats
 * xfs: report runtime failures in scrub
 * xfs: remove redundant function declaration
 * xfs: snapshot old AGFL before rewriting it
 * xfs: bail out on bitmap errors in xrep_agfl_fill
---
 fs/xfs/scrub/dabtree.h         |    2 --
 fs/xfs/scrub/agheader_repair.c |   41 ++++++++++++++++++++++++++----------
 fs/xfs/scrub/stats.c           |   45 ++++++++++++++++++++++++++--------------
 3 files changed, 58 insertions(+), 30 deletions(-)

