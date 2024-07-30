Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F3613B780
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307359; cv=none; b=HuBasQdsYsaz6AIgZpG79+EH8CBjgO5yZFaTtoUqA1+xqHIsg8tKbkBzJTC2Z4mOhgkR9KplrWWOqRlse5lyUkOcBo2A/WXvhwKvfKkQ9Jntgw2YNAirY5sfV3/LDcjX6gzKs1nGva4gK7SFR+myN62cRu2Z5P+jwQzl2yiy7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307359; c=relaxed/simple;
	bh=wMSg2YuqAkkmBiJT2JMt5JUWcYHBYn/z6/vgSBVeioo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=tsF29BbFiQH8pSgcfMJ41bbmcEK2UqsTUM8Xa8UePHfUbPy64Q3UlVeNO63IEmJIa2KZ+/CqHW6b9a9y5prnkwQGNacgjdBMVgo4mUhAxU7VINsv40MBHDjtGDCDIhc/ZXRc0TnYjykF4q/7AHq+10i2jfuxJ40G411risXy4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvvL0NUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvvL0NUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CA0C4AF0A;
	Tue, 30 Jul 2024 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307359;
	bh=wMSg2YuqAkkmBiJT2JMt5JUWcYHBYn/z6/vgSBVeioo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VvvL0NUakoVXQH4apZWdGIo/HbD0omXvR1j/y0l2DDjip3in7bAWkpkx9UPFcjZ3b
	 r6fsmX2g43nZsYKwzO8KxUOUamjiJdWM4F4GsZp7SiHglsay/ck0wpodVr/cXE4CWy
	 vZHof7FD+yGqZT0DFdeMI5qAJ1Idz6nDx/1h67gRS3AnELAbBF8h6sS7PO9S6IQE/F
	 0X18mpnoi34oBHz7ljM/3aB8f6RJhcBmqI487Hq4vxMo10lCk5MYwY+500ycAbOhc0
	 X1ZQAu5sJn6QnUEa9mAxw1yqi9YGr7A7crdUno264q8Bli7ZlKuk0k8ZRvArqjuog5
	 rt0LcLtfWxfmw==
Date: Mon, 29 Jul 2024 19:42:38 -0700
Subject: [GIT PULL 09/23] xfs_scrub: use scrub_item to track check progress
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458655.1455085.7997777511946339540.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 81bfd0ad04a58892e2c153a22c361e7ff959f3fd:

xfs_scrub: remove unused action_list fields (2024-07-29 17:01:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-object-tracking-6.10_2024-07-29

for you to fetch changes up to 8dd67c8eccbe0e6b8dd7975ba53f9ccaf532aa9c:

xfs_scrub: hoist scrub retry loop to scrub_item_check_file (2024-07-29 17:01:08 -0700)

----------------------------------------------------------------
xfs_scrub: use scrub_item to track check progress [v30.9 09/28]

Now that we've introduced tickets to track the status of repairs to a
specific principal XFS object (fs, ag, file), use them to track the
scrub state of those same objects.  Ultimately, we want to make it easy
to introduce vectorized repair, where we send a batch of repair requests
to the kernel instead of making millions of ioctl calls.  For now,
however, we'll settle for easier bookkeepping.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs_scrub: start tracking scrub state in scrub_item
xfs_scrub: remove enum check_outcome
xfs_scrub: refactor scrub_meta_type out of existence
xfs_scrub: hoist repair retry loop to repair_item_class
xfs_scrub: hoist scrub retry loop to scrub_item_check_file

scrub/phase1.c        |   3 +-
scrub/phase2.c        |  12 +-
scrub/phase3.c        |  41 ++-----
scrub/phase4.c        |  16 ++-
scrub/phase5.c        |   5 +-
scrub/phase7.c        |   5 +-
scrub/repair.c        |  71 ++++++-----
scrub/scrub.c         | 321 +++++++++++++++++++++++---------------------------
scrub/scrub.h         |  40 +++++--
scrub/scrub_private.h |  14 +++
10 files changed, 257 insertions(+), 271 deletions(-)

