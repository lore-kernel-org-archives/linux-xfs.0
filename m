Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA5C1EF08D;
	Fri, 21 Mar 2025 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592397; cv=none; b=rWBnOgCysrVOxZOlSD8MJg+8CbFN77IxQ5tDfLWvmgmH6xQS2PrwxKTFf0G3eTUxI1HrkqH9Bk4QeX6TqQTE2Gg6o54j5KFyWYvrt10GYkjTPDUDp4Vy5jowhrOMmWohfS40PfYi8G1cr6g+qZeYFStUJTW0I8BKxvYoQYzD844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592397; c=relaxed/simple;
	bh=Ixs7udQQv3kNJo4JQ3W8IgW8eYlnlkZOkIjXWUD5d1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LnS1wPa7eRJCre+VTqfNnFHFkxzUS3LxYOebfGRAsFB44UCbbTcTVJwYrlxLU+tSrr2uP3arVSL/x6DZCZ2aG6HlI0PYOIgxUraqqPi6cyAIeqkOe8T2WiEwjfkiFMzhtMwl/TEl9VkJ9rIetE4x25MD/hhyAiAF6TXsna9zMQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUwfWA80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUwfWA80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5D3C4CEE3;
	Fri, 21 Mar 2025 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592396;
	bh=Ixs7udQQv3kNJo4JQ3W8IgW8eYlnlkZOkIjXWUD5d1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bUwfWA80pNyFfxbZVKPpX8oR06C9jeb5TukWhbyCX/rK2rMZX24+E+zAgbi+4UueP
	 EaEiU15O1E2UTfVJQ+Ooei9xGTyGDEMXK8IwwZMUHSzpDQciqtdbhG3L09+ADmTCib
	 oR02mUllFLDNr2jtCUlRR1ndyB7q1Zj+3mMTTi+oG8sj1Urd3aSITuRFiqCtbHHvLR
	 BGDk9x1sGiwkZ1A8r4PxXy2uZZWSz42E7ZfX05+CRqSSpSbTS/B7f2pu2la13Nq7lj
	 Vd/XT0NrpSePRCiXlBkDQTglk0k4tGsRHO7g1tPEhypi2eK3+Sn06zd9XonQSVCWeT
	 Egy7C5dsqGRZw==
Date: Fri, 21 Mar 2025 14:26:36 -0700
Subject: [PATCHSET 2/3] fstests: test handling emoji filenames better
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233710.743518.3215391886196460989.stgit@frogsfrogsfrogs>
In-Reply-To: <20250321212508.GH4001511@frogsfrogsfrogs>
References: <20250321212508.GH4001511@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Ted told me about some bugs that the ext4 Unicode casefolding code has
suffered over the past year -- they tried stripping out zero width
joiner (ZWJ) codepoints to try to eliminate casefolded lookup comparison
issues, but doing so corrupts compound emoji handling in filenames.

This short series amends the Unicode testing in generic/453 and 454 to
examine these compound emoji.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-emoji-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-emoji-fixes
---
Commits in this patchset:
 * generic/45[34]: add colored emoji variants to unicode tests
---
 tests/generic/453 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/454 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

