Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A832B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaAvHUxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0088CC433C9;
	Sun, 31 Dec 2023 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052458;
	bh=Nushhxa8IT0/4ESw9Nq9at2xsx/yGhKTWlGTK0UxoUQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gaAvHUxO1rqvrwts9AJbMBAXECEUTczINJQ6klVJAXVRPAnN2GKqTrEDRhjygpJ7t
	 8Ww7SKUpF8td8G6T5UJGClP+Nx3aBUkBjYhn6vwDyCafJqme9xdEiP9l7FC5XoXVDx
	 Uv20tQ060KbiJxVAyTfCqC1edLuWeo9VXk7kJDKbMpzW3fr9F9PCEhi1bkKyNfwYyX
	 svaGBnJ1d3CpLo4MV8M5ZNlOygUcF59aJG7rabwSEJz9hSyevu7lLw12/eivhQsucH
	 5HSAV1EWVpMVwj4XHziY87bewNFaIb5QD4uDtG3Qc4nCGaIc5BgSz/5qhEZD34Qhlk
	 3lGjSthyr3nAQ==
Date: Sun, 31 Dec 2023 11:54:17 -0800
Subject: [PATCHSET v2.0 10/17] xfsprogs: widen EFI format to support rt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Realtime reverse mapping (and beyond that, realtime reflink) needs to be
able to defer file mapping and extent freeing work in much the same
manner as is required on the data volume.  Make the extent freeing log
items operate on rt extents in preparation for realtime rmap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-extfree-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-extfree-intents
---
 libxfs/defer_item.c      |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.c       |   16 ++++++++--
 libxfs/xfs_alloc.h       |   17 +++++++++-
 libxfs/xfs_defer.c       |    6 ++++
 libxfs/xfs_defer.h       |    1 +
 libxfs/xfs_log_format.h  |    6 +++-
 libxfs/xfs_rtbitmap.c    |    4 ++
 logprint/log_misc.c      |    2 +
 logprint/log_print_all.c |    8 +++++
 logprint/log_redo.c      |   57 ++++++++++++++++++++++++++---------
 10 files changed, 172 insertions(+), 20 deletions(-)

