Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBF61BDC3
	for <linux-xfs@vger.kernel.org>; Fri,  1 Nov 2024 22:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730499509; cv=none; b=gSEPsK7JazE/eA6oHPsCmsmjFBLNvo04Ls6bGcI7Yereahe83/9k29/nryQTMNVDwV+JAv8gQ17QFPKpLG+y5AqcYYcyAY5VLRzP79O2oJH95TCHFPH+YWnWBcJ3oKc1XZDmxvyCGuo3oS7KboL+rhpyLw491mGojdGyNL8XA98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730499509; c=relaxed/simple;
	bh=/8OaY1PlMnQv2m8rbX17fvcO772EHmQbc4JEDlA35zM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Y08z7txbkZdVm1MjQQjz5NAfXUSEg5hJR5u1bxfn3tTvT0QgW/WEyCC0qz3PLxTicWhU9xMe18valzcCwT5vCf+ZM6vZ/layvNUdATD+yUnQkABL413gdJ+otGwtTwFn87gy6NE96LW4CBVfFlQjrGDvYFcXjLDdA3fEJ1DNYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OaO4EaWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OaO4EaWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2938AC4CECD;
	Fri,  1 Nov 2024 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730499509;
	bh=/8OaY1PlMnQv2m8rbX17fvcO772EHmQbc4JEDlA35zM=;
	h=Date:Subject:From:To:Cc:From;
	b=OaO4EaWuRn6PYsV2EAvAxQei9Oi1dey0q3M6GZna9o+XNIs9aRdKugzdjYE5GBbRd
	 UeC9HtQA+LZ/SX68uMGV81rDL3EuYLPeyb0gQQNxfq1knLZnsBqZyShOovjXWNrT7A
	 G/DSLXe8eENJQ6LNfExwC6fSrpe0GIxYu/+Z5SFPvlUHIMDLVzPcujXFiENpKPaqJJ
	 a94JEr1qsvzDBp6g79he8mjZeCeGwW7STJ1d9EsKnnArxpbsOUSoulHavxMATj1NrK
	 lf4CIVrk7QwdTImVq1t6WG64s7J/0yLu/RWLo0qzZFsM0O2q1e3QVL4sLFpIFDGhqR
	 xmCNpZ+o/Z3dA==
Date: Fri, 01 Nov 2024 15:18:28 -0700
Subject: [PATCHSET v5.4] xfs: improve ondisk structure checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Message-ID: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Reorganize xfs_ondisk.h to group the build checks by type, then add a
bunch of missing checks that were in xfs/122 but not the build system.
With this, we can get rid of xfs/122.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for a couple of weeks with no problems.
Enjoy!  Comments and questions are, as always, welcome.  Note that the branch
is based off the metadir patchset.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=better-ondisk

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=better-ondisk
---
Commits in this patchset:
 * xfs: convert struct typedefs in xfs_ondisk.h
 * xfs: separate space btree structures in xfs_ondisk.h
 * xfs: port ondisk structure checks from xfs/122 to the kernel
---
 fs/xfs/libxfs/xfs_ondisk.h |  186 ++++++++++++++++++++++++++++++++------------
 1 file changed, 137 insertions(+), 49 deletions(-)

