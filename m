Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A76386
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227322; cv=none; b=rM07lB8XpMkpwKBj+DChNBLHmgDLKkf6NQtAX+fjBd8cQehBlNi2U9vrrgd9fhP4wHD8dftz4j2Ej4Ox7G8fZzhLg0mvtvPy9Fo7ZlO8pIGRR5+FZc3Ociw9cCNaDN6tgPhUXRB7D2flQjQxhjOU5IrC6Y2S272TdZH57M/NBP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227322; c=relaxed/simple;
	bh=zR3awoOGJm8pFHiWnlP02Ha4ybKSZOmEU9A19Jl/OwE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=hs1ohSJTUP29BJHuNlt3xiU7DG0gOPBo0D1uRz+NodpRo/uZIVi2oLqcVq1yr+18YePr8Ewb59QcIgqG0qSX1aYrANZGkjSRl4xAi/a33Bkh49HHoVZqJ29IH+iFK+Umimp9gGTzdgtM0J3BGJlqMykiikWrUrWUgJUq7PueAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DszOhv3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DszOhv3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971BCC113CC;
	Tue, 16 Apr 2024 00:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227321;
	bh=zR3awoOGJm8pFHiWnlP02Ha4ybKSZOmEU9A19Jl/OwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DszOhv3PN+ZOkqDHYUZuo4+/KiHqeAJPkRojydXc/2bAadxdEq/C05nlodeVIJSea
	 ZyCkWCCP1HytI5g9t8EQTR5IS/nyuT50Per+ARquJs8ccOcVzEgt7rLqPnbmLy9Kwm
	 +mKsYG+AAAOkWdjEYoZAxO+WhakEv/hmO07b+dfnjbMbuOjObURspOe5uTkeapOEMd
	 EtCUA5QcCOc4NHY7VXhHO1rcQd1XQRQXV99C5DYEp0pTSi5+Pohjv8U9CtLuqZho8h
	 bWe35rZq8NnBADkJOJZDqoUXQqiL7MhacwKR8EHdgNtFGb3kJzvRnqG//Iweaf2un/
	 T9SsnijjTE/ZA==
Date: Mon, 15 Apr 2024 17:28:41 -0700
Subject: [GIT PULL 05/16] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322716349.141687.11762646937801715481.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 5befb047b9f4de1747bf48c63cab997a97e0088b:

xfs: add the ability to reap entire inode forks (2024-04-15 14:58:49 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-rtsummary-6.10_2024-04-15

for you to fetch changes up to abf039e2e4afde98e448253f9a7ecc784a87924d:

xfs: online repair of realtime summaries (2024-04-15 14:58:49 -0700)

----------------------------------------------------------------
xfs: online repair of realtime summaries [v30.3 05/16]

We now have all the infrastructure we need to repair file metadata.
We'll begin with the realtime summary file, because it is the least
complex data structure.  To support this we need to add three more
pieces to the temporary file code from the previous patchset --
preallocating space in the temp file, formatting metadata into that
space and writing the blocks to disk, and swapping the fork mappings
atomically.

After that, the actual reconstruction of the realtime summary
information is pretty simple, since we can simply write the incore
copy computed by the rtsummary scrubber to the temporary file, swap the
contents, and reap the old blocks.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: support preallocating and copying content into temporary files
xfs: teach the tempfile to set up atomic file content exchanges
xfs: online repair of realtime summaries

fs/xfs/Makefile                 |   1 +
fs/xfs/scrub/common.c           |   1 +
fs/xfs/scrub/repair.h           |   3 +
fs/xfs/scrub/rtsummary.c        |  33 ++--
fs/xfs/scrub/rtsummary.h        |  37 ++++
fs/xfs/scrub/rtsummary_repair.c | 177 ++++++++++++++++++
fs/xfs/scrub/scrub.c            |  11 +-
fs/xfs/scrub/scrub.h            |   7 +
fs/xfs/scrub/tempexch.h         |  21 +++
fs/xfs/scrub/tempfile.c         | 388 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/tempfile.h         |  15 ++
fs/xfs/scrub/trace.h            |  40 +++++
12 files changed, 715 insertions(+), 19 deletions(-)
create mode 100644 fs/xfs/scrub/rtsummary.h
create mode 100644 fs/xfs/scrub/rtsummary_repair.c
create mode 100644 fs/xfs/scrub/tempexch.h

