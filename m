Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8D036492C;
	Thu, 25 Jun 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406258; cv=none; b=sAE90O5HdS2Mzzr2/qdMnGTTiY+2pi5jSSrInzHD3NqV0g7ZbhTdRhaTXylF3qcBDR28evuQUTrmUIUI2OJaiG/n8DPcgUvTVgfpsOAGmF/E9DowRPDhIKnFTZoe2euT4AQU/FJ8LQL9XESs0OmVJV0NL33LMbJBCG1+biI7bq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406258; c=relaxed/simple;
	bh=gKriIsydRaQJH8QK6R2muScuJ/HgHblOYD5hOQhRUF4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=f7oToZKa/GG5I4neIvAX8bTY0FC9HbxpDxCwMNv/vVebTbCzkcOSSCmIf059SZIxvquHuW3l2avxRdLNvTbZPjAJj+yaJn8Ak0QEIooOIdgxKWUk2hceLsRUag57puCK93TEbBRtyADeg0vxUi2rCac+YUtKdb5qv3ll5e4FYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqeND94d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqeND94d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 29C7F1F000E9;
	Thu, 25 Jun 2026 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406257;
	bh=XT/aaot4487TVI5w32iT+R+aBEyWwiW85KUdwwjyBS4=;
	h=Date:Subject:From:To:Cc;
	b=NqeND94dATncv82DzlsZ+46cHt7hfpaQtxaOBQcZNgp5UjtB+NOVqHNDm9K7PQXk7
	 n07oa0Bml3NsUQmwRcHcTZKxfmXVxz4uRlWQ38Z26vvjZKoadYbm45jqFMWnSbhmTl
	 RW+F+T/G0J6G2cmJgUNPm8l93e5dC/95/CvNVN5s8bUZsKyqm0+e/IsKjjUAVIyyK2
	 QRzNg6WfXfB6fQeqGvoKaScxhX0mJHuzml1At/bqPet4c+z/KTR5HV/rK5QHBpNyZu
	 61dZtbo8Kv+kA5tMoiFMztOK/LHBIcKEc5z0YpyxGNCwpuxVvQiLNX8P7EOL8gjKD5
	 AuG9lp4Hww7mw==
Date: Thu, 25 Jun 2026 09:50:56 -0700
Subject: [PATCHSET] fstests: more random fixes for v2026.06.21
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
 * xfs/21[67]: fix mkfs log concurrency detection
---
 common/xfs    |   11 ++++++++---
 tests/xfs/216 |    9 ++++-----
 tests/xfs/217 |    9 ++++-----
 3 files changed, 16 insertions(+), 13 deletions(-)

