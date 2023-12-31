Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8E7BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nt+Pck2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76097C433C7;
	Sun, 31 Dec 2023 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052520;
	bh=R9iOGWh1OTSUf0uq5a1t+FVGQf9vd/oWEX35xY12KU8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nt+Pck2zYrgrFupftxQCnDv9haGmdD3aN379owTEUbeo6rNDaB4ILp/k4hynBRgVk
	 op9BzBEjuxdg7UtDQwFYk+udGBtJwDf255Opg0MYi94HYVGJxAV45TUmkTbkhGKh9T
	 EzLW9TbBou532Ha+b7/Tn1kdy9erfPWCg3zeKzqkWkI2kNd7vzC7yQCwTzeIxmuQOe
	 pAezRUKA+EpllGDQMLPKdK5mzL4bPQG7HnMIgK4Wj76AxFQSxI4cTqJWaUFEIQuc5z
	 2a0eBgKsc6fUgzuRj1LkTB2r4piD+KGuYUQ2nf2tTZdab2XMDZ/9ho3RfiyqUMG+Dr
	 PxTcWeaPvJ2Ig==
Date: Sun, 31 Dec 2023 11:55:20 -0800
Subject: [PATCHSET v2.0 14/17] xfsprogs: refcount log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
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

This series cleans up the refcount intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refcount-intent-cleanups
---
 libxfs/defer_item.c   |   60 ++++++++++++--------
 libxfs/defer_item.h   |    5 ++
 libxfs/xfs_refcount.c |  150 +++++++++++++++----------------------------------
 libxfs/xfs_refcount.h |   11 ++--
 4 files changed, 93 insertions(+), 133 deletions(-)

