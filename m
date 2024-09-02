Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCE19CC03
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301278; cv=none; b=AXF/TweifnvV2lweZ54G3avhlgPSeFHUBB/nofYtN1PybeTUDLTg4N9cAhJP/XyJi6FBpkefFNYppj4+PVr3Gb/TSUtcGRJ3sv/kNSEPrsOmaS1L/sMTC4WBfxayaeCkpTtfS3H3kHAvX+71gkJg2ySFwAXR/GFbb9EMO/SGG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301278; c=relaxed/simple;
	bh=wmsdMFZyYw9nUhx8ih3WK218gLXBNVt5Nr3e33Q5xwA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=at4okeQlW9iyEtimcGsy3gEyWkWBH3myvPy0+XbxSsAsEXZrOaFkDg1fI4TLUXFtZ0s86C5vkJD5e8S/ZWV5DDW8UK0EOYcDrKdCZGaTqXWmjxmpuaZveJgL4ZNkON8ldqAm/YyfYIottZPWQgsJ8VeIpNYq4YMuH8sW8ZoSHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNXZr653; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNXZr653"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B24C4CEC2;
	Mon,  2 Sep 2024 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301278;
	bh=wmsdMFZyYw9nUhx8ih3WK218gLXBNVt5Nr3e33Q5xwA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iNXZr653H67MLgkBvMfUpf+dufHPnjWIG+3wzEEd7pqtKX5HPERxuZeEUAOFMdrHm
	 E2dInWuF8Glam0Wqk9RDVhZpbDtRTeN+rurGAsyeA2qHZOzr2y507M2lOfxsJP1dCk
	 Bq9Yg6b1V8FvVChosjBoimUUWXPGgTMz1tTFR71U3YkZzwxy6sMsedQqfiGi9c+PKA
	 s2Efva80HZiY9sTga0Gh6c+WKOQhf2QuiP4AKz+Cy2Z3j6hARK843dN/sTCNClDSLD
	 YIy2fIrVYefBPnrkYITwPCbPQBe6PefO8wczSyzSnmJWMTtn3bESg1zcbwJMtKmkqa
	 s+HrrrCIVGXTw==
Date: Mon, 02 Sep 2024 11:21:17 -0700
Subject: [PATCHSET v4.2 2/8] xfs: cleanups before adding metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
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

Before we start adding code for metadata directory trees, let's clean up
some warts in the realtime bitmap code and the inode allocator code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-cleanups-6.12
---
Commits in this patchset:
 * xfs: validate inumber in xfs_iget
 * xfs: match on the global RT inode numbers in xfs_is_metadata_inode
 * xfs: pass the icreate args object to xfs_dialloc
---
 fs/xfs/libxfs/xfs_ialloc.c |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.h |    4 +++-
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_icache.c        |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++--
 fs/xfs/xfs_inode.h         |    7 ++++---
 fs/xfs/xfs_qm.c            |    2 +-
 fs/xfs/xfs_symlink.c       |    2 +-
 8 files changed, 16 insertions(+), 12 deletions(-)

