Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632E15885D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224089; cv=none; b=c0arDT4ZO0OFX9gYDqO2UYx4mykHRcsVgskiLVWcI/f2tXWZG6Q4PKMfpM1FwoXPj40T5URoOKlARc9m79MFOqpX2f7HHHOMoG9RfIwcloaCw7dFV5PdtfX/WI/GQSOALRtJxZkSHjm60wLQ2jPUafhqHjDDhRyilxUTRZ0qd8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224089; c=relaxed/simple;
	bh=YDP5XFcvyAFSjO3yqkEp7193Em51Byx/aat9Olencqo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1SvnkySO5G6TjfbRnHRGJUVRz3166zkAlQaC+vRW+NhAL8ViD28vzs6bRi1Pcf7DFvcgBMipEs7QRwn/vbTum5x1+9OYEgDd7bx2w1SwsjmDBUFPcm2/lOK1YO46tX7eH9njkrycBEDayWUAGRgAG3rj52TWd8hMs+UL7pLddM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQ/7mmbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQ/7mmbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DAAC113CC;
	Mon, 15 Apr 2024 23:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224089;
	bh=YDP5XFcvyAFSjO3yqkEp7193Em51Byx/aat9Olencqo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fQ/7mmbIQfGI8W6bLMjWY3amouslxfOKwq6eLcdiksE+bsexEONXdU/ngh+Abm7E1
	 zgeLg6VUXjOxRczUj0VRZo4Ln+UM52PsDcd2GTM7xK6kaZmGvHGf9p/C1MUv3eau44
	 SBqMiXMDt1k0QXPv7a6Fz4tyN5tSUVk+CerxIO1UU46bkk/O34x/6j5PHbIWSq3ZPQ
	 Wz+/Pb0EC92IFKdmqcc/4gp1MvU1O4i1kBtmCJOuRDHeRAeIa/r612++cVpscMLs+o
	 itePwKAk5TYPC5+nL3gY+2982r2wfAQZTdUh7ae5I4r3bbPBkunvH70UImE58IuMEW
	 DRQR5v5qsJQ8w==
Date: Mon, 15 Apr 2024 16:34:48 -0700
Subject: [PATCHSET v30.3 05/16] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171322382166.88091.17655506673018704776.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary-6.10
---
Commits in this patchset:
 * xfs: support preallocating and copying content into temporary files
 * xfs: teach the tempfile to set up atomic file content exchanges
 * xfs: online repair of realtime summaries
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/rtsummary.c        |   33 ++-
 fs/xfs/scrub/rtsummary.h        |   37 ++++
 fs/xfs/scrub/rtsummary_repair.c |  177 ++++++++++++++++++
 fs/xfs/scrub/scrub.c            |   11 +
 fs/xfs/scrub/scrub.h            |    7 +
 fs/xfs/scrub/tempexch.h         |   21 ++
 fs/xfs/scrub/tempfile.c         |  388 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 ++
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 715 insertions(+), 19 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempexch.h

