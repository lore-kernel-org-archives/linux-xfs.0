Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD792194A0
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190859; cv=none; b=pK98MAD71smdo4HXuDoZvt3A0U4ZZzbeH2fHaJoJBfcl5OOSB3OfmrctCYRPbzUY7+WxpXcrOTAiBKATazQENaG5o6UG/GHBptj6chSF/lj+MQHmKj6VWmRNEqwar2geHAOIrMTzHcjbgd1YUN9LWiFj4aaoiDzAjxiF03GnZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190859; c=relaxed/simple;
	bh=Whfye9i++uDaCnJl+Rj9nHoTJ3uOCMxwQkoH4UVmjEM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5BwbUm9T0g0z5IPLtd2UUUCpivPL+xn4dSGJNrjTCKL3p3HKNmcvGxq9CJjTxDBqaAVs7fkuAr4iRTAKYaFbffIeZckSa1r4qdSTuuQwxrMNpzwcek+2tv8NdIbSNYY/wpqKG+q6mvpJPsqMS+JtOPmjvdaGi432dUC7AeGMpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuymK0mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuymK0mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B858C4CED4;
	Thu, 17 Oct 2024 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190858;
	bh=Whfye9i++uDaCnJl+Rj9nHoTJ3uOCMxwQkoH4UVmjEM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AuymK0mJPXKxWHp6Qhhn0L5AfWfUUbEj4br9LwIzLHF/n4vngJeUxotNRjSh3DZ4W
	 CIXkQFCrI5kfuAuXQFpX/z2RZpjmMFJspmihw+o0PhDu+q5LjJ/eqKBmxR/Du9kCTX
	 foholt2aUM1xegHPghdKQb/bTHBURlqeFgy3Qut20wyhOIJ0o2Shbt6vcsV6TYZCia
	 4R9KVBIbIYzt7Eouqwx6SCMQ9ZaJcxsrGViJdTIoDQWg+JPtRcbSMjrvcHHV53kL8H
	 2pDgtfN1zMZ6DTDAHW4MBjARmpvyUGNkj327qJLFP3S78GVZRDekp2cWrqHBQ4A1g+
	 y41WmEaWHDVXQ==
Date: Thu, 17 Oct 2024 11:47:38 -0700
Subject: [PATCHSET v5.1 8/9] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
Commits in this patchset:
 * xfs: fix chown with rt quota
 * xfs: advertise realtime quota support in the xqm stat files
 * xfs: report realtime block quota limits on realtime directories
 * xfs: create quota preallocation watermarks for realtime quota
 * xfs: reserve quota for realtime files correctly
 * xfs: enable realtime quota again
---
 fs/xfs/xfs_dquot.c       |   37 +++++++++++++-----------
 fs/xfs/xfs_dquot.h       |   18 +++++++++---
 fs/xfs/xfs_iomap.c       |   37 +++++++++++++++++++-----
 fs/xfs/xfs_qm.c          |   72 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_qm_bhv.c      |   18 ++++++++----
 fs/xfs/xfs_quota.h       |   12 ++++----
 fs/xfs/xfs_rtalloc.c     |    4 ++-
 fs/xfs/xfs_stats.c       |    7 +++-
 fs/xfs/xfs_super.c       |   11 +++----
 fs/xfs/xfs_trans.c       |   31 +++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   11 +++++++
 11 files changed, 182 insertions(+), 76 deletions(-)

