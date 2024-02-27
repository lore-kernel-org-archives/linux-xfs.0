Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B831096F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000287; cv=none; b=PeGoVneVlXXbb+q6OXMYBMYr4hOdC5OPkCDwVt8JL1O/6ue3yatg3gOqZxzOjeeinkEqrMq61RGsou/C5GSXEQcSOxWG4uTgZchQP9fP+UmkSSQHFWsD7lwC7ku/ta2zVdsa41tiYib67kg4LShLATxNWBi6OziKkwHEImWLunc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000287; c=relaxed/simple;
	bh=3s6w9Lz9IIFB4OrucfL00gyUue2zAvdIGytUHSHfPV4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=jSGHhI2md+zW79uTdxo7VRgUUQxgndxPCjf2qCgMNNNY305MsGIFaZso3pkAVkg6asE/tO4lXw5Iz7Fl7Pk38qRKYiv+HTdGOknqdf3//SAZxyyujlrWyczoomOsxknxDINJuS73M4BHBrvFebzuf0+eUnWon/lJ5jXns4kRjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9Rm9PY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9Rm9PY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FED9C433F1;
	Tue, 27 Feb 2024 02:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000286;
	bh=3s6w9Lz9IIFB4OrucfL00gyUue2zAvdIGytUHSHfPV4=;
	h=Date:Subject:From:To:Cc:From;
	b=I9Rm9PY7+dRw0WiT/Ts5xY2rH/dd02UqYLEA8b9YzUFIf4XCjvhgMleFe8JuDuSyF
	 ZwXBys08UTQmrY5CChqlBqnmjma7VzbixnNcwjhaq5t1+XCz9gOgKmbhqvXJs3990Q
	 oJIONXbXHYHSrwtmo2QJlyF2/FISMrBR5HwJ4qoxxRRaJdQI2kHdCkZ/NmjijGp5IH
	 Ok75/HnRMnQrhU01D3+k6Ur+UjQYHeq96PMIiSoWpE4FD0ldmkAmlOMe4hEjorPxRr
	 P3H/7Ip68JrI4OSLIUpqWKyIV1nVe58Ef82uAjW0KADMUIZTbti/6MszmULmn0eOku
	 uecbxUy7QC5Xw==
Date: Mon, 26 Feb 2024 18:18:06 -0800
Subject: [PATCHSET v29.4 04/13] xfs: create temporary files for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
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

As mentioned earlier, the repair strategy for file-based metadata is to
build a new copy in a temporary file and swap the file fork mappings
with the metadata inode.  We've built the atomic extent swap facility,
so now we need to build a facility for handling private temporary files.

The first step is to teach the filesystem to ignore the temporary files.
We'll mark them as PRIVATE in the VFS so that the kernel security
modules will leave it alone.  The second step is to add the online
repair code the ability to create a temporary file and reap extents from
the temporary file after the extent swap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tempfiles
---
Commits in this patchset:
 * xfs: hide private inodes from bulkstat and handle functions
 * xfs: create temporary files and directories for online repair
 * xfs: refactor live buffer invalidation for repairs
 * xfs: add the ability to reap entire inode forks
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/parent.c   |    2 
 fs/xfs/scrub/reap.c     |  445 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.h     |   21 ++
 fs/xfs/scrub/scrub.c    |    3 
 fs/xfs/scrub/scrub.h    |    4 
 fs/xfs/scrub/tempfile.c |  251 +++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   28 +++
 fs/xfs/scrub/trace.h    |   96 ++++++++++
 fs/xfs/xfs_export.c     |    2 
 fs/xfs/xfs_inode.c      |    3 
 fs/xfs/xfs_inode.h      |    2 
 fs/xfs/xfs_itable.c     |    8 +
 13 files changed, 840 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h

