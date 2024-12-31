Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAC13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688081; cv=none; b=LkTPYZQQwyKmsvOv7Q0h61ruIJwL88StBycptNC1iZcKJq5NHqrGpE16g9x+bUiSgxQi263HE3b5roq4cxl86hCHBI6eGFSPgDz5f1xpfFRtB89V87Te0hcAjHGp22QuVUbZkca1NBNl3oweshZCgEyZakU9gM0DvwhHj0/1onY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688081; c=relaxed/simple;
	bh=qBPxEuVDbqwnc02l1wSbzTtIMjw8X54SpphjBw0xZE8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W443oNOS7YFR1FEUAmoqDsIspp4yttxKaaMPyMW60FMiCtXiaoF/j4NPnRoEqaG4Zrfv8ynbjTnhu/VDVBLhxTcXJaMAr2430pcNdkooeTNLw7HmxDey1ksw/LhrFwNkmU7r08ytMOAaxJypcxros+Z0pQU+K26B/R5bHi33xiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+IoRwg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+IoRwg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7CDC4CED2;
	Tue, 31 Dec 2024 23:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688081;
	bh=qBPxEuVDbqwnc02l1wSbzTtIMjw8X54SpphjBw0xZE8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K+IoRwg1TIn7rDHXChZBjBdhJTJE1BvEl0T4ZUKumbhDg89CKzKaPmPKzjMxbu+Oq
	 QEAFv1547B83t19uGvvuo4SUjIomsAtgkluVA6m0c5Ft2hY3TFwyq8OEGs0Eev+WTR
	 mnDQi6/ZTV1J/7MBHI47MKkGPShGOvLSvtSMYqt4lU8YAHJbyfisS6grFmDUJop0Qm
	 smR3Be7lhHs1Swm4h/lCOanayprJdzxx5WoXVxT1Jx/8nWiGeVTZnRAKNizyI98V75
	 F1KkTDXerENqFLyRRTqWK+v15nKESSUgQ5FfXiqoY1/F6enpFGmQRt/rumzVok3cqx
	 ve5/ORv8ntBrw==
Date: Tue, 31 Dec 2024 15:34:40 -0800
Subject: [PATCHSET 5/5] xfs_repair: add difficult V5 features to filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series enables xfs_repair to add select features to existing V5
filesystems.  Specifically, one can add free inode btrees, reflink
support, and reverse mapping.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-newer-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-newer-features
---
Commits in this patchset:
 * xfs_repair: allow sysadmins to add free inode btree indexes
 * xfs_repair: allow sysadmins to add reflink
 * xfs_repair: allow sysadmins to add reverse mapping indexes
 * xfs_repair: upgrade an existing filesystem to have parent pointers
 * xfs_repair: allow sysadmins to add metadata directories
 * xfs_repair: upgrade filesystems to support rtgroups when adding metadir
 * xfs_repair: allow sysadmins to add realtime reverse mapping indexes
 * xfs_repair: allow sysadmins to add realtime reflink
 * xfs_repair: skip free space checks when upgrading
 * xfs_repair: allow adding rmapbt to reflink filesystems
---
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_admin.8     |   37 +++++
 repair/dino_chunks.c     |    6 +
 repair/dinode.c          |    5 +
 repair/globals.c         |    7 +
 repair/globals.h         |    7 +
 repair/phase2.c          |  341 +++++++++++++++++++++++++++++++++++++++++++++-
 repair/phase4.c          |    5 +
 repair/pptr.c            |   15 ++
 repair/protos.h          |    6 +
 repair/rmap.c            |   12 +-
 repair/xfs_repair.c      |   77 ++++++++++
 12 files changed, 505 insertions(+), 14 deletions(-)

