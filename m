Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922E317B418
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781334; cv=none; b=b6NS5S4rYyzSxMPQ7DyKSS2eVElL52UsUDG5fJkV2xXc0W0mjZrMHltjJuzobo3tM3Io/ZhRWC18Fv6oZ9fH4E60pq6/gsho0VpD5ngfNw0ql20+9arWoCU8ZYXHqOpf9LAETLXRg8JhIrpcqaTOwenWodaqpDHp+TbUpkrPHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781334; c=relaxed/simple;
	bh=Ea7MXd73y35QAjuGpT9vcXxL5QxQy49+j5rdvOqw24w=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=HSk5qIjjyaKP4NNQAwtwprISKKgvgLW4u/VRMMQNoqxFeu4aJWXnAt1uHBLvtsZsswGc1S6dGoVrz1byoFSGsFpINq2QBJchxkYAU9XNPMyKS6QKoTBAaMWsyXvlGKNsu3E6htNurOw8Uy/tqdng8K2Gn+thFymUx7kQIYyb/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjXrPqsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjXrPqsB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 69DB41F000E9;
	Tue, 30 Jun 2026 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781333;
	bh=L+n2Ac5Bk9dhEgpHLkUxqEbURa9ZDiR1WQ2ssKRjdg8=;
	h=Date:Subject:From:To:Cc;
	b=RjXrPqsB11oA+vuWgG17UfTlkP5Fsohwled8iXDoEAjNgFwTtMxG2x+m1K3UTMz9f
	 wunXE0D+NvI91QM546sFqO7mtLOF2IbQOdPutrwhR81ewRG5AlfWjoRJtASdrWflZR
	 fx3Eqym0DA7UEDIiO/63pqJcTYY9siHz5l1rRbA9vgZGI3604pnvgIW5A0OJ6SDnzM
	 xtgUcMRensbRP3NiAdZyRCMpzzXbOfpMoQ0ND9vuD0K+44iaPXGkxsSyafOCFRtTBJ
	 +0GNGZEQiIlByHxCdaT4n7+A4S+aGY5N7KE346gI9GJzSGYoXfvYnSHJ3Zum5R+IPr
	 pDDboDXoR76bw==
Date: Mon, 29 Jun 2026 18:02:13 -0700
Subject: [PATCHSET 3/4] xfs_db: human-inspired bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

I stumbled over these two bugs when I was mucking around in xfs_db.
These aren't from Codex!

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-fixes
---
Commits in this patchset:
 * xfs_db: fix type conversions
 * xfs_db: dump zoned filesystem superblock fields
---
 db/io.c |    9 +++++++--
 db/sb.c |   10 ++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

