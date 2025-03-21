Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942E413B59B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574644; cv=none; b=kxZ207BVllo4VlvSCawOvaLiAJ1g5+Qj5JHdUZq+NqJ41pQqPGj0VZB+KOJVHUkAP95pjLIbXzTx9OPZBPwG/vsCzhut58lxaJ85aEFdLUqkM/RVFK/E9yJuibPwNFDr5Q5wtLRdUOEwpOoZcnxWYKfZNx46SFZR3IlKdRLtbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574644; c=relaxed/simple;
	bh=o9PuhuK94s2gSrjvigRKNhsqrv7GHKmEIOaT+sP3vL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bj0cLg8wclmk4yXRK7STPpkfs2C7+ZXS17eGwMhoseCJ5xNZZzPs+2SGiOn+Dn4yZKLWZxQ7s2X4RWNEMtJtGcEZ11b7f8NSTo8k000A91aqajobiiUcntBjO3/z05teVEQgvJVoO45LrG9wM/w6S0jwJbha8KMN41WMVnMuRRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYHRJYda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYHRJYda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FFFC4CEE3;
	Fri, 21 Mar 2025 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574644;
	bh=o9PuhuK94s2gSrjvigRKNhsqrv7GHKmEIOaT+sP3vL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CYHRJYdaVn3ytyD6T1bGsvCmCRij6stiVKewimbm6CfM0u0/1+trUvV9EMmB1+h8Z
	 6xFpbDo3IW+v+cwtVJivdQrejw0BOVCFPEWqE0WApo01Fve9h33PonH4+H/aJqn6Y+
	 o2Z0eYIg5IyasBM0YuFGir9LpSCh3p9g3wfeWGhLL5LRcSZRc0JbbHDikljgbweTlO
	 3lY2Lmol6z4M7QfV/d13TgO+PKlN/z0R2O2bIKqa/0A8DLdzyinPwltA7qWDZKWjZO
	 bL9a3r3JRLymwSQLOq1B4brg1rxOZSML2Dq53EB7GO+0P7G1piIuSmzCEsYrdNQov6
	 ePxDpxH9tH3ww==
Date: Fri, 21 Mar 2025 09:30:43 -0700
Subject: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 6.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: willy@infradead.org, cem@kernel.org, cmaiolino@redhat.com,
 sandeen@redhat.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453343.474546.18134930850961940333.stgit@frogsfrogsfrogs>
In-Reply-To: <20250321162647.GN2803749@frogsfrogsfrogs>
References: <20250321162647.GN2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.14
---
Commits in this patchset:
 * xfs: Use abs_diff instead of XFS_ABSDIFF
---
 include/platform_defs.h |   19 +++++++++++++++++++
 libxfs/xfs_alloc.c      |    8 +++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

