Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E71FF7B4
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621967; cv=none; b=uRSFAW1bTjlqB9ehi8ex3+N7TV889t4TLk+oowgbFWds/aOmRKh72kGF/aYe4uSADBQ1+n4J4UBLqFcAKnsVUvCL9euO1EHPwpu1tnri0YLoOkXVi2HRLUP0sOFI+zeJ1b95PdCcQrJXZjE0m586h0tnROtRjmfXDdZ79hFEfWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621967; c=relaxed/simple;
	bh=RTj+tTx1A1k/t42wFBp0nwP/9na8DDa4damqmCYjd+g=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=puPjfn/g/SXwzolzrJaC6UWGHniXE1KQuTYy2iKfwcgHyVsLNinYcA1hoL/Cnf3L2wwztfIC0HSmTil1AvLG+ybs086lkUI0dhVSmFHKAZU39qQeMapT10u2AVDJYpiuKPT5DRskOwcD3B2W6XfNJ0Kz8/7HuchamTVq1IOSKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REuzD+yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REuzD+yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D5AC4CED2;
	Mon,  3 Feb 2025 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738621966;
	bh=RTj+tTx1A1k/t42wFBp0nwP/9na8DDa4damqmCYjd+g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=REuzD+yg7QkzS4QkCa+W9ZcHYiUGFQRT/2Ed7t5ti/l6KbMQHgOKupKmuPWGOkD9e
	 CDzgScRUL5XI8QJZ3oS7Z4oUvnHxf5AG0f3jdUuynm0in/sX6U0uYLD4j72+x/FTEy
	 /HGfPD0PtfRHm68Envuqf7556FyYMd5a+cnS8PboSYZSj1npPpMET00ymY2Nq2UNou
	 TyPksUh5FUJpicE+lqChIDbSdMjKtrCYnSELDoRpk7HrCR53SJMMB/LOETuUrPcWrE
	 YOEAqSHdGeZjkaATfNFcjogdnUvzRaEl1JhOREc4uqv1JNo8tNOPc9Bbg0DF54INVL
	 X2HpIKwjfGQdw==
Date: Mon, 03 Feb 2025 14:32:46 -0800
Subject: [GIT PULL] xfs: bug fixes for 6.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: , david.flynn@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862194217.2448987.122994949207801411.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
References: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.14-rc2.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0a08238acfbaeb7d3605a5bec623ed1bc88734eb:

Merge tag 'xfs-fixes-6.14-rc2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2025-02-03 08:51:24 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fixes-6.14_2025-02-03

for you to fetch changes up to 0ab5a2b9378babf743da4467b448f84ba6110f0b:

xfs: fix data fork format filtering during inode repair (2025-02-03 14:29:15 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.14

Here are a couple of bugfixes for 6.14.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
xfs: fix data fork format filtering during inode repair

fs/xfs/scrub/common.h       |  5 -----
fs/xfs/scrub/inode_repair.c | 12 ++++++++++--
fs/xfs/scrub/repair.h       | 11 ++++++++++-
fs/xfs/scrub/scrub.c        | 12 ++++++++++++
4 files changed, 32 insertions(+), 8 deletions(-)

