Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FDA1C36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832718; cv=none; b=eVu3AgAns/VLlg7l6uUBs0BNqT9azF5nkBFGMN6fsOIDylqhF4g1eAJLxP4aWhLA6YVsqjZaJLzWBtRc2WXy6UVI0MBlnvIB3d2mjYANxRt3xVKGprvJzqbdtBrgPX2J8fDK59YPVtvY0RRi1IeDgRSZSTh6FUpbbhQdx5kW6B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832718; c=relaxed/simple;
	bh=JBVUaA5MmSD28pPTmF1hdMj4Qz+ULTJpQp2L999Wad4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=iuI3LWl2VUy0JnV3PmI3bMMW8nGH5OR7V6zELdIQutebPIL3uCbIzi9um8iDSWgBB94uzVrpt57nIKg0BYfVQ+OghnnnaW3tF0m7SGRUJInKH45OvMT7ISH44emnsfoMzBDvHH/TmNMB4ugu91273bmKGPhccG7CE0dcjjRZBiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE38kNCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE38kNCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D04C4CED9;
	Wed,  2 Oct 2024 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832717;
	bh=JBVUaA5MmSD28pPTmF1hdMj4Qz+ULTJpQp2L999Wad4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PE38kNCVvT/zkptFDHE6hj7MA1n/6iRM1JtsllpxYvHeU9DQD5rfWPQ+A6wn12PNT
	 BCJgRrh3X9KhLvSnGBM7Z8yWopDro1EkS5cev1RdZ+VEKjtHPcSXa03NzSRUNyaGbu
	 DIau04Xj84Fjc9FtHtS1byNq27E/QvYw6fLlj/4tFeC6txfbWVFtf4eKnKe69JiYMT
	 qiDac2NCLMhNyUGafWLA62jFAj34kw1C95u1MeiTw1b/EACwAGKPGykNYEQzE5eksL
	 zMP4dIhGh9tIreqGbDTU5uSzSL7W09Zc3KsQR0fKunmZXHNOqpa7XUVpJu+jgYaqDg
	 6BwAgUAiINxjA==
Date: Tue, 01 Oct 2024 18:31:57 -0700
Subject: [GIT PULL 2/2] xfsprogs: do not depend on libattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172783265034.4076916.8174651955916785491.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241002012922.GZ21853@frogsfrogsfrogs>
References: <20241002012922.GZ21853@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit b92bf9bc2da75f3709f5f3a6c09d6c62d0d799ef:

debian: Correct the day-of-week on 2024-09-04 (2024-10-01 17:54:48 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libattr-remove-6.11_2024-10-01

for you to fetch changes up to 2ed5318f360d2734265c2dbf630e93ff3e5e5791:

libfrog: emulate deprecated attrlist functionality in libattr (2024-10-01 17:54:48 -0700)

----------------------------------------------------------------
xfsprogs: do not depend on libattr [02/11]

Remove xfsprogs dependence on libattr because libattr is deprecated.  The code
in that library came from XFS, so we can make our own shims.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
misc: clean up code around attr_list_by_handle calls
libfrog: emulate deprecated attrlist functionality in libattr

configure.ac          |  2 --
debian/control        |  2 +-
include/builddefs.in  |  1 -
libfrog/Makefile      |  8 +++----
libfrog/fakelibattr.h | 36 +++++++++++++++++++++++++++++++
libfrog/fsprops.c     | 22 ++++++++++---------
m4/package_attr.m4    | 25 ----------------------
scrub/Makefile        |  4 ----
scrub/phase5.c        | 59 ++++++++++++++++++++++++++++-----------------------
9 files changed, 85 insertions(+), 74 deletions(-)
create mode 100644 libfrog/fakelibattr.h
delete mode 100644 m4/package_attr.m4

