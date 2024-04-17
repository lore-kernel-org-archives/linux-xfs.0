Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F1A4C62E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391671; cv=none; b=kQHTr4Hmkj2TfW5+NFSuPwOF+yWz32eXEJ4/tJxy2+w9Fu1Hgiv21pX161SA+MMBM0vARVKhFnG05jEsauLS6EcjRL7ibflPSxCnEbxkE2nOYU5sXZ+A9eVN1FsUolv8ifMVisRTxsYHDRWq5nGnjNDja7R6qPZbB10zWK+rLXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391671; c=relaxed/simple;
	bh=qydl3+sxBS5HzE3gxP0PQdPA+UUjxoX4/yzdkdKQLKg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=NIyRxl0aOVPHBGAp/M7ddZdZV8eaIfC3E07j5nCByQ+5HfU07WDYaY0vDXYnDHEiJH+j1cmDxpR5S/7mX8DO2gnhrtQvPsEaJvRaT6c02aw/ourDINPLB3nJsX5+hR6djKTKHBQ1ec9VFcldd6mjnloy+k3ExrlLFhi1FexI80s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNyerjGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNyerjGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D901C072AA;
	Wed, 17 Apr 2024 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391671;
	bh=qydl3+sxBS5HzE3gxP0PQdPA+UUjxoX4/yzdkdKQLKg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RNyerjGNE3Q7q0d5c03xuKLSKcIOfalHm9cazGT2WoU3GmfmWALLSJ1qX8wuJOd8t
	 REYw4i3G08D9y64/TqPvAmyF0AUWOjq9vgwMbkpfLhlk8f3JEJtzBB7FME/ah4TKPu
	 Aw8zdjiRk7WYDrh1ASwk3ka4zhTCg/uMIiGPcGdui/OqOa0ooHbGGpyXHOPf0Y+/RH
	 blXN7B6auC68/WwMQ+qi85s73o2glFrJs7R72pLIJjf8ZkMpH03NimSmQIDRUCUbQZ
	 cMVEdoC9eHzB3rIs03IglJ9wxh9ZOodzqAyv4J/I6HfXn2dGkFrIvXeUHyyli6wOSj
	 vkfz+L+F9zR5w==
Date: Wed, 17 Apr 2024 15:07:50 -0700
Subject: [GIT PULL 02/11] xfsprogs: minor fixes for 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339158704.1911630.229005723181809969.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit d27e715c3081306e1b210e64d21775457c9f087a:

libxfs: fix incorrect porting to 6.7 (2024-04-17 14:06:22 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/random-fixes-6.7_2024-04-17

for you to fetch changes up to 94f4f0a7321d52edaa998367cccbe4dd16f1053a:

mkfs: fix log sunit rounding when external logs are in use (2024-04-17 14:06:22 -0700)

----------------------------------------------------------------
xfsprogs: minor fixes for 6.7 [02/20]

This series fixes some bugs that I and others have found in the
userspace tools.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
mkfs: fix log sunit rounding when external logs are in use

mkfs/xfs_mkfs.c | 16 +++++++++++-----
1 file changed, 11 insertions(+), 5 deletions(-)

