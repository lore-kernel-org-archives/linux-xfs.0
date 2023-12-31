Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF06BA30;
	Sun, 31 Dec 2023 20:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRuhQxNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46996C433C7;
	Sun, 31 Dec 2023 20:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052864;
	bh=AFnc3tv+OLWR1io+76QDID8cGk4U0/UVnOKCw7ppfpM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NRuhQxNvi0GT5O0pVH6dYMVsRBQkxPTwPX5IqYokpdmmMmFNZXo4WVE/UT2mvbEev
	 R2ZNoMOlwZ3sYoD9VyNy/Mu4y2CSUDB6kpar0/aX3OA6S9bPS8WE5ReTtULsuEz7vD
	 x/zk1APaUqsY39W3Y8yc1I2s35l6VeJ5piY6YsRT/GXnk+DPWdkS9tOVgfZxZrq8mG
	 j9jLyQmJCJYHelr5tCejCOsVHsT0BD+9d7lfvVezt/dKI6+9O1NFm6klFjsRhzoWNE
	 UD1NZct6on8FICR9rsWDoWDey2VI+U4PnwhDbrlyAt0G5jMlXRxJ9qE10vFD9mVN6c
	 P3Lf7Cc27gzHA==
Date: Sun, 31 Dec 2023 12:01:03 -0800
Subject: [PATCHSET v2.0 5/9] fstests: establish baseline for realtime rmap
 fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031680.1827280.18087377382466462655.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Establish a baseline golden output for the realtime rmap fuzz tests.
This shouldn't be merged upstream because the output is very dependent
on the geometry of the filesystem that is created.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap-baseline
---
 tests/xfs/1528.out |   22 ++++++++
 tests/xfs/1529.out |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/406.out  |   22 ++++++++
 tests/xfs/408.out  |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/409.out  |   15 ++++++
 tests/xfs/481.out  |   22 ++++++++
 tests/xfs/482.out  |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 495 insertions(+)

