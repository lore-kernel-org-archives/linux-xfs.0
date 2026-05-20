Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3043043C9
	for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 08:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779264440; cv=none; b=tNvygO2gQktuIuBADTWVzBV0C3zVfn/OfsXac4Q2hLaX0Maqw1Di4OxTdDE97TG3uGVCwc0ND9Ewl68TaGXeilZgJH+wed90Ta1e29WFaUY44sTyIQW9GakxPwcPVpKdbmv14WMRhtqSnqJfoHFO8OEFj9oSZ1e3dt+pzOzcaEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779264440; c=relaxed/simple;
	bh=I1PmtdKvnufHl9lHveVru68fv4cByHmGLlJxs7l4Cy4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F6t7/uLk81gnWAhCCQxvftYpQrMORCmttPEmmIieF7Q/5aXDnHn9AsbU1YaabW2VnwHLv6W3bOhUqxQSU+dP5xDbY5PjoAckzujDDmJDneklB2hw7xTc2DGsZXDbacmUnfBm//N5oOvz8U7ZcQdLBR1sMvRh5iuOscnfw5w168I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNh3cGL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNh3cGL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A311F000E9;
	Wed, 20 May 2026 08:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779264438;
	bh=u2q1hHbCCD4PW6r63X7XF7Pog+gEODO4Y7Xrnffjdrc=;
	h=Date:From:To:Cc:Subject;
	b=UNh3cGL1h+r7e84rk6+z7wRjjC0/eEBB/eQzD2dKVyi091Nk9rG6feeaRWFfm17R/
	 bdI1/htlmSrvbyQgThPdDXXivAyk7ZK7Jd+C0VNiYmJCIBHK2+QibVEgOu+ZcxtBNk
	 0SuRgfv7W6esdpABiE5Jmc3Ynpz54TsyodHVJZK6/LMeiiuFdip8OSn/XDQGaLvQG4
	 CUGXEv+HVXicoz0spVrxqv0Jel2X/vwkyooM+wtMLf1tuN+8wowDXi9IX8mcmTfmAP
	 Z1n0qJEqAKMSuot8zM+YrqmTHVkSAHJHkANBD4EjckEWvjxRxyNCCYh8WdTL8HM6hT
	 OVR3nb64XASHA==
Date: Wed, 20 May 2026 10:07:14 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, ailiop@suse.com, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: v7.0.1 released
Message-ID: <5jqivrnvsjgc5n72ykbz3o625cpjagm6pyceyawvdlp3bu4mng@osoivwl7sxg6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release is mainly focuses on fixing a build failure while building with
-Werror and v7.1+ kernel headers. Then, there's fix for a xfs_healer build
failure on system with kernel older than v6.8. Other minor follow-ups to the
fixes and repository maintenance included (dead code removal, release script and
gitignore update).

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

80239046c0dece6ef0d56413637f8af22d3b074d

New commits:

Andrey Albershteyn (3):
      [6149155d0589] xfsprogs: update release.sh with fixes from xfsdump
      [b623033285fa] libfrog: add missing HAVE_LISTMOUNT flag
      [80239046c0de] xfsprogs: Release v7.0.1

Anthony Iliopoulos (4):
      [5a26358ae3d9] configure: always check for statmount supported_mask
      [877f0e57a10d] libfrog: add missing statmount flag definitions
      [b30356f25335] libfrog: add fallback stubs for libfrog_statmount and fstatmount
      [434afafebb3d] gitignore: add xfs_healer binaries and services

Darrick J. Wong (4):
      [66fff0c12fda] platform_defs.h: fix __counted_by_ptr annotation
      [7329ba24ac39] xfs_scrub_all: remove dead code
      [46efb75687bd] xfs_scrub: remove dead code
      [ba267fe516d8] xfs_healer: fix missing HAVE_LISTMOUNT flag and stubs

Code Diffstat:

 .gitignore                |  3 +++
 VERSION                   |  2 +-
 configure.ac              |  4 ++--
 debian/changelog          |  6 ++++++
 doc/CHANGES               |  9 +++++++++
 healer/Makefile           |  4 ++++
 include/platform_defs.h   |  2 ++
 libfrog/Makefile          |  1 +
 libfrog/statmount.h       | 24 +++++++++++++++++++++++-
 release.sh                | 20 +++++++++-----------
 scrub/unicrash.c          |  7 -------
 scrub/xfs_scrub_all.py.in |  6 ------
 12 files changed, 60 insertions(+), 28 deletions(-)

-- 
- Andrey
