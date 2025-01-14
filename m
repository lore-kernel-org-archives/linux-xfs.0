Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E27720A5D2
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890833; cv=none; b=CpMXd0C4tkvTpMWmb18WoQ9IZKEoRDRRSb7F2KdrbA+jWiVe0Vcyj5jRXgRKG9n4WRse1WP1Cm0ZVSJGVUlR/EyyQBxUNNrDjkgYrCYtvuogx482T2Hfg6tMqYwZBpXr2G4azarUMnGALtzx+MJmZlao56EBHhf203lLj3f9prk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890833; c=relaxed/simple;
	bh=RhhlvvI8TEe6/Ol+JroQHmt4gO41UOvxxEd1k2umxjg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=r4wqVzZKyC8WrYazvxH+u5muRD4c1cUVbRV1Xp1g2shPhIfCZExHnpHeL+VrGkNQKkuQdDTRhYMizWzKn2JbUwTQyJmieQpRk2cdh7M9SABpo7Tb0+rv085uvJAExFV4XA7+pS3DHK9jfJdAAAAv4ASSYVxuW1thTALDVLqtx9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTz1AVPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTz1AVPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5D5C4CEDD;
	Tue, 14 Jan 2025 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890832;
	bh=RhhlvvI8TEe6/Ol+JroQHmt4gO41UOvxxEd1k2umxjg=;
	h=Date:Subject:From:To:Cc:From;
	b=QTz1AVPHsUfncgfrD3osypCGO9HkPGLqfTCxmXj7qZXB1A4ldVzzjGp7Pzer+fOpV
	 R2jLrlSnKvl4lFGeUK+snAqMSObcWE8rZ8rloDdepbWD2FSnyMLNan/sWsSN09RkrH
	 33HD71HcxjyaOEH5gwK/RcgJ4vSOAUqvS5v1uLpgAwpXAza7jaTCQ8yiRH5v3jgV5S
	 BiwhMgrQ+GCfyJMe7Mxqp688dk6OWptmmsEu7YsgxlyOzQI9z9xz7qaLnJSrg9TxrM
	 NZundNZoxccXQ9YAUW2FXvQ38WZC7O8GHnMYAccoYjcYIUL2Uu/4TBCmXKXCiuioGS
	 OpSS1nTs8HGXw==
Date: Tue, 14 Jan 2025 13:40:32 -0800
Subject: [PATCHSET] xfsprogs: more random bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is a grab bag of random fixes targetting xfsprogs 6.13.  The first three
patches are bug fixes.  The fourth patch tells gcc to initialize automatic
variables to zero, which should avoid stack content disclosure and reduce
unpredictable behavior due to uninitialized variables.  The fifth patch adds a
"-r concurrency=" option to mkfs.xfs so that we can try to format enough
rtgroups to minimize contention on rtgroup metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=more-random-fixes
---
Commits in this patchset:
 * xfs_db: improve error message when unknown btree type given to btheight
 * mkfs: fix parsing of value-less -d/-l concurrency cli option
 * m4: fix statx override selection if /usr/include doesn't define it
 * build: initialize stack variables to zero by default
 * mkfs: allow sizing realtime allocation groups for concurrency
---
 configure.ac            |    1 
 db/btheight.c           |    6 ++
 include/builddefs.in    |    2 -
 m4/package_libcdev.m4   |    2 -
 m4/package_sanitizer.m4 |   14 +++++
 man/man8/mkfs.xfs.8.in  |   28 +++++++++
 mkfs/xfs_mkfs.c         |  144 +++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 190 insertions(+), 7 deletions(-)

