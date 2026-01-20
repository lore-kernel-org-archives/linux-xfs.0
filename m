Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FC143DA20
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931444; cv=none; b=FFjV3BSefBNXI5xTWYb8eB1wTUXc6euJp7QZTdd/1fSnFcQt1XJ7y+f7Dz339DLEXHa2ni17HwjYdz6rYeC5T1bGWSExAno/1h1Nj9T8pXM9i3cYByn3qnoRngEmkLdLqQgLhDcVi22gqTXL4OnLpwFuDocpTTVqnoNtpf9Rg5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931444; c=relaxed/simple;
	bh=cU2SqhbM/+XGXc3Y6JE1uCqFigZ2xRuElXuci2z9+3Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=NdYIYkk3IXVL/dLcQd/u+ZOunX27Cpm58+D0t8tqRH1b0HkbyAa9ezuICe3jPPfjOur/7aePnjC8bFoM1UcPKQ5ANziyyVasy1+u8ZK6dMf4qckSoaabxziVvr/4OLBOIOUNcD8DI4XSFHflgTiI3P27GIkXN7MYmh99kMmrLyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1zhfXcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1zhfXcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EFAC16AAE;
	Tue, 20 Jan 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931443;
	bh=cU2SqhbM/+XGXc3Y6JE1uCqFigZ2xRuElXuci2z9+3Q=;
	h=Date:Subject:From:To:Cc:From;
	b=k1zhfXcmH8m+lbEsdtBSCevaPgQPHAJMvlQY4lPrGRm+DIwP8N/ojoaKM5InsK1RZ
	 xBvxboI+5lq9uvOO1KFIrUrwjeOTkoEvD/BbHq9ZWBkJ/a9Vb/4dk3Ezsm9GzZ7e+2
	 cNjgEESRhOrZDXu6nFNvwGJcYNKgFXoA1zBMA++ZzZSKiHxFNvasYq7uk/8vFg7F7L
	 4EvwAnhYjxUvbxFpS7REtEjTGcSKmxXfszWaGxaCecxZqUruPBxaeMBXaGJqx09xxr
	 rzMeNfXBFveuzRmEc8XrFeJu/lhu3vplfhSqCMAUAO4KrM3eatEOufld808Od3qrF0
	 AsWjuU2ZSrmrQ==
Date: Tue, 20 Jan 2026 09:50:43 -0800
Subject: [PATCHSET] xfsprogs: various bug fixes for 6.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * mkfs: set rtstart from user-specified dblocks
 * xfs_logprint: print log data to the screen in host-endian order
 * mkfs: quiet down warning about insufficient write zones
 * xfs_mdrestore: fix restoration on filesystems with 4k sectors
 * debian: don't explicitly reload systemd from postinst
---
 logprint/logprint.h       |    1 +
 debian/postinst           |    3 ---
 logprint/log_print_all.c  |    5 +++--
 logprint/logprint.c       |    5 +++++
 man/man8/xfs_logprint.8   |    4 ++++
 mdrestore/xfs_mdrestore.c |   16 +++++++++++----
 mkfs/xfs_mkfs.c           |   47 +++++++++++++++++++++++++++++++++------------
 7 files changed, 59 insertions(+), 22 deletions(-)

