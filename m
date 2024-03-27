Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725C13FD4
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504073; cv=none; b=SgRbrxPw6WTnTRah6VqY9ZI8lvK42ECGjjvVwlJtq+sc78MrErhGBkfd187SmxXqg1zI+fDPOiB1i/9rZDUe6qjBpop5uGrg7UjAnisVVxZQ+tt9gjg79gphAdmRVaIGvLZ6OTplHna5dRXcBbEx6273B5K1JmkHvfEMu1ojdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504073; c=relaxed/simple;
	bh=cnHf5DDQJYfoX4BdJSWUOlCz4vJhel22KyAkPg6tb4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2s+DbFct5g9nemFgNoRSeOM8mYt3vDGbIQWUvFDky90buGYmuE5b4prEwS/GPQxtkUVD2RTocYWr7qXTQmXsckqNFWeW6OqawS3yxUB0lzuooajBd3opzB2rBt09cz+3u7Sl2kjTy1gN25dUcdZAjH1k9Jyf6r1pARU8wT4Vcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1Ul5qK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1Ul5qK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF827C433C7;
	Wed, 27 Mar 2024 01:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504073;
	bh=cnHf5DDQJYfoX4BdJSWUOlCz4vJhel22KyAkPg6tb4c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l1Ul5qK8uEQc+flAm9wwt2xxA3pOncOxn69+JLm2Iyz7kq1GmGzOjDZNm+FCIsJPV
	 j94349fzvn+qXMe8vJoEAqmyORK6PM7on0bK8HlXvGWpGK5N3mb28YatPpu29c3cy4
	 U8tdaBVzfB+I6Lb6+yjhoaoSKD1ykOXeiyaMLqkuIMq9HlUMryGZ42f0XOfAD2kNaF
	 rzncwdDTmecCV6yaItDYIg/6D5QDLc0wOBn2eSiaD7u8N7Z9piRcqJdkTwdY1lvAT5
	 gumF5Hb3eWesINLN9I5/zCDlFkL8bVUpCqnbGa+yEHO3AFYu40+kvEnulbS0WuW9mB
	 BJX7xq89Ne2jw==
Date: Tue, 26 Mar 2024 18:47:52 -0700
Subject: [PATCHSET v30.1 06/15] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171150381678.3217242.16606238202905878098.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rtsummary
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
 fs/xfs/scrub/tempfile.c         |  391 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 +
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 718 insertions(+), 19 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempexch.h

