Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C142B357CE9
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021315; cv=none; b=L6qEcC5SdzPZAXQ9UB0F/qfzZ7xCQ1BZbtbDwvfeaqkHtXkIXy5W/F4I4OiGMIBoifcumEqHqzzUe377e3J5JZPWZT0/oF/Bvdzne1AOlRWRt3y/Rb4W8qrkNCzdH5mzH671DlzYQRqRxvSEG7bu4L7Vu6GMbTSEHBWjF68vPYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021315; c=relaxed/simple;
	bh=qRM3IFIzouav0ebSumOXBDb8jZOifPj6S6/fwgPzhOU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=s5x+w+kHFzBaX3Vd+DEkEDZ5zhRdV32d02dCy/DknhGaNzcoGZ6+JSdWSUH28RGS09n8i3S3QrzyXCn6aY5GCXlCLEi+jg67qqe//09u5rBduMtQpjyh9lhPZ5EHHN856DBhh/O1X39UYrWuhbFMEtnvWweD3cAlkLbw9WTohh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARq2ij9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARq2ij9V"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 55EF51F000E9;
	Thu,  2 Jul 2026 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783021314;
	bh=kDp1mpmwyfwB5hhTEsssh0rfqRpOUpPPC1W3NSbiRVw=;
	h=Date:Subject:From:To:Cc;
	b=ARq2ij9V11/X0oWFw3THww5vC7IGQkvF534+9RPE0kWCJzE772ZF3BXn7BPHDeV8k
	 j/SJ/Ayumi4N6lmIoKiOn0uRWwxx40TWtaVhV3becS+SpomKE2jkCuk9UwFiYcuAKo
	 8ET5NIMfyPYtKABLZSmr8dxow2VDB9/H0FhmiroJp2PLYFYn/luVb7VurxLCIW6R2f
	 W/Gfftb4qabqW/XhFKRzvMXLj9tbDuIeis5BnN64k7Xg+1TkXA4ELFdHBKnxRWdpAE
	 ygGmw9bwG7zhLrZjENeqY5Zi+Li8UCmAH69+ub2G5e/h521Ui+guDSif8+Lmc+eXni
	 D12nDEza74WtQ==
Date: Thu, 02 Jul 2026 12:41:54 -0700
Subject: [GIT PULL 2/3] mkfs.xfs: codex-inspired bug fixes, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178302114867.828394.10574116701813141609.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.1-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit b3268fb3d822a7ef7d647284e0dfeaeb61713011:

xfs_protofile: make nondirectory arguments actually work (2026-07-02 12:38:24 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-codex-fixes2_2026-07-02

for you to fetch changes up to 8c6bf6721ac440c806d5da0d0fc93ec7ccf98da1:

mkfs: PQUOTA shouldn't conflict with GQNOENFORCE (2026-07-02 12:38:24 -0700)

----------------------------------------------------------------
mkfs.xfs: codex-inspired bug fixes, part 2 [2/7]

Here's a batch of mkfs.xfs fixes resulting from Codex reviews.
These are really just the patches from yesterday that needed more tweaks.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
mkfs: pass stat buf pointers around the protofile code
mkfs: fix hardlink detection in directory import code
mkfs: PQUOTA shouldn't conflict with GQNOENFORCE

mkfs/proto.c    | 47 +++++++++++++++++++++++++++++------------------
mkfs/xfs_mkfs.c |  2 +-
2 files changed, 30 insertions(+), 19 deletions(-)

