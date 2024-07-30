Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56062EB02
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309568; cv=none; b=BjYNwIREKS7tEWqO3o5XFA9qogACKkvAspj0chviMYGMK0RzLHsOjVNyP3vysEK4d714NvELxik8AQDKu6WvgvyYf0IRfHxQH6Z0s0ukJySCXa5rROooRsCjwMQpbLZ60hvtyMX65Vu0g0ssfBnCy1RlAlXIiukewaHrcOzqw9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309568; c=relaxed/simple;
	bh=EE4PHZGazch6EyGPvwUXmEiX36si6P9j7RABc+HOvhw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwpttqQZ3DGL8SxQgnfwYSAVEoGpImuM65NhpcKTu3vyHJSfsf1ZWyPAZ9ykfkWY9Jw9nyI13JoGW1fS0yWl5b2Bb7j2yq3RA/92686MfrL1hUf+tJACFKivE2WoiyuUfySigd66mxl7ay+qVGKSFxTjTUYGOKefHpceYUg1TYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZjb/usN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZjb/usN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C55C32786;
	Tue, 30 Jul 2024 03:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309568;
	bh=EE4PHZGazch6EyGPvwUXmEiX36si6P9j7RABc+HOvhw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IZjb/usNmPXXJS8pzuoYwhFX8oVu9crGOmNRY4FlTtz6/dbA8T+SP6DtOib1WCkzn
	 wzUwl12/UyBAy3qxR7vBHDs5tv4suOIIXfYDyu0pg+BcOs3BJ3D2IzzZDGOyfd+Xba
	 9f7MexfWFnwttJScnS81TtAFJ0lrJoWe5qTmEPznHIZBhgJm9hy6HpFg5/W17CGTgp
	 6jFVW7M8n/xE0yv0++bFE5DAR3xB0mbC/AJvfBoFHaeClOJNqRawXFk07MAa93gI5b
	 d3ITnfilRKgP02Us0fuvxFZpMpiwj5NslbKsRHPR2Q7HezvMDStZF9t0jjsXU95xia
	 kfOII/Em9/PTA==
Date: Mon, 29 Jul 2024 20:19:27 -0700
Subject: [PATCHSET v30.9 3/3] xfs_scrub: separate package for self healing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941338.1544199.12238614551925293396.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730031030.GA6333@frogsfrogsfrogs>
References: <20240730031030.GA6333@frogsfrogsfrogs>
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

Debian policy (section 9 iirc) says that services shipped in a package should
be started by default.  We don't necessarily want that from the base xfsprogs
package long term, so separate the self healing services into a separate
package.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-self-healing-package
---
Commits in this patchset:
 * misc: shift install targets
 * xfs_scrub: use the self_healing fsproperty to select mode
 * debian: create a new package for automatic self-healing
---
 Makefile                          |   14 +++++++++++---
 copy/Makefile                     |    6 +++++-
 db/Makefile                       |    6 +++++-
 debian/Makefile                   |    6 +++++-
 debian/control                    |    8 ++++++++
 debian/rules                      |   15 ++++++++++-----
 doc/Makefile                      |    7 ++++++-
 estimate/Makefile                 |    6 +++++-
 fsck/Makefile                     |    7 ++++++-
 fsr/Makefile                      |    6 +++++-
 growfs/Makefile                   |    6 +++++-
 include/Makefile                  |    7 ++++++-
 io/Makefile                       |    6 +++++-
 libfrog/Makefile                  |    4 +++-
 libhandle/Makefile                |    6 +++++-
 libxcmd/Makefile                  |    4 +++-
 libxfs/Makefile                   |    7 ++++++-
 libxlog/Makefile                  |    4 +++-
 logprint/Makefile                 |    6 +++++-
 m4/Makefile                       |    4 +++-
 man/Makefile                      |   10 +++++++---
 man/man2/Makefile                 |    4 +++-
 man/man3/Makefile                 |    4 +++-
 man/man5/Makefile                 |    5 ++++-
 man/man8/Makefile                 |    4 +++-
 mdrestore/Makefile                |    6 +++++-
 mkfs/Makefile                     |    6 +++++-
 po/Makefile                       |    7 ++++++-
 quota/Makefile                    |    6 +++++-
 repair/Makefile                   |    6 +++++-
 rtcp/Makefile                     |    6 +++++-
 scrub/Makefile                    |   19 ++++++++++++++-----
 scrub/xfs_scrub@.service.in       |    2 +-
 scrub/xfs_scrub_media@.service.in |    2 +-
 spaceman/Makefile                 |    6 +++++-
 35 files changed, 182 insertions(+), 46 deletions(-)

