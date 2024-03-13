Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40BB654
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294564; cv=none; b=pk1VT5LH1fqS+CADMLWpauYLEQAJIWyVOf4iys70xE2sucNEauHslL9649TXcjXN+J9rBLT5KhWGIvPMpwMrUqfSmt+PT3WxspFcrkMU10JeDObU5ulu7tozs46CzeTgXDRETa5YBkUpcmb8GilFxANbIxQX7mY6MqujCTTgTM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294564; c=relaxed/simple;
	bh=46Y6Dn8pzeZbtoP9BrsEKSPAMM6+o08DDHMbuwDxzio=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXBFg48VzWJSpLDEd4lZcjPiX00wi1KRz7JDwux/Y7wjp+XZpyNoBc/KZPIWYhH/d8NDB+jcsm6cqGWRN5qejD06V3cVtnw8CGh7xtVaVN2EqerC4LVoWMlib6Re3DGA1HkuOr9rB3AWjFWnO7hoW7lwJAzEp+loLa4zieNBQAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYb96tJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYb96tJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B01CC433C7;
	Wed, 13 Mar 2024 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294564;
	bh=46Y6Dn8pzeZbtoP9BrsEKSPAMM6+o08DDHMbuwDxzio=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DYb96tJlg9ZLXx4Zod5i/dan+/IWGgoOkFi3bIFDj6X3AlJcx1u+fmsEkKTFq+L5M
	 Ux7ygph2R3rgkZUS/C/UaCbWmNda/6NaYJX5m0xJFsJsIBsDeZnQiS1Q9zEcIpaLK/
	 Tw7+hzqbCDWw2TgRFQvRE8mqV4pnxII7LBEosZpSlwZ7JCCABeLjLmBq/LjubeBs3K
	 G2wX3joaG02NeSX9vo13Yn4Hc5aYCczPi6xe0Yn7VeyeSrpRFz3CFKzXccO0btgBUc
	 VMx0mUZvJLP1VXc6OadBIpZTXvSPGaDjxSL+gvcX2EkROQAV2ESDHhrSqB3axTxHXN
	 HIUP4t3VcienA==
Date: Tue, 12 Mar 2024 18:49:24 -0700
Subject: [PATCHSET 09/10] xfs_repair: support more than 4 billion records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
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

I started looking through all the places where XFS has to deal with the
rc_refcount attribute of refcount records, and noticed that offline
repair doesn't handle the situation where there are more than 2^32
reverse mappings in an AG, or that there are more than 2^32 owners of a
particular piece of AG space.  I've estimated that it would take several
months to produce a filesystem with this many records, but we really
ought to do better at handling them than crashing or (worse) not
crashing and writing out corrupt btrees due to integer truncation.

Once I started using the bmap_inflate debugger command to create extreme
reflink scenarios, I noticed that the memory usage of xfs_repair was
astronomical.  This I observed to be due to the fact that it allocates a
single huge block mapping array for all files on the system, even though
it only uses that array for data and attr forks that map metadata blocks
(e.g. directories, xattrs, symlinks) and does not use it for regular
data files.

So I got rid of the 2^31-1 limits on the block map array and turned off
the block mapping for regular data files.  This doesn't answer the
question of what to do if there are a lot of extents, but it kicks the
can down the road until someone creates a maximally sized xattr tree,
which so far nobody's ever stuck to long enough to complain about.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-support-4bn-records
---
Commits in this patchset:
 * xfs_db: add a bmbt inflation command
 * xfs_repair: slab and bag structs need to track more than 2^32 items
 * xfs_repair: support more than 2^32 rmapbt records per AG
 * xfs_repair: support more than 2^32 owners per physical block
 * xfs_repair: clean up lock resources
 * xfs_repair: constrain attr fork extent count
 * xfs_repair: don't create block maps for data files
 * xfs_repair: support more than INT_MAX block maps
---
 db/Makefile       |   65 +++++-
 db/bmap_inflate.c |  564 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    1 
 man/man8/xfs_db.8 |   23 ++
 repair/bmap.c     |   26 +-
 repair/bmap.h     |    9 -
 repair/dinode.c   |   12 +
 repair/dir2.c     |    2 
 repair/incore.c   |    9 +
 repair/rmap.c     |   26 +-
 repair/rmap.h     |    4 
 repair/slab.c     |   36 ++-
 repair/slab.h     |   36 ++-
 14 files changed, 735 insertions(+), 79 deletions(-)
 create mode 100644 db/bmap_inflate.c

