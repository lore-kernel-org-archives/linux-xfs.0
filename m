Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092AA1FF7AF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844374; cv=none; b=rSeMkPmvNMzMbYDUlyaT41Xt+xwzIslOvFXGtPzZW3PSBT+lTUUkUQb3NQPrxma/B3jpeppkwnoZiRHO2iPMjk6CZID1EbUDoc2Jf32xy4sSpnYGIt+3uFU5j5809UB+SbQxJKYQ1NSptJJ+bVBW0fPIVhFCYmEk5ZY9stkQWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844374; c=relaxed/simple;
	bh=mumpo6rLmQCEGehOpFoszxhGrRCeyRvLL7v3l3aVyYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLttZR5Fg2NdMtXvJBGW50MHwMIlyUo52ai5zVh9dtw2ZDESV9E4cSN/wptapz3bpO4kgD+V32bdPklGxHa+eaDv3V/OEZ792SmAAWFon6hP2i0e5zuitRfu2sVrsNDJAcD2hWG6CrYMJd/Z618XeWxE1TBD56Dp1V3nhGX8FWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsktPQb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsktPQb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93B9C4CECF;
	Tue,  5 Nov 2024 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844373;
	bh=mumpo6rLmQCEGehOpFoszxhGrRCeyRvLL7v3l3aVyYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dsktPQb1naZ095/oqlUtSjVIMALvK2krn1eduAikZ7G2HkzYKDCpgjXVys/PMSpeb
	 yn3xOPFYN4mqP/VhuVxNDlepxHqk+bXq8iPHj9hFb5ueeQV9t4BjeLJzRIwPTasma4
	 nOtEzTh+AdnimkZs/2r//KpUG59sd8aOHupsK7QibdugWbe2jvZAh3BwxCtjXCHcq6
	 SysV+fV5GqiQuPYCMKFQj3hzlWY5vKgx2PSN90WeOja/sFonBeXOkGvfw/IFGCRwxH
	 CgD33MIz0NEY4MOLg+BplKI+hRhoKYKSRDlWJLjJX+/gU5fY//5zIC70zY5USrzJfJ
	 VH9d0bA2aru5A==
Date: Tue, 05 Nov 2024 14:06:13 -0800
Subject: [PATCHSET v5.5 09/10] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400008.1873485.5807628318264601379.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Actually enable this very large feature, which adds metadata directory
trees, allocation groups on the realtime volume, persistent quota
options, and quota for realtime files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-6.13
---
Commits in this patchset:
 * xfs: update sb field checks when metadir is turned on
 * xfs: enable metadata directory feature
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/scrub/agheader.c    |   36 ++++++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

