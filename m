Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F5188A0E
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 21:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746048664; cv=none; b=Lsp6HuLMoV0K0izawnvTkFKnD9WDXM37afZIs5XGN9I+3cIX3ZyQheyONkAU8rD15jGqbDung8Ce21sYCTgtyGafzqbIYGO9IuXW+lzfMm8y6Plye70PslTGmQueDKfAvhm61ExDBpk8/rF/Y8KDJk/Fw663lPjtBlJ7gtXJs0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746048664; c=relaxed/simple;
	bh=68LArkRo0/ycrBJRkNh1rmVZUmm/1Gy1a3CNO8h2/sQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cMDMpq6SYwZ4nr2iOQB3AyLhA1Dp1cD7q6UCkjnrYJmEytiMf7Jjzx9q7DqN562L/ppqynLEoWRqK9HTKU9mPnxSBMQrWlCdW31otZB2kUDdlnS+KgjtAcJCesG5O521HoYSLyA9aiHpZFWTq5lEN4HqduLZMq0j7Q8Rqf3f6/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpizMVuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpizMVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74188C4CEF6
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 21:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746048664;
	bh=68LArkRo0/ycrBJRkNh1rmVZUmm/1Gy1a3CNO8h2/sQ=;
	h=Date:From:To:Subject:From;
	b=CpizMVuffXT0SvXC8MFhUvxCB2/1homT7vZdYNO5C3D3yzB7guutr6oY/iLBic5U6
	 5UckDY3C4969N/Qk2dLs4gg6IdprAM9b6bLSBG9P2umosiaSI2WWGNf84RoFsUWmnr
	 jV05zBxoeL1EjS3fpv3i0VSd7Gh75bH9na59jG9ur3DWzZiRM8FwiBiZSUWpidSptF
	 OTeH4PasYlPpcGt9t/Ra1Sj9ZntF0j3tcRZt1MOAAaTFdBykoVd0Cc9rIR2oQWYg9W
	 fjH9gzOjcjcIHjj1peYpUIMRw7qdnxjrORndM2poRn1m7IWAK5rQpmzEb1s0BaSrFu
	 UrDVh8W7r6oKg==
Date: Wed, 30 Apr 2025 23:31:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to bfecc4091e07
Message-ID: <i7cvwglvka5p3an55jejwtgx2ziuvo3j2kqvdmqshrfin6t2mb@mpogzrfj6fve>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

bfecc4091e07 xfs: allow ro mounts if rtdev or logdev are read-only

1 new commit:

Hans Holmberg (1):
      [bfecc4091e07] xfs: allow ro mounts if rtdev or logdev are read-only

Code Diffstat:

 fs/xfs/xfs_super.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)
