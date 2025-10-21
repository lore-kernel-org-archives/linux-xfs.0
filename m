Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A834D90E;
	Tue, 21 Oct 2025 18:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071957; cv=none; b=UB+E1hi98nuv95ObZ6jbHwdf1H8Bcwlyv6EziCYJzx+wHcGcZlj7LG7rgRme4dQ4lP2X4mKWagGEo1k/uaPDwImNbRNAHphemCqcgTJ4/kQ7/g/RoRgbGWsrE/iMtChOpvMAheVCkhYxabxda8R0BpoVKiqqX2tMLbncTg1r4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071957; c=relaxed/simple;
	bh=4of9pK3Z+eFQK4QoqNSUABPsJYOo62l+zFpLxtYWrE4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=pDiKueTzxDK6qQSY/KGF4i4mCK9Yu17Pqo49qJLs6kPER5ebTRrTgUM9EBdQ5Fnwtmaakb41lLqv9AtLvpn1TVu5d9Sd9xp1S4h4kuYjhqezifJ9qqdT4bI9LmUk3NXxpPo5yUsAFB0A2tKcj4d1ny8t08JgH04TCOiKAV8286s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5YByBTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5YByBTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9375BC4CEF1;
	Tue, 21 Oct 2025 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071956;
	bh=4of9pK3Z+eFQK4QoqNSUABPsJYOo62l+zFpLxtYWrE4=;
	h=Date:Subject:From:To:Cc:From;
	b=K5YByBTyOuxXFfoa+k3lijpk/zOBszFjgfzXLHR41hEo+wlEf/K9Tsb37HVak41CM
	 hRWpaziCXSSZcqPvWEI6jVw9nPpL3ON/xgJjHmSkQzu7D84o+trmRd+cZmWiJvq1lT
	 COMxItJwcMcMWitft4MPylt9w/rqCRO8Tl6FPh4deYkf1O5Roz3NdYAjxB//mQ1vQx
	 vC6AGNM8dGQY/fyWD+vv03AF9jdcx43kbFNSo0YHitZ+hIyucumJgyTPFa0OM3TdhK
	 tHj7tP3PQ5WE+6ylUy8Gjclgs8cuTdeNefU+koIed6p8FMMJ9aiW0g1Fwlh1WhYDgJ
	 WDZ6uiRb3oEeg==
Date: Tue, 21 Oct 2025 11:39:16 -0700
Subject: [PATCHSET 1/2] fstests: more random fixes for v2025.10.05
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
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
 * generic/427: try to ensure there's some free space before we do the aio test
 * common/rc: fix _require_xfs_io_shutdown
 * generic/742: avoid infinite loop if no fiemap results
 * generic/{482,757}: skip test if there are no FUA writes
 * generic/772: actually check for file_getattr special file support
 * common/filter: fix _filter_file_attributes to handle src/file_attr.c file flags
 * common/attr: fix _require_noattr2
 * common: fix _require_xfs_io_command pwrite -A for various blocksizes
 * generic/778: fix severe performance problems
 * check: line up stdout columns
 * fsx: don't print messages when atomic writes are explicitly disabled
---
 check              |    8 +++++++-
 common/attr        |    4 ++++
 common/filter      |   33 +++++++++++++++++++++++++--------
 common/rc          |   21 +++++++++++++++++----
 ltp/fsx.c          |    1 -
 src/fiemap-fault.c |   14 +++++++++++++-
 tests/generic/427  |    3 +++
 tests/generic/482  |    2 +-
 tests/generic/757  |    2 +-
 tests/generic/772  |   41 ++++++++++++++++++++++-------------------
 tests/generic/778  |   39 ++++++++++++++++++++++++++-------------
 tests/xfs/648      |    3 +++
 12 files changed, 122 insertions(+), 49 deletions(-)

