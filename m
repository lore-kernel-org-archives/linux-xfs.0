Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4712D1E51F6;
	Tue, 29 Jul 2025 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819721; cv=none; b=sBQJmgldxhA1TvqQ4AW6PX2/9PQwpaohqx2gXFGY7c/zZOSvCMY23IcuLoY7DQSyZGbEob7wPuZKcJ+8RTlWZDBiAGwzx3sZxyFKjANerswjACWSWPEQ6WdeqE5D90WE4pTo0t3DqVtClrGSaHddqDu5LcSytjZ24b8HKgSpDfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819721; c=relaxed/simple;
	bh=4xI0swoaIqMhOdehHsUm9fuaty+5HR9LxRpomUZ189c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=BsGTUHn/OYUZc9V0b2O9yA/kRPr/al4q4bvt9C+5s1UZC46Q6Q+XYH54Wfl+vG/XLP5HR6+U3yzggMNh2zA/8K+E+ZeJinPhbe1LOvWfhi+gXAw/eWQpp8LhLhAF2oIk2EBjeR20mXgVhKpu6aIh33vgKTsWoCDEd81I2E1mIEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGmT259T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGmT259T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1983C4CEF6;
	Tue, 29 Jul 2025 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819720;
	bh=4xI0swoaIqMhOdehHsUm9fuaty+5HR9LxRpomUZ189c=;
	h=Date:Subject:From:To:Cc:From;
	b=MGmT259TRTRaUKk/G88DsPqhShJoqmfpF9utu6m2n0tXLwcHi09m3oHw1IBzKUGCc
	 4qSQtcifhKmWqITnL7FXUEwMBaBl9uhtmvd4jTbvfFlTDPPnYtxAsbXngocj44ZcPn
	 hnpLG7BFCcYb1gUxJBvLF1G63wrNsVUX9hVCLVf0D2Bdeb3JI9KvgihEokSwI+H3sA
	 kndSZyFxguKfgQI88FrP3d5L/+YUWSMpmRnZ9vNyvqdtpaTW3hjXDj8hmyGglN8MLU
	 0E3JLnJWQzu9HnSoTg9WTvGqe6ZGzU4hhO3x9vg9Cm/40hcELMUTKYMKNoDxTTwev9
	 fVUhTBr7j7MJA==
Date: Tue, 29 Jul 2025 13:08:40 -0700
Subject: [PATCHSET 3/3] fstests: integrate with coredump capturing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Integrate fstests with coredump capturing tools such as systemd-coredump.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=coredump-capture
---
Commits in this patchset:
 * fsstress: don't abort when stat(".") returns EIO
 * check: collect core dumps from systemd-coredump
---
 check          |    2 ++
 common/rc      |   44 ++++++++++++++++++++++++++++++++++++++++++++
 ltp/fsstress.c |   15 ++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

