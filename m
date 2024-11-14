Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BF779EA
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543610; cv=none; b=RVcav4F4VWePsDk535X1b0B35xz43xhmfJRYJZq2AmJDrs+7lbH5njXWzXADh7F4u7/dpzl+IdtUJujmJ/FkfSRBcLNkBf3fUBDLlCMpoBi290HWJcQTCS0wlzkdi+a1t+9JWgrykXIRkvnPJ+/NRhdbatVByv0pkNfRKGtmCTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543610; c=relaxed/simple;
	bh=t3lCq37MHykzlVR68bwDReqsM+AqB1PmXkdP8YwWArs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=TTJG9bSFJP3g/No63EbF6CqimTHtbdAU/rSPOizTJ1T54g4n67uw8UhInFZythKljozGgduu80QHh4gGDLMk4N9c8Ayj/sdgUrRWhvHhjY1GMwgX9iGWqZ6ni97huzJnkGxAMivR/uuoSOpMYpqYNhrmq29pvhFKfrkhApUD4IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsLzMajL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsLzMajL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F97EC4CEC3;
	Thu, 14 Nov 2024 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543610;
	bh=t3lCq37MHykzlVR68bwDReqsM+AqB1PmXkdP8YwWArs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XsLzMajL0JjHOEaS8ZsyAH59wKsUSQd9FNa1dtIuc0a0MpENswoU/3RRP+H487jek
	 6rbmd3Jah+XzQxwcLzlIPWYX10NP1pZSXCtl4naUnZVRUSQ5wq15htUMHn+kz8oCL3
	 ZKvPakTUFceJIp6x7lvx1yalOqWJ+n+XySqd4GQUVTuwsEVVpzjf83AanH375LFm4A
	 l3odaQVrayvkNxwNWp9EFSWmEYMyMbL6Z3xU4m18UeTn+eXWiqCIkM6dz3KaVQlI+2
	 N3WirE3kvUVYHdfHrr7T5pMfehlFzll5/YlDkLHdPo2v9tzz3vAUL8MIBFHpC4zf3u
	 Zt8Ru9CWv6qWA==
Date: Wed, 13 Nov 2024 16:20:10 -0800
Subject: [GIT PULL 10/10] xfs: improve ondisk structure checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342773.1140548.909946367548269731.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit aca759a9b1afc6693cfaaafcad7546298423fd20:

xfs: enable metadata directory feature (2024-11-13 16:05:40 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/better-ondisk-6.13_2024-11-13

for you to fetch changes up to b038df088d5bf221ac4f8c7fd20d7a60c9a9ddfc:

xfs: port ondisk structure checks from xfs/122 to the kernel (2024-11-13 16:05:40 -0800)

----------------------------------------------------------------
xfs: improve ondisk structure checks [v5.6 10/10]

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

