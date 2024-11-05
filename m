Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09E721219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844390; cv=none; b=b9FEkbEIltiClIo3lVofaB92TFf5RsX/t0WMcJQyaRmXzuBJEi1Xnet3w9UILA8vYoLs0uXFrkK8SLb1HM+EuKE4yo1TFDGqdTcPvqlm0Ls4saQgCxBq7qichmPiR0Fv0feMSGrCiQx+rOZ0ZgRDV5McfRrySCsijpfO2f+t4Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844390; c=relaxed/simple;
	bh=C1x9/tCIei/YeLB08HnV/UiXrBvpXYIw6ALYKswdtwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPWSxZzz+Xk4Ojx/qcJ/tP2MHX5wJcrKmBfH21Z5a4KyyBWdMVuhU38s9p1IIZc/f5nW/AQblD4ANK5BtQvi9LRHr5asZe6wdaDSwuWK0Io8p6KTyqy7vPoCYtvcKG6ZGvdAVeIf3BACD3RkpQ8Z2fIfcnQJ6QxHNJkT6SRXyJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1nMeCVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1nMeCVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C94FC4CECF;
	Tue,  5 Nov 2024 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844389;
	bh=C1x9/tCIei/YeLB08HnV/UiXrBvpXYIw6ALYKswdtwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t1nMeCVZNJond2kJIdNMdPCiq8bHKo8O5UsDWtpexiaz21PhAFV/77e62qcNLkm31
	 sNLi9B+9q+AWmu/QMV96SloaW1EjashC5gX2d1nZEQjEAdPbJdGeUptRTJYXjF2jQR
	 AbZUa9Z+Yk94cR//eFCtE6KJrMBslfyPMMFklPYsSRcroJFQgPsgnEvF+KRswYJCDM
	 p56hNuAw66qLNz5YyPIABlMwDfXUuW2QJ/9t1nQn+PVmHwNNdTuxyo+h2rPCFMQP9a
	 K4CJwD8hAYvDO6otNEEXHXalI5X2CKghZLZVzfd/vMXY0P7okp6aLW3eltBYcNZKLc
	 4fL01ebLWYlGQ==
Date: Tue, 05 Nov 2024 14:06:29 -0800
Subject: [PATCHSET v5.5 10/10] xfs: improve ondisk structure checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400403.1873612.4794500935296519016.stgit@frogsfrogsfrogs>
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

Reorganize xfs_ondisk.h to group the build checks by type, then add a
bunch of missing checks that were in xfs/122 but not the build system.
With this, we can get rid of xfs/122.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=better-ondisk-6.13
---
Commits in this patchset:
 * xfs: convert struct typedefs in xfs_ondisk.h
 * xfs: separate space btree structures in xfs_ondisk.h
 * xfs: port ondisk structure checks from xfs/122 to the kernel
---
 fs/xfs/libxfs/xfs_ondisk.h |  186 ++++++++++++++++++++++++++++++++------------
 1 file changed, 137 insertions(+), 49 deletions(-)

