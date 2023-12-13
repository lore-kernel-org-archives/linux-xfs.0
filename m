Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C17224E8;
	Wed, 13 Dec 2023 22:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYJMn/mX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CD2C433C8;
	Wed, 13 Dec 2023 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702506868;
	bh=qNNNLaAopM3TP/vab4bc5MpBTPefHzRz3pEW6+txJCA=;
	h=Subject:From:To:Cc:Date:From;
	b=HYJMn/mX3YqyDtOqcJopwUHY9BjxE4aZWQ1c1U/IBG4rZDMowL3uo+9jQ8OMrMXWT
	 iUS/Cx8XVJD6CQsVHe/+SxkhKOlOkvmOA0stgzn/DdIaJ9CNxHU4AZo3tp3ot/8NNz
	 X1UtguNV3zo8lN3CdqqxluSyvaLkQKz/sDnmDmkYnBnnsTjvZRwLagttYPkzvKpS8k
	 VT2AB1JT8hIgUZMScyG3uHzcnCPydUqP8h2EZ4fKDQ2yKGdFlvTz6jc0f0FtBufsPC
	 oyOcgGbkc3tKF3YDUUcZQcEFOC0jSe+J9SWvspkL25xihlgYRjmrOQc2v7q3YWbV6x
	 YAbbt7llFEDoQ==
Subject: [PATCHSET 0/3] fstests: random fixes for v2023.12.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 13 Dec 2023 14:34:28 -0800
Message-ID: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 tests/generic/410 |    2 +-
 tests/generic/615 |    6 ++++--
 tests/generic/735 |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

