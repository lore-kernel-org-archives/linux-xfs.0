Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25115F4F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000332; cv=none; b=FGl6j4Gd9zAmGbagj9Ja3WjzbC94VFjIRLrnFyHheoFRXQ66TFf/03nfasAJ0fTzwzEUqM2PkEW7ZQkv0wUPqWeiyc3ely1biKingIoYJ7u5+2LRW/7e5xUx+318q6TMu+/uWxoM6rLw147Lx7qHYPdPoS+zj+AYygMER1lI33s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000332; c=relaxed/simple;
	bh=C6tYTprx6ZIVWvs1MaZ9iufMr54T+V0aOOgRwMpDXyo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=P9FIrwfp5vlaJIJ7L8QkDNGZ+RH5rAG5fzn1oyLrTMMV89f3G0saioxZ8SUDxdO0H1bQ8AIfOykqO3cbcttSHKi4nnqRXd2dW1Cv7KxOn0/P05bXGdK4pdyVqBwL1Lh2cDs05+BP0bkPEMLEUJsT7nTDG/Qhm7SoHf8fv6PUqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dofJQRop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dofJQRop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAF4C433C7;
	Tue, 27 Feb 2024 02:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000331;
	bh=C6tYTprx6ZIVWvs1MaZ9iufMr54T+V0aOOgRwMpDXyo=;
	h=Date:Subject:From:To:Cc:From;
	b=dofJQRopIeN6H7uAIzsiFy6FIGZG79IzDpAgfc42ap8uLO4ZodgtTXrEyXZJ30K25
	 gHLwppnJXmkdMDSDpD+g4mlAscJzR5+wZNHUNR5q9EwqPKPU4QNj17Pivt57ttrbHx
	 vXL+kLQKnUKDSz21WJsXv9a93ADP9eiBiKtwoF3jPPnyNYxRwi1ISFvW4+kFNmSqk8
	 eE5K3GXqssoooxvHEQLclM/tqX+4r8lmVUPLkb0BXmXD28Y4acoUR0cdwZA4ak6kCT
	 3gDkIkcyTKnjF52Zm0uh0PCNwaQ/upx232PiqB3yoU5SwfvVZgIH1GJKzlSLRsbvWH
	 sd4Y3v+SG+a3w==
Date: Mon, 26 Feb 2024 18:18:51 -0800
Subject: [PATCHSET v29.4 12/13] xfs: online fsck of iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
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

