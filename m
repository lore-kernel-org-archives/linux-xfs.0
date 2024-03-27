Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF821CD3B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504198; cv=none; b=mQIv8Pjlw8RWEKmWyKWADw0p0NXjBy+DbqRuF2nN+z1I3ZJpnpRcGobb5oHfixrwkmU/Bw7dgUI7qJfxpfE84lBjD+M3ozpTxzNNwFen3akhR8Ll4Ia3XahSRtJqC0xyWw8oyS1HN28T7JZC70y89eQ6PUVnUzdR3iaCnWsZXfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504198; c=relaxed/simple;
	bh=VPgRPIFfvbILCs16h5gz68U9fFeduD8DSvECisHzxrs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEy94Qce9pWCU6FbvsFL6N/JeRFwYKOIZXKyf21xgwnAPgPX8gvM9e+/FxkrH7UDm4C2/Q2GayohrsYQPrlBdkAKsKNBunjg+1UM8nvtuXkyqhdzkvWLkaNAqfGlyxUkjvnt9a6SYCJ9k/l3Tdn8kXoN+UPSut2iU/MXW3u4NOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OH2VECzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OH2VECzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF66C433C7;
	Wed, 27 Mar 2024 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504198;
	bh=VPgRPIFfvbILCs16h5gz68U9fFeduD8DSvECisHzxrs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OH2VECzY7vqkOFB79sFOzaq74ZavOG3XgGUrNuoayRxOAK1je8TXe2VHQr4wjYgzL
	 DfRWB30D8+4Y/HWk1Pb/EY547X0d6OTndq3tyh8rw1tDdCMrq8fsYOpwsjKNbqdIem
	 mZzeJj/i01AZHRMSK94iLh5Gb7CpwmRFH/RHlQI6TgnXUhgfRW+O6+R7IRvwbE2rSc
	 nhV4M6FnJLk0c3mYfzoem0MsgJyk9NWGzdvpEdVff0USbKQZyaYhCSJwOnBxzZiuJQ
	 byFiJtqx99Cnp7AZqf0poSS8StWMmi1ARGf1wQ+OC/NN7UezjfyS51C8Z06W52q/DS
	 SWTyHRL0/f73A==
Date: Tue, 26 Mar 2024 18:49:57 -0700
Subject: [PATCHSET v30.1 14/15] xfs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.  Fourth, the x{chk,rep}_metadata_inode_fork functions
should be subclassing the main scrub context, not modifying the
parent's setup willy-nilly.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
Commits in this patchset:
 * xfs: check unused nlink fields in the ondisk inode
 * xfs: try to avoid allocating from sick inode clusters
 * xfs: pin inodes that would otherwise overflow link count
 * xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype
---
 fs/xfs/libxfs/xfs_format.h    |    6 ++++
 fs/xfs/libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    8 +++++
 fs/xfs/scrub/common.c         |   23 ++------------
 fs/xfs/scrub/dir_repair.c     |   11 ++-----
 fs/xfs/scrub/inode_repair.c   |   12 +++++++
 fs/xfs/scrub/nlinks.c         |    4 ++
 fs/xfs/scrub/nlinks_repair.c  |    8 +----
 fs/xfs/scrub/repair.c         |   67 ++++++++---------------------------------
 fs/xfs/scrub/scrub.c          |   63 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h          |   11 +++++++
 fs/xfs/xfs_inode.c            |   33 +++++++++++++-------
 12 files changed, 187 insertions(+), 99 deletions(-)

