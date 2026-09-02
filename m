Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B02155757;
	Wed,  2 Sep 2026 05:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327705; cv=none; b=cgtwx/wJvj/beDrkcqZIFZq/EKp/zmSTkNPzeGa97z4+ndvVJEq+oqnpjTH0IgyoFBD2NijfhFW70V2FBU7yCNuWSRRQ5Md+LbUm2lfQlBnnY44rfPUTbSCFQK8QCIdXf+o+uhK/M+wOLPoaiCIeuaDJvz6fJq4T3GZZ4a/fhJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327705; c=relaxed/simple;
	bh=xPtaMoYvazOcEe3Qdkvav1rJF/DNPdYIv4auok8F++w=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=pDFkqt9u3T4aUDtiqJsdjZogar8nJxUkvrucM5R05NNGx0DgrN5uZn98JXviUo6k7VVlO6XzF09J4TioaN4/0CqNdzIv9mptS9yknMRTp9GSBUmoDgswAECL+WmzHd+aq5W2OK/Zxz9trbM9ffBO6XAfyVLOtsIjuwl27Sha0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVGM2K6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVGM2K6R"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8622A1F000E9;
	Wed,  2 Sep 2026 05:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327703;
	bh=NDIg5vTgu/QtSW5uyZL8tQL5+OQKXkfLmYPk1DcFtO0=;
	h=Date:Subject:From:To:Cc;
	b=YVGM2K6RRpC8ro9aFrxxIrDxP8cEiexxR9fGtE4XOGsLEMk/DL38cYhzVF/m4YBs9
	 ZXY3vtm8rvJYM0vW0+i+nbuweffLVpDg7wHTklEsZm2Ey025FSF7CCoKpvyQ8PZ5dR
	 ALaG3drlBsAie6R0AIBjW0hL0CnVaicVmV5mDrIAAZPU7hWsOLTSlhPrKlIFQh5Xlz
	 M3Xnv2M56nNJaK9uMnk8pqDUZ5F8VOupKcvUXe1TXEg5+r3wElt0w3KeIe9tvaFZ0c
	 BTkHiPmj3Gc05mUxQfsRAdw70inTZi5Zaoxy++snwx9ifK3SKFEZO41isRtJSKtodD
	 AaqQUgNkENx1A==
Date: Tue, 01 Sep 2026 22:41:43 -0700
Subject: [PATCHSET v3 3/5] xfs: LLM-inspired bug fixes, part 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a seventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add rvbs, tweak some of the commit messages
v3: add more rvbs, finish review

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-7
---
Commits in this patchset:
 * xfs: don't spin forever on zero-length dirents when salvaging them
 * xfs: don't stash removename operations with unknown ftype
 * xfs: log the tempip after we convert it to extents format
 * xfs: fix parent rec lookup initialization in xrep_metapath_unlink
 * xfs: handle reconnecting metadir subdirectories
 * xfs: lock the healthmon when inserting unmount event
---
 fs/xfs/scrub/dir_repair.c     |   27 ++++++++++++-
 fs/xfs/scrub/metapath.c       |   85 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/symlink_repair.c |    2 -
 fs/xfs/xfs_healthmon.c        |    6 +++
 4 files changed, 114 insertions(+), 6 deletions(-)

