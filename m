Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02494B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q02BXQfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79897C433C8;
	Sun, 31 Dec 2023 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051519;
	bh=0lo5jIsToDn6m9RHhnd5MuMQ8VLNksgMLmwX/D6azu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q02BXQfdM1uty1TNE8HT/mLVfMP9xUaNVMpjn491XEa3IkhCehLg61SWEaXbVfxD6
	 tltVLTLFJ98gH7bdnZYAaGS3oG+BGys3gwazun72h5JULtJP/2DCOV5iIe8wf+NhuK
	 bjzUhcuYQRy2zu8EIeYoCkkKAFnZByfkHRXxUucDQM17aOl6wOsirCkA7YLr2MGdbY
	 g/S5yhwGf98PZbp1zCQA9uetX9rXKAzzsZViVClhZPKLIL+/YPL4ngblwuugiugbG2
	 6H7Py8FEC+yabI2ynnFi84r+HL7H3F1K0Bua9hci0GmsYJP64fwX2YYvnrfomNOadw
	 +KhzIgT3r59gw==
Date: Sun, 31 Dec 2023 11:38:39 -0800
Subject: [PATCHSET 1/5] xfs: improve post-close eofblocks gc behavior
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170404854320.1769544.582901935144092640.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

Here's a few patches mostly from Dave to make XFS more aggressive about
keeping post-eof speculative preallocations when closing files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close
---
 fs/xfs/xfs_bmap_util.c |    9 ++++++---
 fs/xfs/xfs_file.c      |   14 ++++++++++++--
 fs/xfs/xfs_inode.c     |   13 ++++++-------
 fs/xfs/xfs_inode.h     |    2 +-
 4 files changed, 25 insertions(+), 13 deletions(-)

