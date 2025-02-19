Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B325C2BAF4;
	Wed, 19 Feb 2025 00:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926078; cv=none; b=e3uVS+k+/ng1668AwaOFqXpZKPFfADU+06Wq+BjGoV8waMtHorzQ0xFvbApNaGcFbUtZwMtGA4ww9o9ngZMHwqbgmclJPB+i1Xvs2uJmSxfilB12R2v4vIxb1GMBmv6XJaqQ0INFACrb1Mfri6qhirFh5rRh2dEj5RTEJPJpQxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926078; c=relaxed/simple;
	bh=eEDrvMh5G5pKjB7IcbK2ByivKoqpKAA1OmgnaRc0WOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BksasYTFBydgN6zLH3IoPjtg7dc6KNob6G7DCNVriGfngdZzG/cC8fD/wq3Igj6CYG/Me1q+Oav2rhX8iRG5g8Jmxb8oG4X1ZSKq7kpPABs6ZppSpvlvQvJEwjkdQmkS52t+jT42HfcROhE4UCMTEU+cEZneeUDoQXJRp0iMLQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVGWGxID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVGWGxID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A06FC4CEE2;
	Wed, 19 Feb 2025 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926078;
	bh=eEDrvMh5G5pKjB7IcbK2ByivKoqpKAA1OmgnaRc0WOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iVGWGxIDZWp4hfomJ92Oi2wIk9KfDIeOPXX9JWa0zik0xqZuJWP5tC0CkGite6JWG
	 QdSDfwOEQ185DSkRmwAPadO1w5PZpZV6Ya+CmeNuoilXpQeXcQhx+7OfcxgM8eSbsz
	 Nqe4wmRv8t7XV5yClj3pOaqCplIryscGZIuHU4pwqHq/WRij4wx96pSwOfG8kFem09
	 XpeQoZ+H/NsWw0yunKJvVxq21I0h1KVoXGtiamERvQpN4dtfVFaK6DRJUu32kk98nw
	 v50TgKgC2gdSQJ2medSE3dR9d1QVf2iH4QH2CkuRZVnFbdD8eFnhcMSUp6zFBmC8Ml
	 L6QHB1YypXulw==
Date: Tue, 18 Feb 2025 16:47:57 -0800
Subject: [PATCHSET v6.4 08/12] fstests: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

The sole patch in this series sets up functional testing for quota on
the xfs realtime device.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
Commits in this patchset:
 * common: enable testing of realtime quota when supported
 * xfs: fix quota tests to adapt to realtime quota
 * xfs: regression testing of quota on the realtime device
---
 common/populate    |   10 ++-
 common/quota       |   45 ++++++++-----
 common/xfs         |   62 +++++++++++++++++++
 tests/generic/219  |    1 
 tests/generic/230  |    1 
 tests/generic/305  |    1 
 tests/generic/326  |    1 
 tests/generic/327  |    1 
 tests/generic/328  |    1 
 tests/generic/566  |    4 +
 tests/generic/587  |    1 
 tests/generic/603  |    1 
 tests/generic/691  |    2 +
 tests/generic/710  |    4 +
 tests/xfs/050      |    2 +
 tests/xfs/096      |    4 +
 tests/xfs/106      |    1 
 tests/xfs/108      |    2 +
 tests/xfs/152      |    1 
 tests/xfs/153      |    2 +
 tests/xfs/161      |    1 
 tests/xfs/1858     |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1858.out |   47 ++++++++++++++
 tests/xfs/213      |    1 
 tests/xfs/214      |    1 
 tests/xfs/220      |    2 +
 tests/xfs/299      |    2 +
 tests/xfs/330      |    1 
 tests/xfs/434      |    1 
 tests/xfs/435      |    1 
 tests/xfs/440      |    3 +
 tests/xfs/441      |    1 
 tests/xfs/442      |    1 
 tests/xfs/508      |    2 +
 tests/xfs/511      |   10 +++
 tests/xfs/720      |    5 +
 36 files changed, 377 insertions(+), 23 deletions(-)
 create mode 100755 tests/xfs/1858
 create mode 100644 tests/xfs/1858.out

