Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182E229C328;
	Thu, 27 Aug 2026 05:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808661; cv=none; b=UgtLyICMXLLzIz4MDvi3b12DrFQ1YpjQu3UXT18IQmSfdDy4M6iZcucuz5Dzov6/rJibCZNNkDATlKAYD1DKwuixLpqoZrBmVHPSzk80l7lchG+6Sdz1ZqKy8mIUAwv9iqLkWbjp2XMOrPBtGDt/EBZjRNDBTLlGw+yCd2EFHyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808661; c=relaxed/simple;
	bh=/sLwpOwtooIuMLyFMl+5ynYBBE0vFPMti5rKAwuVcjw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=FGMG+Qtmx7dOZWkjAGBuHjAWrWsp3xg4WaltFVK/qpSDnz5LdCjCHGet5rOBuEmm5Ki+sc7RcAPSflAe8H6bjjX2Lc40L8oDT8hADW5SaJ0kFXD5FoolcnmAZjcFLMJlfOISoogb8sEKOVrhGbDQgrUabXJZ6pUB5wJ1jmJBNpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aL+/H9KX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aL+/H9KX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 960141F000E9;
	Thu, 27 Aug 2026 05:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808659;
	bh=LpqMh3hqO+x46vn7icJFaTNQIyGH8oOl0P7AlBm+GZc=;
	h=Date:Subject:From:To:Cc;
	b=aL+/H9KXZhyENxfIK7dpyxiJyYxWzfaNQQZ0hQ9QZRGmPDbZJUAVhu7RvIex2MF22
	 c+PFtaU9ay3n1CXftzpnwvLQ4ve4p1awHt2Wfc6CZ3V34Q+CRvX2wKmb1Y12K+B5cS
	 C0mXrl5b2VQDp818JZR7wzY/Nl2ak84/jwaXAt1LzoVTx+OfH7xw8JGkxaeK1N5dxO
	 c6iLQgCIG2KRNsX7d39rS/xtSBtwZCEpvbLzlTzv8bYrOKxo/TrWiogbPrAFOzSwGX
	 Y9pBxhAThsOcgYmr76vf39YV2tS40jwCyuvqA854+wU7CourDT6or/SbnILQ3/Y2+L
	 A7xQid88CN/4w==
Date: Wed, 26 Aug 2026 22:30:57 -0700
Subject: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a seventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add rvbs, tweak some of the commit messages

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-7
---
Commits in this patchset:
 * xfs: don't spin forever on zero-length dirents when salvaging them
 * xfs: don't stash removename operations with unknown ftype
 * xfs: log the tempip after we convert it to extents format
 * xfs: fix parent rec lookup initialization in xrep_metapath_unlink
 * xfs: handle reconnecting metadir subdirectories
 * xfs: lock the healthmon when inserting unmount event
---
 fs/xfs/scrub/dir_repair.c     |   27 ++++++++++++-
 fs/xfs/scrub/metapath.c       |   85 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/symlink_repair.c |    2 -
 fs/xfs/xfs_healthmon.c        |    6 +++
 4 files changed, 114 insertions(+), 6 deletions(-)

Unreviewed patches in this series:

[PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 7
  [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
