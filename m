Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDDC495521
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 08:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778575174; cv=none; b=MiNDIkRCeKWlxX1FRZzrtQLhmKjSOkB50gWt3qfyJP8Bge92jRyp9ujwUl7aUmiJND4fLoxs26aIcqw7CfwefqsTBU8xTga26LzyHiqLYcfFbBKFU3YkFMdvHhgd8QFJBNnsStZDaKke2pQQ3qX6CM09ZTMADsSBHoKYwh5wQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778575174; c=relaxed/simple;
	bh=d6s6Fv11m3RiwQB01QrFeM/8D5tCgGXZufiNj/HXXco=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BMei0K5JYDQI3K9xyzTX5jwPKYvRiZGY8BdXjnH2FVEbEeLFCFB1m7UBHWorNQ1yBY0NQNjkgrB9+tEuYT4bhajGRnInMqdIfjSTDFzEZhUp3m5r3vbQEPrTytV1uEwTXQFVCDwy0+8gCTox6De/TsUbpBG/aPN0qGL0kY4GkIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rv3U0wrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rv3U0wrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ABEC2BCB0;
	Tue, 12 May 2026 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778575172;
	bh=d6s6Fv11m3RiwQB01QrFeM/8D5tCgGXZufiNj/HXXco=;
	h=Date:From:To:Cc:Subject:From;
	b=rv3U0wrSrr07a0epzAtLbz0YVVjJZcC7NtLLWzC9wl4AhLIuSTTnY1gfnyss6Xv91
	 6GumXFH52ruOJsQHLmkSBWNASrl1Cx4+IyEp/zgSs1VgxMlB2ITylcSu5MPVfGS/Co
	 HDjF2k3a2dmzv/oJ8N1y4fB3pP7UXZnHH/dbFfikCw5mX9TCSNl7HFo0GUrC+TiQta
	 U8Cke1zi3yvD57aa1af7Pav0cUWy/1zVi5bVp8Ptw/Prc6i/9c0d7hRfto/ydsaxD4
	 dgwGrax52ouXPrgaPM0ChdDwRq6oXLaEAju77JhgfwV+GvajrRK8FkH3Rc2v35O4ic
	 Ay50kp+ApI9OA==
Date: Tue, 12 May 2026 10:39:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, ddouwsma@redhat.com, hch@lst.de
Subject: [ANNOUNCE] xfsdump: v3.3.0 released
Message-ID: <yu4bqjh2oejn7t7ttsn6ibfziwwzcknhgg64xpl2gzbxsaa5ms@aai4qli3d7ea>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsdump master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

This release consist mainly of the fix in xfsrestore, the issues was occuring
for cumulative restores with subtree option. The renames outside of the subtree
caused assert fire aborting restore.

In addition this release includes maintainer tooling update.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

04051066b6c66218717cb6cbfd51e96df393d183

New commits:

Andrey Albershteyn (3):
      [523dea982158] xfsdump: fix permissions on files installed by libtoolize
      [7033f078face] xfsdump: update release.sh
      [04051066b6c6] xfsdump: Release v3.3.0

Donald Douwsma (1):
      [dd63de5d42e1] xfsrestore: only process subtrees that are selected

Code Diffstat:

 Makefile                  |   3 +
 VERSION                   |   2 +-
 configure.ac              |   2 +-
 debian/changelog          |   6 ++
 doc/CHANGES               |   5 ++
 release.sh                | 197 ++++++++++++++++++++++++++++++++++++++++++----
 restore/tree.c            |   7 ++
 tools/git-contributors.py | 168 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 374 insertions(+), 16 deletions(-)
 create mode 100755 tools/git-contributors.py

-- 
- Andrey
