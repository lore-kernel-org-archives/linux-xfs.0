Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC041632E7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565712; cv=none; b=C/SAaXSz+u4TmXfrwaOujN5KA//KgxYMUXpQ0M5DQ92hAUYpUTKQOuoBSUlzuigG3ACVHi1z7Ex8O09YFzna/d08RScyb2i9OZ/zZtJA7zX8zfifyyaTWYVOXfoSQqRm4MPOlthUPfvoEgi88taaBJSnjoed2pqqKpYxzcmyAKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565712; c=relaxed/simple;
	bh=IxJaJ+/P5Bu1CeUUEOP/HVj1EWOhkTVm7wUK2b8pJ3Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=BE6GfuKNyq1upZv8wBI1axbTZVxmu7et3KcYUDsy0jKLhrFZ4VxTmwvJi4L/T+l+10HhKxspIDqxCqyMHPMM/Ts0Fq/3IiWaScHhYjRJNUkDMVuq2MPIxnhEJ4eD4nAqxMTuTFVeV2UsLGGbqEkNiqFRbkYcfmmswmUkwbbT6Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Om08mgjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Om08mgjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB5BC4CECF;
	Thu, 14 Nov 2024 06:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565711;
	bh=IxJaJ+/P5Bu1CeUUEOP/HVj1EWOhkTVm7wUK2b8pJ3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Om08mgjZbAt439I6I1ESNmXL+zZlInS/z8PdWFbBThdp1WzMYl68ViEBNu9PT+wtD
	 yPd/1Pa9Tk+ppMeTLIUrBD3BIviu79isM2w754rqIspay8Nn3BVKVS0CJCMFCi6woi
	 fxm8mv8BgF73K6yfW4mlpgJjAyOj5H+EySUPQlbH8qzUZEMgZHQ/lUXVGdRYIAvcig
	 SsFGXq2zkHzQEGx7XzWQh0zj05K++dWgkCVWeazvq2ghOgVqqmA9p3GGldtcVmvNPC
	 NlPoSXvXxNCGYVFVyQ7kV7CHwCzXcjql0SZ+5eA0dGnt6PMlhd8zjZEBjSRh2ZmLgR
	 QenEwuVipe1XA==
Date: Wed, 13 Nov 2024 22:28:31 -0800
Subject: [GIT PULL 10/10] xfs: improve ondisk structure checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551969.1445256.8234868674837338084.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 407ef7c670221fd3d67a69a4b5aac49f5d89446b:

xfs: enable metadata directory feature (2024-11-13 22:17:13 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/better-ondisk-6.13_2024-11-13

for you to fetch changes up to c70402363d6d27925f8acccff727db279b5a154d:

xfs: port ondisk structure checks from xfs/122 to the kernel (2024-11-13 22:17:14 -0800)

----------------------------------------------------------------
xfs: improve ondisk structure checks [v5.7 10/10]

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

