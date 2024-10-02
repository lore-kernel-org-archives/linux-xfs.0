Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4294391
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831082; cv=none; b=ReMJzC/k8HnyBMuJz64IcGqf3TiD1XiUweg8PhteydiHPwVOy1DdY5TANNAUo2rNVoACk39Lqak07TrDzqVGV7nr+uo+ALS2suVXRwULEvQSPgitnhcck639ZJ731RYQEUIjfxZ9fjiIAkMGptEg6R7Kl1jBYXGAjCbsNH9yikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831082; c=relaxed/simple;
	bh=njcT2alOWkDY5oJBTlP3oLIYXfIJsnMQnhSn2vggGOk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srwagZ0cLH1qYzj1uvNknNRWfErxGxgS7kj+myw0N2F9S+sN64i8CvD5J7Pqxx2emzNF7MSQtUEAp+LO2Uc8w0tXxw3d/EtVTgTPqr2xoFECvWC0mpIY44EY/FW4mIoRyJVhMg13tpUil/EkPbVYBvfYYXDE9E2k2U9vtVXLa+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnQU2jsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnQU2jsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DC5C4CEC6;
	Wed,  2 Oct 2024 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831082;
	bh=njcT2alOWkDY5oJBTlP3oLIYXfIJsnMQnhSn2vggGOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fnQU2jsvlu3lsFEUjrSAcLE5wwxzx1RlUkiQYbLSfHPuABlwtTw1QaNyrxX6b5Fmr
	 fi+Id3W2FbZ+PjY3BOLCLKG1P435B3PIlvSb9EaExQDnWUsOqah/xM6PNER8F/oNnh
	 LICwRREEcG97q/wd4LL5iQCvnrvhWDar1/3FI9g1ft9OIG1B/FclevGSHgLBOdRy1A
	 DthQmi+MIp97U2hVD0+4y6FncMYod0ss1d36HWUpXPUzwmYyZJJ60j0uEdEAnkoKva
	 +4XLrQa0ud6b3LIALTAlNrynv/mUFTd4scOBwzOjW+02Sg1QEBd5VMPXdAsrvb8Rpw
	 Kl9ig7d3yQbtQ==
Date: Tue, 01 Oct 2024 18:04:41 -0700
Subject: [PATCHSET 2/6] xfsprogs: do not depend on libattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
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

Remove xfsprogs dependence on libattr because libattr is deprecated.  The code
in that library came from XFS, so we can make our own shims.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libattr-remove-6.11
---
Commits in this patchset:
 * misc: clean up code around attr_list_by_handle calls
 * libfrog: emulate deprecated attrlist functionality in libattr
---
 configure.ac          |    2 --
 debian/control        |    2 +-
 include/builddefs.in  |    1 -
 libfrog/Makefile      |    8 ++-----
 libfrog/fakelibattr.h |   36 ++++++++++++++++++++++++++++++
 libfrog/fsprops.c     |   22 ++++++++++--------
 m4/package_attr.m4    |   25 ---------------------
 scrub/Makefile        |    4 ---
 scrub/phase5.c        |   59 +++++++++++++++++++++++++++----------------------
 9 files changed, 85 insertions(+), 74 deletions(-)
 create mode 100644 libfrog/fakelibattr.h
 delete mode 100644 m4/package_attr.m4

