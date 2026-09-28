Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F1409103;
	Mon, 28 Sep 2026 06:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576166; cv=none; b=hGjGAZJHSchfAign7sjOLzJlLKdyE9rEL+dlyJynKvxv1hTUhbHhslMvCrPRnHKXeJ1P42az94d5s6ItKosA3hoFqYIgmAXAkvqwVls6aOswhCkWcKkh91RMWTJZYr34bwW/f6KNzJDYTHPi0EmyC565LPChy2KhE1qWiTWP7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576166; c=relaxed/simple;
	bh=7jEIXfKCh8DMThWH0t4rVQfIaXKLpwQ8yIjmdbwEzt8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=UPIvC0e+sT+6piMkXR6p91yFluEp1NOklKTV6PFwjDladYDtBvqHyQYJcDWfv21L47DuSgsJlJFBuJrmebl1UGmx4bRPslFZ8qK8yxf3/8Yzt/HATqL6RFXWJ4pPFgdvbF4hmgkS0YAVoLVIk6yjFO9tdyCzsEMLYQfrKnh0eqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzZ9iwCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzZ9iwCb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 737A61F00893;
	Mon, 28 Sep 2026 06:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576159;
	bh=oyldUKsHRI1gR3yAZchEjgk7Uwx2KY9ZJC7r2zTFG2Y=;
	h=Date:Subject:From:To:Cc;
	b=hzZ9iwCbNenjE0S0ndfZVJTV+73oeTE2KCrZu+w643TKmoMSNGzH9B+ceXwogaExg
	 fhlRmBqVi+Whfl3elU15PUUbM8KOhqZWMsCxKHre/KDhQkaYOvZTdB5Ba2uJKhDzr0
	 qtva8NDwqIimngnVxBE5hG/3GphtaD54SIx2VJ2J9ZJGSUDGkURZIC74UYRsjye3+8
	 UajCOKjAW1xHh+45MZrndRoHDbSarIPH5ArOWzxppGaF85lGnRebfhUpdPOd3z6cl/
	 u+q/jmQhZqejPA/DqihT1yGd+8BXHjjLvgHsJptjf58rw0zwwIb0HfJz0IjVxmwBWJ
	 QaI0bP3b9OMEw==
Date: Sun, 27 Sep 2026 23:15:58 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 19
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a nineteenth batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-19
---
Commits in this patchset:
 * xfs: be extra careful about replacement directory construction
 * xfs: improve dirent bounds checking in scrub and repair
 * xfs: abort dirtree repair if the live update hook dies
 * xfs: bail out of directory tree repairs on error
 * xfs: fix revalidation of xchk_dquot_iter cached mappings
 * xfs: don't repair fs summary counters with garbage
 * xfs: allow softlimit with no hardlimit in quota scrub
 * xfs: assign an owner to scrub_stats_fops
 * xfs: fix lost errno returned from xfarray_foliosort
 * xfs: fix skipped inode mask handling in iscan
 * xfs: don't proceed with xattr repair if the live update fails
 * xfs: don't fix the directory tree if live update fails
---
 fs/xfs/scrub/attr_repair.c    |    3 ++
 fs/xfs/scrub/dir.c            |   56 +++++++++++++++++++++++++++++++---
 fs/xfs/scrub/dir_repair.c     |   38 ++++++++++++++++++-----
 fs/xfs/scrub/dirtree_repair.c |   67 ++++++++++++++++++++++++++++-------------
 fs/xfs/scrub/dqiterate.c      |    1 +
 fs/xfs/scrub/fscounters.c     |    4 ++
 fs/xfs/scrub/iscan.c          |    2 +
 fs/xfs/scrub/quota.c          |    8 ++---
 fs/xfs/scrub/quota_repair.c   |    6 ++--
 fs/xfs/scrub/stats.c          |    2 +
 fs/xfs/scrub/xfarray.c        |    4 ++
 11 files changed, 147 insertions(+), 44 deletions(-)

