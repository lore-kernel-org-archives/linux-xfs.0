Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6EB135A5A;
	Mon,  3 Jun 2024 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445521; cv=none; b=GCqy81e6ZyByJAqQGdgJtDY0NDaN4wvOifJUdrNyDYPkiQ8hGYmMNqzxaVWAsQAi/4lC4ffEVhMkFxuQIXcdG3J3kRTy1GWS7nfEIwR2N7wUWgPwvHEZxslIjERVJQisKVsF1wzf0kiAxFiAN4moNNV1rWkXiJgccl0EWJF3M6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445521; c=relaxed/simple;
	bh=Hz9z82iemJ/aaWow0Ur+WNdzXpSETvhxYhh2o3HS02o=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=EQdNQnh2PyrYDMSv7utlisCcLusZ9yjLY45sVfpKmL6+JN2JKgGs8yOEzdUtlb90uM0uqhg1SIWaZ3XB8y7tQzvHgxkGfcY2ItW0Dpd91sb8MKEImx38SUAgya+kx/OZsTiIDtXhmhfBTR5qxfgRYsChupTzF7ko5DHhHzB8nBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqnnCQ8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqnnCQ8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2070C2BD10;
	Mon,  3 Jun 2024 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445520;
	bh=Hz9z82iemJ/aaWow0Ur+WNdzXpSETvhxYhh2o3HS02o=;
	h=Date:Subject:From:To:Cc:From;
	b=VqnnCQ8iH8vO5pKDzmnEuaxdBjtOxvk55PCTucKT+kEuGCziXJPdPmQSnE4J7JT+Y
	 A/WEprz4KKGi5EbYEc7bBBfGEiROmY3qAUNjOdMYV4lzgc6rgWZXWc+6Pc8Vg3wSBo
	 rrMb1GYcbKIfCdK85T803SlcHXPmBZ1SN7Y1kRqBZh5nAnsX1J6gObnfToSodG469g
	 Iq0pvR+rANZAG/ttEYZULuc2g0DNgGDbmecOA3dkZz5jTR9WTiLdmJ+yyL5WoAsTBz
	 Rum88hYI3LUCMYtXeoG/58zsI1nJxKypmw1fbEEgaqYchMjTFb0j+yvMyowxXzN77X
	 dbiUZQNVuAOhw==
Date: Mon, 03 Jun 2024 13:12:00 -0700
Subject: [PATCHSET v30.5 2/3] fstests: fuzz non-root dquots on xfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
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

During testing of online fsck part 2, I noticed that the dquot iteration
code in online fsck had some math bugs that resulted in it only ever
checking the root dquot.  Loooking into why I never noticed that, I
discovered that fstests also never checked them.  Strengthen our testing
by adding that.

While we're at it, hide a few more inode fields from the fuzzer, since
their contents are completely user-controlled and have no other
validation.  Hence they just generate noise in the test system and
increase runtimes unnecessarily.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzz-dquots
---
Commits in this patchset:
 * fuzzy: mask off a few more inode fields from the fuzz tests
 * fuzzy: allow FUZZ_REWRITE_DURATION to control fsstress runtime when fuzzing
 * fuzzy: test other dquot ids
---
 check           |   12 ++++++++++++
 common/fuzzy    |   27 ++++++++++++++++++++++++---
 common/populate |   14 ++++++++++++++
 tests/xfs/425   |   10 +++++++---
 tests/xfs/426   |   10 +++++++---
 tests/xfs/427   |   10 +++++++---
 tests/xfs/428   |   10 +++++++---
 tests/xfs/429   |   10 +++++++---
 tests/xfs/430   |   10 +++++++---
 tests/xfs/487   |   10 +++++++---
 tests/xfs/488   |   10 +++++++---
 tests/xfs/489   |   10 +++++++---
 tests/xfs/779   |   10 +++++++---
 tests/xfs/780   |   10 +++++++---
 tests/xfs/781   |   10 +++++++---
 15 files changed, 134 insertions(+), 39 deletions(-)

