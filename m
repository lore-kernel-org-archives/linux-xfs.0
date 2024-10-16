Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61135170A3E;
	Wed, 16 Oct 2024 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120506; cv=none; b=UOFANN2gdVfluT6dV7wrNDKnInhw8rxcdgG/4A1UlOwbBjJyApqibtn3adiv6B3pq+smWy0w7HeejWVfg1VEOKRETR9nYFAjyyQP7YUYntkDJTN+LOYe/J91JkpmylkvEvXqDIueadS5R6PyoetQDDLTanwknmiFDbqlCXlNb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120506; c=relaxed/simple;
	bh=lAPmhpeoeptZPxY9wR+QO7T6CUDz2p31LBgQ5Ax4g4g=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=u8kTif803jcj1+INlzkJgdGPoiF3dzTKlhtU/u39xFFqzAXiBq/MR09Y4h0lba9BOXymb6s7Fg5/rpIP43U13aCMaJpAoovTQWSferjSdQE0ooMxCAzJ61+z9Ewmt56BkrZVTIM+lnGBHEMNEOuYQfH9bG0eYiMfznhLf8pg0I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YK902Qem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YK902Qem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ADDC4CEC5;
	Wed, 16 Oct 2024 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729120506;
	bh=lAPmhpeoeptZPxY9wR+QO7T6CUDz2p31LBgQ5Ax4g4g=;
	h=Date:Subject:From:To:Cc:From;
	b=YK902Qemgr7OLhXZCiqEbQc3raIoZbKn/iGocRlnZt8tUsl7gKFLAXsHsFv6Og4F9
	 8f95NdFEHwtsrwIwCZSnznG3I6CwrKrrJTzItKnDs1poD/uMBslsDSwmYDm36fIFHu
	 hyNNSDgDx56KhatyYciXq17jynr9zzrWTljp+JEd1xiR7N6z73OiJxuPIwCqfLYd6c
	 tiDWOT7QJNYaqquYQc79EjdG1UvrvNIyEFh1mLz1h5LCcfKkUhjIbPAW19rwdzQUKn
	 IjP/TO0Vbc7OVRYTJx0pR8esqXfKpp1WsLzCQvyZqPu1lpzbJRIqOFLpwKgH4hK3zm
	 g6YTHQhx08few==
Date: Wed, 16 Oct 2024 16:15:05 -0700
Subject: [PATCHSET 1/2] fstests: fix fstests for 64k fsblock size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
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

Various patches to fstests to make 64k fsblock filesystems mostly pass.
I haven't gone back through the remaining failures (mostly quota tests)
to figure out why they fail.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-64k-blocksize
---
Commits in this patchset:
 * common/xfs: _notrun tests that fail due to block size < sector size
 * xfs/161: adapt the test case for LBS filesystem
---
 common/xfs    |    5 +++++
 tests/xfs/161 |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

