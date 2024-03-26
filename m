Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD56C5788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421731; cv=none; b=N9hb2A5yFoAd4RPUdImwrytJqAtn2Vhau4lr03YUPS6T8hiFtS4fAmQJy/PqGSw8/yEktvEov48t6S69jBLaMWFsifKBF6uWAoocbOnWjq1Ms1YT35bYvDmh+QkyR3fAibkuvy5u9SAuyyvstEsdf4+xYY/r5Xjkmbc0ZNcd9ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421731; c=relaxed/simple;
	bh=onBqUr9TfULye4LJABGUSYg4brOfMPhkvOpLRp9tCT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxIKJIZSySum3/gYaVqYn1nrUSmPPibJhhplcW8Cw38rQ4TPd9o4U7lOctB+XfFmtC68jNjkGDxLksDoWZFegmb1Y92+t/dO0UhFBLtTW4nssn5awbkUhWDHDdzDwt3v+l8ZgMCN/zKaM9/CVMKOL8yHbtxlcQZUNCAymOlshwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFSuvVg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFSuvVg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BFC433F1;
	Tue, 26 Mar 2024 02:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421731;
	bh=onBqUr9TfULye4LJABGUSYg4brOfMPhkvOpLRp9tCT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SFSuvVg2GTTPzVVj7RKdBhrMeer9oRcoxxFgpheqMxDctiHxx9DFOt901pbV8O7jO
	 jNfbu/xBgqTEowRBMScJKHpKQdtE2CJIglIQc0nYNQViTFztL6cMdorCDDfn2AmnSi
	 va75Sanz9LAQGMtGiU07bt1jTo37ev30p7Y+jlkNHWsDeuyEVb6KPe2BLXhbp4Vkwn
	 WRrCH2/Ysy2b2IxLRHkF5owcq/QoXuiuhAnw/vdFCq3g6cZV8bzTtWS3rqt+bpaxR1
	 GEvjXUmfP159jmhPppCQYmgXE9Yxb7ND3jJjQ6sOqtYjHeWsnRC/aCrRoLl2B4Hs0S
	 1CbTYSUjducmQ==
Date: Mon, 25 Mar 2024 19:55:30 -0700
Subject: [PATCHSET 03/18] xfs_repair: faster btree bulkloading
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128229.2213983.6809200974790500472.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

Two improvements for xfs_repair: first, we adjust the btree bulk
loader's slack computation to match the kernel.  Second, we make the
bulk loader write as many records as w can per ->get_records call.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulkload-faster
---
Commits in this patchset:
 * xfs_repair: adjust btree bulkloading slack computations to match online repair
 * xfs_repair: bulk load records into new btree blocks
---
 repair/agbtree.c  |  161 ++++++++++++++++++++++++++++++-----------------------
 repair/bulkload.c |    9 ++-
 2 files changed, 95 insertions(+), 75 deletions(-)

