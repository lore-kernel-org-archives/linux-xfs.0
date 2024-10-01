Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846ED1C6889;
	Tue,  1 Oct 2024 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727801331; cv=none; b=QdwLbxCmlA5emiAmpDvLGX61v5o3bR1F/wVryFiozaSGKUS066E3nl337L+kDjOifut8vGDaouAyghJXvefCzy0MeoxLTFxLWRnclSGc7xDXyEAp9UFOe+TfLlCiSGheKQyIWwPnYAvypJhVdb31r/LsXZllX99D2o137KvJEH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727801331; c=relaxed/simple;
	bh=ph9RmkEOqRry8GvFouPuHMK8qhqvk/CnGoSNBU1rNVE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=nFdHlnu2qqbRxJtEXGbCKTJt7Tm0yfkfRmu4isDPq6WwBqbqmCnfIyIzk+pwnxMqO+SDW2HGIMdl1dpOaPJIoyjfVEyiRDfvzw/HZmat5ApMJDj2LQzAEahGTPZ9CaA9HBfk7mnVTlWpyu79U+FlpCcdgQ2UkhovANAjEmpioB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSBHg5yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSBHg5yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0253FC4CEC6;
	Tue,  1 Oct 2024 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727801331;
	bh=ph9RmkEOqRry8GvFouPuHMK8qhqvk/CnGoSNBU1rNVE=;
	h=Date:Subject:From:To:Cc:From;
	b=jSBHg5yFHXgB3MMnabw+z4kH3WkopyS3PMMXoSY04GZf9UJMbqfmi71Szt0i8m0xI
	 33RAyiQlvMtld0tVNWdJ7A4XmFVepJAAw8+lKVdgnIeYfP6FEwIxhKOC8tDtmjAFmA
	 np9VsPqE0fvu5fDOrx7ER5OkHcqGa64JJMJU/xy69SnYgO7vqLH4reoxeSY11HqntP
	 sB/m31mCZ+KPPB30/gxkTnsYy7Kiev+CGgBWvM65Al2EZfNl2080TL9uvskldPzUSB
	 hUDpM1uASdzMT8u8HNtep7nhNLMAN9+mv3c7EMLsZrd/nX8kLv/n0e9Qbim8DBBqKB
	 XV7BRj/GJzjQw==
Date: Tue, 01 Oct 2024 09:48:50 -0700
Subject: [PATCHSET v31.1 2/2] fstests: atomic file content commits
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
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

This series creates XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE ioctls
to perform the exchange only if the target file has not been changed
since a given sampling point.

This new functionality uses the mechanism underlying EXCHANGE_RANGE to
stage and commit file updates such that reader programs will see either
the old contents or the new contents in their entirety, with no chance
of torn writes.  A successful call completion guarantees that the new
contents will be seen even if the system fails.  The pair of ioctls
allows userspace to perform what amounts to a compare and exchange
operation on entire file contents.

Note that there are ongoing arguments in the community about how best to
implement some sort of file data write counter that nfsd could also use
to signal invalidations to clients.  Until such a thing is implemented,
this patch will rely on ctime/mtime updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-commits

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-commits

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-commits
---
Commits in this patchset:
 * src/fiexchange.h: add the start-commit/commit-range ioctls
 * xfs/122: add tests for commitrange structures
---
 m4/package_xfslibs.m4 |    2 ++
 src/fiexchange.h      |   26 ++++++++++++++++++++++++++
 src/global.h          |    4 ++++
 tests/xfs/122.out     |    1 +
 4 files changed, 33 insertions(+)

