Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9082610C
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606936; cv=none; b=KAneA4HvRu2o2GBat4BymHd+P1Y5H9+e3vWvZsHt3FjuvAYFdnNatxZRljV/MwVVMenaO5kRBG0/cgwrON/0ZT1RQ1+CGx7hKcR4o82o/tagyNF7HpvAex5Dsw6j0nlQJ2vVpkCjyImyXqLGULShFWcLuwOeAG9Z4/fjkVMuOyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606936; c=relaxed/simple;
	bh=I2i1O0EJeryCEq2p56u60xm0BD/X0XqaiLHipuzT6GY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egPwiFvEvbsuYoil9+tb7G5uLpmk06pglPRJz36Hx6SFePhee26RWRUTfsO9mw/ynLgE0tK9Qnn+0gM6Pt3MxC8W2jCJcW4Cuw+Fph5YKqATXkHofGCFofujfvEpbj30Fi4mDdPv3rv+l+FCZBr1YFO392XNFpvp9GXxIiQeOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMeG4fgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMeG4fgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF69C4CEC5;
	Fri, 11 Oct 2024 00:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606936;
	bh=I2i1O0EJeryCEq2p56u60xm0BD/X0XqaiLHipuzT6GY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FMeG4fgjU7u9fzSnGLlFPPa3OxhH1ai+pNZ0TCUhYiTZIvHxSrByCR5GAW9gNCDux
	 awpH0Z9u5taByfYWUJZ+KLPvmhEttBMSJGXbKqxGtSzfFogxMuF2obDjJPn+/93OA6
	 P67MJvPk+UwUtbedd4oDejTplcrALOZKyCLgKRgUnJF0zuQD7wy0QSzcuNVOqJSI60
	 ZfSb6H4OyH3TX5EjZbtRqglPLxVOrZoWNyOo132dzwNWbx3OckEvsZ6esjyPNEhcwZ
	 /T/WTvgfzN4fWOxWaKeiThTPIDm/OX0m1uit1RajTuKUVYevEQr33NoRYZVL/CXc38
	 oUo0EQwtVbReg==
Date: Thu, 10 Oct 2024 17:35:36 -0700
Subject: [PATCHSET v5.0 9/9] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860646128.4180365.15337586086476354855.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Actually enable this very large feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
Commits in this patchset:
 * xfs: update sb field checks when metadir is turned on
 * xfs: enable metadata directory feature
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/scrub/agheader.c    |   36 ++++++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

