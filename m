Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8434B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ptkax2Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB4C433C8;
	Sun, 31 Dec 2023 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052364;
	bh=0tb/DPdwWDat4H1kTt1p4BxxeoG9mIvWd2D2EhFdFuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ptkax2SyHTZ02fP6QWKpq0zwqZCjvxfHwJQ8gdy3L3E2mhW4GC+zMxVfYWmpLaFSn
	 kuXAnIWTkOolEVc+1gHXN1f+LvO3YEeY60lD1F1ForFenJi04TvtZfCYWt3TwVkTdC
	 uil8gFHKUYUdZMCCdoguIJ8HFqSN84S39GLJ9KFkkdOr0Z1CSYyOuzEFKNQbvIJwol
	 4e4zAGuT1GstBo4gd5Use6eXhequ/DYA+VJnvy+cO8NOd3jIV7tIv0tMvnIfnrCBHo
	 8VRb8a//t1MUfdhvFZOPSHrM/rit0Mc1D2hM10VHgDi19K6BYE7Hx1jSx0xZUplNti
	 KUzw227N1t4EA==
Date: Sun, 31 Dec 2023 11:52:43 -0800
Subject: [PATCHSET v2.0 04/17] xfs_metadump: support external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011421.1811063.2601536880760874799.stgit@frogsfrogsfrogs>
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

This series augments the xfs_metadump and xfs_mdrestore utilities to
capture the contents of an external log in a metadump, and restore it on
the other end.  This will enable better debugging analysis of broken
filesystems, since it will now be possible to capture external log data.
This is a prequisite for the rt groups feature, since we'll also need to
capture the rt superblocks written to the rt device.

This also means we can capture the contents of external logs for better
analysis by support staff.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-external-devices

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadump-external-devices
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)

