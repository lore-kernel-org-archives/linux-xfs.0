Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D0F1CF28B;
	Thu, 24 Oct 2024 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769013; cv=none; b=N3FjnmoPAumlz+U+IS5FaBJKygV+qnuUmOtwmAtBqZrhz66LgyAOuRcDjtqy61THKzk84TYr0OHgch2fBNJ2x1EnW87FwM2YMo1gbBx4RpKMsgQXHii95qa+bPmW5f19EpnVsk/+yX/yI1rs9GXLtV2K3DAnqUUtArTF3odglXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769013; c=relaxed/simple;
	bh=UeQWcDdLpPqJwRoeYek52y21HGAPQeBJJajpTi24zoE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qzpZ4DHGu27FUyjZaRc9qaDUz6w5XHD65D9D1FnS87GDqfmZBGpCdPq6ydfLUEpO4HX7tt2WZk+JaP4JFjyRZ3+VQQN+qh27EN8ovL1CqbbtnPQdJJJ6JTmM6PUFElUUs4WbWc3R+pdPSp1uy7wvPhiFmIhdWUNjtEwOwVjvGc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4XZ3ST1rn2z9sPq;
	Thu, 24 Oct 2024 13:23:21 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: fstests@vger.kernel.org,
	zlang@redhat.com
Cc: linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	mcgrof@kernel.org,
	p.raghav@samsung.com,
	kernel@pankajraghav.com,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 0/2] fix generic quota tests for XFS with 32k and 64k block sizes
Date: Thu, 24 Oct 2024 13:23:09 +0200
Message-ID: <20241024112311.615360-1-p.raghav@samsung.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes to generic quota tests for XFS with 32k and 64k block sizes. The
tests are failing for bigger block sizes due to minimum allocation unit > IO size
or the way default delayed allocation works.

I have tested this on both 4k and 64k page size systems.

Pankaj Raghav (2):
  generic/219: use filesystem blocksize while calculating the file size
  generic: increase file size to match CoW delayed allocation for XFS
    64k bs

 tests/generic/219     | 18 +++++++++++++++---
 tests/generic/305     |  2 +-
 tests/generic/305.out | 12 ++++++------
 tests/generic/326     |  2 +-
 tests/generic/326.out | 12 ++++++------
 tests/generic/328     |  2 +-
 tests/generic/328.out | 16 +++++++++-------
 7 files changed, 39 insertions(+), 25 deletions(-)


base-commit: 891f4995ab07ee0a07eca156915ed87ab5f479f6
-- 
2.44.1

