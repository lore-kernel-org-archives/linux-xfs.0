Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B4B1E51F6;
	Tue, 29 Jul 2025 20:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819715; cv=none; b=SDTaCdYZ0Osjzfl9pHR6RPC04Fm3NuTQ2PXTm5xTPY7kbe20TfR05IsCcCgGDQjeG/J8gl+IxRKcoKdNUW3U+qwWE9HepvkPOTJQvtHXGLdWRTiT4kqmZKuDmdzN1XWq0c/gcVFgS1svcZnUu2ifvcXfyX7LmMyr+yvhoDLWs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819715; c=relaxed/simple;
	bh=yT1fwgoLECFUrKTllBrUw8+0bBnjzRTJzDFA13LQ9tQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=OqMdx/FxcL18SswVfG+JmAlHTt232E5Df621ZXtOX2p/OWpQ37nCalHg/VqNzMgVd0rfHfsEuFGE1Rjd3Jsejh61oRUOtlyT5qOaEbDamBuTN315RNkb+6EJbZM/sriRjtN1EWl35SWImfeJZrO+NuhMEwK0OCo/6fGjUyk3IM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xyr+1vDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xyr+1vDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1E5C4CEF7;
	Tue, 29 Jul 2025 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819715;
	bh=yT1fwgoLECFUrKTllBrUw8+0bBnjzRTJzDFA13LQ9tQ=;
	h=Date:Subject:From:To:Cc:From;
	b=Xyr+1vDwfltbPBYAqG2QFZg6qRvhZcH93RfIatRaro7J7waYStLxn1E9f9uBJT10r
	 XNAwErckMeGUAkM6n2/ylabziiheAW60t210Sgi+12g6KnDCuq/7LaylTXnLM2DDJW
	 mOr6SwTgQI3MxaiJ8oI3hRx1+XcHysWN3EufnwDA/+4dw6/f+Rs0voUas4eWQ7zmi8
	 1wg654hp8YWfQCbCg/q5jCMdegnpqMCM6xiOwZKvaOgEOkpmsulHcJeah7x70IRE5m
	 go+LNpkzSnl+6HycAybfxub5i4yZdsb3RIdPB8gavQF5ieiDIN159AVfxtqJGAQZA0
	 2eRk9X3lADn6w==
Date: Tue, 29 Jul 2025 13:08:34 -0700
Subject: [PATCHSET 2/3] fstests: check new 6.15 behaviors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958191.3021057.13973475638062852804.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Adjust fstests to check for new behaviors introduced in 6.15.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=linux-6.15-sync
---
Commits in this patchset:
 * xfs/259: try to force loop device block size
 * xfs/432: fix metadump loop device blocksize problems
---
 common/metadump   |   12 ++++++++----
 common/rc         |   37 ++++++++++++++++++++++++++++++++++---
 tests/generic/563 |    2 +-
 tests/xfs/078     |    4 ++--
 tests/xfs/259     |    2 +-
 tests/xfs/613     |    3 ++-
 6 files changed, 48 insertions(+), 12 deletions(-)

