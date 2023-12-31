Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361B0B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUyJMD7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74FDC433C8;
	Sun, 31 Dec 2023 19:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052082;
	bh=07drDnu68vskaCTKlOXQU9LiRzd+vOFZ1zBTTw6F0IE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUyJMD7PQV+QkFYGA3g7DYQml1JUrjF/prYqF7jdf2olg9+YJ0S0CRQretU/CYswe
	 uU2ydvPtkAl3FU6VxheUEKt5sVpv14KRtWjcEXiCz3rTdW/WfGloP+XB56TwWI1l9e
	 +DGEylFx5fLZTabD8y1W1i7kp9RiVhc8qP9eEkguxZScopfekpUIdIu6r1sJ8uHLej
	 pjTNa4FSDFa+9MHMzEC8Ce8Lpa4nyrJiR5sHNXjjOQc48fJHCdQTq0yXfHgG3Hnh/5
	 EOlhc0cvVnX5YKeQLIPPZGDLTI2SPoYzQCxnxlpButO40oPuZsz1Gg5NqlifnMWxHv
	 4Tdk7xK3qlsaw==
Date: Sun, 31 Dec 2023 11:48:02 -0800
Subject: [PATCHSET v29.0 32/40] xfs_scrub: move fstrim to a separate phase
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Back when I originally designed xfs_scrub, all filesystem metadata
checks were complete by the end of phase 3, and phase 4 was where all
the metadata repairs occurred.  On the grounds that the filesystem
should be fully consistent by then, I made a call to FITRIM at the end
of phase 4 to discard empty space in the filesystem.

Unfortunately, that's no longer the case -- summary counters, link
counts, and quota counters are not checked until phase 7.  It's not safe
to instruct the storage to unmap "empty" areas if we don't know where
those empty areas are, so we need to create a phase 8 to trim the fs.
While we're at it, make it more obvious that fstrim only gets to run if
there are no unfixed corruptions and no other runtime errors have
occurred.

Finally, reduce the latency impacts on the rest of the system by
breaking up the fstrim work into a loop that targets only 16GB per call.
This enables better progress reporting for interactive runs and cgroup
based resource constraints for background runs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-phase
---
 scrub/Makefile    |    1 
 scrub/phase4.c    |   30 +----------
 scrub/phase8.c    |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   22 +++++---
 scrub/vfs.h       |    2 -
 scrub/xfs_scrub.c |   11 ++++
 scrub/xfs_scrub.h |    3 +
 7 files changed, 183 insertions(+), 37 deletions(-)
 create mode 100644 scrub/phase8.c

