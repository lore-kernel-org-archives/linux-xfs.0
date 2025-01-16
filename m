Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC7A8821
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063496; cv=none; b=DVGjFsRaW9lhXlHhu3EuECUYGAJH7t3Vlp4Jx7YxSBA4fUsiTS6m/dSBd9tVZo88Y/s+vsqnVwQwgh+WldIxXlsT3n1P9f1/UuEkZZ9RkAMI6QzjinnmypnrHZa4QJ50eAX+80KLKJsWKROvLUMqmV4B13kIMZCeyJE4Ws3pPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063496; c=relaxed/simple;
	bh=0Td399b0fmlhG6O7VC+pNzHZTS0WgsDWBzy+IRC3vAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyJHGjs32evpnlRC2oyaXUOXyDFIgB1/4XsQ8TzArBHKQoP+eaagBSi/Cq8F3+IKMMzwFqX2ug4B94+QC/Y795PqT5u8i4JppIE2AVY//asNRHuPh9eoXjMt3DCGwKsk8hr9IJe7kGBF7ShmQKyO7l+9rj44bmN4C+h1iVA4sL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZsIB/Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZsIB/Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB84C4CEDD;
	Thu, 16 Jan 2025 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063496;
	bh=0Td399b0fmlhG6O7VC+pNzHZTS0WgsDWBzy+IRC3vAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eZsIB/Yl9WQoi/R0a50aJUX7FlxHDTg7pHb5356Svk8gGb3kHJhLTiGCYaSs5tdpv
	 bHS3DboNsWC7Q2YKJZmM5PvdlOOzQ+BCLgQWLrwWpzJsHTS7NbUGCywxG8uQojhuWI
	 Ea99998I83+YMO64Bh5leexv6hW9fY5QdxMLK3/e+ZbokJRGjfaKpPaC0BtqoXbnRo
	 zObRynkLb5X880pE2feL9TjL4WKvx6nP/4k5muITP/255T/dFUvP0sqyryuxLEBAry
	 Uwu5WADyMJ5AcMwKYPjaiQW9dAHRcPpZbUjXjuDC/L/Eo2bOompm4H8N3LPd3YnJPX
	 pncKLamOG5kaQ==
Date: Thu, 16 Jan 2025 13:38:15 -0800
Subject: [PATCHSET 2/2] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: tom.samstag@netrise.io, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116213334.GB1611770@frogsfrogsfrogs>
References: <20250116213334.GB1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.13

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-fixes-6.13
---
Commits in this patchset:
 * xfs_db: fix multiple dblock commands
 * xfs_repair: don't obliterate return codes
 * libxfs: fix uninit variable in libxfs_alloc_file_space
 * xfs_db: improve error message when unknown btree type given to btheight
 * mkfs: fix parsing of value-less -d/-l concurrency cli option
 * m4: fix statx override selection if /usr/include doesn't define it
 * build: initialize stack variables to zero by default
 * mkfs: allow sizing realtime allocation groups for concurrency
---
 configure.ac            |    1 
 db/block.c              |    4 +
 db/btheight.c           |    6 ++
 include/builddefs.in    |    2 -
 libxfs/util.c           |    2 -
 m4/package_libcdev.m4   |    2 -
 m4/package_sanitizer.m4 |   14 +++++
 man/man8/mkfs.xfs.8.in  |   28 +++++++++
 mkfs/xfs_mkfs.c         |  144 +++++++++++++++++++++++++++++++++++++++++++++--
 repair/quotacheck.c     |    2 -
 10 files changed, 195 insertions(+), 10 deletions(-)

