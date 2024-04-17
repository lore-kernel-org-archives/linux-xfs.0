Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5C37163
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388547; cv=none; b=PkTKZHUZ3Ens9QHKpXyX+VpxNnyf8h7IIMY+ZJ/n5iH2ow2aHiF2z80YJMFb4jOw+Tp9KtJF2MjIH2y2ax6J9oVw0fJKAkk4L9Q5ZPhkl0cO571nkFE3KEnrN75igrivsgedreirZq0y5tAC5IZvcyNidouCk0l4zfo9z9ScZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388547; c=relaxed/simple;
	bh=ChmOmEbX4NUR2if7t4XAUO/MNgj20w5T89PTedOpkRY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPEkD6FZKihLr4YpSg4nSswmQbSN6XLCpwxs7DaAEgmn3vpyc3hb1GL5KCa4Smg/T/zGnHP/RyywiKu172KXko7gJBODFxfUzvqhOjJ3Ov9Ae58hhsJND0AdJg9ibHeSGERm6tmzFUH24ClQiXve3+pY8DGxB4yRZB8k6FValYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skST0ZgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skST0ZgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822CFC072AA;
	Wed, 17 Apr 2024 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388546;
	bh=ChmOmEbX4NUR2if7t4XAUO/MNgj20w5T89PTedOpkRY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=skST0ZgVPvfkZsX6J4/Z1uvGRWekqHwfg/jBBNtNjEwAtm/JSukeeJEKbRSXgh8cL
	 Wt5vOUa5oYBuljjVPW9tVYGqmMwUTQdCO6s2Cv34IyxvQF2qd4qg478pUXK9AbA7zv
	 hsjEJzWk6ENLNxUB6JfDqrhLU+g1ajWbG8zKGa8RZv6AuaLhnYtM04OrI61O9kTtxR
	 nFSuj97SRdn9W4ydS30H99TLSeHYQ9/iLkzIOviu3Rfxyp1uHRZHaJ2qds3rcSlcH4
	 t+RjdQZLgCPwGl9ZsDSmDSWv50XU6t+syeyX9R7MlMrsjOjQHqVVmMZ6EEVbzQTBfb
	 wJEX+Q5CPcEBA==
Date: Wed, 17 Apr 2024 14:15:45 -0700
Subject: [PATCHSET 02/11] xfsprogs: minor fixes for 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841408.1852939.2939418967368399225.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

This series fixes some bugs that I and others have found in the
userspace tools.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes-6.7
---
Commits in this patchset:
 * mkfs: fix log sunit rounding when external logs are in use
---
 mkfs/xfs_mkfs.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

