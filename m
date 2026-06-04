Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E8199385
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553073; cv=none; b=Ww+IFp4oluLXtyp+H41J4bU8+panFbYvpYOCVuMnLldW1LwxY1XW+VyH7Ux9S9N69ipXHUTk9imiv/jM04H7qLzDhyx8+Xf+6Te8F5ZG96xHTaIKu1WbzRtnVJSS+1EAoH/CMPs1nTYgd0u7DS8IFFu152EBBFRVNIRDBIADmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553073; c=relaxed/simple;
	bh=K62FU2HREgjaaGSRk5c4YffRbHoupfKlaHTY0YuppcA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=HEELXGY5AhMNU3t3xOJJ8MkCP6Bl5o7wRZoQdujPsGkQShBOY+aEsp4qx/12K7kgKwv6Pci51yBQhTnhm3WWr7k6/dcB/CWoy/UnIj08OvUPJb2HvopEsj6mx6qAQvtcTVlr8JNzTRL8CGHWJpgr8EN42cKdvirI+Xv0IbNChRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kh0TTs/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kh0TTs/T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8B6F21F00893;
	Thu,  4 Jun 2026 06:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553071;
	bh=hbHxbbuxhJMX4Vn+bKGmivX3LaLPNquNUW5yTfqY1x0=;
	h=Date:Subject:From:To:Cc;
	b=kh0TTs/Tp7IrgDKFa0ehmV+aJ9HS4kXVZ+lG1BpcuqWuMHYchC1jR9yY697qS8Yow
	 WQ1H+sBG9UhGMOMxh7jJTD8YsfPtYo4gPhSUAQQAMnqYRCbZHQG2EGDig6qkquQtsA
	 nWUNZg7IrPkwCkb2haGC544P7hst2fLIRK087v25omRL1dQBt24B7BNnn+v973t4jM
	 rdstL3Au0UG4OXOK1fKCy4mosoxGY1Kdfu5W0UXhWeODG8FxbiqDIybA8JESslTwgL
	 xgnkK7cYehdMfA6tXRk2rEjBaKrG5ou2+rtBLX16WVh2v38HWKXr2VIQpR4ZFjBLjb
	 PwesLCeQ3ACHw==
Date: Wed, 03 Jun 2026 23:04:30 -0700
Subject: [PATCHSET] xfs_scrub: codex-inspired bug fixes for 7.1
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

I then threw Codex at the entirety of the xfs_scrub codebase to see what
kinds of problems it would report.  I picked off the obviously
delusional complaints, and fixed the rest as well.  There are a lot of
fixes here, but most of them are for nitpicky details that C is terrible
at, footgun fixes, and missing corner case handling.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-codex-fixes
---
Commits in this patchset:
 * xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
 * xfs_scrub_all: fix broken command line string array construction
 * xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
 * xfs_scrub_fail: send content headers for xfs_scrub_all failures
 * xfs_scrub: fix uninitialized variable
 * xfs_scrub: fix integer overflows
 * xfs_scrub: don't count internal log space in the data device used count
 * xfs_scrub: widen scrub and repair dependency mask
 * xfs_scrub: fix work estimation for rtgroups filesystems
 * xfs_scrub: don't report media errors in specially-owned areas as file data
 * xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
 * xfs_scrub: fix nonsense advice after a scrub finds errors
 * xfs_scrub: don't allow NAN as fstrim percentage
 * xfs_scrub: reset bulkstat pointer on retry
 * xfs_scrub: don't return garbage value from bulkstat_the_rest
 * xfs_scrub: don't continue with phase1 if autofsck=none
 * xfs_scrub: don't crash trying to complain about clean health
 * xfs_scrub: fix inverted return value from ptvar_get
 * xfs_scrub: don't obscure repair failures in repair_list_schedule
 * xfs_scrub: bitmap iteration functions must retur
 * xfs_scrub: read verification isn't ok if it hit runtime errors
---
 scrub/scrub_private.h                  |    2 +
 scrub/xfs_scrub.h                      |    2 +
 scrub/inodes.c                         |   17 +++++++--
 scrub/phase1.c                         |    5 ++-
 scrub/phase2.c                         |    2 +
 scrub/phase3.c                         |    4 +-
 scrub/phase4.c                         |   11 ++++--
 scrub/phase5.c                         |    4 +-
 scrub/phase6.c                         |    4 ++
 scrub/phase7.c                         |    4 --
 scrub/phase8.c                         |    2 +
 scrub/read_verify.c                    |    2 +
 scrub/repair.c                         |   10 +++--
 scrub/scrub.c                          |   23 +++++++++---
 scrub/xfs_scrub.c                      |   18 ++++++++--
 scrub/xfs_scrub_all.py.in              |    2 +
 scrub/xfs_scrub_all_fail.service.in    |   59 +++-----------------------------
 scrub/xfs_scrub_fail.in                |    2 +
 scrub/xfs_scrub_media_fail@.service.in |   58 ++-----------------------------
 19 files changed, 84 insertions(+), 147 deletions(-)

