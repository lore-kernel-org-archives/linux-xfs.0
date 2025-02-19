Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2484C79;
	Wed, 19 Feb 2025 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925983; cv=none; b=qSnKLCZmEidnJBqYA4et4iLjFUxtxFepAbIQmVCSb9OIYQvhiAlmP9i6na1qQfAMLU+H0/KT6I7BS3B9Z0nI234AMlUfyNqy84e3lwzjZI15lV5scXECBXl4K6bFHlwDG4kJiHCffCEOL1xPyEaxDyPtG8cnqKGcrchl15IvrPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925983; c=relaxed/simple;
	bh=w2oXJ/cznkqomK0gElJMRD9vYYojTVr7Rk2ynCXX114=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPjIpL3TysQrbABsHLCSnayeGVaNC0mdR+hJkeUto2H3Npec2fZYlPu3URnIlSXYPbW9zL+uxCxF2P7GDEK7VBbJ2zYp+06obCUYZ1u3DOXi9U9V2t+ZDLNlF19Swh+/kndAWgEXOfPW9DzfhCtns2g+hM7uB4Z7o8NhyvjQZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFsQM1mF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFsQM1mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A47C4CEE2;
	Wed, 19 Feb 2025 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739925982;
	bh=w2oXJ/cznkqomK0gElJMRD9vYYojTVr7Rk2ynCXX114=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kFsQM1mFiz78wTyqBYVmYxpB6qBN74g3aA4Z0jeokG3gD5toGZ2foo3+4W7Qww3+h
	 S6mBqms2TAPtYkVyofQqaB2JMw8AlFFOlmgGIdazpyd8GPaTvhR3hhTcULUPfA5MYA
	 DEp7p//lj2AQptBrLR2sfvAcBJuzrQtEkxaWpUux8NILrxxWvghWdy0vuzYBywO+99
	 NvVWnN7a0W3SWe03u+mpJOMM+CK+MgCSAQnt1/0NVOWpPdGUL3IcqIOcyfAW9kU550
	 jCl7T2BAx+Hbukk1V6XBBbUaTRH9xUhhxcGB4TAvvCnUUA5XRNpLmOXjaX45+/axwG
	 n+OLsQLf93E9g==
Date: Tue, 18 Feb 2025 16:46:22 -0800
Subject: [PATCHSET 02/12] fstests: fix logwrites zeroing
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
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
 src/log-writes/log-writes.h |    1 +
 common/dmlogwrites          |   39 ++++++++++++++++++++++++++++++++++++++-
 src/log-writes/log-writes.c |   10 ++++++++++
 src/log-writes/replay-log.c |    8 ++++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

