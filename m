Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC7B652;
	Tue, 26 Nov 2024 01:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732583919; cv=none; b=eIeWA7MNww7Y3b3FBmMYoOzML++99fAV/c4WQN85ie8AXJrFk+TskWLNjlIue5p6qliC+4L7nmmUsXJn98ZuXoruLr/W2rEruTE88T8uP/qH9yZglD/yA6wnL5Wah1C0wGzyRbsH659O3p5t8wpbyh4nqvWaLBHmWx+7KFYcm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732583919; c=relaxed/simple;
	bh=xkrUIHEDlzXmrw8U3wtY0pfWT+iz5qzF+9JEFtuA0P0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TvNMBmAX7okfX6XB23iSk+jR9T2C+jD1senRH+2BIEvo1e++uxqxyH1cKIETPiZSB0/OUnrLIjPkJetgxe217xai8oGLKl3ll+nVxswLYcfkVywJjYh7L0Ounz1h0mb4YEYaE5MnxzA3odpZzWv2UaMXqiUC6cYdmkeqIu8X6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzdC69s8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzdC69s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1856EC4CECE;
	Tue, 26 Nov 2024 01:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732583919;
	bh=xkrUIHEDlzXmrw8U3wtY0pfWT+iz5qzF+9JEFtuA0P0=;
	h=Date:From:To:Cc:Subject:From;
	b=gzdC69s8RIl7TBeov/2tI4xdJs5DUghEW/HQnn0hg6P3a7LY14Kf91ETgdWW3feMg
	 v7gZVj8o9RAx/E3CxnZVtLvkQ3LVLPe0TzSYGE8xbnHve4pKrutQy543FMTVQwENgq
	 uoWLO2+G8UN2uKdu5AJNETq18umuLaEa9XYZN/bNA69BkIYWEyNajoU2WvVHHprNhd
	 ftU4pRvEUQJfjHBTZOM/yBfC9qoBhrLJhEmS+g0+n8trrIFrdVNlwaStuUsSYt0Q8l
	 dmrb8fcChAm683Gxt2qXq5Kgln5O4yOqWtDQaBhtZID0Iw/KM3j3F8AXOFDHYRv2TK
	 ugzrNZbXOF+8w==
Date: Mon, 25 Nov 2024 17:18:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>, Carlos Maiolino <cem@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] xfs/fstests: largeish pile of bug fixes
Message-ID: <20241126011838.GI9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

I have a rather large pile of bug fixes to send in for 6.12^H^H13-rc.
Most of the fstests fixes you've already seen before, but I've been
working on some new bug fixes for the kernel.  The code that's already
been reviewed is ready for merging, and I was going to ask for a merge
last week.  But.

But then I decided to look at a warning from the page allocator and that
unravelled a bunch more broken stuff.  So now we have some fixes for the
transaction code, a couple more fixes that got lost in the rtrmap
series, an unlock bug, and the quota code.

Ah, the quota code.  I'm removing what I hope is the last place where
reclaim and/or the AIL can have to do a disk read in order to write
dirty data back to disk.  Fixing that was pretty annoying until I got
the other bits settled.

Here's all the new stuff:

[PATCHSET v3] fstests: random fixes for v2024.11.17
  [PATCH 06/16] generic/562: handle ENOSPC while cloning gracefully
  [PATCH 15/16] generic/454: actually set attr value for llamapirate
  [PATCH 16/16] xfs/122: add tests for commitrange structures
[PATCHSET] xfs: bug fixes for 6.13
  [PATCH 11/21] xfs: update btree keys correctly when _insrec splits an
  [PATCH 12/21] xfs: fix scrub tracepoints when inode-rooted btrees are
  [PATCH 13/21] xfs: unlock inodes when erroring out of
  [PATCH 14/21] xfs: only run precommits once per transaction object
  [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
  [PATCH 16/21] xfs: don't lose solo superblock counter update
  [PATCH 17/21] xfs: don't lose solo dquot update transactions
  [PATCH 18/21] xfs: separate dquot buffer reads from xfs_dqflush
  [PATCH 19/21] xfs: clean up log item accesses in
  [PATCH 20/21] xfs: attach dquot buffer to dquot log item buffer
  [PATCH 21/21] xfs: convert quotacheck to attach dquot buffers

--D
