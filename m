Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F390BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/JQ1+h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2BC433C8;
	Sun, 31 Dec 2023 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052504;
	bh=fBHkCPfKmVBO6s7HZpQ+ZfnJpChpS7xK/xDpAicN8kM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V/JQ1+h+mHfanHF8uNtubd5kzY0ao4GSPiZ12SMzg77DuIiSl8ZIUbKJpq4Ra+6v9
	 jSUxvZak5+Xe4yt2kWQr1jX/58UPLoqeknm6/DIb6IzLAKM0x53+qpNifsVyYXb3B6
	 Hui6f5W8aP3+31oDaKqPzB8waU/F2YExOQUI2jFaiH37B2VQNfnSWB3ffJVadAOvCF
	 MatNloFDawv5FjjNmVVarG17Iskz4n2CV19/+RdovOr8ljLdh2JjGPm6hY7ABPKNbO
	 UFuqt0YB66JPGaroGYNEqI8AJohgeSiE/0cFbYzNsFSKYWNVl57ZH1aTI2bgMAO9IU
	 gWGTtda5cg36Q==
Date: Sun, 31 Dec 2023 11:55:04 -0800
Subject: [PATCHSET v2.0 13/17] xfsprogs: file write utility refactoring
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
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

Refactor the parts of mkfs and xfs_repair that open-code the process of
mapping disk space into files and writing data into them.  This will help
primarily with resetting of the realtime metadata, but is also used for
protofiles.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-utils
---
 include/libxfs.h |    6 +-
 libxfs/util.c    |  212 ++++++++++++++++++++++++++++++++++++++++++------------
 mkfs/proto.c     |  108 +++++-----------------------
 repair/phase6.c  |   76 +++----------------
 4 files changed, 197 insertions(+), 205 deletions(-)

