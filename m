Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F7A31ED93
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364895; cv=none; b=S2pgWOk2SQR+EUWA2CBcm0jcxcg1fRZCHnONUDi9MZsJgBh5TOmE70TE7pwURXgmzFpctwEbKEZwtgVkYRGNyowfCmrf5tbkRo+HEZvXtcThmL4LUT0Vx5icA/141IPdHPVB6W1RWchwrRb2m5Nd2X2fGxgtfo4NHH9lYbyLBAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364895; c=relaxed/simple;
	bh=5oZ8I1Le7yjONwzqFEecdHdQDUE8LIbno94WheN7BDg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=QCunD4a2ZyJ0yXOB8BoMUR6vrzKTJZGVAPg70JURybqY+EkWl08PbRLWtwD3vu+NEJxC7Ys6ulhrpmAkRP2fkNkk1lcQZQFiXZkTpWYJ0OaLsjW4NS8Rmth/8DyBedgFDyawo3yf7zeez59vMBzQzVXfvIGNfr6dDMuH1WNGOhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YB3aSGnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YB3aSGnn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 815151F000FF;
	Mon, 14 Sep 2026 05:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364891;
	bh=kTnJwuWN1D22JhR+V0Ilhzv71/lQ1O2dZ2BdbYYnUHo=;
	h=Date:Subject:From:To:Cc;
	b=YB3aSGnnSGnCj2fcsVffb5rWNNuwJy7s2YpwMIetJ/d6vds676ZgoPbSsZLGsYHA7
	 +bNA1cBbbQ+idabKQr8n3M33I5nH7U5WvtSzZ7KignCGMZGsemkdHW66lPKt2HGg/J
	 50xwv0xKwY3vWCArLRfEQh/mKr1muheyy6V89UIMSpbXM2ZgmZaCOMwJjfHnvbuy8M
	 XuUko9MCHpupKLFIbfoT594LS1HVuXZZ2YiL4ib1gSVMrikfFbcjqJnn5bcVtCriwU
	 GVvUuEn6xgxAZYS1UvaOgOUTnzOLJk1jJZj5HI7sot6AzBgiECqQrhLi+7dbqFHM0t
	 FtP6w9oUt3F+g==
Date: Sun, 13 Sep 2026 22:48:11 -0700
Subject: [PATCHSET 2/2] xfsprogs: use quotactl_fd when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

xfs_quota (really, quotactl()) has an interesting interface quirk in
that one passes a path to a block device in order to administer quotas
on a mounted filesystem.  Linux 5.17 added a new quotactl_fd syscall
so that one only has to have an open fd to the target filesystem.

Let's port xfsprogs to this new syscall because repeated path lookups
in xfs_quota mean that it's prone to failure if the device gets renamed
while it's running (e.g. lvm).  Weirder still, you can unmount the
filesystem while xfs_quota is running.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=quotactl-fd
---
Commits in this patchset:
 * libfrog: hoist xfsquotactl out of xfs_quota
 * libfrog: clean up xfsquotactl a little bit
 * libfrog: enhance struct fs_path to store optional mount fd
 * libfrog: try to pass struct fs_path objects to quotactl wrapper
 * libfrog: add quotactl_fd support to xfsquotactl
 * xfs_quota: open the filesystem mountpoint for quota operations
 * xfs_spaceman: port makecfg to use xfsquotactl
---
 libfrog/paths.h       |    1 +
 libfrog/quotactl.h    |   30 ++++++++++++++++++++++++
 quota/init.h          |    2 ++
 quota/quota.h         |   18 +-------------
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 libfrog/Makefile      |    6 +++++
 libfrog/paths.c       |    3 ++
 libfrog/quotactl.c    |   45 +++++++++++++++++++++++++++---------
 m4/package_libcdev.m4 |   19 +++++++++++++++
 quota/Makefile        |    2 +-
 quota/edit.c          |   36 +++++++++++++++++------------
 quota/free.c          |   11 +++++----
 quota/init.c          |   15 ++++++++++++
 quota/path.c          |    4 ++-
 quota/project.c       |    7 ++++++
 quota/quota.c         |    6 +++--
 quota/report.c        |   61 ++++++++++++++++++++++++-------------------------
 quota/state.c         |   38 ++++++++++++++++++-------------
 spaceman/info.c       |    7 ++----
 20 files changed, 208 insertions(+), 105 deletions(-)
 create mode 100644 libfrog/quotactl.h
 rename quota/linux.c => libfrog/quotactl.c (53%)

