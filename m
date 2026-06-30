Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE7E86334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781340; cv=none; b=UGGr40FR6tpVCkb43He8tN/nU2soJbF1LcduMvDXy/ZUEVdCs94TCncyyc1qE2h27xyOMXhqmWoqwpH/9vUhfaT0lA4PzGphJubDvYXjvttjtIflbdNauLA/2WQDSTtZgjtdBhslhGUZLZW30MTMXD+4e2K7h95DDUD4eSUcp3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781340; c=relaxed/simple;
	bh=8hECRMtxJvcNhznrQ8Aw732kvGSyNe/ustG8IfgyhDE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=UobMd+nFhCPe6Asc3lPL2ThKOEj7GXNLb4xqzX98MZH2kv5QfIMhZx64BspcBFGnN8eZjjatJsQjeeuMXH4CXuKqAqwdia5ACxRF86EV/TsZ1zmc7KzOzDV5/zozrYY1C241asfNVoUMLSABaAKh29PcsZuiKdam8clmV0dvNIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tuoq2O88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tuoq2O88"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E99491F000E9;
	Tue, 30 Jun 2026 01:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781339;
	bh=JTSp5MRNZR1sTbCiLOzsmQozm22tNeJ4/U5c589Q0WA=;
	h=Date:Subject:From:To:Cc;
	b=Tuoq2O88Vy/o2tu8+iag2hkZq88k3JXbPeLrYLiAM93O/LJWI4yqBj6Nsixxx3z6W
	 Ds1SroFviTPSWmpMiszupC/rDTEUIGoQ0R/M1kvF6BiMDTU/eq7ZXDWZnXw2TF3jSg
	 0h3r7SZheMp95jAnXuCA3BX3zwqL0VbRbhqVBoA+NKiKFB880gkEVngsPXJjL4AzBC
	 z1Q2FI1oQKuT8H/HLnMGc7+bOpz+PAPw7fjt5+H4S1WTdf+dPiylvI3qTHb6zCJrhH
	 YUDWyVntMmUtTKIW2aQqRLfOjohnPv1ZdYVvKrETMDxXd7yX8GyZ97vUQ1NuDMofdP
	 zPveQoagmy1ZQ==
Date: Mon, 29 Jun 2026 18:02:18 -0700
Subject: [PATCHSET 4/4] xfs_healer: codex-inspired bug fixes, part 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278130347.858743.17561352882773270723.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a third batch of xfs_healer fixes resulting from Codex reviews.
I'm done now.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=healer-codex-fixes3
---
Commits in this patchset:
 * xfs_healer: fix getmntent race in weakhandle
---
 healer/weakhandle.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

