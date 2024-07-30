Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032116EB5B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307313; cv=none; b=F/8w5lOywPsG3VK8MH33BUgxdXJY7C0bV7LaEgpa1ERK5XirAMInJWZj00Jmrq4WmiJf9tWHdpNSlKiHmoJ0uT7CWGGu+fhlA97m03T49mmw6xmVfZvnZZiNsuJq7iNPXbJbty/0VWzJmJCrP95xNL3TRVBEHQ9qegLhwzoywjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307313; c=relaxed/simple;
	bh=MYpP2p0Eu09EU7VNiIqSAc6Oqh9MCcfrObRu1Lxqcz8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=VHs40syAHv8ofEaze0oyUZYotoMFR0KEfTQk0tTVwhC8DOCcPVWKz8CnxJq4OtWtmilq5fDUomU6teLPlKZEGvSEM7MyRW7SheSp4Ghg8K/N/KMKGDVuAQpyamQ2NQxas0T8WpYfYPRXp9gjhIOO2SfTaivcVZabKbru/oDRuOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9GK6qRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9GK6qRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7828BC32786;
	Tue, 30 Jul 2024 02:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307312;
	bh=MYpP2p0Eu09EU7VNiIqSAc6Oqh9MCcfrObRu1Lxqcz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L9GK6qRJGWlgB0D2xEG6teDgk1ntBbZ7G74N+xbtdkDgdGiGj6BAOEzhvT0rKqP8P
	 kfWjDdsv1LpiV4dB6PX51Trr8XLW0RarhtMWRd91bjQf4sQW0cerQ8YwmFxglrErQC
	 a9BP9T4p9cRMQuKDmuTJjqQH6qmZCCN5VIzG3dj8WEGK+eeCyBpGpOuZx3BwMNUisW
	 vb2uBn1tJLzsDcqI2uJ7AVBIjq2i7p4J26O4v4mzLoUEbp7aeZ8izugditB3oaouPf
	 t75xjX6vWuN7TqDxuROlA+/7wSElEmMWfa/ia3OMhsHc7b6Pfz8MQZzHVXHoywZ2Gt
	 I56A0gj5syPCg==
Date: Mon, 29 Jul 2024 19:41:51 -0700
Subject: [GIT PULL 06/23] xfs_scrub: fixes to the repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458353.1455085.9566516777477890945.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit ebf05a446c09336c08865dc29a6332be6ff8223c:

mkfs/repair: pin inodes that would otherwise overflow link count (2024-07-29 17:01:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-repair-fixes-6.10_2024-07-29

for you to fetch changes up to 4b959abc5f353123775973cd98c94d819cc9de79:

xfs_scrub: actually try to fix summary counters ahead of repairs (2024-07-29 17:01:06 -0700)

----------------------------------------------------------------
xfs_scrub: fixes to the repair code [v30.9 06/28]

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs_scrub: remove ALP_* flags namespace
xfs_scrub: move repair functions to repair.c
xfs_scrub: log when a repair was unnecessary
xfs_scrub: require primary superblock repairs to complete before proceeding
xfs_scrub: actually try to fix summary counters ahead of repairs

scrub/phase1.c        |   2 +-
scrub/phase2.c        |   3 +-
scrub/phase3.c        |   2 +-
scrub/phase4.c        |  22 ++++--
scrub/phase5.c        |   2 +-
scrub/phase7.c        |   2 +-
scrub/repair.c        | 177 ++++++++++++++++++++++++++++++++++++++++++-
scrub/repair.h        |  16 +++-
scrub/scrub.c         | 204 +-------------------------------------------------
scrub/scrub.h         |  16 +---
scrub/scrub_private.h |  55 ++++++++++++++
11 files changed, 269 insertions(+), 232 deletions(-)
create mode 100644 scrub/scrub_private.h

