Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE863876BA;
	Wed,  2 Sep 2026 05:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327693; cv=none; b=R7DZwxQfYbGwwKIW8Hnux23YPaj8PmoHObeYUu24APCKv+HaILgZDVUdix6jXA4wwUtAqEpFHf7dbVQg8XMANpxom1OZE4iB+Sxi/62/tUqGkdpdUlXLNN3z/OkD6zZ9mD1sL0f/u+f29Dyd7lmd43EH77qqiBCP1EvL0NBZcOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327693; c=relaxed/simple;
	bh=sYAFqR5cloi3byPAdJBiUYpNEUZGC3fH0Owdo7n65lk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=I3pIeb4tVMW7sLxCRExPCLaF9hy8x2V2NOT9c9P+8KtoqgFmHrYQr3Ti2SMkUywi49XXXGvhvS4lje+QJkDLj+hZZ/wuSo0KVJ/3jZyalCu8MsT9zNr+BlfXzmV/M8mDuUyY0WJ40tdfKsy3GdQ/p7E/sXKu2e4cV6RaaGxSZrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozAXAcJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozAXAcJY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D0081F000E9;
	Wed,  2 Sep 2026 05:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327692;
	bh=4g9X0iqXX2DbyGcxi5muhy+BQxjl6Gb499eh1s2fjFI=;
	h=Date:Subject:From:To:Cc;
	b=ozAXAcJYVzW3MFiHnhWl7j1VgC8u0Xy9JMECVuLUIgs/UvdZzabCg/omu45XkXv1/
	 zjnc2viytU+QDDStzQeyO164RvpxfNw308kqKxg7JZy5P3y50/aU+JevkyCcQKCmlx
	 r7fBvIchUHlS5TLQc3E0F9+6gW04gGvmnp2DBpMwNzaVL7dalhrMpwUp7g8XRYhOBh
	 6eYqqytFdVIUR2rGlVw8zULErUOTyMMH40sliugrUs9JpqAA3YtxfKHxv1EBVE1cEM
	 3r+Dlmww1RjQtXjBVsRQCIqL6iRWtuEc0pytozKlaZhojK5PG/0uvXJN0J9/Ly18qa
	 HwcM50v0EbbPg==
Date: Tue, 01 Sep 2026 22:41:32 -0700
Subject: [PATCHSET v3 1/5] xfs: LLM-inspired bug fixes, part 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fifth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add RVBs
v3: add even more RVBs, finish review

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-5
---
Commits in this patchset:
 * xfs: fix unit conversions in per_binval computation
 * xfs: fix short ifork reaping computation in xreap_bmapi_binval
 * xfs: fix name string recording in slowpath pptr tracepoints
 * xfs: don't leak dqacct if rhashtable insertion fails
 * xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
 * xfs: fix media verification ioctl for internal rt volumes
---
 fs/xfs/scrub/trace.h                 |    2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 fs/xfs/scrub/quotacheck.c            |    4 +++-
 fs/xfs/scrub/reap.c                  |    6 +++---
 fs/xfs/xfs_verify_media.c            |   24 +++++++++++++++++-------
 6 files changed, 32 insertions(+), 15 deletions(-)

