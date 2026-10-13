Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5B750276;
	Tue, 13 Oct 2026 00:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850120; cv=none; b=lT3g1t5SgalwnvK71ZW0KaKD4mQ3OJr8D6DH5XETdf8wtxfiEayYsII9Y3W2l8hkkaa1oo/72Jd6ErjqPl4to7h0n46Yl2OzV1+owc4qpi9hamHWhelEwULeVM1/RziamRsGFOLKMdCG6aoduxegmhIxT7lQFjUMRIhSrf4R8Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850120; c=relaxed/simple;
	bh=ntyGTGyoxNUofp367S+abeehWDa0hjqYbmVKqywHFRg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=F+ZU4tQdO8zGE2sST2Fr68NpJRS3DXwq3oBSGU96KdFz9be7r/ZQe64NczWb49nN5CETgDMwwpuopT3WyNlVKSLEJHRgzmPv9gEPK78p0YwDGiBmUQnIW3kQJ5PcPf2omhc9t2zmIH441qRIj0HluPyuDCi8lmkT91HHoil8MS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1bKE/a6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1bKE/a6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96F351F0089B;
	Tue, 13 Oct 2026 00:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850119;
	bh=82LuNCr+2xgjPLZqUaPWkqn6lRaV7lfZE53IiXzD20A=;
	h=Date:Subject:From:To:Cc;
	b=H1bKE/a6lPzQO8qPq0eowE5E0ey6Q+My5EG6EZNFCGIkGjwVa5bqzaj9X+DFTQ4po
	 Fwjh9ItPC081PiJZ+PFZCx4m6baOh7lWyjg6szlA/PUm1pzIduYI3kqKumuQL1tkUy
	 iHWLietyRuIbp4J+LXlPP0zDgupSTPYj+ne5UL4j3srIg3zDaYh+MsF5lEQaRvXjon
	 JKB9V8qnERmvItNzPBPJFXaNCcNhiH1gCOCjyABxru0+PJgWe1BBEwiLmigsWaw5aB
	 U7HpIYoOu5fNgc2pPnYQoBvnPo3FSlDR7fGDWkBerDI4VqT0E5yfv/X8BNTaVnTdwO
	 m16AfznfkKHrQ==
Date: Mon, 12 Oct 2026 17:08:39 -0700
Subject: [PATCHSET v2 1/2] fstests: new tests for old features
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: hch@lst.de, norbert@doyensec.com, aalbersh@kernel.org, qsa@qualys.com,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some new tests for old features.

v2: various tweaks requested by reviewers

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests
---
Commits in this patchset:
 * generic: regression test for refluxfs fixes
 * common/xfs: add zoned/rtstart info to mkfs filter output
 * xfs: basic functional testing of media verification command
 * xfs: test mkfs.xfs config file generation
 * xfs: add regression test for exchangerange-to-eof reflux
 * xfs: add regression test for swapext reflux
---
 .gitignore                      |    3 
 common/xfs                      |    3 
 src/Makefile                    |    3 
 src/refluxfs.c                  |  435 +++++++++++++++++++++++++++++++++++++++
 src/xfs-exchange-to-dirty-eof.c |  210 +++++++++++++++++++
 src/xfs-exchange-to-eof.c       |  168 +++++++++++++++
 src/xfs-swapext-reflink.c       |  230 +++++++++++++++++++++
 tests/generic/1956              |   58 +++++
 tests/generic/1956.out          |    2 
 tests/generic/1958              |  138 ++++++++++++
 tests/generic/1958.out          |   11 +
 tests/xfs/1908                  |  123 +++++++++++
 tests/xfs/1908.out              |   28 +++
 tests/xfs/1909                  |  163 +++++++++++++++
 tests/xfs/1909.out              |    2 
 tests/xfs/1939                  |   70 ++++++
 tests/xfs/1939.out              |    2 
 17 files changed, 1648 insertions(+), 1 deletion(-)
 create mode 100644 src/refluxfs.c
 create mode 100644 src/xfs-exchange-to-dirty-eof.c
 create mode 100644 src/xfs-exchange-to-eof.c
 create mode 100644 src/xfs-swapext-reflink.c
 create mode 100755 tests/generic/1956
 create mode 100644 tests/generic/1956.out
 create mode 100755 tests/generic/1958
 create mode 100644 tests/generic/1958.out
 create mode 100755 tests/xfs/1908
 create mode 100644 tests/xfs/1908.out
 create mode 100755 tests/xfs/1909
 create mode 100644 tests/xfs/1909.out
 create mode 100755 tests/xfs/1939
 create mode 100644 tests/xfs/1939.out

