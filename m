Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46627AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294502; cv=none; b=m7d1sxU+UDo5r/u4oNnwoKADHJ7GSKWZQ7iiIRylRrcd9wvtJQi8WfJOC0I80L11bZkKJ7Evj0d8oroZAxB6YBALvYe1+LDlt+U7D+f/kC4RZfvTfcFhhHvhQBCBAX31gGtieCyYj8jEQHLpE6ago5ItKHS5Zxu68ZiDa0wC+ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294502; c=relaxed/simple;
	bh=5A4MS+s3LdPk5dBPuQyuNAioZ001f/QykJCr6FuzW3M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqvR0yU1wUUPpoBlKt7MLrlw40xBSKuve1sEnHmOnfqiuMrarx6v6hHsY6vL7zwz2V786Tr13Fteh+mzh6H3ilpwj57vcuSCXDgbViSxeyqMMPHgXshmDTAPrner/gkmD0jRKs1D4+QKiQ+ArNZZD3+6CA1cLYxuTbpXvFj9+q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nle4qKDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nle4qKDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BB3C433C7;
	Wed, 13 Mar 2024 01:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294501;
	bh=5A4MS+s3LdPk5dBPuQyuNAioZ001f/QykJCr6FuzW3M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nle4qKDOvus8rU0wK+7L1Ipf41FEQ+sBN1cPIPIQMJ4j30XVLL0xVKfLb7ac6xkGG
	 oxYTXbeoslbbipxhRScG2A1pvG0hvm5sCBN8sICzR+Vncxzw+khN8okMrbNXhOUNez
	 YrHh/Sxg1IFixTTrlxJGtzyhK4J9R/Qnzbdm2ygx11zfa/re5BAVkl379s5QNWrfx8
	 mpD+tdhk8k+PbM2ap44QiHO+G/IexvQ9sSQ3bT/OUJ0akid/3ACLHMRhgyRBb7S4Rq
	 OrPYPCiQLQZsV//LBy9289KOrw7zlQtg2lJ9NO31sA0PQQ5ATq3RukcfHYVM7N3rwd
	 t295duUWtYKeA==
Date: Tue, 12 Mar 2024 18:48:21 -0700
Subject: [PATCHSET V2 05/10] xfsprogs: fix log sector size detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

From Christoph Hellwig,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v1:
 - fix a spelling mistake
 - add a few more cleanups

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fix-log-sector-size
---
Commits in this patchset:
 * libxfs: remove the unused fs_topology_t typedef
 * libxfs: refactor the fs_topology structure
 * libxfs: remove the S_ISREG check from blkid_get_topology
 * libxfs: also query log device topology in get_topology
 * mkfs: use a sensible log sector size default
---
 libxfs/topology.c |  124 ++++++++++++++++++++++++++---------------------------
 libxfs/topology.h |   19 +++++---
 mkfs/xfs_mkfs.c   |   71 ++++++++++++++----------------
 repair/sb.c       |    2 -
 4 files changed, 107 insertions(+), 109 deletions(-)

