Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585802010EC
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920563; cv=none; b=jNEg/LwHSNOEjBXhHKBeVKPExVWvRdKtLioypGAV0alnX1ORVTE2q6mUECG0tT316NA2yD65kdqLdTMtfemOimbUQvme4+hz2qMkHqBO54850qNRlKDZtbtnyfRhMIFzZ4mq4IEWQ2kz+xajlbc+V1c8IgEYVZLshll0mjD+zFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920563; c=relaxed/simple;
	bh=gQAGbyiWmgfsc4lnyfD+a5CssGXZAlBxB3+4I/elrdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=smlUDR0IfRQGFxJfiVjWPz7suIHRVn41aySCVICO1/8MUwLGfAYJ3nS7hhxS7ntHk/aYNQyCZ5kGoh1xnJnG04BdGhR2uc/gsgExNmfdRsW/CeyppNys7TMphyycPDFCE3pvY+woiUuBGA5r0KCNuFB8GNQEfw9zYQ+gWcfbsRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbwRoRub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbwRoRub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AA2C4CEC6;
	Wed,  6 Nov 2024 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920563;
	bh=gQAGbyiWmgfsc4lnyfD+a5CssGXZAlBxB3+4I/elrdQ=;
	h=Date:From:To:Cc:Subject:From;
	b=GbwRoRubr4x2xO6kbIQBXKOO8C5kTbjdUGB8NF4i8BxMvI0/ThIEdZKi7gD5yxwQk
	 sk5hQSvfaCkdm+P7t3bYeMOKf1ThvmfVxOv/YMoEP8lnHKzWgcRC2BzTzrihg+GMg6
	 XVwDSgxE9InfWtNzt3rP0QU4c+Dla3faJS664ZOqMHUFtQUuljQApbbK4U6ETQ8vZm
	 ESTUByQdNG71I4e+3RfQW0IibVNsgXuJQEwNXGuHO6thYUcZUegMroLivAej6lp9JK
	 ArKzzR43kTx2RPvkoEZi1nbvB+GQTeCkjT8RI3zxNFEaRP74WPCZYrbZeRClr6mfS7
	 Jcov4BwfOjkWA==
Date: Wed, 6 Nov 2024 11:16:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB 6.13 v5.5] xfs-docs: metadata directories and realtime
 groups
Message-ID: <20241106191602.GO2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Now that I've sent off the metadir PR, here are the relevant changes to
the ondisk format documentation for the last few bits of online fsck and
the metadata directory tree / realtime allocation groups feature.

vNobody likes asciidoc, so if you want an easy to read version, try
either:
http://djwong.org/docs/xfs_filesystem_structure.pdf
http://djwong.org/docs/xfs_filesystem_structure.html

Please have a look at the git tree links for code changes:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups_2024-11-06

--D
