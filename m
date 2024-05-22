Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C831E894
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346033; cv=none; b=kmBhwsUBMmgJkplIGUCcBCZvSrNdiYg6o7NnuUe5tvfAoKc/2a2+I2dipyTQV/sLVBASwWLx4M59c8aiv7LE5Q8IY7jC9rfIs08E4PeO4tZgjeY/9lXAx1HFGRh+j+FOZTzHdyxzG88eRRv2IwzqSf80uiIkKz2w0WfWj8gKQCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346033; c=relaxed/simple;
	bh=NQ58/mRuGZA+GX9yUFFr8KF9XHEO32GwD4DZ0Oa9mm4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gC1C0874d0gkmgCG11OG8/ESKiwy+313UIFW5ZzZ+uBkRp/9Up0veaz2wgxZVW74ze6ZhZUQjTDNDbOZMKCvTd1dDyAUe+9A0VeEhQjOKqn/5JPYATqk7LF/PZQ6QOd2lPVOoVvnoPYDv3hVGhXPGkVfzESRDF2Ml3vyQ86Pkqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tooz4/8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tooz4/8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9DCC2BD11;
	Wed, 22 May 2024 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346032;
	bh=NQ58/mRuGZA+GX9yUFFr8KF9XHEO32GwD4DZ0Oa9mm4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tooz4/8cykhvys467GEqz1f/ceCsL3efFkMWBI/ZGsDDlcAV1SmTPWRNEC2MWbqrv
	 54p50HW/kexSzBVhrJWKQztx3jkSQ1BiDVIaS/uNB5xBBbK0khuA4N8ozuVYOqL/vf
	 3t29WSbG1wFfXoPomewtxWtNfHAasMwUDNAUAtO949dMwXR02RifeZxNlrMnxMfcIQ
	 fP6KnxF08g/mk+ZNa8XV7OGHKuM+f0DfoLxzXgy9SZKMGvRgGvRZyamO6sChul4LDr
	 dPlpTYGGkKw8Gkgkrb3Z7zCOPtXh9RHOQuEur8aT/DLp40JTaa4FbwGcUTY5oddxHy
	 vYIBVAizse4zA==
Date: Tue, 21 May 2024 19:47:12 -0700
Subject: [PATCHSET v30.4 07/10] xfs_repair: minor fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535073.2483183.1359823514229331918.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix some random minor problems in xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes-6.9
---
Commits in this patchset:
 * xfs_repair: check num before bplist[num]
---
 repair/prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

