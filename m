Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A2376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591020; cv=none; b=ZDQWEyELxLkAqw4VXAJmPhUQcboF/5DRNrnoltFMgfPshShvUj0LXcHtBnSAOLF5IqcPAD/Fpui0BjuC2n7HUkmKiGSyD/IItHYkNdyQGBY+hMz78LfIiYXHSXYh0bDUq4wA0bavuFItNWZYMYL/ar7e80KLiE97VEmiBZil8d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591020; c=relaxed/simple;
	bh=3YjCnakdIFfNw8qYKV82Vxrgm0IrncOyW23l3Biu9p4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=JIXUCklwB9tNesbgmEKvgOej+vEK2fjAKbH5jKR4aqQcGmwmKsTa4uQrVLfkOTamIR7O9kLx+G6vuWAmyIj1RaBanu2aDjSp9dvjv0XQ7X84XR1BEIx7eFE/m2OHjwA9gRk+bMJLFHQWxM1zRt3XZmmMygrZQ0ZKbYC9qcy6Bo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ+QaITJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ+QaITJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D7C433F1;
	Tue, 30 Jan 2024 05:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591020;
	bh=3YjCnakdIFfNw8qYKV82Vxrgm0IrncOyW23l3Biu9p4=;
	h=Date:Subject:From:To:Cc:From;
	b=kJ+QaITJwy5HOpEBj7HWYNr5Ou2bqda0SaM/gE2eTzGiDRYZb0BluJErdOBAq1vYk
	 VCgpsuWjQj5Sxw3HZAksL5i9Jf9wwc5KxpWL8qHhpVDqkvlgvZ4V0P1FelUlW+q6jf
	 h+xxT9ZW0F9sm9bYU0Q/AoQ1sMgo3G80XnOyUpXe7Nq0HwU4E5s2pKX0zBgF2zxhBO
	 +k+k8V74RmcUlOf7xWTUd5gbDxJNHvO3g+EH2SjQydSNCuNjVfczWorP7VYpO6dl2r
	 iwVmjdg+sD18sHABx32mE44ZeLJOLd87ud1Yu1FsYh00L/r49wL32IZ1lQmnOK09FV
	 BAwOVBvq+1hpA==
Date: Mon, 29 Jan 2024 21:03:39 -0800
Subject: [PATCHSET v29.2 7/7] xfs: online repair for fs summary counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659064662.3354357.16936859621849391669.stgit@frogsfrogsfrogs>
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

A longstanding deficiency in the online fs summary counter scrubbing
code is that it hasn't any means to quiesce the incore percpu counters
while it's running.  There is no way to coordinate with other threads
are reserving or freeing free space simultaneously, which leads to false
error reports.  Right now, if the discrepancy is large, we just sort of
shrug and bail out with an incomplete flag, but this is lame.

For repair activity, we actually /do/ need to stabilize the counters to
get an accurate reading and install it in the percpu counter.  To
improve the former and enable the latter, allow the fscounters online
fsck code to perform an exclusive mini-freeze on the filesystem.  The
exclusivity prevents userspace from thawing while we're running, and the
mini-freeze means that we don't wait for the log to quiesce, which will
make both speedier.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-fscounters
---
Commits in this patchset:
 * xfs: repair summary counters
---
 fs/xfs/Makefile                  |    1 +
 fs/xfs/scrub/fscounters.c        |   27 +++++++-------
 fs/xfs/scrub/fscounters.h        |   20 +++++++++++
 fs/xfs/scrub/fscounters_repair.c |   72 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h            |    2 +
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/scrub/trace.c             |    1 +
 fs/xfs/scrub/trace.h             |   21 +++++++++--
 8 files changed, 128 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h
 create mode 100644 fs/xfs/scrub/fscounters_repair.c

