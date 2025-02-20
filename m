Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311113AF2;
	Thu, 20 Feb 2025 22:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089154; cv=none; b=cqpfsJkg8SmUIrSnNxFimxtw0lz364RLn44ilicqux2tgg1gf3/6cwgdgzRWvVNQUtBXj+KqiME7OTqP6d3Ln4xwakGka3qcKxZHTnvzXwXX5lTRRC0b5bG4tH4ym1e3gXFQd92MS18KIXJJ8nBwPgvFErgnFpzxqjT9Mm4TcnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089154; c=relaxed/simple;
	bh=9TK7LEXZoDdO33Zd75aZCiZRy7Ap6SNtptBynVh3l4k=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=uUow6Ku58yce/8T6xjiE4aopF7HSrIYy4A8stYPLYD7gin8DRf8gO/L3PIGaJWsTTCS5e6e9rNbF4jYfpzujQZdEKpFG+1NCb5yzykFA6n++CKqfwPfBkTyK1BKZdP0FzwAhhV1V98UEv5geOiWj62QSyyRRgDZ+myFYtONkeQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jizmyUmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jizmyUmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B1C4CED1;
	Thu, 20 Feb 2025 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089154;
	bh=9TK7LEXZoDdO33Zd75aZCiZRy7Ap6SNtptBynVh3l4k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jizmyUmFC8CxT0uEdjLktYHggiar1Xd/Cdl1VCRkQKP0V8fUxkIe6/y/bdTXdi4cb
	 o4qu9teLxVi0AisO/3wbP2OuSDkr0DlL0GUWCBchtGKBVoWKOwXXPmXxeGXpqlcpiL
	 WoxgGa/lzHwf2ozZvdqbLN91SQ+vLglrszhGmdESFzv3qtuN/l5fTbbE+pSyLgaMEi
	 4hpqmgu7FiLxOOFfxUUOEBOF/iP3FIadHROCdYdzx82hIJz6G7mVH/9DszCaU+H2+r
	 OId4o04IgNF5heW+XPqQD5F64ACdCcUduAva4Y2yG/7NWJnlG5reQVxCsp0e80WbCW
	 jcDcBbr0CatpA==
Date: Thu, 20 Feb 2025 14:05:53 -0800
Subject: [GIT PULL 07/10] fstests: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901957.1712746.5253001988544026343.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7ba79ac12c4be53d13673236b2d8f1a86076e5e0:

xfs: fix tests for persistent qflags (2025-02-20 13:52:20 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/realtime-quotas_2025-02-20

for you to fetch changes up to f5be7b47b120876ac7f256781744c834bad22db6:

xfs: regression testing of quota on the realtime device (2025-02-20 13:52:20 -0800)

----------------------------------------------------------------
fstests: enable quota for realtime volumes [v6.5 07/22]

The sole patch in this series sets up functional testing for quota on
the xfs realtime device.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
common: enable testing of realtime quota when supported
xfs: fix quota tests to adapt to realtime quota
xfs: regression testing of quota on the realtime device

common/populate    |  10 ++-
common/quota       |  45 ++++++++------
common/xfs         |  62 +++++++++++++++++++
tests/generic/219  |   1 +
tests/generic/230  |   1 +
tests/generic/305  |   1 +
tests/generic/326  |   1 +
tests/generic/327  |   1 +
tests/generic/328  |   1 +
tests/generic/566  |   4 +-
tests/generic/587  |   1 +
tests/generic/603  |   1 +
tests/generic/691  |   2 +
tests/generic/710  |   4 +-
tests/xfs/050      |   2 +
tests/xfs/096      |   4 ++
tests/xfs/106      |   1 +
tests/xfs/108      |   2 +
tests/xfs/152      |   1 +
tests/xfs/153      |   2 +
tests/xfs/161      |   1 +
tests/xfs/1858     | 174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/xfs/1858.out |  47 +++++++++++++++
tests/xfs/213      |   1 +
tests/xfs/214      |   1 +
tests/xfs/220      |   2 +
tests/xfs/299      |   2 +
tests/xfs/330      |   1 +
tests/xfs/434      |   1 +
tests/xfs/435      |   1 +
tests/xfs/440      |   3 +
tests/xfs/441      |   1 +
tests/xfs/442      |   1 +
tests/xfs/508      |   2 +
tests/xfs/511      |  10 ++-
tests/xfs/720      |   5 ++
36 files changed, 377 insertions(+), 23 deletions(-)
create mode 100755 tests/xfs/1858
create mode 100644 tests/xfs/1858.out

