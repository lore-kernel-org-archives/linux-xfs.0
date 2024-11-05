Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3154D149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850760; cv=none; b=ndpDnRLruWTOSHhB7aTYIZ5b84VG196fSByPz37C7rpSVu9cZPE5YXOZjYbpivQlDsazbM4JEGplxO4j3AJ9QqtyekX1WagRKsaHRRiY2Ndoo2eKZ1R8pCLHxruWX7q4nBMiOjHmG2XdVPi7yKOE556CJDciygAtD9ximAIkAwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850760; c=relaxed/simple;
	bh=jRJGOf31T9uPOodbPxdI+udSSMjLARlP372KnmVg7Ts=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=fR52jaJrIdtL40yZL1CMhbC5xPmu9m2r3M58GJc3UX1cPIjhpitFS7xxga5UHt4er4H8VoqWAUpjnIoaslef6cCcP10l8KIYRIaBhBC4+Qby8Dni2j5GgW2OYBSG3/G7Ole3MS2YvVnp6TTlSIwPVfnigPRQ+z+UoM5dSg7Lba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=payvT1qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="payvT1qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E82C4CECF;
	Tue,  5 Nov 2024 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850760;
	bh=jRJGOf31T9uPOodbPxdI+udSSMjLARlP372KnmVg7Ts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=payvT1qMijczo3iSH5FHNRjP+J2LiL2EUtYOmSoOtFepdYZmgmrRb9xX3VwL94Ca1
	 05HfugjX61H+tJBMXBcAijiynyt/zgMyytM26kVaYuTSBGW/mGb91EKRMy2TZ6ybQt
	 2Q6nZhAuxccjo6fskRRm39W/CnxXVW5gdXvLwht7z70kDru1nW0PN+ddZzazASCAVi
	 vHcanuLlP0+pJrjNTqXOCwiabyjyWC1jUwjYuYXinh10EC8hpODvvuLDPYkkV3bSC1
	 sjzCHoQ8w9O9/Da5DQv2NNm1cHFF3RCu+2XkB/Q5D2iAtYfCNNIxwRShLJoGZ51OXU
	 KyMPHR/GpKw8A==
Date: Tue, 05 Nov 2024 15:52:39 -0800
Subject: [GIT PULL 10/10] xfs: improve ondisk structure checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054782.1980968.5008642841097262386.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ea079efd365e60aa26efea24b57ced4c64640e75:

xfs: enable metadata directory feature (2024-11-05 13:38:46 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/better-ondisk-6.13_2024-11-05

for you to fetch changes up to 13877bc79d81354c53e91f3c86ac0f7bafe3ba7b:

xfs: port ondisk structure checks from xfs/122 to the kernel (2024-11-05 13:38:47 -0800)

----------------------------------------------------------------
xfs: improve ondisk structure checks [v5.5 10/10]

Reorganize xfs_ondisk.h to group the build checks by type, then add a
bunch of missing checks that were in xfs/122 but not the build system.
With this, we can get rid of xfs/122.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: convert struct typedefs in xfs_ondisk.h
xfs: separate space btree structures in xfs_ondisk.h
xfs: port ondisk structure checks from xfs/122 to the kernel

fs/xfs/libxfs/xfs_ondisk.h | 186 +++++++++++++++++++++++++++++++++------------
1 file changed, 137 insertions(+), 49 deletions(-)

