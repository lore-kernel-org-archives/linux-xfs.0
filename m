Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8DD18C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504183; cv=none; b=qGa+sj8FiqLvgVm9skuep/HHNyJaFfcEeP30Rn0LdKd2EEWGGRMspI+/qzEcbjg+5U6w7wcjTD/Fg6SLygl+ofGAg4F8CgdCXcnI/5RIzazMt/taiYQpMrZIblXDtibzw2D1i8sSmYeAu3l+XNNYRSyspyErkITVBKJHW7S6mUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504183; c=relaxed/simple;
	bh=C6tYTprx6ZIVWvs1MaZ9iufMr54T+V0aOOgRwMpDXyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4R0KI7AY/Okf9rSIQ8Asl7iqorG7kTmCWxjA8as9DczDaZc0Bc4PJ+j40V9g/FLP2hH+/IG2X2vqbEhbCDPrK1RVZkrLlt+7b2NmbWULLfRhXpsoP4E3xd3Wx0bj+bEb9d5IMX7FovQMJF/JpLu9WTK6wKP6/Qo+kC2eTtArHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgmaC7T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgmaC7T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF0C433C7;
	Wed, 27 Mar 2024 01:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504182;
	bh=C6tYTprx6ZIVWvs1MaZ9iufMr54T+V0aOOgRwMpDXyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XgmaC7T/ONZaH7O0T2B2taku0DN0FRVqNtDSXN9GVwoTbd8yDcGqogYlMLGt2kLIE
	 y197gxaMLaC+iDIsWwBD3mXJ0l699dy2tI80hWDYUYGES5TygT6mXAyt+Pjei6L3l0
	 x/+Abk4QS33i1b3cGT1lIOlcGYTFr4iE0vRdF1sITLKBHLdIiyVtMAaw2ZiLo9GPN2
	 SXYvKh/KBW5tXI/IwGpkOewu+sbSIkEs9w+DBNRzw8ycqVmh8PhqfNTuAhbOqtmVwQ
	 EYe1l4ot9Ap/Z8OupOLT9wpSoTtq+cxJRTt3+72ErCWl19at3Ay/O5lqV4LjHtCoJr
	 LI5K7YqzA4KPg==
Date: Tue, 26 Mar 2024 18:49:42 -0700
Subject: [PATCHSET v30.1 13/15] xfs: online fsck of iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150384705.3220168.3647633643279321481.stgit@frogsfrogsfrogs>
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

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-iunlink
---
Commits in this patchset:
 * xfs: check AGI unlinked inode buckets
 * xfs: hoist AGI repair context to a heap object
 * xfs: repair AGI unlinked inode bucket lists
---
 fs/xfs/scrub/agheader.c        |   40 ++
 fs/xfs/scrub/agheader_repair.c |  879 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/agino_bitmap.h    |   49 ++
 fs/xfs/scrub/trace.h           |  255 ++++++++++++
 fs/xfs/xfs_inode.c             |    2 
 fs/xfs/xfs_inode.h             |    1 
 6 files changed, 1179 insertions(+), 47 deletions(-)
 create mode 100644 fs/xfs/scrub/agino_bitmap.h

