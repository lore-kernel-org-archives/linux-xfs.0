Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944B1158520;
	Thu, 16 Jan 2025 23:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069833; cv=none; b=qIYTrF0siUZ/1lhXb1TJARrs0sKJfaX6B/UQZ1r3VfhJO02uLxyd3tnX6bbae5984ngupsyAZVvYebL2z7ksJn777IudClw1K69rsaU4bVW6gA7NHrsNZ50w7fTfViGH2s5xk7kGdJNJwNIAy5hdut6ch3aP6pB77BjYdTukUGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069833; c=relaxed/simple;
	bh=6tfuUPx6BxM7R7NPrC8c1ZGZ1AfS2LSQfGEHwzERMBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1kvIvUuCrX0CktVIqKzZlD1eCs4R9fZnZMLI5KNnYgvOH/JlDQ9yATBk7BLa42YtTWY2gj359wHtO/BoHT34lyUFyNLJ6GDCDajwYrAPHYhMP/9BeThTqL5J5b6mbK+HXxNtHLimoi8e2RCtuj9fDeex/73Ltimzdzc2M5GqO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VcnOn/GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcnOn/GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7BC4CED6;
	Thu, 16 Jan 2025 23:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069833;
	bh=6tfuUPx6BxM7R7NPrC8c1ZGZ1AfS2LSQfGEHwzERMBs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VcnOn/GSUFAkVrKQjaI0rtPMXJMzoIp0J5nbtzcq6d4tgP1yk8rhkhgeSIWix8The
	 tqDFKFvHjusTki0W0ouyrrBe4ucv4AWaML4kmGorX+UrUSk6oyHoCdyzEZF2s/xeEu
	 mEi9z/CFBgCdhzGcs/JiMk7fJ9WATjZQjWaT9HzPx7+qDWiuQAfhDps9jJwDdVgZ1x
	 MIKPki+NPb+uUBc0TmeHnvZtP5kzapapg94s0ce8BLyw9Fh7v9uRoRGW27dcsVf1g5
	 q9fCUsu8bKGgdB/QPDrebuSxuRskA3Gpfs7pQvVou+e2B03d4qeDDhgPZHNus5MbP7
	 Im3ixuKXQ/uOg==
Date: Thu, 16 Jan 2025 15:23:50 -0800
Subject: [PATCHSET 2/7] fstests: fix logwrites zeroing
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974730.1928123.3781657849818195379.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset attempts to fix the behavior of the logwrites replay tests
when running on XFS.  In short, the logwrites code logs every write made
to a block device and can set tags at arbitrary points in that log.  The
replay tests then erase the block device and replay up to those tags,
and then invoke the filesystem to see if it can recover the filesystem.

However, the logwrites replay has long had subtle problems.  XFS log
recovery won't replay a metadata block from the log if the ondisk block
has a newer log sequence number (LSNs), which rests on the assumption
that ondisk filesystem metadata do not have LSNs greater than that of
the head of the log.  This is not true if we're replaying to a point in
the past, so log recovery fails to produce a consistent filesystem.

The logwrites replay code works around this issue by erasing the block
device before replaying.  Unfortunately, it uses BLKDISCARD, which has
never guaranteed the results of a read after the discard completes.
Some devices return zeroes, others do nothing.  This inconsistency has
been worked around by installing the one block device that guarantees
that reads after a mass discard always return zeros -- dm-thinp.

Unfortunately that leaves a subtle landmine for test authors.  If their
filesystem's recovery doesn't behave like XFS's then they might not need
thinp.  If it does, it's all too easy to write a broken testcase.

Fix this whole situation by adding a warning to the logwrites setup code
if the block device is not known to guarantee that reads after discard
returns zeroes; fix the replay program to use BLKZEROOUT so that the
block device is zeroed before replay begins; and then fix the logwrites
setup to tell the replay program that it can use BLKDISCARD for the
devices where we know that will work, because discard is much faster
than writing zeroes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=logwrites-fix-zeroing
---
Commits in this patchset:
 * logwrites: warn if we don't think read after discard returns zeroes
 * logwrites: use BLKZEROOUT if it's available
 * logwrites: only use BLKDISCARD if we know discard zeroes data
---
 common/dmlogwrites          |   39 ++++++++++++++++++++++++++++++++++++++-
 src/log-writes/log-writes.c |   10 ++++++++++
 src/log-writes/log-writes.h |    1 +
 src/log-writes/replay-log.c |    8 ++++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

