Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B21849
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229099; cv=none; b=lZF4GmGPMSPu34eSnKP5XT1LPAFlB//xUFjAKsiSL+NSN526QZeuy5AvcH30NhXxMynKI7/n+KI5aPRvbGikmFIH+UJFYglLvMuYtMsxVCh7rxu5STrqTI9v5vbynbVizcY4hLG0k38TQusJS3SP7VRCFjkwEyIwCIBmfGcK3Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229099; c=relaxed/simple;
	bh=omxdmSAkWTThBFLZBQfYZQay0wq4LFgtUzAPIjb/c3w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KBrRt8A9H1huy6gPGOZXYedFlxlByAHMJ4X7UDQGQ22ffrXmiBEAjsf8R9KFiCx64ZNJ3t5Ipw3tNwTARNExyUQs2dSe45R5WIvB9CIYm+hSHDCH2SXHMcfoJIO7hLczSjwVzb/51sEa39oJaWZmjohEHPumCE89Ds/Gm31J13Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JA11/L0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JA11/L0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC5DC113CC;
	Tue, 16 Apr 2024 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229099;
	bh=omxdmSAkWTThBFLZBQfYZQay0wq4LFgtUzAPIjb/c3w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JA11/L0NfnLI2VSd98Rarkp1SeRxF6KDY0BzXXSBYgEPtwqxbpq45TaJzOc5xcRJQ
	 Gk1iNkf3yEOSgxA/8AYcWCF5kdHg5POPoFaUNuWrO6fD33y1C6hlP/QJ7jse+NWDlp
	 KrNsYY1U64LUJr+qtcbAYtY8tuf//lDvdxy92bDZSOkiZYyMKX+e+N0vuqBMMQc51u
	 R8RjVYoXp8oeltrZnMgdUYoWgOjej0vSum3T8VE8uyYaZc9VMxDhqQPgtcXfVvOke6
	 Xa2zAh1QGrULMFMYHjv0W1cThTSSn5qqlMxs+uLkhrAZ8vTgJcZpcrquUKmyt+vBUk
	 SvsrbxCrRKleA==
Date: Mon, 15 Apr 2024 17:58:18 -0700
Subject: [PATCHSET v30.3 3/4] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416005120.GF11948@frogsfrogsfrogs>
References: <20240416005120.GF11948@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups
---
Commits in this patchset:
 * libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
 * libxfs: add a bi_entry helper
 * libxfs: reuse xfs_bmap_update_cancel_item
 * libxfs: add a xattr_entry helper
---
 db/bmap_inflate.c         |    2 +-
 include/kmem.h            |   10 +-------
 libxfs/defer_item.c       |   58 ++++++++++++++++++++++++---------------------
 libxfs/init.c             |    2 +-
 libxfs/kmem.c             |   32 ++++++++-----------------
 libxlog/xfs_log_recover.c |   19 +++++++--------
 repair/bmap_repair.c      |    4 ++-
 7 files changed, 55 insertions(+), 72 deletions(-)

