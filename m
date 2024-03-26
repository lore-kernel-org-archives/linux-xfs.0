Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0B112838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421841; cv=none; b=ZFtRvIZsX1DVmD93rdzQ+TZhl20eQwf8iQmAb8lwBxqxKJttJNXMIdsr+yoLDSsCNS4nTYW+hxcYbzYik7syHE/2k2TPkNNk2LaKOgrdOmDh7x+obyDBuDxzSC3S+c7rUilyQMIASEJXyJOnV79xJdMANszco2WG+XHURzGA3Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421841; c=relaxed/simple;
	bh=Uo1GMwtkGzXnsdQTgd4OgIJRf5fYx32nRDX7svI+sLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s83/mcuyX7UXjDRZEjgoPw1JsM03glnDRVlCAw27CLLc04VB9uzHMLX6ygs7UYkxboFLR2C3uVswter1vh/9Puvne6mlHflQygm+V2TM4eZ973Zcc5ygbvsqrf8rg+PVCadcfyPvGxBemUrg7FoT33jQoXU/WlyBSePcmjCAPRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6XgafYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6XgafYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F7FC433C7;
	Tue, 26 Mar 2024 02:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421841;
	bh=Uo1GMwtkGzXnsdQTgd4OgIJRf5fYx32nRDX7svI+sLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q6XgafYnmFA/UDvvMDIYuldctDQf6Ik08sTXkVdwiukMvvPucJkD7F/4ErvNcKixw
	 orvMHsGw6fW/2eUQni2SpWlIK1Z2ZQvZ1btx4bTK4Tp6RSWOcC/KQp9aR0lXWCTM9W
	 SmuNYi+24L5J+Lvfjxn5XUxB8cwyedNrPu0bCFvgdNNZzecWX3t4HYi8uPNAB1jTHH
	 bZ2WtTh5fgmPuUQEXs4Dq3Ju0j94sxcLc9pQPnrL6jtSpWhB6tBnWgoPIuBlYKUWjX
	 AshrmXisr2bP3/EoGNa6tUQJVJDd7MIi+a9ishKE1UhDtpLnlFA3gJ+ZeVsuEopAJC
	 5szI6Ikce2krQ==
Date: Mon, 25 Mar 2024 19:57:20 -0700
Subject: [PATCHSET v29.4 10/18] libxfs: prepare to sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130769.2215041.13045675877934918888.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

Apply some cleanups to libxfs before we synchronize it with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.9-sync-prep
---
Commits in this patchset:
 * libxfs: actually set m_fsname
 * libxfs: clean up xfs_da_unmount usage
 * libfrog: create a new scrub group for things requiring full inode scans
---
 io/scrub.c        |    1 +
 libfrog/scrub.h   |    1 +
 libxfs/init.c     |   24 +++++++++++++++++-------
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 7 files changed, 74 insertions(+), 9 deletions(-)

