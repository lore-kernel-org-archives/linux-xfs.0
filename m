Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A62F3EA66
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775320604; cv=none; b=LFLwiOKCAdTwnkjUgeTGZuK7s+shibs7tJK8COu1Mgijq2fZ1xTsoiHqNuq1QYpYCd4dYjGkt7oaKVpeKijufV08HkNCMDnZQydSgIwmm1P0k6QuAjmAVYFJKAqco6ooGyILtyv1aVID/tqcrzFN9XPRi7YJDWuKwcLamNrKG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775320604; c=relaxed/simple;
	bh=h+MRF8w3Zne4eGLNI+bqXycJwuychusF8Y2F6KANjhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PCFnpkEYtqPUrE/6G/U6OkkedPZvZ57AGu11v/qk3sDhNN6vrxlCnzNkGk+IITtfGXk8eq1h+zfgHjoswLicFvoLrwshtZ02oncDjzf/1HyzXVXl+5M0q0tMgPXc2ZotSofnu9Yb+zMjvSfkD3cfqCBAYSR0fq4+/WoCAzCPWNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNYsg83H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNYsg83H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F055AC19421;
	Sat,  4 Apr 2026 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320603;
	bh=h+MRF8w3Zne4eGLNI+bqXycJwuychusF8Y2F6KANjhE=;
	h=From:To:Cc:Subject:Date:From;
	b=nNYsg83H3NrGUhlRQWZSMFSwUGYM+cMGkzAxRaufK9mWHkLYN3BqFAKHaeTGlJssb
	 Ihsh6MT2cM0kWbv9lSex1gt+qe1yPPWObHGsQIyWO3Q8dUvQp2CogTlamKvKYdSHnF
	 87L08LkFHNOof+R1gFQ+dn+O/WFge31VyLYB0xyI53xyvSyhYjcUcR0Ge5OkIoTJI2
	 LABhs78y/jU7G5uW00eFqSSDJokNY26j8njCpu3RBW5SYLpc94V0+JXoIWZARZhK67
	 IB6pf8PEa78kp8VaqTbEsxYfim1xproP6RI6/nhq9l/GoH2e4syFj65dV3wYz/BM2X
	 RM9BQL9g0VJnQ==
From: Zorro Lang <zlang@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfsprogs/mkfs: consolidate subvolume validation logic for file images
Date: Sun,  5 Apr 2026 00:36:38 +0800
Message-ID: <20260404163640.1013997-1-zlang@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset contains two patches:
[PATCH 1/2] mkfs: fix assertion failure on empty data file
[PATCH 2/2] mkfs: unify validation behavior for data, log and rt dev

[PATCH 1/2] trys to fix an assertion failure in xfs_mkfs.c . Then [PATCH 2/2]
trys to rewrite the subvolume validation logic of validate_{data,log,rt}dev.
Further details are available in the patches. Any feedback or review points
would be appreciated.

Thanks,
Zorro
