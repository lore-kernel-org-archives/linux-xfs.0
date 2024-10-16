Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3192F18E054;
	Wed, 16 Oct 2024 23:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120512; cv=none; b=M47aRvW8qFTTdC26ezl6B0C3NC+pPI3DQT+f26xs5VllWuIY7tf9sLPMlf/hsNJfsHuh2AdEBdt4dprfUOI8DtMNhoQkBwL3nhqys3gvC7w7nyzvvRh8TgGpNb3L+mOdoIZ8ai0wBUt4glvjNSY0znBmMiAJmbKn+nen74DK9lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120512; c=relaxed/simple;
	bh=BOEzQ+I27mCfgQzYR/C1gS5uZM3g+UrVqvo5xle2LIc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=CzHR68ZrbEpEByu7oHtNQG8CsgqrEV8om7pouGjhioMD07gKVf8WbeYB0Qlamjx/Jx2vqEcBNKMvOuG7DgKaw4wWkQNWcLpZTfXydFmG+WpBXZxMk6nW07Xeoiz460kUn0ou2SOt6TPtKAiMu0ToAu1gcYN/KgeKcsKkSq3FFB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9umbn2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9umbn2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A751DC4CEC5;
	Wed, 16 Oct 2024 23:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729120511;
	bh=BOEzQ+I27mCfgQzYR/C1gS5uZM3g+UrVqvo5xle2LIc=;
	h=Date:Subject:From:To:Cc:From;
	b=L9umbn2CCfzWxKPG136yrd8bvB7AbxCtS2gntWlXIQfmtA60Qxolxc8lPck2yUAMj
	 nrSDzNWd7r24dAduoJSxdfTBVLqMc7AU9IzpWTZ6k7GJ9Qe9R91JETmBrH8JUx3d9T
	 zP4ofxB2E1P2w2zjbLrQSsPHug1wRgi21EfVPD5/LHWHmbr2cuZ+cEHy2bUnj3AcsH
	 uUOuRJoPufpj2yQ43fBe4mDJ//eeVQ8T0mpWdqZFkeswhFfOw8HYcrAM4h/4GZgUd+
	 onAziwc5xSlyAwhJkvUpcuz0uahRl5lO03iM/ahDqe023C8HeeTD5L6ReFK21UDg6G
	 tuw2slY1Bn9Pg==
Date: Wed, 16 Oct 2024 16:15:11 -0700
Subject: [PATCHSET 2/2] fstests: random new stuff for v2024.10.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172912045895.2584109.2643798036760972085.stgit@frogsfrogsfrogs>
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

Here's some new testing functionality to strengthen QA.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-newstuff
---
Commits in this patchset:
 * misc: amend unicode confusing name tests to check for hidden tag characters
---
 tests/generic/453 |    8 ++++++++
 tests/generic/454 |   29 +++++++++++++++++++----------
 tests/xfs/504     |    3 +++
 3 files changed, 30 insertions(+), 10 deletions(-)

