Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122930EF91;
	Mon,  5 Oct 2026 05:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179729; cv=none; b=KXyZT5LYbqLK5Y2mtBvM1/XmbW2R8+KTLdXAGKXwgvl11Y8swhFT+BtupkCLd2zcEa1xdiybQJhIvMWpNGD7qxrxQxrL3CLeh36B/RFsLhmpJmlKXknV90kcw7Sd7VzkZHD67Vqesqr6CwDhN+rs8RXKxcn6wntiiQP7V+EXajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179729; c=relaxed/simple;
	bh=zsnTRmW5dYu3GlFXKQEheAry2CIK15srHWuJVnDa0bw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=B1Iy2Q39iaCyehRvnKVVAaQEuNQJHqQj0k0D233RLMF9BfOKRihXto/El846jRXE99cnjeT6h0CVPhO8Am4QTRt3xA6n9nORil5p1Q6banFd6sZsFTBgJrb2815cKiqocNFyPpjehZWAn4O+XG7OOE15qg4pGadYY80KlWiMYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTS4AMUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTS4AMUj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C58EC1F000FF;
	Mon,  5 Oct 2026 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179727;
	bh=0VYZACEIiGaDW5VLg3DYeX7rkbniigUVDdPFcgdnxG4=;
	h=Date:Subject:From:To:Cc;
	b=bTS4AMUjFnWKZ+RenWrbpYMt3z5voQyvQ0ruqyNaQPYdiHTv4khitdMBe7PFw0dvm
	 ViJd1GQSTFymn7FZAtCDmI0jZCbcMyjQ0gIH2tSiefY5REs3SXCMHmXDuZbT0tq3SP
	 TQUg69Qt7vJB64u/Z8TYy4hsUeAlDyFvfM/EU/PhFRRUU1A13BPnpaq/wOstXsvSxG
	 rtRB1PA5gmjYNdNmGVW9isjMLFyU29lbw5NJsxVrNWOuQRvVA3zl4xHuzTwA5IGH6B
	 Ud4CB2NaZuMWHiomDz9kcSmmxcy+Rs8dniEeW2jnplu6EeNCkb5DgqNm1WduG1+EH4
	 jxT29XtLhKsdQ==
Date: Sun, 04 Oct 2026 22:55:27 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 20
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twentieth batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-20
---
Commits in this patchset:
 * xfs: flag excessive delalloc rt extents as corruption
 * xfs: zero out di_metatype when removing the metadir file iflag
 * xfs: forcibly reset quota timers when upgrading to bigtime during repair
 * xfs: don't pass iget failures up when marking ondisk inodes
 * xfs: always reset incore attr fork buffer when resetting fork
 * xfs: propagate errors while checking null siblings
 * xfs: don't try to scrub self-referential dirent in metapath checker
 * xfs: don't allow sm_agno for non-group metadir path checking
 * xfs: init inode number for tracepoint
 * xfs: release ip after unlinked list store failure
 * xfs: always zero the whole shortform header when zeroing attr fork
 * xfs: always forget cached ACLs if the attr fork swap succeeds
---
 fs/xfs/scrub/agheader_repair.c |   13 +++++++------
 fs/xfs/scrub/attr_repair.c     |   12 ++++++------
 fs/xfs/scrub/dabtree.c         |    5 +++--
 fs/xfs/scrub/fscounters.c      |    7 +++++++
 fs/xfs/scrub/inode_repair.c    |    4 +++-
 fs/xfs/scrub/metapath.c        |   17 +++++++++++++++--
 fs/xfs/scrub/quota_repair.c    |   17 ++++++++++++++++-
 7 files changed, 57 insertions(+), 18 deletions(-)

