Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907447785
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrM4NzvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183FAC433C9;
	Wed, 20 Dec 2023 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092255;
	bh=pahZ6T2JMNGaZkEg2hjUdm1q1RDJcgjeP/GiM69+FRk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DrM4NzvNZ864G7Larc0WmOmuHvdvrlKlUGpN7KUKPtkfcm5P8AlDJpB6/rCzvN3V4
	 +TuGudR+W9YGVaT5bYy96b8DIFhia9TRo5dvwpwx9TUJvb7kAeGiCt1Br6NQiDNq2E
	 0J/WiuekIPZczKqEt1MYE+tmtGLYGq7ZYvthneeaX+ZH5gjPlmN+Nm65T4G2A5EQan
	 gBNvcIDXJi2XfZdFw9uPDHCtRWPecUZ0FqfMpCx64P3/JKwCiHJehyDsl8y7f0dsCG
	 YIKkRL6XZLEoVa9kczy4D8xiS0Xryp5SaDQvFRZhe7aBcHH+j6m0MbWJ5faPSKAdvY
	 vos4S07JURmhg==
Date: Wed, 20 Dec 2023 09:10:54 -0800
Subject: [PATCHSET 2/4] xfs_metadump: various bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
In-Reply-To: <20231220170641.GQ361584@frogsfrogsfrogs>
References: <20231220170641.GQ361584@frogsfrogsfrogs>
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

This series fixes numerous errors I found in the new metadump v2 format
handling code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-fixes-6.6
---
 man/man8/xfs_mdrestore.8  |    6 ++
 man/man8/xfs_metadump.8   |    7 ++-
 mdrestore/xfs_mdrestore.c |  122 ++++++++++++++++++++++++++-------------------
 3 files changed, 81 insertions(+), 54 deletions(-)

